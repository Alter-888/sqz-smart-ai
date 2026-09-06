package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysUserSecurityQuestion;

/**
 * 用户安全问题 数据层
 */
public interface SysUserSecurityQuestionMapper
{
    /**
     * 查询用户的所有安全问题
     *
     * @param userId 用户ID
     * @return 安全问题列表
     */
    public List<SysUserSecurityQuestion> selectByUserId(Long userId);

    /**
     * 根据ID查询安全问题
     *
     * @param id 主键
     * @return 安全问题
     */
    public SysUserSecurityQuestion selectById(Long id);

    /**
     * 统计用户安全问题数量
     *
     * @param userId 用户ID
     * @return 数量
     */
    public int countByUserId(Long userId);

    /**
     * 删除用户所有安全问题
     *
     * @param userId 用户ID
     * @return 影响行数
     */
    public int deleteByUserId(Long userId);

    /**
     * 批量插入安全问题
     *
     * @param list 安全问题列表
     * @return 影响行数
     */
    public int batchInsert(List<SysUserSecurityQuestion> list);
}
