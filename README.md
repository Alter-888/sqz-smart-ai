# 基于Spring AI与MCP的智能电子商城AI客服系统

> 个人技术展示项目 —— 将大语言模型（LLM）与 MCP（Model Context Protocol）协议深度融合到电子商城场景，实现一个具备商品推荐、订单管理、售后工单、购物车操作、知识库问答等全链路能力的智能AI客服系统。

---

## 一、项目概述

### 1.1 项目背景

随着电子商务的快速发展，客户服务需求呈现爆发式增长。传统的人工客服模式面临响应速度慢、服务时间受限、人力成本高等问题。近年来，大语言模型（Large Language Model, LLM）技术的突破性进展为智能客服系统带来了全新的解决思路。然而，单纯的LLM对话只能进行文本问答，无法直接操作业务系统（如查询订单、管理购物车、创建工单等），这严重限制了AI客服的实际应用价值。

MCP（Model Context Protocol，模型上下文协议）是由Anthropic于2024年提出的开放标准协议，旨在为AI模型提供与外部工具和数据源交互的标准化接口。Spring AI 1.0.0 GA版本原生集成了MCP协议支持，使得Java生态下的AI应用开发变得更加规范和高效。

本项目基于若依（RuoYi-Vue）框架，结合Spring AI 1.0.0和MCP协议，设计并实现了一个面向数码电子商城的智能AI客服系统。系统不仅具备自然语言理解和生成能力，更通过MCP工具调用机制，使AI客服能够直接操作商城业务系统，实现"对话即操作"的智能服务体验。

### 1.2 项目目标

1. **智能对话能力**：基于Spring AI集成大语言模型，实现自然流畅的中文客服对话
2. **MCP工具调用**：通过MCP协议将商城业务能力（商品、订单、工单、购物车等）暴露为标准化工具，AI可自主决策调用
3. **RAG知识库问答**：基于向量检索增强生成（Retrieval-Augmented Generation）技术，实现商品信息、售后政策等知识的精准问答
4. **全链路电商能力**：覆盖商品浏览、购物车管理、订单生命周期、售后工单、商品评价等完整电商流程
5. **管理后台**：提供AI运营数据仪表盘、知识库管理、商品管理、订单管理等后台管理功能
6. **安全保障**：实现JWT认证、RBAC权限控制、数据脱敏、XSS防护等安全机制

### 1.3 项目特色与创新点

| 特色 | 说明 |
|------|------|
| **MCP协议原生集成** | 采用Spring AI 1.0.0 GA的MCP Server（WebMVC模式），将7大业务工具组暴露为标准MCP协议端点，支持外部MCP Client接入 |
| **Function Calling驱动** | AI通过@Tool注解声明的工具函数直接操作数据库，实现"对话即操作"，用户可通过自然语言完成下单、退款等复杂操作 |
| **RAG + 商品知识自动同步** | 商品新增/修改时自动通过事件监听同步到向量知识库，确保AI回答始终基于最新商品数据 |
| **SSE实时推送 + 工具调用可视化** | 通过Server-Sent Events实时推送AI回复和工具调用过程，前端展示商品卡片、订单卡片等结构化数据 |
| **数据库持久化聊天记忆** | 自定义DatabaseChatMemory实现，对话历史持久化到MySQL，服务重启后AI仍保持上下文连贯 |
| **对话审计与AI效果评测** | 每轮对话记录RAG命中情况、工具调用链、响应时长，支持工具成功率、RAG命中率、用户满意度等多维指标分析 |
| **敏感数据脱敏** | AI返回的手机号、地址等敏感信息自动脱敏，防止隐私泄露 |

---

## 二、技术栈

### 2.1 后端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| **Java** | 17 | 编程语言 |
| **Spring Boot** | 3.5.8 | 应用框架 |
| **Spring AI** | 1.0.0 GA | AI能力集成框架（ChatClient、Advisor、Tool Calling） |
| **Spring AI MCP Server** | 1.0.0 | MCP协议服务端（WebMVC模式，暴露MCP标准端点） |
| **Spring Security** | 6.x | 安全框架（JWT认证 + RBAC权限控制） |
| **MyBatis** | 3.0.5 | 持久层框架（若依原生ORM） |
| **MyBatis-Plus** | 3.5.9 | 增强ORM框架（业务模块使用） |
| **MySQL** | 8.2.0 | 关系型数据库 |
| **Redis** | - | 缓存中间件（Token管理、SSE Ticket、数据缓存） |
| **Druid** | 1.2.27 | 数据库连接池 |
| **JWT (jjwt)** | 0.9.1 | JSON Web Token认证 |
| **Fastjson2** | 2.0.60 | JSON序列化/反序列化 |
| **Hutool** | 5.8.34 | Java工具类库 |
| **Spring Retry** | - | AI调用重试机制 |
| **Lombok** | - | 代码简化 |
| **SpringDoc OpenAPI** | 2.8.14 | API文档（Swagger） |

### 2.2 前端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| **Vue.js** | 3.5.26 | 前端框架（Composition API） |
| **Vite** | 6.4.1 | 构建工具 |
| **Element Plus** | 2.13.1 | UI组件库 |
| **Pinia** | 3.0.4 | 状态管理 |
| **Vue Router** | 4.6.4 | 路由管理 |
| **Axios** | 1.13.2 | HTTP请求库 |
| **ECharts** | 5.6.0 | 数据可视化图表 |
| **markdown-it** | 14.1.1 | Markdown渲染（AI回复格式化） |
| **DOMPurify** | 3.3.1 | XSS防护（HTML净化） |
| **Splitpanes** | 4.0.4 | 面板分割组件（聊天界面布局） |

### 2.3 AI/LLM技术栈

| 技术 | 说明 |
|------|------|
| **阿里云百炼 DashScope** | LLM服务提供商，使用qwen3.5-plus模型（qwen3.5-plus-2026-02-15 快照版） |
| **text-embedding-v3** | 向量嵌入模型（用于RAG语义检索） |
| **Spring AI ChatClient** | 统一的LLM调用客户端，支持System Prompt、Advisor链、Tool Calling |
| **Spring AI VectorStore** | 向量存储抽象层（本项目使用SimpleVectorStore，文件持久化） |
| **QuestionAnswerAdvisor** | Spring AI内置的RAG顾问，实现检索增强生成 |
| **MessageChatMemoryAdvisor** | 聊天记忆顾问，自动管理对话上下文 |
| **MethodToolCallbackProvider** | 将@Tool注解方法注册为Function Calling回调 |
| **MCP Server (WebMVC)** | 标准MCP协议服务端，暴露工具端点供外部MCP Client调用 |

---

## 三、系统整体架构

### 3.1 系统架构图（文字描述）

```
┌─────────────────────────────────────────────────────────────────────┐
│                         前端层 (Vue 3 + Element Plus)                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐    │
│  │ 用户端    │  │ 管理后台  │  │ AI聊天   │  │ 数据仪表盘       │    │
│  │ 商城页面  │  │ 商品/订单 │  │ 对话界面  │  │ ECharts 可视化   │    │
│  └─────┬────┘  └─────┬────┘  └─────┬────┘  └──────┬───────────┘    │
│        │             │             │               │                │
│        └─────────────┴──────┬──────┴───────────────┘                │
│                             │ HTTP/SSE                              │
└─────────────────────────────┼───────────────────────────────────────┘
                              │
┌─────────────────────────────┼───────────────────────────────────────┐
│                    Spring Boot 应用层                                │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │              安全层 (Spring Security + JWT)                   │    │
│  │  JwtAuthenticationTokenFilter → SSE Ticket认证 → RBAC       │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    AI 模块 (ruoyi-ai)                        │   │
│  │  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐    │   │
│  │  │ ChatService  │  │ KnowledgeService│ │ AuditService    │    │   │
│  │  │ (对话核心)    │  │ (知识库管理)    │ │ (审计记录)       │    │   │
│  │  └──────┬──────┘  └──────┬───────┘  └──────────────────┘    │   │
│  │         │                │                                   │   │
│  │  ┌──────▼──────────────────────────────────────────────┐     │   │
│  │  │           Spring AI ChatClient                       │     │   │
│  │  │  ┌──────────────┐ ┌───────────────┐ ┌────────────┐ │     │   │
│  │  │  │ RAG Advisor  │ │ Memory Advisor│ │ QA Advisor  │ │     │   │
│  │  │  │ (溯源捕获)    │ │ (数据库记忆)   │ │ (知识检索)  │ │     │   │
│  │  │  └──────────────┘ └───────────────┘ └────────────┘ │     │   │
│  │  │  ┌──────────────────────────────────────────────┐   │     │   │
│  │  │  │        MCP 工具层 (7大工具组, 38个工具)         │   │     │   │
│  │  │  │  Product │ Order │ Cart │ Ticket │ User │...  │   │     │   │
│  │  │  └──────────────────────────────────────────────┘   │     │   │
│  │  └─────────────────────────────────────────────────────┘     │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │               业务模块 (ruoyi-business)                       │   │
│  │  ProductService │ OrderService │ CartService │ TicketService  │   │
│  │  ReviewService  │ AddressService │ NotificationService        │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │               系统模块 (ruoyi-system / ruoyi-framework)       │   │
│  │  用户管理 │ 角色管理 │ 菜单管理 │ 字典管理 │ 日志管理          │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
        ┌─────▼─────┐  ┌─────▼─────┐  ┌──────▼──────┐
        │  MySQL 8   │  │  Redis    │  │ DashScope   │
        │ (数据持久化)│  │ (缓存/会话)│  │ (LLM API)   │
        └───────────┘  └───────────┘  └─────────────┘
```

### 3.2 模块划分

本项目采用Maven多模块架构，共6个子模块，职责明确、层次分明：

```
RuoYi-sqz/                          # 项目根目录
├── ruoyi-admin/                     # 启动模块（Spring Boot Application入口）
│   └── src/main/java/com/ruoyi/
│       ├── RuoYiApplication.java    # 应用启动类
│       └── web/controller/          # 系统级Controller（登录、注册、密码重置等）
│
├── ruoyi-ai/                        # 🤖 AI智能客服模块（核心创新模块）
│   └── src/main/java/com/ruoyi/ai/
│       ├── config/                  # AI配置（ChatClient、VectorStore、ChatMemory等）
│       ├── controller/              # AI相关Controller（聊天、知识库、仪表盘）
│       ├── mcp/                     # MCP工具层（7大工具组：商品/订单/购物车/工单/用户/通知/评价）
│       ├── service/                 # AI服务层（对话、知识库、审计、历史记录）
│       ├── advisor/                 # Spring AI Advisor（RAG溯源捕获）
│       ├── entity/                  # AI实体类（会话、消息、知识、审计等）
│       ├── mapper/                  # 数据访问层
│       ├── context/                 # 聊天上下文（ThreadLocal管理）
│       ├── event/                   # 事件定义（工具调用事件）
│       ├── listener/                # 事件监听器（商品知识自动同步）
│       ├── enums/                   # 枚举类
│       └── util/                    # 工具类（敏感数据脱敏）
│
├── ruoyi-business/                  # 🛒 电商业务模块
│   └── src/main/java/com/ruoyi/business/
│       ├── controller/              # 业务Controller（商品、订单、购物车、工单、评价、地址、通知）
│       ├── service/                 # 业务Service层
│       ├── entity/                  # 业务实体类（Product、Order、CartItem、Ticket等）
│       ├── mapper/                  # 数据访问层
│       ├── enums/                   # 业务枚举（OrderStatus、TicketType等）
│       ├── event/                   # 业务事件（ProductChangeEvent）
│       └── constant/                # 业务常量
│
├── ruoyi-system/                    # 系统管理模块（用户、角色、菜单、字典、日志等）
├── ruoyi-framework/                 # 框架核心模块（安全配置、拦截器、AOP切面等）
├── ruoyi-common/                    # 通用工具模块（注解、常量、异常、工具类等）
├── ruoyi-ui/                        # 前端工程（Vue 3 + Element Plus + Vite）
├── sql/                             # 数据库脚本（增量迁移脚本，按日期命名）
└── pom.xml                          # Maven父POM（统一依赖版本管理）
```

### 3.3 模块依赖关系

```
ruoyi-admin（启动模块）
    ├── ruoyi-framework（框架核心）
    │       └── ruoyi-system（系统管理）
    │               └── ruoyi-common（通用工具）
    ├── ruoyi-ai（AI智能客服）
    │       ├── ruoyi-business（电商业务）
    │       │       └── ruoyi-common
    │       ├── ruoyi-system
    │       └── ruoyi-common
    └── ruoyi-business
```

### 3.4 请求处理流程

以一次用户AI对话请求为例，完整的处理流程如下：

```
用户发送消息 "有什么手机推荐？"
        │
        ▼
1. 前端通过 SSE 连接 /ai/chat/stream?message=...&sessionId=...&ticket=...
        │
        ▼
2. JwtAuthenticationTokenFilter 验证 SSE Ticket（一次性凭证）
   ├─ 从 Redis 获取 loginUuid
   ├─ 验证后立即删除 ticket（防重放）
   └─ 恢复 SecurityContext
        │
        ▼
3. ChatController.streamChat() → ChatService.streamChat()
   ├─ 创建 SseEmitter（5分钟超时）
   ├─ 异步线程执行（保持HTTP不阻塞）
   └─ 设置 ChatContext（ThreadLocal绑定会话ID和SseEmitter）
        │
        ▼
4. Spring AI ChatClient 处理链：
   ├─ (a) RagSourceCapturingAdvisor：向量检索，捕获RAG来源元数据
   ├─ (b) MessageChatMemoryAdvisor：从数据库加载历史对话上下文
   ├─ (c) QuestionAnswerAdvisor：向量语义搜索，注入知识库参考信息
   └─ (d) LLM 调用 DashScope API（qwen3.5-plus模型）
        │
        ▼
5. LLM 决策调用工具 → Function Calling
   ├─ AI 判断需要调用 searchProducts(category="手机")
   ├─ MethodToolCallbackProvider 路由到 ProductMcpTools.searchProducts()
   ├─ 查询数据库获取上架手机商品列表
   ├─ 发布 ToolCallEvent → SSE 推送 tool_call 事件到前端
   ├─ 发布 card_data 事件（商品卡片数据）→ SSE 推送
   ├─ 记录 ToolCallLog（工具名、参数、耗时、成功/失败）
   └─ 返回商品列表给 LLM
        │
        ▼
6. LLM 生成最终回复（包含商品推荐文案）
        │
        ▼
7. 结果通过 SSE 推送：
   ├─ data: "为您找到以下热门手机 📱：1. iPhone 16 Pro Max..."
   ├─ event: rag_source, data: [{"title":"【商品】iPhone 16","knowledgeId":"5"}]
   ├─ event: card_data, data: {"cardType":"product","items":[...]}
   └─ data: [DONE]
        │
        ▼
8. 后置处理：
   ├─ DatabaseChatMemory 自动持久化用户消息和AI回复
   ├─ AuditService 异步记录审计信息（RAG命中、工具调用、响应时长）
   ├─ 卡片数据持久化到 ai_chat_message.cards_data
   └─ ChatContext.clear() 清理 ThreadLocal
```

---

## 四、AI核心设计

### 4.1 Spring AI ChatClient 配置架构

系统的AI核心基于Spring AI的`ChatClient`构建，通过Builder模式组装了完整的对话处理链：

```java
// AiConfig.java - AI核心配置
ChatClient = builder
    .defaultSystem(systemPrompt)           // 系统提示词（角色定义+工具使用策略）
    .defaultAdvisors(
        RagSourceCapturingAdvisor,         // 自定义：RAG溯源捕获
        MessageChatMemoryAdvisor,          // 内置：对话记忆管理
        QuestionAnswerAdvisor              // 内置：RAG知识检索增强
    )
    .defaultToolCallbacks(toolCallbackProvider)  // MCP工具回调
    .build();
```

**核心组件说明：**

| 组件 | 类型 | 职责 |
|------|------|------|
| `SystemPrompt` | 提示词工程 | 定义AI角色"小智"、绝对规则、工具使用策略、回答格式、主动服务规则 |
| `RagSourceCapturingAdvisor` | 自定义Advisor | 在QuestionAnswerAdvisor之前执行向量检索，捕获RAG来源元数据用于审计和前端展示 |
| `MessageChatMemoryAdvisor` | Spring AI内置 | 自动在每次对话前加载历史消息、对话后持久化新消息 |
| `QuestionAnswerAdvisor` | Spring AI内置 | 执行向量语义搜索（topK=3, threshold=0.5），将检索结果注入LLM上下文 |
| `ToolCallbackProvider` | Spring AI内置 | 将7大MCP工具组（38个工具方法）注册为Function Calling回调 |

### 4.2 System Prompt 设计

系统提示词是AI行为的核心控制器，采用结构化设计：

```
System Prompt 结构：
├── 角色定义：数码商城智能客服"小智"
├── 绝对规则（最高优先级）：
│   ├── 所有数据必须通过工具获取，禁止编造
│   ├── 工具返回空结果时如实告知
│   ├── 系统可用商品分类列表
│   └── 查询订单/工单自动识别用户身份
├── 工具使用策略：
│   ├── 商品相关（5个工具的调用场景）
│   ├── 订单相关（6个工具的调用场景）
│   ├── 售后与工单（5个工具的调用场景）
│   ├── 个人信息与地址（7个工具的调用场景）
│   ├── 通知（4个工具的调用场景）
│   ├── 评价（3个工具的调用场景）
│   └── 购物车（6个工具的调用场景）
├── 回答格式指南（列表/表格/订单展示格式）
├── 主动服务规则（推荐后引导/订单状态建议等）
├── 沟通风格（中文/简洁/emoji）
├── 示例对话
└── 动态参数：当前用户ID = {userId}
```

### 4.3 Advisor链执行顺序

Spring AI的Advisor机制类似于Servlet Filter，按Order值从小到大依次执行：

```
请求进入 → RagSourceCapturingAdvisor (order=0)
                    │
                    ├─ 独立执行向量检索
                    ├─ 捕获RAG来源元数据 → ChatContext
                    ▼
         MessageChatMemoryAdvisor (order=100)
                    │
                    ├─ 从 DatabaseChatMemory 加载最近N条历史消息
                    ├─ 注入到 Prompt 的消息列表
                    ▼
         QuestionAnswerAdvisor (order=200)
                    │
                    ├─ 执行向量语义搜索（topK=3, threshold=0.5）
                    ├─ 将检索结果通过 RAG Prompt Template 注入
                    ▼
           LLM 调用 → Function Calling → 生成回复
                    │
                    ▼
         MessageChatMemoryAdvisor（响应后）
                    │
                    └─ 自动持久化 user/assistant 消息到数据库
```

### 4.4 对话记忆持久化（DatabaseChatMemory）

系统自定义实现了`ChatMemory`接口，将对话记忆持久化到MySQL，解决了以下问题：

- **服务重启不丢失**：默认的`InMemoryChatMemory`在服务重启后会丢失所有对话上下文
- **多实例共享**：分布式部署时多个实例可共享对话历史
- **窗口限制**：仅加载最近N条消息（默认30条），避免上下文无限增长导致Token溢出

```
DatabaseChatMemory 工作原理：
├── add(conversationId, messages)
│   └── 遍历消息列表，逐条写入 ai_chat_message 表
├── get(conversationId)
│   ├── 按时间倒序查询最近 30 条消息
│   └── 反转为时间正序返回
└── clear(conversationId)
    └── 删除该会话的所有消息记录
```

### 4.5 SSE实时通信与工具调用可视化

系统采用Server-Sent Events（SSE）实现服务端向客户端的实时推送：

```
SSE 事件类型：
├── data（默认）  → AI文本回复内容
├── tool_call     → 工具调用通知（工具名+描述，如"正在搜索商品..."）
├── card_data     → 结构化卡片数据（商品卡片/订单卡片）
├── rag_source    → RAG来源溯源信息（命中的知识条目）
├── data_changed  → 数据变更通知（工具修改数据后通知前端刷新购物车/订单等）
├── message_id    → 本轮AI回复的消息ID（供前端点赞/点踩反馈使用）
└── [DONE]        → 对话结束标记
```

**SSE安全认证机制**：由于SSE使用GET请求（EventSource API不支持自定义Header），无法直接携带JWT Token。系统设计了一次性Ticket机制：

```
安全流程：
1. 前端先 POST /ai/chat/stream-ticket（携带JWT）获取一次性 ticket
2. Redis 存储 ticket → loginUuid 映射（60秒TTL）
3. 前端通过 EventSource 连接 /ai/chat/stream?ticket=xxx
4. JwtAuthenticationTokenFilter 检测到 ticket 参数：
   ├─ 从 Redis 获取 loginUuid
   ├─ 立即删除 ticket（一次性使用，防重放攻击）
   └─ 恢复 SecurityContext
```

### 4.6 AI调用重试机制

系统通过Spring Retry为AI调用提供了容错保障：

```
RetryConfig 配置：
├── 最大重试次数：3次（smart-cs.chat.retry-max-attempts）
├── 重试间隔：初始2秒，指数退避（multiplier=2）
├── 最大间隔：10秒
├── 重试条件：Exception.class（所有异常均重试）
└── 重试耗尽回调：记录日志，返回友好提示
```

### 4.7 异步线程与安全上下文传递

SSE对话在异步线程中执行，需要特别处理安全上下文传递：

```java
// 主线程捕获 SecurityContext
SecurityContext securityContext = SecurityContextHolder.getContext();

CompletableFuture.runAsync(() -> {
    // 异步线程恢复安全上下文
    SecurityContextHolder.setContext(securityContext);
    // 绑定 ChatContext（ThreadLocal）
    ChatContext.setSessionId(sessionId);
    ChatContext.setEmitter(emitter);
    try {
        // AI对话处理...
    } finally {
        ChatContext.clear();          // 清理ThreadLocal防内存泄漏
        SecurityContextHolder.clearContext();  // 清理安全上下文
    }
});
```

---

## 五、MCP工具系统设计

### 5.1 MCP协议概述

MCP（Model Context Protocol）是一种开放标准协议，定义了AI模型与外部工具/数据源之间的交互规范。本项目通过`spring-ai-starter-mcp-server-webmvc`将业务工具暴露为标准MCP端点：

```
MCP Server 架构：
┌─────────────────────────────┐
│    MCP Server (WebMVC)      │
│    名称: smart-cs-mcp-server │
│    版本: 1.0.0               │
├─────────────────────────────┤
│  /mcp/tools/list            │ ← 列出所有可用工具
│  /mcp/tools/call            │ ← 调用指定工具
├─────────────────────────────┤
│  ToolCallbackProvider       │
│  ├── ProductMcpTools (5)    │
│  ├── OrderMcpTools (6)      │
│  ├── CartMcpTools (6)       │
│  ├── TicketMcpTools (6)     │
│  ├── UserMcpTools (7)       │
│  ├── NotificationMcpTools(5)│
│  └── ReviewMcpTools (3)     │
└─────────────────────────────┘
```

### 5.2 工具分组与功能清单

#### 5.2.1 商品工具组（ProductMcpTools）

| 工具名 | 功能 | 参数 | 触发场景 |
|--------|------|------|----------|
| `searchProducts` | 搜索商品列表 | keyword, category, minPrice, maxPrice | 用户搜索/查找商品 |
| `getProductDetail` | 获取商品详情 | productId | 用户询问商品具体信息 |
| `compareProducts` | 对比两个商品 | productId1, productId2 | 用户要求对比商品 |
| `recommendProducts` | 场景化推荐 | scene, budget | 用户需要购买建议 |
| `getProductReviews` | 查询商品评价 | productId | 用户想了解商品口碑 |

**智能降级机制**：当`keyword + category`同时设置但无结果时，自动放宽条件（仅保留keyword）重试。

#### 5.2.2 订单工具组（OrderMcpTools）

| 工具名 | 功能 | 参数 | 安全控制 |
|--------|------|------|----------|
| `queryOrder` | 按订单号查详情 | orderNo | 所有权校验 + 数据脱敏 |
| `queryUserOrders` | 查用户订单列表 | status（可选） | 自动绑定当前用户 |
| `queryLogistics` | 查物流信息 | orderNo | 所有权校验 |
| `cancelOrder` | 取消订单 | orderNo | 仅限PENDING状态 + 二次确认 |
| `confirmReceive` | 确认收货 | orderNo | 仅限SHIPPED状态 |
| `payOrder` | 模拟支付 | orderNo | 仅限PENDING状态 + 金额确认 |

#### 5.2.3 购物车工具组（CartMcpTools）

| 工具名 | 功能 | 参数 | 说明 |
|--------|------|------|------|
| `viewCart` | 查看购物车 | - | 返回商品列表+总计信息 |
| `addToCart` | 加入购物车 | productId, quantity | 已有商品自动累加数量 |
| `removeFromCart` | 移除商品 | productId | - |
| `updateCartQuantity` | 修改数量 | productId, quantity | - |
| `clearCart` | 清空购物车 | - | 危险操作，AI先确认 |
| `checkoutFromCart` | 结算下单 | remark | 使用默认地址+库存扣减+事务保护 |

#### 5.2.4 工单工具组（TicketMcpTools）

| 工具名 | 功能 | 参数 | 说明 |
|--------|------|------|------|
| `createTicket` | 创建售后工单 | orderNo, type, description | 类型：COMPLAINT/REFUND/EXCHANGE/CONSULT |
| `queryTicket` | 查工单详情 | ticketNo | 所有权校验 |
| `queryUserTickets` | 查用户工单列表 | - | 自动绑定当前用户 |
| `replyTicket` | 回复工单 | ticketNo, content | 支持多轮沟通 |
| `closeTicket` | 关闭工单 | ticketNo | 二次确认 |
| `escalateToHuman` | 转人工客服 | reason | 自动创建高优先级工单 |

#### 5.2.5 用户工具组（UserMcpTools）

| 工具名 | 功能 | 参数 | 说明 |
|--------|------|------|------|
| `queryUserInfo` | 查询个人信息 | - | 手机号脱敏返回 |
| `queryUserAddresses` | 查地址列表 | - | 详细地址/手机脱敏 |
| `queryDefaultAddress` | 查默认地址 | - | 下单时自动使用 |
| `setDefaultAddress` | 设默认地址 | addressId | - |
| `addAddress` | 新增地址 | contactName, phone, province, city, district, detail | 首个地址自动设为默认 |
| `updateAddress` | 修改地址 | addressId + 地址字段 | 所有权校验 |
| `deleteAddress` | 删除地址 | addressId | 所有权校验 |

#### 5.2.6 通知工具组（NotificationMcpTools）

| 工具名 | 功能 | 说明 |
|--------|------|------|
| `queryUnreadNotifications` | 查未读通知 | - |
| `getUnreadCount` | 未读通知数 | - |
| `markNotificationRead` | 标记单条已读 | - |
| `markAllNotificationsRead` | 全部已读 | - |
| `queryNotificationHistory` | 通知历史 | 分页查询 |

#### 5.2.7 评价工具组（ReviewMcpTools）

| 工具名 | 功能 | 说明 |
|--------|------|------|
| `submitProductReview` | 提交商品评价 | 1-5分评分 + 文字评价 |
| `checkReviewStatus` | 检查是否已评价 | 评价前先检查 |
| `queryMyReviews` | 查评价历史 | 分页查询 |

### 5.3 工具调用安全机制

每个MCP工具都内置了多层安全保障：

```
工具调用安全链路：
├── 1. 身份认证：SecurityUtils.getUserId() 获取当前登录用户
├── 2. 所有权校验：对比数据归属用户与当前用户（非管理员只能操作自己的数据）
├── 3. 状态校验：订单状态机检查（如仅PENDING可取消，仅SHIPPED可确认收货）
├── 4. 数据脱敏：SensitiveDataMasker 对手机号、地址等敏感字段脱敏
├── 5. 二次确认：危险操作（取消订单、清空购物车）AI先向用户确认
└── 6. 日志审计：ToolCallLog 记录每次工具调用的参数、耗时、成功/失败
```

### 5.4 工具调用日志与事件机制

每个工具调用都会：

1. **记录ToolCallLog**：写入`ai_tool_call_log`表（工具名、参数、会话ID、成功标志、耗时、错误信息）
2. **发布ToolCallEvent**：通过Spring `ApplicationEventPublisher`发布事件
3. **SSE实时推送**：`ChatService`监听事件，通过SseEmitter推送到前端
4. **卡片数据传递**：商品/订单查询结果以结构化卡片数据推送，前端渲染为可交互的卡片组件

```
工具调用事件流：
MCP Tool 方法执行
    │
    ├─ logToolCall() → ai_tool_call_log 表
    │
    ├─ publishToolCallEvent() → Spring Event
    │       │
    │       ▼
    │   ChatService.handleToolCallEvent()
    │       │
    │       ├─ SSE event: tool_call → {"toolName":"searchProducts","description":"搜索到5个商品"}
    │       └─ SSE event: card_data → {"cardType":"product","items":[...]}
    │
    └─ ChatContext.addToolCallName() → 累积到ThreadLocal（供审计使用）
```

---

## 六、RAG知识库系统设计

### 6.1 RAG架构概述

RAG（Retrieval-Augmented Generation，检索增强生成）是本系统的核心技术之一，通过将外部知识注入LLM的上下文，提升回答的准确性和专业性。

```
RAG 处理流程：
用户问题 "退货政策是什么？"
    │
    ▼
VectorStore.similaritySearch()
    │  query = "退货政策是什么？"
    │  topK = 3
    │  similarityThreshold = 0.5
    ▼
匹配到知识条目：
    ├── [score=0.89] 退换货政策：7天无理由退货...
    ├── [score=0.72] 保修信息：全国联保1年...
    └── [score=0.65] 售后注意事项：请保留发票...
    │
    ▼
RAG Prompt Template 注入：
    "用户问题：退货政策是什么？
     以下是从知识库中检索到的参考信息：
     {检索结果}
     回答要求：优先引用参考信息..."
    │
    ▼
LLM 生成回答（融合知识库内容，不暴露内部术语）
```

### 6.2 知识库数据模型

```
ai_knowledge（知识条目表）
├── knowledge_id     BIGINT PK  知识ID
├── title            VARCHAR    标题
├── content          TEXT       知识内容（纯文本）
├── category         VARCHAR    分类：FAQ/POLICY/PRODUCT_INFO/GUIDE
├── product_category VARCHAR    商品分类（商品类知识专用）
├── source_type      VARCHAR    来源类型：MANUAL（手动）/ PRODUCT_AUTO（商品自动同步）
├── source_id        BIGINT     来源ID（关联商品ID等）
├── status           TINYINT    状态：0禁用 1启用
└── create_time      DATETIME   创建时间

ai_knowledge_doc（知识文档表）
├── doc_id           BIGINT PK  文档ID
├── file_name        VARCHAR    原始文件名
├── file_path        VARCHAR    存储路径
├── file_type        VARCHAR    文件类型：txt/md/pdf
├── file_size        BIGINT     文件大小（字节）
├── chunk_count      INT        分片数量
├── status           VARCHAR    状态：PENDING/PROCESSING/COMPLETED/FAILED
└── create_time      DATETIME   创建时间
```

### 6.3 知识库管理功能

| 功能 | 说明 |
|------|------|
| **手动添加** | 管理员手动录入知识条目（标题+内容+分类），立即向量化并持久化 |
| **文档上传** | 支持txt/md/pdf文件上传，异步解析→分片→向量化 |
| **商品自动同步** | 商品新增/修改时，通过Spring Event自动生成/更新对应知识条目 |
| **向量库重建** | vectorstore.json损坏时，可一键从数据库重建全部向量 |
| **知识禁用/删除** | 禁用或删除知识条目时，同步从向量库中移除 |

### 6.4 商品知识自动同步机制

这是本系统的一个重要创新点——商品数据与知识库的自动联动：

```
商品变更 → ProductChangeEvent → ProductKnowledgeSyncListener
    │
    ├── CREATED / UPDATED：
    │   ├── 构造结构化知识内容（名称/分类/价格/卖点/规格/退换货政策/保修/评价统计）
    │   ├── 查找是否已有 source_type=PRODUCT_AUTO 的知识条目
    │   ├── 存在 → 更新知识内容 + 重新向量化
    │   └── 不存在 → 新建知识条目 + 向量化
    │
    └── OFF_SHELF / DELETED：
        ├── 将对应知识条目状态设为禁用
        └── 从向量库中移除
```

### 6.5 向量存储与并发保护

系统使用`SimpleVectorStore`（文件持久化到vectorstore.json），通过`ReentrantReadWriteLock`保护并发写入：

```java
private final ReentrantReadWriteLock vectorStoreLock = new ReentrantReadWriteLock();

// 写入时加写锁
vectorStoreLock.writeLock().lock();
try {
    vectorStore.add(documents);
    vectorStore.save(new File(vectorStorePath));
} finally {
    vectorStoreLock.writeLock().unlock();
}
```

### 6.6 RAG溯源（RagSourceCapturingAdvisor）

自定义的`RagSourceCapturingAdvisor`在RAG检索后捕获来源信息，用于：

1. **前端展示**：通过SSE推送`rag_source`事件，前端展示"来源参考"
2. **审计记录**：写入`ai_chat_turn_audit`表的`rag_source`字段
3. **效果评测**：统计RAG命中率指标

---

## 七、数据库设计

### 7.1 数据库总览

系统数据库基于MySQL 8，分为三大类表：

| 类别 | 表数量 | 说明 |
|------|--------|------|
| **系统管理表** | 10+ | 若依框架自带（sys_user, sys_role, sys_menu等） |
| **AI相关表** | 7 | 对话会话、消息、知识库、文档、审计、工具日志 |
| **业务表** | 9 | 商品、订单、订单项、工单、工单回复、购物车、评价、地址、通知 |

### 7.2 ER关系图（核心表）

```
sys_user (若依用户表)
    │1
    │
    ├──N ai_chat_session (对话会话)
    │       │1
    │       └──N ai_chat_message (对话消息)
    │               └── feedback (满意度反馈)
    │
    ├──N biz_order (订单)
    │       │1
    │       └──N biz_order_item (订单项)
    │               │
    │               └──1 biz_product (商品)
    │
    ├──N biz_cart_item (购物车项)
    │       └──1 biz_product
    │
    ├──N biz_ticket (工单)
    │       │1
    │       ├──N biz_ticket_reply (工单回复)
    │       └──? biz_order (关联订单，可为空)
    │
    ├──N biz_review (商品评价)
    │       ├──1 biz_order_item
    │       └──1 biz_product
    │
    ├──N biz_address (收货地址)
    │
    └──N biz_notification (站内通知)

ai_knowledge (知识库) ──?── biz_product (商品自动同步)
ai_knowledge_doc (知识文档)
ai_chat_turn_audit (对话审计)
ai_tool_call_log (工具调用日志)
```

### 7.3 业务核心表结构

#### 7.3.1 商品表（biz_product）

| 字段 | 类型 | 说明 |
|------|------|------|
| product_id | BIGINT PK | 商品ID |
| name | VARCHAR(200) | 商品名称 |
| category | VARCHAR(50) | 分类（手机/笔记本电脑/平板电脑/耳机/智能手表/充电器配件） |
| price | DECIMAL(10,2) | 价格 |
| stock | INT | 库存 |
| highlights | TEXT | 核心卖点 |
| description | TEXT | 详细规格描述 |
| image_url | VARCHAR(255) | 商品图片 |
| refund_policy | VARCHAR(500) | 退换货政策 |
| warranty_info | VARCHAR(500) | 保修信息 |
| after_sale_note | VARCHAR(500) | 售后注意事项 |
| status | TINYINT | 状态：0下架 1上架 |

#### 7.3.2 订单表（biz_order）

| 字段 | 类型 | 说明 |
|------|------|------|
| order_id | BIGINT PK | 订单ID |
| order_no | VARCHAR(50) UNIQUE | 订单编号（如ORD20260001） |
| user_id | BIGINT FK | 用户ID |
| total_amount | DECIMAL(10,2) | 订单总金额 |
| status | VARCHAR(20) | 状态：PENDING/PAID/SHIPPED/DELIVERED/CANCELLED/REFUNDED |
| address | VARCHAR(500) | 收货地址 |
| logistics_no | VARCHAR(50) | 物流单号 |
| logistics_company | VARCHAR(50) | 物流公司 |
| remark | VARCHAR(500) | 备注 |

#### 7.3.3 工单表（biz_ticket）

| 字段 | 类型 | 说明 |
|------|------|------|
| ticket_id | BIGINT PK | 工单ID |
| ticket_no | VARCHAR(50) UNIQUE | 工单编号 |
| user_id | BIGINT FK | 提交用户 |
| order_id | BIGINT FK | 关联订单（可为空） |
| type | VARCHAR(20) | 类型：COMPLAINT/REFUND/EXCHANGE/CONSULT |
| title | VARCHAR(200) | 标题 |
| description | TEXT | 问题描述 |
| status | VARCHAR(20) | 状态：OPEN/PROCESSING/RESOLVED/CLOSED |
| priority | INT | 优先级（转人工为高优先级） |

### 7.4 AI相关表结构

#### 7.4.1 对话会话表（ai_chat_session）

| 字段 | 类型 | 说明 |
|------|------|------|
| session_id | BIGINT PK | 会话ID |
| user_id | BIGINT FK | 用户ID |
| title | VARCHAR(200) | 会话标题（首条消息自动摘要） |
| pinned | TINYINT | 是否置顶 |
| status | TINYINT | 状态：0已关闭 1活跃 |

#### 7.4.2 对话消息表（ai_chat_message）

| 字段 | 类型 | 说明 |
|------|------|------|
| message_id | BIGINT PK | 消息ID |
| session_id | BIGINT FK | 会话ID |
| role | VARCHAR(20) | 角色：user/assistant/system |
| content | TEXT | 消息内容 |
| cards_data | TEXT | 卡片数据（JSON，商品/订单结构化数据） |
| feedback | TINYINT | 满意度：0不满意 1满意 NULL未评价 |

#### 7.4.3 对话审计表（ai_chat_turn_audit）

| 字段 | 类型 | 说明 |
|------|------|------|
| audit_id | BIGINT PK | 审计ID |
| session_id | BIGINT | 会话ID |
| user_id | BIGINT | 用户ID |
| user_message | TEXT | 用户消息（截断5000字符） |
| ai_response | TEXT | AI回复（截断10000字符） |
| rag_source | TEXT | RAG来源（JSON） |
| tool_calls | TEXT | 工具调用链（JSON） |
| has_rag_hit | TINYINT | 是否命中RAG |
| duration_ms | BIGINT | 响应耗时（毫秒） |

#### 7.4.4 工具调用日志表（ai_tool_call_log）

| 字段 | 类型 | 说明 |
|------|------|------|
| log_id | BIGINT PK | 日志ID |
| tool_name | VARCHAR(100) | 工具名称 |
| tool_params | TEXT | 调用参数 |
| session_id | BIGINT | 关联会话 |
| success_flag | TINYINT | 成功标志：0失败 1成功 |
| duration_ms | BIGINT | 执行耗时（毫秒） |
| error_msg | TEXT | 错误信息 |

### 7.5 数据库增量迁移策略

项目采用按日期命名的SQL增量迁移脚本，便于版本管理和环境部署：

```
sql/
├── ry_20250522.sql                    # 若依基础数据库
├── smart-cs-tables.sql                # 智能客服系统建表脚本
├── smart-cs-data.sql                  # 初始数据
├── 2026-02-21_工具调用日志表.sql        # 增量：工具调用日志
├── 2026-02-27_订单流程增强.sql          # 增量：订单状态机
├── 2026-02-27_通知系统.sql             # 增量：通知系统
├── 2026-02-28_知识库来源追踪.sql        # 增量：RAG溯源
├── 2026-03-04_RAG溯源与审计记录.sql     # 增量：审计表
├── 2026-03-07_商品评价.sql             # 增量：评价系统
├── 2026-03-07_收货地址管理.sql          # 增量：地址管理
├── 2026-03-08_购物车系统.sql           # 增量：购物车
├── 2026-03-13_消息卡片数据持久化.sql     # 增量：卡片数据
├── 2026-03-14_安全问题系统升级.sql       # 增量：安全问题
└── ... (共40+增量脚本)
```

---

## 八、电商业务功能设计

### 8.1 商品管理

```
商品生命周期：
创建商品 → 上架(status=1) → 用户可搜索/购买
                │
                ├── 修改商品信息 → 自动同步知识库
                │
                └── 下架(status=0) → 用户不可见 → 禁用知识库条目
```

**功能清单：**
- 商品CRUD（名称、分类、价格、库存、图片、卖点、规格描述）
- 售后信息管理（退换货政策、保修信息、售后注意事项）
- 上架/下架状态管理
- 商品变更事件发布（`ProductChangeEvent`）→ 知识库自动同步
- 商品分类：手机、笔记本电脑、平板电脑、耳机、智能手表/手环、充电器/配件

### 8.2 订单管理

#### 订单状态机

```
         ┌─────────┐
         │ PENDING  │ (待付款)
         │ 创建订单  │
         └────┬─────┘
              │
    ┌─────────┼──────────┐
    │ payOrder │          │ cancelOrder
    ▼         │          ▼
┌─────────┐   │   ┌──────────┐
│  PAID   │   │   │CANCELLED │ (已取消)
│ 已付款   │   │   │ 库存回滚  │
└────┬────┘   │   └──────────┘
     │ 管理员发货
     ▼
┌─────────┐
│ SHIPPED │ (已发货)
│ 填写物流 │
└────┬────┘
     │ confirmReceive
     ▼
┌──────────┐
│DELIVERED │ (已签收)
│ 可评价   │
└────┬─────┘
     │ 退款申请
     ▼
┌──────────┐
│ REFUNDED │ (已退款)
└──────────┘
```

#### 订单状态转换规则（OrderStatusTransition）

| 当前状态 | 允许转换到 | 操作人 |
|---------|-----------|--------|
| PENDING | PAID, CANCELLED | 用户 |
| PAID | SHIPPED, REFUNDED | 管理员 |
| SHIPPED | DELIVERED | 用户 |
| DELIVERED | REFUNDED | 管理员 |

### 8.3 购物车系统

```
购物车功能：
├── 添加商品（已有则累加数量，校验库存上限）
├── 修改数量（校验库存）
├── 移除商品
├── 勾选/取消勾选
├── 查看购物车摘要（总件数、已勾选件数、总价）
├── 清空购物车（危险操作，需二次确认）
└── 结算下单：
    ├── 获取已勾选商品
    ├── 获取默认收货地址
    ├── 创建订单（事务保护 + 库存扣减）
    └── 清除已下单的购物车商品
```

### 8.4 售后工单系统

```
工单类型：
├── COMPLAINT（投诉）
├── REFUND（退款）
├── EXCHANGE（换货）
└── CONSULT（咨询/转人工）

工单状态流转：
OPEN → PROCESSING → RESOLVED → CLOSED

工单多轮沟通：
├── 用户创建工单（包含描述）
├── 管理员回复 → 通知用户
├── 用户追加回复 → biz_ticket_reply 表
├── 管理员再次回复
└── 用户关闭工单 / 管理员解决工单

转人工机制：
├── AI判断无法解决 → 调用 escalateToHuman
├── 创建 priority=1（高优先级）的 CONSULT 工单
└── 标题前缀"【转人工】"+ 转接原因
```

### 8.5 商品评价系统

```
评价流程：
订单确认收货(DELIVERED) → 用户评价商品
    │
    ├── checkReviewStatus：检查是否已评价
    ├── submitProductReview：提交评分(1-5) + 评价内容
    └── 管理员可回复评价
```

### 8.6 收货地址管理

- 用户可管理多个收货地址
- 支持设置默认地址
- 购物车结算自动使用默认地址
- 地址字段：联系人、电话、省/市/区、详细地址

### 8.7 站内通知系统

```
通知触发场景：
├── 订单状态变更 → 通知用户
├── 工单回复 → 通知用户
├── 系统公告 → 全员通知
└── AI产生的通知

通知功能：
├── 未读通知查询
├── 未读数量角标
├── 单条/全部标记已读
└── 通知历史记录
```

---

## 九、前端系统设计

### 9.1 前端架构

```
ruoyi-ui/src/
├── views/
│   ├── customer/                    # 用户端页面
│   │   ├── chat/index.vue          # AI客服对话页面（SSE通信）
│   │   ├── cart/index.vue          # 购物车页面
│   │   └── profile/                # 个人中心
│   │       ├── index.vue           # 个人信息
│   │       └── addressManage.vue   # 地址管理
│   │
│   ├── shop/
│   │   └── product/index.vue       # 商品橱窗（用户浏览）
│   │
│   ├── home/
│   │   └── UserHome.vue            # 用户首页
│   │
│   ├── ai/                          # AI管理后台（管理员）
│   │   ├── chat/                    # 对话管理
│   │   │   ├── index.vue           # 聊天主界面
│   │   │   └── components/
│   │   │       ├── SessionList.vue  # 会话列表（置顶/重命名/删除）
│   │   │       ├── MessageList.vue  # 消息列表（Markdown渲染）
│   │   │       ├── MessageBubble.vue # 消息气泡（满意度反馈）
│   │   │       ├── MessageInput.vue # 消息输入框
│   │   │       ├── ProductCard.vue  # 商品卡片组件
│   │   │       └── OrderCard.vue   # 订单卡片组件
│   │   ├── knowledge/index.vue     # 知识库管理
│   │   └── dashboard/index.vue     # AI数据仪表盘（ECharts）
│   │
│   ├── business/                    # 业务管理后台（管理员）
│   │   ├── product/index.vue       # 商品管理
│   │   ├── order/
│   │   │   ├── index.vue           # 订单管理（管理员）
│   │   │   └── my.vue             # 我的订单（用户）
│   │   ├── ticket/
│   │   │   ├── index.vue           # 工单管理（管理员）
│   │   │   └── my.vue             # 我的工单（用户）
│   │   ├── review/index.vue        # 评价管理
│   │   └── notification/index.vue  # 通知管理
│   │
│   └── system/                      # 系统管理
│       ├── user/                    # 用户管理
│       ├── role/                    # 角色管理
│       ├── menu/                    # 菜单管理
│       └── resetRequest/index.vue   # 密码重置请求管理
│
├── layout/
│   ├── index.vue                    # 管理后台布局
│   └── CustomerLayout.vue           # 用户端布局
│
└── components/
    └── PayDialog/index.vue          # 支付对话框组件
```

### 9.2 AI聊天界面设计

AI聊天界面是系统的核心交互页面，采用经典的即时通讯布局：

```
┌─────────────────────────────────────────────────────────┐
│  左侧面板 (SessionList)  │  右侧主区域                    │
│  ┌────────────────────┐  │  ┌─────────────────────────┐  │
│  │ + 新建会话          │  │  │  消息列表 (MessageList)  │  │
│  │ 📌 置顶会话1       │  │  │  ┌───────────────────┐  │  │
│  │ 💬 会话2           │  │  │  │ 用户: 有什么手机？ │  │  │
│  │ 💬 会话3           │  │  │  └───────────────────┘  │  │
│  │ ...                │  │  │  ┌───────────────────┐  │  │
│  │                    │  │  │  │ 🔧 正在搜索商品... │  │  │
│  │                    │  │  │  └───────────────────┘  │  │
│  │                    │  │  │  ┌───────────────────┐  │  │
│  │                    │  │  │  │ 📱 商品卡片列表    │  │  │
│  │                    │  │  │  │ [ProductCard]×N    │  │  │
│  │                    │  │  │  └───────────────────┘  │  │
│  │                    │  │  │  ┌───────────────────┐  │  │
│  │                    │  │  │  │ AI: 为您找到...    │  │  │
│  │                    │  │  │  │ [Markdown渲染]     │  │  │
│  │                    │  │  │  │ 👍 👎 (满意度)    │  │  │
│  │                    │  │  │  └───────────────────┘  │  │
│  │                    │  │  └─────────────────────────┘  │
│  │                    │  │  ┌─────────────────────────┐  │
│  └────────────────────┘  │  │  输入框 (MessageInput)  │  │
│                          │  └─────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

**关键交互特性：**
- **SSE实时通信**：消息通过EventSource接收，支持打字机效果
- **Markdown渲染**：AI回复使用markdown-it渲染，支持表格、列表、代码块
- **XSS防护**：所有渲染内容经DOMPurify净化
- **商品卡片**：ProductCard组件展示商品图片、名称、价格、核心卖点
- **订单卡片**：OrderCard组件展示订单号、状态、金额
- **工具调用动画**：收到tool_call事件时显示"正在搜索商品..."等加载提示
- **满意度反馈**：每条AI回复支持点赞/点踩
- **会话管理**：置顶、重命名、删除会话
- **RAG来源展示**：显示AI回答所引用的知识来源

### 9.3 AI数据仪表盘

管理员仪表盘使用ECharts可视化展示AI运营数据：

```
数据仪表盘指标：
├── 汇总卡片：
│   ├── 用户总数、会话数、消息数、知识库条数
│   ├── 订单数、工单数
│   └── 平均对话轮次、满意度统计
│
├── 趋势图表：
│   ├── 消息量趋势（折线图）
│   ├── 会话量趋势（折线图）
│   ├── 工单类型分布（饼图）
│   ├── 工单状态分布（饼图）
│   ├── 知识库分类分布（柱状图）
│   ├── 订单状态分布（饼图）
│   ├── 工具调用统计（柱状图）
│   └── 热门问题排行（列表）
│
└── AI效果评测：
    ├── 工具调用成功率（数值+趋势）
    ├── RAG知识命中率（数值+趋势）
    ├── 用户满意度（数值+趋势）
    ├── 平均对话轮次（数值+趋势）
    └── 转人工率（数值+趋势）
```

### 9.4 角色化页面路由

系统实现了基于角色的差异化页面展示：

| 角色 | 可见页面 | 布局 |
|------|---------|------|
| **普通用户** | 商品橱窗、AI客服对话、购物车、我的订单、我的工单、个人中心、通知 | CustomerLayout |
| **管理员** | 商品管理、订单管理、工单管理、评价管理、知识库管理、AI仪表盘、用户管理、角色管理、日志 | 管理后台Layout |

---

## 十、安全设计

### 10.1 认证机制

```
认证架构：
├── JWT Token认证
│   ├── 登录 → 生成JWT Token（30分钟有效期）
│   ├── 请求携带 Authorization Header
│   └── JwtAuthenticationTokenFilter 验证Token
│
├── SSE Ticket认证（创新点）
│   ├── 问题：EventSource API不支持自定义Header
│   ├── 方案：一次性短期Ticket替代JWT暴露
│   ├── 流程：POST获取ticket → GET携带ticket → 验证后立即删除
│   └── 安全性：60秒TTL + 一次性使用 + Redis存储
│
└── 验证码机制
    ├── 图形验证码（登录/注册）
    └── 安全问题验证（密码重置）
```

### 10.2 授权机制（RBAC）

```
RBAC权限模型：
sys_user ──N:N── sys_role ──N:N── sys_menu

权限控制：
├── 菜单权限：控制前端页面/按钮的可见性
├── 接口权限：@PreAuthorize("@ss.hasPermi('xxx')") 控制API访问
├── 数据权限：DataScope注解控制数据行级访问
└── MCP工具权限：工具内部通过SecurityUtils获取当前用户，校验数据所有权
```

### 10.3 数据安全

| 安全措施 | 实现方式 |
|----------|---------|
| **敏感数据脱敏** | SensitiveDataMasker：手机号(138****1234)、地址(前6字符+***) |
| **XSS防护** | XssFilter过滤请求参数 + DOMPurify前端净化 |
| **SQL注入防护** | MyBatis参数化查询 + SqlUtil安全检查 |
| **接口限流** | @RateLimiter注解 + Redis令牌桶 |
| **重复提交防护** | @RepeatSubmit注解 + 同URL数据拦截 |
| **密码安全** | BCrypt加密存储 + 错误次数锁定（5次/10分钟） |
| **消息长度限制** | 对话消息限制5000字符，防止Prompt注入 |
| **JSON安全序列化** | ObjectMapper替代字符串拼接，防止JSON注入 |

### 10.4 安全问题与密码重置

```
密码重置流程：
1. 用户忘记密码 → 输入用户名
2. 系统展示该用户的安全问题
3. 用户回答安全问题
4. 验证通过 → 创建密码重置请求
5. 管理员审核通过 → 重置密码
```

---

## 十一、审计与运营分析设计

### 11.1 对话审计（ChatTurnAudit）

每轮AI对话自动异步记录：

| 审计维度 | 记录内容 |
|----------|---------|
| 用户消息 | 截断保留5000字符 |
| AI回复 | 截断保留10000字符 |
| RAG来源 | 命中的知识条目ID、标题、分类（JSON） |
| 工具调用 | 本轮调用的所有工具名称（JSON数组） |
| RAG命中标记 | has_rag_hit: 0/1 |
| 响应耗时 | duration_ms（毫秒级精度） |

### 11.2 AI效果评测指标

| 指标 | 计算方式 | 意义 |
|------|---------|------|
| **工具调用成功率** | 成功次数 / 总调用次数 × 100% | 衡量工具可靠性 |
| **RAG知识命中率** | has_rag_hit=1的轮次 / 总轮次 × 100% | 衡量知识库覆盖度 |
| **用户满意度** | feedback=1 / 有反馈总数 × 100% | 衡量AI回答质量 |
| **平均对话轮次** | 各会话用户消息数的平均值 | 衡量问题解决效率 |
| **转人工率** | 调用escalateToHuman的会话 / 总会话 × 100% | 衡量AI自主解决能力 |

所有指标支持：
- 按天趋势图表展示
- 可选时间范围（1-90天）
- 实时刷新

---

## 十二、项目部署与运行

### 12.1 环境要求

| 环境 | 版本要求 |
|------|---------|
| JDK | 17+ |
| Maven | 3.8+ |
| MySQL | 8.0+ |
| Redis | 6.0+ |
| Node.js | 18+ |
| npm/yarn | 最新稳定版 |

### 12.2 后端部署

```bash
# 1. 导入数据库
mysql -u root -p ry-vue < sql/ry_20250522.sql
mysql -u root -p ry-vue < sql/smart-cs-tables.sql
mysql -u root -p ry-vue < sql/smart-cs-data.sql
# 按日期顺序执行增量SQL脚本...

# 2. 配置环境变量
export DASHSCOPE_API_KEY=your-dashscope-api-key

# 3. 修改数据库配置
# ruoyi-admin/src/main/resources/application-druid.yml

# 4. 编译打包
mvn clean package -DskipTests

# 5. 启动
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

### 12.3 前端部署

```bash
cd ruoyi-ui

# 安装依赖
npm install

# 开发环境
npm run dev

# 生产构建
npm run build:prod
```

### 12.4 关键配置项

```yaml
# application.yml 核心配置
spring.ai:
  openai:
    api-key: ${DASHSCOPE_API_KEY}         # 阿里云百炼API Key
    base-url: https://dashscope.aliyuncs.com/compatible-mode
    chat.options:
      model: qwen3.5-plus-2026-02-15      # LLM模型（qwen3.5-plus 快照版）
      temperature: 0.7                    # 生成温度
      max-tokens: 2048                    # 最大Token数
    embedding.options:
      model: text-embedding-v3            # 向量嵌入模型
  mcp.server:
    name: smart-cs-mcp-server             # MCP服务名称

smart-cs:
  vector-store.path: D:/ruoyi/uploadPath/vectorstore.json  # 向量存储路径
  chat:
    max-memory-messages: 30               # 最大记忆消息数
    retry-max-attempts: 3                 # AI调用重试次数
```

---

## 十三、项目总结

### 13.1 技术实现总结

本项目成功实现了一个基于Spring AI 1.0.0与MCP协议的智能电子商城AI客服系统，主要技术成果包括：

1. **MCP协议的工程化落地**：通过Spring AI的MCP Server组件，将7大业务工具组（38个工具方法）标准化暴露为MCP协议端点，实现了AI模型与电商业务系统的深度集成
2. **RAG知识库的自动化管理**：创新性地实现了商品数据到知识库的自动同步机制，通过Spring Event事件驱动，确保AI始终基于最新的商品信息进行回答
3. **对话记忆的持久化方案**：自定义DatabaseChatMemory实现，解决了服务重启后对话上下文丢失的问题
4. **全链路安全保障**：从SSE Ticket认证、数据所有权校验、敏感数据脱敏到XSS防护，构建了完整的安全体系
5. **AI运营可观测性**：通过对话审计和工具调用日志，实现了工具成功率、RAG命中率、用户满意度等多维度的AI效果评测

### 13.2 功能实现总结

| 功能模块 | 实现状态 | 关键特性 |
|----------|---------|---------|
| AI智能对话 | 已完成 | System Prompt工程、Advisor链、SSE实时推送 |
| MCP工具调用 | 已完成 | 7大工具组、38个工具、自动决策调用 |
| RAG知识库 | 已完成 | 向量检索、文档上传、商品自动同步、溯源 |
| 商品管理 | 已完成 | CRUD、上下架、知识库联动 |
| 订单管理 | 已完成 | 完整状态机、库存扣减、AI辅助操作 |
| 购物车 | 已完成 | 增删改查、结算下单、AI操作 |
| 售后工单 | 已完成 | 多类型、多轮沟通、转人工、AI创建 |
| 商品评价 | 已完成 | 评分评价、评价统计、管理员回复 |
| 地址管理 | 已完成 | 多地址、默认地址、AI操作 |
| 通知系统 | 已完成 | 站内通知、已读管理、AI查询 |
| 数据仪表盘 | 已完成 | 多维统计、趋势图表、AI效果评测 |
| 安全体系 | 已完成 | JWT+Ticket认证、RBAC、脱敏、XSS防护 |
| 用户系统 | 已完成 | 注册登录、角色管理、密码重置 |
| 自动化测试 | 已完成 | AI/业务模块单元测试（JUnit）、性能测试（AiPerformanceTest、BusinessPerformanceTest） |
