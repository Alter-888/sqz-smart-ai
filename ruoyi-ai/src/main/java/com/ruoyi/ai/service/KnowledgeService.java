package com.ruoyi.ai.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.ai.entity.Knowledge;
import com.ruoyi.ai.entity.KnowledgeDoc;
import com.ruoyi.ai.enums.KnowledgeDocStatus;
import com.ruoyi.ai.mapper.KnowledgeDocMapper;
import com.ruoyi.ai.mapper.KnowledgeMapper;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.service.ReviewService;
import com.ruoyi.common.exception.ServiceException;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.document.Document;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.FileSystemResource;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@Service
@RequiredArgsConstructor
public class KnowledgeService {

    private static final Logger log = LoggerFactory.getLogger(KnowledgeService.class);

    private final KnowledgeMapper knowledgeMapper;
    private final KnowledgeDocMapper knowledgeDocMapper;
    private final VectorStore vectorStore;
    private final ApplicationContext applicationContext;
    private final ReviewService reviewService;
    private final SmartCsProperties props;

    /** 读写锁：保护向量存储的并发写入操作 */
    private final ReentrantReadWriteLock vectorStoreLock = new ReentrantReadWriteLock();

    /** P1: 共享分块器, 按 smart-cs.rag.chunk-size(默认400) 切分知识/文档 */
    private TokenTextSplitter splitter;

    @PostConstruct
    public void initSplitter() {
        this.splitter = new TokenTextSplitter(props.getRag().getChunkSize(), 350, 5, 10000, true);
    }

    @Value("${smart-cs.upload.path:uploads/}")
    private String uploadPath;

    /**
     * 重建向量库：将 ai_knowledge 表中所有启用的知识条目重新写入 PG 向量库。
     * P1 起 PG 是主向量存储；此方法保留为「迁移/恢复工具」，用于从 MySQL 全量重建向量数据。
     */
    public int rebuildVectorStore() {
        vectorStoreLock.writeLock().lock();
        try {
            LambdaQueryWrapper<Knowledge> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Knowledge::getStatus, 1);
            List<Knowledge> allKnowledge = knowledgeMapper.selectList(wrapper);

            for (Knowledge knowledge : allKnowledge) {
                addToVectorStore(knowledge);
            }

            log.info("向量库重建完成，共重建 {} 条知识", allKnowledge.size());
            return allKnowledge.size();
        } finally {
            vectorStoreLock.writeLock().unlock();
        }
    }

    public IPage<Knowledge> listKnowledge(int pageNum, int pageSize, String category, String title, String sourceType) {
        Page<Knowledge> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Knowledge> wrapper = new LambdaQueryWrapper<>();
        if (category != null && !category.isEmpty()) {
            wrapper.eq(Knowledge::getCategory, category);
        }
        if (title != null && !title.isEmpty()) {
            wrapper.like(Knowledge::getTitle, title);
        }
        if (sourceType != null && !sourceType.isEmpty()) {
            wrapper.eq(Knowledge::getSourceType, sourceType);
        }
        wrapper.orderByDesc(Knowledge::getCreateTime);
        return knowledgeMapper.selectPage(page, wrapper);
    }

    public void addKnowledge(Knowledge knowledge) {
        knowledge.setStatus(1);
        knowledgeMapper.insert(knowledge);

        // 同步到向量存储（加锁保护）
        vectorStoreLock.writeLock().lock();
        try {
            addToVectorStore(knowledge);
        } finally {
            vectorStoreLock.writeLock().unlock();
        }
        log.info("知识条目添加成功并已向量化: {}", knowledge.getTitle());
    }

    public void updateKnowledge(Knowledge knowledge) {
        Knowledge existing = knowledgeMapper.selectById(knowledge.getKnowledgeId());
        if (existing == null) {
            throw new ServiceException("知识条目不存在");
        }
        knowledgeMapper.updateById(knowledge);

        // 重新向量化（加锁保护）
        vectorStoreLock.writeLock().lock();
        try {
            removeFromVectorStore(knowledge.getKnowledgeId());
            addToVectorStore(knowledge);
        } finally {
            vectorStoreLock.writeLock().unlock();
        }
        log.info("知识条目更新成功: {}", knowledge.getTitle());
    }

    public void deleteKnowledge(Long knowledgeId) {
        knowledgeMapper.deleteById(knowledgeId);

        vectorStoreLock.writeLock().lock();
        try {
            removeFromVectorStore(knowledgeId);
        } finally {
            vectorStoreLock.writeLock().unlock();
        }
        log.info("知识条目删除成功: {}", knowledgeId);
    }

    public void deleteKnowledgeBatch(List<Long> knowledgeIds) {
        if (knowledgeIds == null || knowledgeIds.isEmpty()) {
            return;
        }
        knowledgeMapper.deleteBatchIds(knowledgeIds);

        vectorStoreLock.writeLock().lock();
        try {
            for (Long knowledgeId : knowledgeIds) {
                removeFromVectorStore(knowledgeId);
            }
        } finally {
            vectorStoreLock.writeLock().unlock();
        }
        log.info("知识条目批量删除成功，共删除 {} 条", knowledgeIds.size());
    }

    /**
     * 上传文档：同步保存文件和数据库记录，异步处理解析和向量化
     */
    public void uploadDocument(MultipartFile file) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String fileType = originalFilename != null ?
                originalFilename.substring(originalFilename.lastIndexOf(".") + 1) : "txt";

        // 保存文件
        Path uploadDir = Paths.get(uploadPath);
        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
        }
        String savedFileName = UUID.randomUUID() + "." + fileType;
        Path filePath = uploadDir.resolve(savedFileName);
        file.transferTo(filePath.toFile());

        // 记录文档信息
        KnowledgeDoc doc = new KnowledgeDoc();
        doc.setFileName(originalFilename);
        doc.setFilePath(filePath.toString());
        doc.setFileType(fileType);
        doc.setFileSize(file.getSize());
        doc.setStatus(KnowledgeDocStatus.PROCESSING.getCode());
        knowledgeDocMapper.insert(doc);

        log.info("文档已保存，开始异步处理: {}", originalFilename);

        // 异步处理文档（通过 ApplicationContext 获取代理，确保 @Async 生效）
        applicationContext.getBean(KnowledgeService.class).processDocumentAsync(doc, filePath);
    }

    /**
     * 异步处理文档：解析、分片、向量化
     */
    @Async("docProcessExecutor")
    public void processDocumentAsync(KnowledgeDoc doc, Path filePath) {
        try {
            // 解析文档
            TextReader textReader = new TextReader(new FileSystemResource(filePath.toFile()));
            List<Document> documents = textReader.get();

            // 分片（共享 splitter，按 smart-cs.rag.chunk-size）
            List<Document> chunks = splitter.apply(documents);

            // 重建 id + metadata（全字符串，满足 pgvector jsonb 约定），再入库
            List<Document> finalChunks = new ArrayList<>(chunks.size());
            for (int i = 0; i < chunks.size(); i++) {
                Document chunk = chunks.get(i);
                finalChunks.add(new Document(
                        "doc_" + doc.getDocId() + "_c" + i,
                        chunk.getText(),
                        Map.of(
                                "sourceType", "DOC",
                                "docId", doc.getDocId().toString(),
                                "title", doc.getFileName() != null ? doc.getFileName() : "",
                                "category", "GUIDE",
                                "chunkIndex", String.valueOf(i),
                                "fileType", doc.getFileType() != null ? doc.getFileType() : ""
                        )
                ));
            }

            // 向量化存储（加锁保护）
            vectorStoreLock.writeLock().lock();
            try {
                vectorStore.add(finalChunks);
            } finally {
                vectorStoreLock.writeLock().unlock();
            }

            // 更新文档状态
            doc.setChunkCount(chunks.size());
            doc.setStatus(KnowledgeDocStatus.COMPLETED.getCode());
            knowledgeDocMapper.updateById(doc);

            log.info("文档异步处理完成: {}, 分片数: {}", doc.getFileName(), chunks.size());
        } catch (Exception e) {
            doc.setStatus(KnowledgeDocStatus.FAILED.getCode());
            knowledgeDocMapper.updateById(doc);
            log.error("文档异步处理失败: {}", doc.getFileName(), e);
        }
    }

    public IPage<KnowledgeDoc> listDocs(int pageNum, int pageSize) {
        Page<KnowledgeDoc> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<KnowledgeDoc> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(KnowledgeDoc::getCreateTime);
        return knowledgeDocMapper.selectPage(page, wrapper);
    }

    private void addToVectorStore(Knowledge knowledge) {
        Document doc = new Document(
                "knowledge_" + knowledge.getKnowledgeId(),
                knowledge.getTitle() + "\n" + knowledge.getContent(),
                Map.of(
                        "knowledgeId", knowledge.getKnowledgeId().toString(),
                        "category", knowledge.getCategory() != null ? knowledge.getCategory() : "",
                        "title", knowledge.getTitle()
                )
        );
        List<Document> chunks = splitter.apply(List.of(doc));
        List<Document> finalChunks = new ArrayList<>(chunks.size());
        for (int i = 0; i < chunks.size(); i++) {
            Document chunk = chunks.get(i);
            finalChunks.add(new Document(
                    "knowledge_" + knowledge.getKnowledgeId() + "_c" + i,
                    chunk.getText(),
                    Map.of(
                            "knowledgeId", knowledge.getKnowledgeId().toString(),
                            "category", knowledge.getCategory() != null ? knowledge.getCategory() : "",
                            "title", knowledge.getTitle(),
                            "sourceType", knowledge.getSourceType() != null ? knowledge.getSourceType() : "MANUAL",
                            "sourceId", knowledge.getSourceId() != null ? knowledge.getSourceId().toString() : "",
                            "productCategory", knowledge.getProductCategory() != null ? knowledge.getProductCategory() : "",
                            "chunkIndex", String.valueOf(i)
                    )
            ));
        }
        vectorStore.add(finalChunks);
        log.info("知识条目向量化完成: knowledgeId={}, 分块数={}", knowledge.getKnowledgeId(), finalChunks.size());
    }

    private void removeFromVectorStore(Long knowledgeId) {
        // P1: PG 下用 filter 按 knowledgeId 元数据删除该条知识的所有分块
        vectorStore.delete("knowledgeId == '" + knowledgeId + "'");
    }

    /**
     * 商品自动同步知识库：商品新增/更新时自动生成或更新对应的知识条目
     */
    public void syncProductKnowledge(Product product) {
        // 构造结构化知识内容（提升向量语义匹配质量）
        StringBuilder content = new StringBuilder();
        content.append("【商品名称】").append(product.getName()).append("\n");
        content.append("【分类】").append(product.getCategory() != null ? product.getCategory() : "未分类").append("\n");
        content.append("【价格】").append(product.getPrice() != null ? product.getPrice() + "元" : "暂无").append("\n");
        if (product.getHighlights() != null && !product.getHighlights().isEmpty()) {
            content.append("【核心卖点】").append(product.getHighlights()).append("\n");
        }
        if (product.getDescription() != null && !product.getDescription().isEmpty()) {
            content.append("【详细规格】").append(product.getDescription()).append("\n");
        }
        if (product.getRefundPolicy() != null && !product.getRefundPolicy().isEmpty()) {
            content.append("【退换货政策】").append(product.getRefundPolicy()).append("\n");
        }
        if (product.getWarrantyInfo() != null && !product.getWarrantyInfo().isEmpty()) {
            content.append("【保修信息】").append(product.getWarrantyInfo()).append("\n");
        }
        if (product.getAfterSaleNote() != null && !product.getAfterSaleNote().isEmpty()) {
            content.append("【售后注意事项】").append(product.getAfterSaleNote()).append("\n");
        }
        content.append("【库存】").append(product.getStock() != null ? product.getStock() : 0);

        // 追加评价数据
        try {
            Map<String, Object> stats = reviewService.getProductStats(product.getProductId());
            int reviewCount = (int) stats.get("count");
            if (reviewCount > 0) {
                double avgRating = (double) stats.get("avgRating");
                content.append("\n【用户评价】").append(avgRating).append("分(共").append(reviewCount).append("条评价)");
            }
        } catch (Exception e) {
            log.warn("获取商品评价统计失败: productId={}, {}", product.getProductId(), e.getMessage());
        }

        // 查找是否已有自动同步的知识条目
        LambdaQueryWrapper<Knowledge> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Knowledge::getSourceType, "PRODUCT_AUTO");
        wrapper.eq(Knowledge::getSourceId, product.getProductId());
        Knowledge existing = knowledgeMapper.selectOne(wrapper);

        if (existing != null) {
            // 更新已有知识
            existing.setTitle("【商品】" + product.getName());
            existing.setContent(content.toString());
            existing.setCategory("PRODUCT_INFO");
            existing.setProductCategory(product.getCategory());
            existing.setStatus(1);
            knowledgeMapper.updateById(existing);
            // 重新向量化
            vectorStoreLock.writeLock().lock();
            try {
                removeFromVectorStore(existing.getKnowledgeId());
                addToVectorStore(existing);
            } finally {
                vectorStoreLock.writeLock().unlock();
            }
            log.info("商品知识同步更新: productId={}, knowledgeId={}", product.getProductId(), existing.getKnowledgeId());
        } else {
            // 新建知识条目
            Knowledge knowledge = new Knowledge();
            knowledge.setTitle("【商品】" + product.getName());
            knowledge.setContent(content.toString());
            knowledge.setCategory("PRODUCT_INFO");
            knowledge.setProductCategory(product.getCategory());
            knowledge.setStatus(1);
            knowledge.setSourceType("PRODUCT_AUTO");
            knowledge.setSourceId(product.getProductId());
            knowledgeMapper.insert(knowledge);
            // 向量化
            vectorStoreLock.writeLock().lock();
            try {
                addToVectorStore(knowledge);
            } finally {
                vectorStoreLock.writeLock().unlock();
            }
            log.info("商品知识同步新增: productId={}, knowledgeId={}", product.getProductId(), knowledge.getKnowledgeId());
        }
    }

    /**
     * 商品下架时禁用对应的知识条目
     */
    public void disableProductKnowledge(Long productId) {
        LambdaQueryWrapper<Knowledge> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Knowledge::getSourceType, "PRODUCT_AUTO");
        wrapper.eq(Knowledge::getSourceId, productId);
        Knowledge existing = knowledgeMapper.selectOne(wrapper);
        if (existing != null && existing.getStatus() == 1) {
            existing.setStatus(0);
            knowledgeMapper.updateById(existing);
            // 从向量库移除
            vectorStoreLock.writeLock().lock();
            try {
                removeFromVectorStore(existing.getKnowledgeId());
            } finally {
                vectorStoreLock.writeLock().unlock();
            }
            log.info("商品知识已禁用: productId={}, knowledgeId={}", productId, existing.getKnowledgeId());
        }
    }
}
