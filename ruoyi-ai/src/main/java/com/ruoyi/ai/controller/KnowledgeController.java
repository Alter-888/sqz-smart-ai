package com.ruoyi.ai.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.ai.entity.Knowledge;
import com.ruoyi.ai.entity.KnowledgeDoc;
import com.ruoyi.ai.service.KnowledgeService;
import com.ruoyi.common.core.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai/knowledge")
@RequiredArgsConstructor
public class KnowledgeController {

    private final KnowledgeService knowledgeService;

    @Value("${smart-cs.vector-store.path:vectorstore.json}")
    private String vectorStorePath;

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
        File file = new File(vectorStorePath);
        Map<String, Object> status = new LinkedHashMap<>();
        status.put("exists", file.exists());
        if (file.exists()) {
            long sizeKB = file.length() / 1024;
            status.put("fileSize", sizeKB > 1024 ? String.format("%.1f MB", sizeKB / 1024.0) : sizeKB + " KB");
            status.put("lastModified", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(file.lastModified())));
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
