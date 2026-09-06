-- =============================================================================
-- 说明：P6 离线评测管道 —— 黄金集表 + 评测结果表
-- 命名：2026-09-06_sqz_离线评测黄金集与结果表.sql
-- 用途：
--   1) ai_eval_golden   评测黄金集（问题/期望意图/期望工具/ground truth块/答案要点）
--   2) ai_eval_result   离线评测结果（Recall/MRR/命中率 + 参数快照，用于同集对比）
--   设计依据：docx/改造多agent规划/设计/05-指标与评测设计.md §3.2 / §3.3
--
-- ⚠️ 执行顺序：先执行本脚本（建表），再录入黄金集数据。
--   本脚本基于 CREATE TABLE IF NOT EXISTS，幂等，可重复执行。
--   表在 MySQL 业务库（ruoyi 使用的库）中创建。
-- =============================================================================

-- 1. 黄金集表
CREATE TABLE IF NOT EXISTS `ai_eval_golden` (
    `golden_id`       BIGINT       NOT NULL AUTO_INCREMENT COMMENT '条目ID',
    `dataset`         VARCHAR(32)  NOT NULL DEFAULT 'v1'   COMMENT '黄金集版本，便于并存多套',
    `question`        VARCHAR(500) NOT NULL                COMMENT '用户问题（尽量用真实提问）',
    `expect_intent`   VARCHAR(32)  DEFAULT NULL            COMMENT '期望意图，评路由准确率',
    `expect_tools`    JSON         DEFAULT NULL            COMMENT '期望调用的工具名数组',
    `truth_chunk_ids` JSON         DEFAULT NULL            COMMENT '相关块id数组，算Recall/MRR的ground truth',
    `answer_points`   VARCHAR(1000) DEFAULT NULL           COMMENT '答案必须覆盖的要点，给judge打分用',
    `category`        VARCHAR(32)  DEFAULT NULL            COMMENT 'FAQ/POLICY/PRODUCT_INFO/GUIDE',
    `status`          TINYINT      DEFAULT 1               COMMENT '1启用 0停用',
    `create_time`     DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`golden_id`),
    KEY `idx_dataset` (`dataset`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='评测黄金集';

-- 2. 评测结果表
CREATE TABLE IF NOT EXISTS `ai_eval_result` (
    `result_id`       BIGINT       NOT NULL AUTO_INCREMENT COMMENT '结果ID',
    `dataset`         VARCHAR(32)  NOT NULL DEFAULT 'v1'   COMMENT '黄金集版本',
    `case_count`      INT          DEFAULT 0               COMMENT '本次实际评测条数',
    `recall_at_k`     DECIMAL(5,2) DEFAULT NULL            COMMENT 'Recall@K（K=eval.k，固定口径）',
    `recall_at_final_k` DECIMAL(5,2) DEFAULT NULL          COMMENT 'Recall@final-top-k，实际喂给模型的召回',
    `precision_at_k`  DECIMAL(5,2) DEFAULT NULL            COMMENT 'Precision@K',
    `mrr`             DECIMAL(5,2) DEFAULT NULL            COMMENT 'MRR',
    `hit_rate`        DECIMAL(5,2) DEFAULT NULL            COMMENT 'Hit Rate@K',
    `intent_accuracy` DECIMAL(5,2) DEFAULT NULL            COMMENT '路由意图准确率',
    `tool_accuracy`   DECIMAL(5,2) DEFAULT NULL            COMMENT '工具选择准确率',
    `faithfulness`    DECIMAL(5,2) DEFAULT NULL            COMMENT '回答被资料支持的程度(judge打分)',
    `avg_duration_ms` BIGINT       DEFAULT NULL            COMMENT '平均单条耗时',
    `config_snapshot` JSON         DEFAULT NULL            COMMENT '当次参数快照，用于复现与同集对比',
    `remark`          VARCHAR(255) DEFAULT NULL            COMMENT '本次跑的目的，如「P5全文路开启后」',
    `run_time`        DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`result_id`),
    KEY `idx_dataset_time` (`dataset`, `run_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='离线评测结果';