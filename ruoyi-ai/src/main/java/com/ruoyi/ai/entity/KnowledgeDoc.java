package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("ai_knowledge_doc")
public class KnowledgeDoc {

    @TableId(type = IdType.AUTO)
    private Long docId;

    private String fileName;

    private String filePath;

    private String fileType;

    private Long fileSize;

    private Integer chunkCount;

    private String status;

    private LocalDateTime createTime;
}
