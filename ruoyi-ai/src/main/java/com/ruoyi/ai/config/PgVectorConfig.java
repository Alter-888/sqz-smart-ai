package com.ruoyi.ai.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.ai.vectorstore.pgvector.PgVectorStore;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * PG 向量库配置。
 *
 * 关键约束：
 * 1) RuoYi 的 dynamicDataSource 带 @Primary 且指向 MySQL，这里的数据源必须是「非 Primary」，
 *    否则 MyBatis / DashboardController 注入的 JdbcTemplate 会被换成 PG，业务查询全挂。
 * 2) 因此也不能用 pgvector 的 starter（它按唯一 JdbcTemplate 装配），只能手写 Bean。
 * 3) P1 落地：提供 PgVectorStore Bean（复用 pgVectorDataSource / pgVectorJdbcTemplate），
 *    正式替换掉 SimpleVectorStore（对应 VectorStoreConfig 已删除）。
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
    @Value("${smart-cs.vector-store.pg.schema-name:public}")
    private String schemaName;
    @Value("${smart-cs.vector-store.pg.table-name:vector_store}")
    private String tableName;
    @Value("${smart-cs.vector-store.pg.dimensions:1024}")
    private int dimensions;
    @Value("${smart-cs.vector-store.pg.initialize-schema:true}")
    private boolean initializeSchema;
    @Value("${smart-cs.vector-store.pg.max-document-batch-size:200}")
    private int maxDocumentBatchSize;

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

    /**
     * 修复 P1 回归：新增第二个 DataSource(Hikari PG) 后，Spring 不再自动生成 MySQL 主库的默认 JdbcTemplate，
     * 导致 DashboardController 等无 @Qualifier 的 JdbcTemplate 拿到的是 PG，业务查询全挂。
     * 这里显式提供一个 @Primary 主库 JdbcTemplate，绑定 @Primary 的 dynamicDataSource（MySQL）。
     * pgVectorJdbcTemplate 仍按名字注入，不受影响。
     */
    @Bean("masterJdbcTemplate")
    @Primary
    public JdbcTemplate masterJdbcTemplate(@Qualifier("dynamicDataSource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    /**
     * PgVectorStore（P1 落地）。
     *
     * 说明：
     * - 必须用 pgVectorJdbcTemplate（指向 PG），不能用默认 JdbcTemplate（那是 @Primary 的 MySQL）。
     * - idType 用 TEXT：知识块 id 形如 knowledge_33_c0，非 UUID，避免启动/写入时 UUID.fromString 抛异常。
     * - dimensions 显式给 1024（= text-embedding-v3 输出维度），避免启动时多打一次 embedding 探测。
     * - 首次启动 initialize-schema=true 自动建表 + 建 HNSW/cosine 索引。
     */
    @Bean
    public VectorStore vectorStore(@Qualifier("pgVectorJdbcTemplate") JdbcTemplate pgJdbc,
                                   EmbeddingModel embeddingModel) {
        log.info("初始化 PgVectorStore - table: {}.{}, dimensions: {}, index: HNSW/COSINE",
                schemaName, tableName, dimensions);
        return PgVectorStore.builder(pgJdbc, embeddingModel)
                .schemaName(schemaName)
                .vectorTableName(tableName)
                .idType(PgVectorStore.PgIdType.TEXT)
                .dimensions(dimensions)
                .distanceType(PgVectorStore.PgDistanceType.COSINE_DISTANCE)
                .indexType(PgVectorStore.PgIndexType.HNSW)
                .initializeSchema(initializeSchema)
                .maxDocumentBatchSize(maxDocumentBatchSize)
                .build();
    }
}
