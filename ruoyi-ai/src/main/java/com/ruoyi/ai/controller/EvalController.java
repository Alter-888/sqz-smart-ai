package com.ruoyi.ai.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ruoyi.ai.eval.EvaluationJob;
import com.ruoyi.ai.entity.EvalResult;
import com.ruoyi.ai.mapper.EvalResultMapper;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * 离线评测接口（P6）。
 * run 是长耗时同步接口，用 Redis 锁防并发：setIfAbsent 抢锁，finally 释放（一次异常不锁死 30 分钟）。
 * 只跑检索层几十秒；一旦开 run-agent 会到几分钟，需 Nginx proxy_read_timeout 调大。
 */
@RestController
@RequestMapping("/ai/eval")
@RequiredArgsConstructor
public class EvalController extends BaseController {

    private static final String LOCK_KEY = "ai:eval:running";

    private final RedisTemplate<Object, Object> redisTemplate;
    private final EvaluationJob job;
    private final EvalResultMapper resultMapper;

    /** 历史评测结果分页（用于评测页表格）。 */
    @PreAuthorize("@ss.hasPermi('ai:eval:list')")
    @GetMapping("/list")
    public TableDataInfo list(@RequestParam(required = false) String dataset,
                              @RequestParam(required = false) String remark) {
        startPage();
        List<EvalResult> list = resultMapper.selectList(new LambdaQueryWrapper<EvalResult>()
                .eq(StringUtils.hasText(dataset), EvalResult::getDataset, dataset)
                .like(StringUtils.hasText(remark), EvalResult::getRemark, remark)
                .orderByDesc(EvalResult::getResultId));
        return getDataTable(list);
    }

    /** 某次评测详情（含 config_snapshot 参数快照）。 */
    @PreAuthorize("@ss.hasPermi('ai:eval:list')")
    @GetMapping("/result/{id}")
    public AjaxResult result(@PathVariable("id") Long id) {
        return AjaxResult.success(resultMapper.selectById(id));
    }

    /** 触发一次离线评测（同步长耗时，Redis 锁防并发）。 */
    @PreAuthorize("@ss.hasPermi('ai:eval:run')")
    @PostMapping("/run")
    public AjaxResult run(@RequestParam(defaultValue = "v1") String dataset,
                          @RequestParam(required = false) String remark) {
        Boolean got = redisTemplate.opsForValue()
                .setIfAbsent(LOCK_KEY, System.currentTimeMillis(), 30, TimeUnit.MINUTES);
        if (!Boolean.TRUE.equals(got)) {
            return AjaxResult.error("已有评测任务在跑，等它结束再点");
        }
        try {
            return AjaxResult.success(job.run(dataset, remark));
        } finally {
            redisTemplate.delete(LOCK_KEY);
        }
    }
}