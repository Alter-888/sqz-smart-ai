package com.ruoyi.ai.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.ai.entity.Knowledge;
import com.ruoyi.ai.entity.KnowledgeDoc;
import com.ruoyi.ai.service.KnowledgeService;
import com.ruoyi.common.core.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai/knowledge")
@RequiredArgsConstructor
public class KnowledgeController {

    private final KnowledgeService knowledgeService;

    @Value("${smart-cs.vector-store.pg.schema-name:public}")
    private String schemaName;
    @Value("${smart-cs.vector-store.pg.table-name:vector_store}")
    private String tableName;

    /** P1: 向量库状态改为查 PG 表（必须用 @Qualifier 指向 PG JdbcTemplate，否则会拿到 @Primary 的 MySQL） */
    @Autowired
    @Qualifier("pgVectorJdbcTemplate")
    private JdbcTemplate pgVectorJdbcTemplate;

    @GetMapping("/list")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:list')")
    public AjaxResult list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String sourceType) {
        IPage<Knowledge> page = knowledgeService.listKnowledge(pageNum, pageSize, category, title, sourceType);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }

    @PostMapping
    @PreAuthorize("@ss.hasPermi('ai:knowledge:add')")
    public AjaxResult add(@RequestBody Knowledge knowledge) {
        knowledgeService.addKnowledge(knowledge);
        return AjaxResult.success();
    }

    @PutMapping("/{id}")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:edit')")
    public AjaxResult update(@PathVariable("id") Long knowledgeId, @RequestBody Knowledge knowledge) {
        knowledge.setKnowledgeId(knowledgeId);
        knowledgeService.updateKnowledge(knowledge);
        return AjaxResult.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:remove')")
    public AjaxResult delete(@PathVariable("id") Long knowledgeId) {
        knowledgeService.deleteKnowledge(knowledgeId);
        return AjaxResult.success();
    }

    @DeleteMapping("/batch/{ids}")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:remove')")
    public AjaxResult deleteBatch(@PathVariable("ids") List<Long> ids) {
        knowledgeService.deleteKnowledgeBatch(ids);
        return AjaxResult.success();
    }

    @PostMapping("/upload")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:upload')")
    public AjaxResult upload(@RequestParam("file") MultipartFile file) throws Exception {
        knowledgeService.uploadDocument(file);
        return AjaxResult.success("文档上传并处理成功");
    }

    @PostMapping("/rebuild-vector")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:edit')")
    public AjaxResult rebuildVectorStore() {
        int count = knowledgeService.rebuildVectorStore();
        return AjaxResult.success("向量库重建完成，共处理 " + count + " 条知识", count);
    }

    @GetMapping("/vector-store-status")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:list')")
    public AjaxResult vectorStoreStatus() {
        String table = schemaName + "." + tableName;
        Map<String, Object> status = new LinkedHashMap<>();
        try {
            Long vectorCount = pgVectorJdbcTemplate.queryForObject(
                    "SELECT count(*) FROM " + table, Long.class);
            Long knowledgeCount = pgVectorJdbcTemplate.queryForObject(
                    "SELECT count(DISTINCT metadata::jsonb ->> 'knowledgeId') FROM " + table
                            + " WHERE metadata IS NOT NULL", Long.class);
            String tableSize = pgVectorJdbcTemplate.queryForObject(
                    "SELECT pg_size_pretty(pg_total_relation_size('" + table + "'))", String.class);
            status.put("vectorCount", vectorCount);
            status.put("knowledgeCount", knowledgeCount);
            status.put("tableSize", tableSize);
            status.put("indexType", "HNSW / cosine");
            status.put("dimensions", 1024);
        } catch (Exception e) {
            status.put("error", e.getMessage());
        }
        return AjaxResult.success(status);
    }

    @GetMapping("/doc/list")
    @PreAuthorize("@ss.hasPermi('ai:knowledge:list')")
    public AjaxResult docList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        IPage<KnowledgeDoc> page = knowledgeService.listDocs(pageNum, pageSize);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("rows", page.getRecords());
        ajax.put("total", page.getTotal());
        return ajax;
    }
}
