package com.ruoyi.ai.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * PG 向量库配置。
 *
 * 关键约束：
 * 1) RuoYi 的 dynamicDataSource 带 @Primary 且指向 MySQL，这里的数据源必须是「非 Primary」，
 *    否则 MyBatis / DashboardController 注入的 JdbcTemplate 会被换成 PG，业务查询全挂。
 * 2) 因此也不能用 pgvector 的 starter（它按唯一 JdbcTemplate 装配），只能手写 Bean。
 * 3) P0 先让「PG 数据源 + JdbcTemplate」打通（验收：select 1 能打到 PG）；
 *    向量存储 Bean（PgVectorStore）在 P1 落地并替换掉 SimpleVectorStore。
 */
@Configuration
public class PgVectorConfig {

    private static final Logger log = LoggerFactory.getLogger(PgVectorConfig.class);

    @Value("${smart-cs.vector-store.pg.url}")
    private String url;
    @Value("${smart-cs.vector-store.pg.username}")
    private String username;
    @Value("${smart-cs.vector-store.pg.password}")
    private String password;
    @Value("${smart-cs.vector-store.pg.pool-size:5}")
    private int poolSize;

    /** 向量库专用连接池（HikariCP 由 spring-boot-starter-jdbc 带入，无需额外依赖） */
    @Bean("pgVectorDataSource")
    public DataSource pgVectorDataSource() {
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(url);
        cfg.setUsername(username);
        cfg.setPassword(password);
        cfg.setMaximumPoolSize(poolSize);
        cfg.setMinimumIdle(1);
        cfg.setConnectionTimeout(10_000);
        cfg.setPoolName("pgVectorPool");
        log.info("向量库数据源初始化 - url: {}, poolSize: {}", url, poolSize);
        return new HikariDataSource(cfg);
    }

    @Bean("pgVectorJdbcTemplate")
    public JdbcTemplate pgVectorJdbcTemplate(@Qualifier("pgVectorDataSource") DataSource ds) {
        return new JdbcTemplate(ds);
    }
}