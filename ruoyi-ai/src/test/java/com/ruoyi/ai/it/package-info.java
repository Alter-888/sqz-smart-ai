/**
 * 集成测试包（it/）。
 *
 * 约定（07 §2.4）：
 * - 类以 *IT 结尾，由 maven-failsafe-plugin 在 verify 阶段执行；mvn test 不碰它；
 * - unit/ 跑秒级纯单测；it/ 需要真实 MySQL / PG（Testcontainers，依赖已加到 ruoyi-ai/pom.xml）；
 * - 需连库的用例用 @EnabledIfSystemProperty 开关，Docker 没起时跳过而不是整批红掉；
 * - 测试数据 user_id 统一用 -1，避免污染在线指标（05 §6.3）。
 */
package com.ruoyi.ai.it;