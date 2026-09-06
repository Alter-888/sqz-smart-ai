/*
 Navicat Premium Dump SQL

 Source Server         : 本地sql
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : sqz-smart-ai

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 11/03/2026 11:23:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_chat_message
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_message`;
CREATE TABLE `ai_chat_message`  (
  `message_id` bigint NOT NULL AUTO_INCREMENT,
  `session_id` bigint NOT NULL COMMENT '会话ID',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色：user/assistant/system',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容',
  `tool_calls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'AI 调用的工具信息（JSON，可为空）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `feedback` tinyint NULL DEFAULT NULL COMMENT '满意度反馈：1满意 0不满意 NULL未评价',
  PRIMARY KEY (`message_id`) USING BTREE,
  INDEX `idx_session_id`(`session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 133 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '对话消息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_chat_message
-- ----------------------------
INSERT INTO `ai_chat_message` VALUES (1, 1, 'user', '你好', NULL, '2026-02-28 10:04:34', NULL);
INSERT INTO `ai_chat_message` VALUES (2, 1, 'assistant', '好的，如果有任何问题或需要帮助的地方，请随时告诉我！我会尽力为您提供支持。', NULL, '2026-02-28 10:04:37', NULL);
INSERT INTO `ai_chat_message` VALUES (3, 1, 'user', '我当前是一个什么角色', NULL, '2026-02-28 10:04:57', NULL);
INSERT INTO `ai_chat_message` VALUES (4, 1, 'assistant', '你好！请问有什么可以帮您的吗？无论是查询订单、物流信息，还是售后问题，我都可以协助您处理。', NULL, '2026-02-28 10:05:07', NULL);
INSERT INTO `ai_chat_message` VALUES (5, 2, 'user', '你们的退货政策是什么？', NULL, '2026-02-28 12:36:35', NULL);
INSERT INTO `ai_chat_message` VALUES (6, 2, 'assistant', '好的！请告诉我您的问题，我会结合已有的信息或通用知识为您解答。', NULL, '2026-02-28 12:36:41', NULL);
INSERT INTO `ai_chat_message` VALUES (7, 3, 'user', '现在有什么商品可以购买？', NULL, '2026-02-28 16:54:14', NULL);
INSERT INTO `ai_chat_message` VALUES (8, 3, 'assistant', '好的，请告诉我您的问题或需求，我会根据我掌握的信息为您提供帮助！', NULL, '2026-02-28 16:54:16', NULL);
INSERT INTO `ai_chat_message` VALUES (9, 4, 'user', '帮我查询一下我的订单状态', NULL, '2026-03-01 12:23:38', NULL);
INSERT INTO `ai_chat_message` VALUES (10, 4, 'assistant', '好的，请告诉我你的问题或需求，我会根据已有的信息或通用知识为你提供帮助！', NULL, '2026-03-01 12:23:44', NULL);
INSERT INTO `ai_chat_message` VALUES (11, 5, 'user', '推荐一个手机', NULL, '2026-03-02 22:55:01', NULL);
INSERT INTO `ai_chat_message` VALUES (12, 5, 'assistant', '好的，请问您有什么具体的问题需要解答？如果有参考信息，我会结合它为您提供更准确的回答；如果没有，我也会尽力帮助您！', NULL, '2026-03-02 22:55:05', NULL);
INSERT INTO `ai_chat_message` VALUES (13, 5, 'user', '推荐一个手机', NULL, '2026-03-02 23:24:24', NULL);
INSERT INTO `ai_chat_message` VALUES (14, 5, 'assistant', '根据我的通用知识，以下是几款在不同价位和需求下的手机推荐：\n\n### 1. **预算有限（1000-2000元）**\n   - **Redmi Note 12 Turbo**  \n     - 性能：搭载骁龙7+ Gen 2处理器，性能强劲。  \n     - 屏幕：6.67英寸AMOLED高刷屏。  \n     - 电池：5000mAh大电池，支持67W快充。  \n     - 适合人群：学生党或预算有限的用户。\n\n### 2. **中端性价比（2000-3000元）**\n   - **Realme GT Neo5**  \n     - 性能：骁龙8+ Gen 1处理器，游戏体验优秀。  \n     - 充电：150W快充，充电速度极快。  \n     - 屏幕：144Hz高刷直屏，适合游戏玩家。  \n     - 适合人群：追求性价比和快充的用户。\n\n### 3. **高端旗舰（4000-6000元）**\n   - **iPhone 15**  \n     - 性能：A16芯片，iOS系统流畅稳定。  \n     - 相机：4800万像素主摄，拍照效果出色。  \n     - 适合人群：喜欢苹果生态和拍照的用户。\n   - **华为 Mate 60 Pro**  \n     - 性能：麒麟9000S处理器，鸿蒙OS。  \n     - 特色：卫星通信功能，适合户外爱好者。  \n     - 适合人群：支持国产和需要卫星通信的用户。\n\n### 4. **折叠屏手机（8000元以上）**\n   - **三星 Galaxy Z Fold5**  \n     - 屏幕：7.6英寸内屏，支持S Pen。  \n     - 性能：骁龙8 Gen 2 for Galaxy，多任务处理强。  \n     - 适合人群：商务人士或科技爱好者。\n\n如果您有具体的需求（如拍照、游戏、续航等）或预算范围，可以告诉我，我会为您推荐更合适的机型！', NULL, '2026-03-02 23:24:47', NULL);
INSERT INTO `ai_chat_message` VALUES (15, 6, 'user', '帮我查询一下我的订单状态', NULL, '2026-03-02 23:25:56', NULL);
INSERT INTO `ai_chat_message` VALUES (16, 6, 'assistant', '好的，请告诉我您的问题，我会结合参考信息和通用知识为您解答！', NULL, '2026-03-02 23:25:58', NULL);
INSERT INTO `ai_chat_message` VALUES (17, 7, 'user', '推荐一个手机', NULL, '2026-03-03 10:15:42', NULL);
INSERT INTO `ai_chat_message` VALUES (18, 7, 'assistant', '好的，请告诉我您的问题或需要帮助的内容，我会根据您的需求提供相应的帮助！', NULL, '2026-03-03 10:15:44', NULL);
INSERT INTO `ai_chat_message` VALUES (19, 7, 'user', '推荐一个手机', NULL, '2026-03-03 10:27:44', NULL);
INSERT INTO `ai_chat_message` VALUES (20, 7, 'assistant', '好的！请问您对手机有什么具体需求吗？比如：  \n- **预算**：比如2000元以内、3000-4000元等。  \n- **用途**：日常使用、游戏、拍照、商务等。  \n- **品牌偏好**：是否有喜欢的品牌（如华为、小米、苹果等）？  \n\n根据您的需求，我可以为您精准推荐合适的手机型号！📱😊', NULL, '2026-03-03 10:27:58', NULL);
INSERT INTO `ai_chat_message` VALUES (21, 7, 'user', '我系统里面有什么手机商品', NULL, '2026-03-03 10:29:09', NULL);
INSERT INTO `ai_chat_message` VALUES (22, 7, 'assistant', '好的！根据您的需求，我可以为您推荐几款不同价位和用途的热门手机 📱，供您参考：\n\n### 1. **预算2000元以内**\n   - **Redmi Note 12 Turbo**  \n     - **核心卖点**：骁龙7+ Gen2处理器，性能强劲；120Hz OLED屏幕；5000mAh大电池。  \n     - **价格**：约1799元起。  \n     - **适合人群**：学生党或预算有限，注重性价比的用户。  \n\n### 2. **预算3000-4000元**\n   - **realme GT5**  \n     - **核心卖点**：骁龙8 Gen2旗舰芯片；144Hz高刷屏；240W快充，充电速度极快。  \n     - **价格**：约3299元起。  \n     - **适合人群**：游戏玩家或追求高性能的用户。  \n\n### 3. **拍照旗舰**\n   - **vivo X90**  \n     - **核心卖点**：蔡司镜头+自研V2芯片，拍照效果顶级；天玑9200芯片；120Hz曲面屏。  \n     - **价格**：约3999元起。  \n     - **适合人群**：摄影爱好者或注重影像体验的用户。  \n\n### 4. **高端商务**\n   - **华为Mate 60 Pro**  \n     - **核心卖点**：鸿蒙OS 4.0；昆仑玻璃+卫星通信；XMAGE影像系统。  \n     - **价格**：约6999元起。  \n     - **适合人群**：商务人士或华为生态用户。  \n\n如果您有更具体的需求（比如品牌偏好或特殊功能），可以告诉我，我会进一步为您筛选！  \n或者，您是否需要了解某款手机的更多详情？😊', NULL, '2026-03-03 10:29:25', NULL);
INSERT INTO `ai_chat_message` VALUES (23, 7, 'user', '你们系统有什么商品卖', NULL, '2026-03-03 11:56:41', NULL);
INSERT INTO `ai_chat_message` VALUES (24, 7, 'assistant', '根据您的要求，我将为您查询系统中现有的手机商品信息。请稍等，我将调用工具为您检索最新的商品列表。 🛒🔍', NULL, '2026-03-03 11:56:48', NULL);
INSERT INTO `ai_chat_message` VALUES (25, 8, 'user', '你们系统有什么商品卖', NULL, '2026-03-03 12:57:15', NULL);
INSERT INTO `ai_chat_message` VALUES (26, 8, 'assistant', '好的，请告诉我您需要了解什么问题呢？😊 如果您有关于商品、订单或者售后的问题，都可以随时向我提问哦！🔍📦🔍', NULL, '2026-03-03 12:57:19', NULL);
INSERT INTO `ai_chat_message` VALUES (27, 9, 'user', '你们系统有什么商品卖', NULL, '2026-03-03 19:12:29', NULL);
INSERT INTO `ai_chat_message` VALUES (28, 9, 'assistant', '您好！我是小智，很高兴为您服务。请问您今天需要什么帮助呢？😊', NULL, '2026-03-03 19:12:31', NULL);
INSERT INTO `ai_chat_message` VALUES (29, 9, 'user', '查看我的订单', NULL, '2026-03-03 19:14:04', NULL);
INSERT INTO `ai_chat_message` VALUES (30, 9, 'assistant', '您好！我们系统中有各种商品，包括电子产品、家居用品、服装鞋帽、图书音像等。如果您有具体的商品名称、类型或使用场景，可以告诉我，我会帮您搜索或推荐合适的商品。😊', NULL, '2026-03-03 19:14:06', NULL);
INSERT INTO `ai_chat_message` VALUES (31, 10, 'user', '你们系统有什么商品卖', NULL, '2026-03-03 21:33:20', NULL);
INSERT INTO `ai_chat_message` VALUES (32, 10, 'assistant', '您好！我是小智，很高兴为您服务。请问您需要查询商品、订单还是有其他问题需要帮助？😊', NULL, '2026-03-03 21:33:22', NULL);
INSERT INTO `ai_chat_message` VALUES (33, 10, 'user', '查看我的订单', NULL, '2026-03-03 21:33:37', NULL);
INSERT INTO `ai_chat_message` VALUES (34, 10, 'assistant', '您好！我们系统中有丰富的商品，包括电子产品、家居用品、服饰鞋包、图书音像、食品饮料等。您需要了解哪一类商品呢？或者可以告诉我您想购买的场景和预算，我可以为您推荐合适的产品 😊', NULL, '2026-03-03 21:33:39', NULL);
INSERT INTO `ai_chat_message` VALUES (35, 11, 'user', '你们有什么商品卖', NULL, '2026-03-03 22:03:12', NULL);
INSERT INTO `ai_chat_message` VALUES (36, 11, 'assistant', '您好！我是小智，您的电商智能客服助手 😊\n\n我可以为您提供以下服务：\n\n🛍️ **商品导购**\n- 搜索商品、查看商品详情\n- 对比商品参数\n- 根据场景和预算为您推荐商品\n\n📦 **订单服务**\n- 查询您的订单状态\n- 查看物流进度\n\n🔧 **售后支持**\n- 提交投诉、退款、换货、咨询工单\n- 查询工单处理进度\n\n请问有什么可以帮您的吗？您可以直接告诉我您的需求，比如：\n- \"我想买一台笔记本电脑，预算5000元左右\"\n- \"帮我查一下订单ORD20250001的物流\"\n- \"我想对比两款手机\"\n- \"我的商品有问题，需要申请退款\"\n\n随时为您服务！👍', NULL, '2026-03-03 22:03:18', NULL);
INSERT INTO `ai_chat_message` VALUES (37, 12, 'user', '你们有什么商品卖', NULL, '2026-03-03 22:22:28', NULL);
INSERT INTO `ai_chat_message` VALUES (38, 12, 'assistant', '您好！😊 我们商城目前有丰富的商品供您选择，主要分为以下几类：\n\n## 📱 手机系列\n- **iPhone 15 Pro Max 256GB** - ¥12,990（库存96件）\n- **华为 Mate 60 Pro** - ¥6,999（库存80件）\n- **小米14 Ultra** - ¥5,999（库存120件）\n\n## 💻 电脑系列\n- **MacBook Pro 14英寸 M3** - ¥12,999（库存50件）\n- **联想 ThinkPad X1 Carbon** - ¥8,999（库存60件）\n\n## 🎧 配件系列\n- **AirPods Pro 2** - ¥1,799（库存200件）\n- **华为 FreeBuds Pro 3** - ¥1,199（库存150件）\n- **Apple Watch Series 9** - ¥2,999（库存80件）\n\n## 📟 平板系列\n- **iPad Air M2** - ¥4,799（库存70件）\n- **华为 MatePad Pro 13.2** - ¥5,699（库存40件）\n\n---\n\n请问您对哪类商品感兴趣呢？我可以为您提供：\n- 🔍 **商品详情**：查看具体规格参数\n- ⚖️ **商品对比**：帮您对比两款商品的差异\n- 💡 **场景推荐**：根据您的使用场景和预算推荐合适的商品\n\n是否需要了解更多详情呢？😊', NULL, '2026-03-03 22:22:41', NULL);
INSERT INTO `ai_chat_message` VALUES (39, 12, 'user', '查看我的订单', NULL, '2026-03-03 22:27:30', NULL);
INSERT INTO `ai_chat_message` VALUES (40, 12, 'assistant', '您好！😊 我为您查询到当前共有 **2个订单**：\n\n## 📋 您的订单列表\n\n| 订单编号 | 订单金额 | 下单时间 | 状态 |\n|---------|---------|---------|------|\n| ORD2027960831975133184 | ¥38,970.00 | 2026-03-01 12:15 | ✅ 已付款 |\n| ORD2027692769887748096 | ¥9,999.00 | 2026-02-28 18:30 | ✅ 已付款 |\n\n---\n\n两个订单目前都是**已付款**状态，请问您需要：\n\n1. 📦 **查看订单详情**：了解具体购买了哪些商品\n2. 🚚 **查询物流进度**：查看商品配送情况\n3. ❓ **其他问题**：如有任何疑问随时告诉我\n\n您可以告诉我订单编号，我帮您查询更详细的信息哦！😊', NULL, '2026-03-03 22:27:39', NULL);
INSERT INTO `ai_chat_message` VALUES (41, 12, 'user', '我刚刚问你什么了', NULL, '2026-03-03 23:00:32', NULL);
INSERT INTO `ai_chat_message` VALUES (42, 12, 'assistant', '您好！😊 回顾一下我们之前的对话，您刚刚问了两个问题：\n\n1. **第一问**：\"你们有什么商品卖\" \n   - 我为您介绍了商城的商品分类和主要商品\n\n2. **第二问**：\"查看我的订单\"\n   - 我为您查询到共有 2 个订单，都是已付款状态\n\n---\n\n现在您是想继续了解商品信息，还是需要查询某个订单的详情呢？📦\n\n有任何需要随时告诉我哦！😊', NULL, '2026-03-03 23:00:39', NULL);
INSERT INTO `ai_chat_message` VALUES (43, 12, 'user', '为我推荐一个华为手机', NULL, '2026-03-04 11:26:54', NULL);
INSERT INTO `ai_chat_message` VALUES (44, 12, 'assistant', '您好！😊 根据您的需求，我为您推荐一款华为手机：\n\n## 📱 华为 Mate 60 Pro\n\n- **价格**：¥6,999.00\n- **库存**：80件（现货充足）\n- **分类**：手机\n\n---\n\n这款华为 Mate 60 Pro 是华为的旗舰机型，性能强劲，适合日常使用和商务办公。\n\n**是否需要了解更多详情呢？** 我可以为您：\n- 🔍 查看详细的规格参数和核心卖点\n- ⚖️ 与其他华为手机进行对比\n- 🛒 如果您感兴趣，可以直接加入购物车\n\n请问您想了解哪方面信息呢？😊', NULL, '2026-03-04 11:27:03', NULL);
INSERT INTO `ai_chat_message` VALUES (45, 13, 'user', '你好', NULL, '2026-03-04 13:27:12', NULL);
INSERT INTO `ai_chat_message` VALUES (46, 13, 'assistant', '您好！我是小智，您的电商智能客服助手 😊\n\n很高兴为您服务！我可以帮您：\n- 🛒 **商品导购**：搜索商品、查看详情、对比参数、根据需求推荐\n- 📦 **订单服务**：查询订单状态、物流信息、取消订单、确认收货\n- 🎧 **售后支持**：提交工单、查询进度、转接人工客服\n\n请问今天有什么可以帮您的吗？', NULL, '2026-03-04 13:27:17', NULL);
INSERT INTO `ai_chat_message` VALUES (47, 14, 'user', '你好', NULL, '2026-03-04 13:28:01', NULL);
INSERT INTO `ai_chat_message` VALUES (48, 14, 'assistant', '您好！我是小智，您的电商智能客服助手 😊\n\n很高兴为您服务！我可以帮您：\n\n🛍️ **商品导购** - 搜索商品、查看详情、对比参数、根据需求推荐\n📦 **订单服务** - 查询订单状态、物流信息、取消订单、确认收货\n🔧 **售后支持** - 提交工单、查询处理进度、转接人工客服\n\n请问今天有什么可以帮您的吗？比如想看看有什么商品，或者查询一下订单？', NULL, '2026-03-04 13:28:07', NULL);
INSERT INTO `ai_chat_message` VALUES (49, 14, 'user', '退货政策是什么', NULL, '2026-03-04 13:28:49', NULL);
INSERT INTO `ai_chat_message` VALUES (50, 14, 'assistant', '您好！关于退货政策，我来为您介绍一下 📋\n\n## 🔄 退货政策概览\n\n**1. 退货期限**\n- 支持 **7天无理由退货**（自签收之日起计算）\n- 部分特殊商品（如定制类、生鲜类）除外\n\n**2. 退货条件**\n- ✅ 商品完好，不影响二次销售\n- ✅ 原包装、配件、标签齐全\n- ✅ 未使用、未洗涤、无损坏\n\n**3. 退货流程**\n1. 在订单页面申请退货/提交售后工单\n2. 等待客服审核通过\n3. 按指定地址寄回商品\n4. 仓库收货验货后退款\n\n**4. 运费说明**\n- 📦 质量问题：平台承担往返运费\n- 📦 无理由退货：买家承担寄回运费\n\n**5. 退款时效**\n- 仓库验货确认后，**3-7个工作日** 原路退回\n\n---\n\n⚠️ **温馨提示**：如果您有具体订单需要退货，我可以帮您提交售后工单。请问您是需要了解某个订单的退货事宜吗？或者有其他问题需要咨询？😊', NULL, '2026-03-04 13:28:56', NULL);
INSERT INTO `ai_chat_message` VALUES (51, 14, 'user', '查看我的订单', NULL, '2026-03-04 13:30:40', NULL);
INSERT INTO `ai_chat_message` VALUES (52, 14, 'assistant', '您好！我为您查询到了以下订单信息 📦\n\n## 您的订单列表\n\n### 订单 1\n- **订单编号**：ORD2027960831975133184\n- **订单金额**：¥38,970.00\n- **下单时间**：2026-03-01 12:15\n- **订单状态**：✅ 已付款\n\n### 订单 2\n- **订单编号**：ORD2027692769887748096\n- **订单金额**：¥9,999.00\n- **下单时间**：2026-02-28 18:30\n- **订单状态**：✅ 已付款\n\n---\n\n💡 **温馨提示**：\n您的两个订单都已付款，接下来会进入发货流程。您可以：\n- 🔍 查询某个订单的详细信息（商品列表、物流等）\n- 📦 查看物流进度（发货后可查询）\n\n请问您想了解哪个订单的详细信息吗？或者需要查询物流信息？😊', NULL, '2026-03-04 13:30:48', NULL);
INSERT INTO `ai_chat_message` VALUES (53, 14, 'user', '贵阳今天的天气怎么样', NULL, '2026-03-04 13:34:30', NULL);
INSERT INTO `ai_chat_message` VALUES (54, 14, 'assistant', '您好！😊\n\n关于贵阳的天气查询，我这边主要是电商客服助手，暂时无法提供实时天气信息哦~\n\n建议您可以通过以下方式查询：\n- 📱 手机天气 APP\n- 🌐 搜索引擎搜索\"贵阳天气\"\n- 📺 当地气象部门官网\n\n---\n\n🛍️ **不过我可以帮您处理电商相关事务哦！**\n\n比如：\n- 🔍 搜索商品、查看商品详情\n- 📦 查询订单状态、物流信息\n- 🔧 提交售后工单、处理退换货\n- 💡 根据需求推荐商品\n\n请问有什么电商相关的问题需要我帮您处理吗？😊', NULL, '2026-03-04 13:34:37', NULL);
INSERT INTO `ai_chat_message` VALUES (55, 15, 'user', '有什么热门商品推荐？', NULL, '2026-03-04 14:24:52', NULL);
INSERT INTO `ai_chat_message` VALUES (56, 15, 'assistant', '您好！😊 为您推荐几款热门商品：\n\n**📱 手机类：**\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存：96件\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：120件\n\n**💻 电脑类：**\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n这些都是当前比较受欢迎的商品哦！👍\n\n您对哪款商品感兴趣呢？是否需要了解更多详情，或者要不要加入购物车？🛒', NULL, '2026-03-04 14:25:04', NULL);
INSERT INTO `ai_chat_message` VALUES (57, 16, 'user', '早上好', NULL, '2026-03-05 10:15:07', NULL);
INSERT INTO `ai_chat_message` VALUES (58, 16, 'assistant', '早上好！😊 我是小智，您的电商智能客服助手。\n\n今天有什么可以帮您的吗？比如：\n- 🛒 想看看有什么商品？\n- 📦 查询订单状态或物流？\n- 🎁 需要商品推荐？\n- 🔧 有售后问题需要处理？\n\n随时告诉我您的需求哦！', NULL, '2026-03-05 10:15:12', NULL);
INSERT INTO `ai_chat_message` VALUES (59, 16, 'user', '转接人工客服', NULL, '2026-03-05 10:15:23', NULL);
INSERT INTO `ai_chat_message` VALUES (60, 16, 'assistant', '已为您成功转接人工客服！😊\n\n**工单号：TK2029380236642742272**\n\n客服人员会尽快与您联系处理您的问题，请您耐心等待。如有其他需要，随时告诉我哦！👍', NULL, '2026-03-05 10:15:31', NULL);
INSERT INTO `ai_chat_message` VALUES (61, 16, 'user', '你好！我是谁', NULL, '2026-03-05 15:28:29', NULL);
INSERT INTO `ai_chat_message` VALUES (62, 16, 'assistant', '您好！😊 \n\n根据系统信息，您的用户ID是 **100**。\n\n不过我这里没有您的更多个人信息（如姓名、联系方式等）。如果您需要查询自己的订单、工单或其他账户相关信息，我很乐意帮您查询！\n\n今天有什么可以帮您的吗？比如：\n- 🛒 浏览或搜索商品\n- 📦 查询订单状态\n- 🔧 处理售后问题\n- 💡 商品推荐\n\n随时告诉我哦！👍', NULL, '2026-03-05 15:28:37', NULL);
INSERT INTO `ai_chat_message` VALUES (63, 17, 'user', '有什么热门商品推荐？', NULL, '2026-03-05 21:23:07', NULL);
INSERT INTO `ai_chat_message` VALUES (64, 17, 'assistant', '您好！为您精选了几款热门商品 👇\n\n**📱 手机类：**\n1. **iPhone 15 Pro Max 256GB** - ¥12,990 \n   - 核心卖点：这里是核心买点\n   - 库存充足（96件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：120件\n\n**💻 电脑类：**\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n您对哪款商品感兴趣呢？我可以为您：\n- 📦 查看商品详细参数和规格\n- 🔍 对比两款商品的差异\n- 🛒 帮您加入购物车\n\n请告诉我您的偏好，我随时为您服务！😊', NULL, '2026-03-05 21:23:21', 1);
INSERT INTO `ai_chat_message` VALUES (65, 17, 'user', '退货流程是什么', NULL, '2026-03-06 09:46:52', NULL);
INSERT INTO `ai_chat_message` VALUES (66, 17, 'assistant', '您好！我是小智，很高兴为您解答退货流程 😊\n\n## 📋 退货流程说明\n\n**1. 提交退货申请**\n- 在订单详情页点击\"申请售后\"\n- 或联系我帮您创建退款工单\n\n**2. 选择退货原因**\n- 商品质量问题\n- 七天无理由退货\n- 商品与描述不符\n- 其他原因\n\n**3. 等待审核**\n- 客服会在 1-2 个工作日内审核您的申请\n\n**4. 寄回商品**\n- 审核通过后，系统会提供退货地址\n- 请将商品原包装寄回（保持商品完好）\n\n**5. 退款处理**\n- 收到退货并验收合格后\n- 退款将在 3-5 个工作日内原路返回\n\n---\n\n## ⚠️ 注意事项\n- 退货商品需保持完好，不影响二次销售\n- 部分特殊商品（如定制类、生鲜类）不支持无理由退货\n- 请保留好物流单号，方便查询退货进度\n\n---\n\n**如果您需要办理退货**，请告诉我您的订单编号，我可以帮您直接提交退款工单 🛒\n\n请问有什么可以帮您的吗？😊', NULL, '2026-03-06 09:47:03', NULL);
INSERT INTO `ai_chat_message` VALUES (67, 18, 'user', '1', NULL, '2026-03-06 10:29:57', NULL);
INSERT INTO `ai_chat_message` VALUES (68, 18, 'assistant', '您好！我是小智，您的电商智能客服助手 😊\n\n我看到您发送了\"1\"，请问有什么可以帮助您的吗？我可以为您提供以下服务：\n\n🛍️ **商品导购** - 搜索商品、查看商品详情、对比商品参数、根据场景推荐商品\n📦 **订单服务** - 查询订单状态和物流信息、取消订单、确认收货\n🔧 **售后支持** - 提交售后工单、查询处理进度、转接人工客服\n\n请告诉我您需要什么帮助吧！', NULL, '2026-03-06 10:30:03', NULL);
INSERT INTO `ai_chat_message` VALUES (69, 18, 'user', '2', NULL, '2026-03-06 10:30:14', NULL);
INSERT INTO `ai_chat_message` VALUES (70, 18, 'assistant', '您好！我是小智，您的电商智能客服助手 😊\n\n我看到您发送了\"2\"，请问有什么可以帮助您的吗？我可以为您提供以下服务：\n\n🛍️ **商品导购**\n- 搜索商品、查看商品详情\n- 对比商品参数\n- 根据场景和预算推荐商品\n\n📦 **订单服务**\n- 查询订单状态和物流信息\n- 取消待付款订单\n- 确认收货\n\n🔧 **售后支持**\n- 提交售后工单（投诉/退款/换货/咨询）\n- 查询工单处理进度\n- 转接人工客服\n\n请告诉我您需要什么帮助吧！比如：\n- \"我想买一台笔记本电脑\"\n- \"帮我查一下订单状态\"\n- \"商品有问题要退款\"\n\n期待您的回复！🌟', NULL, '2026-03-06 10:30:19', NULL);
INSERT INTO `ai_chat_message` VALUES (71, 18, 'user', '为我推荐一款手机', NULL, '2026-03-06 10:35:12', NULL);
INSERT INTO `ai_chat_message` VALUES (72, 18, 'assistant', '您好！根据您的需求，我为您推荐以下几款热门手机：\n\n## 📱 推荐商品\n\n**1. iPhone 15 Pro Max 256GB**\n- 💰 价格：¥12,990\n- 📦 库存：95件\n- ✨ 核心卖点：这里是核心买点\n\n**2. 华为 Mate 60 Pro**\n- 💰 价格：¥6,999\n- 📦 库存：80件\n\n---\n\n这两款手机各有特色，iPhone 15 Pro Max 适合追求高端体验和iOS生态的用户，华为 Mate 60 Pro 性价比更高。\n\n**请问您：**\n- 想了解哪款手机的详细参数和配置？\n- 需要我帮您对比这两款手机的差异吗？\n- 或者您有特定的预算范围和使用场景，我可以为您重新推荐？\n\n如果您看中某款，可以直接加入购物车，方便统一结算哦！🛒', NULL, '2026-03-06 10:35:22', 1);
INSERT INTO `ai_chat_message` VALUES (73, 18, 'user', '为我推荐一款手机', NULL, '2026-03-06 11:08:47', NULL);
INSERT INTO `ai_chat_message` VALUES (74, 18, 'assistant', '您好！根据您的手机需求，我为您推荐以下两款热门机型：\n\n## 📱 推荐商品\n\n**1. iPhone 15 Pro Max 256GB**\n- 💰 价格：¥12,990\n- 📦 库存：95件\n- ✨ 核心卖点：这里是核心买点\n\n**2. 华为 Mate 60 Pro**\n- 💰 价格：¥6,999\n- 📦 库存：80件\n\n---\n\n这两款手机各有优势：\n- **iPhone 15 Pro Max** 适合追求高端体验和iOS生态的用户\n- **华为 Mate 60 Pro** 性价比更高，适合追求实用性的用户\n\n**请问您：**\n- 📋 想了解哪款手机的详细参数和配置？\n- ⚖️ 需要我帮您对比这两款手机的差异吗？\n- 💰 或者您有特定的预算范围，我可以为您重新推荐？\n\n如果您看中某款，您可以直接加入购物车，方便统一结算哦！🛒', NULL, '2026-03-06 11:08:56', 1);
INSERT INTO `ai_chat_message` VALUES (75, 18, 'user', 'e 60 Pro\n\n💰 价格：¥6,999\n📦 库存：80件\n这两款手机各有优势：\n\niPhone 15 Pro Max 适合追求高端体验和iOS生态的用户\n华为 Mate 60 Pro 性价比更高，适合追求实用性的用户\n请问您：\n\n📋 想了解哪款手机的详细参数和配置？\n⚖️ 需要我帮您对比这两款手机的差异吗？\n💰 或者您有特定的预算范围，我可以为您重新推荐？\n如果您看中某款，您可以直接加入购物车，方便', NULL, '2026-03-06 11:45:05', NULL);
INSERT INTO `ai_chat_message` VALUES (76, 18, 'assistant', '您好！📱\n\n我刚刚查询了系统数据库，**当前系统暂无手机商品上架**。很抱歉无法为您推荐具体的手机型号。\n\n不过，我可以帮您：\n- 🔍 搜索其他类别的商品（如电脑、平板、配件等）\n- 💡 根据您的使用场景和预算推荐其他电子产品\n- 📦 查询您的订单状态或物流信息\n- 🔧 处理售后问题\n\n**请问您：**\n- 想了解其他类别的商品吗？\n- 或者您有订单需要查询？\n- 需要我转接人工客服为您进一步协助吗？\n\n期待您的回复！😊', NULL, '2026-03-06 11:45:17', NULL);
INSERT INTO `ai_chat_message` VALUES (77, 18, 'user', '为我推荐一款手机', NULL, '2026-03-06 12:09:00', NULL);
INSERT INTO `ai_chat_message` VALUES (78, 18, 'assistant', '您好！根据您的需求，我为您推荐以下两款热门手机：\n\n## 📱 推荐商品\n\n**1. iPhone 15 Pro Max 256GB**\n- 💰 价格：¥12,990\n- 📦 库存：95件\n- ✨ 核心卖点：这里是核心买点\n\n**2. 华为 Mate 60 Pro**\n- 💰 价格：¥6,999\n- 📦 库存：80件\n\n---\n\n这两款手机各有优势：\n- **iPhone 15 Pro Max**：高端旗舰，适合追求极致体验和iOS生态的用户\n- **华为 Mate 60 Pro**：性价比高，适合追求实用性的用户\n\n**请问您：**\n- 📋 想了解哪款手机的详细参数和配置？\n- ⚖️ 需要我帮您对比这两款手机的差异吗？\n- 💰 或者您有特定的预算范围，我可以为您重新推荐？\n\n如果您看中某款，您可以直接加入购物车，方便统一结算哦！🛒', NULL, '2026-03-06 12:09:11', NULL);
INSERT INTO `ai_chat_message` VALUES (79, 18, 'user', '为我对比这个两个手机', NULL, '2026-03-06 12:10:40', NULL);
INSERT INTO `ai_chat_message` VALUES (80, 18, 'assistant', '您好！😊\n\n我刚刚查询了系统数据库，**当前系统暂无手机商品上架**，所以无法为您对比手机型号。\n\n**我可以为您提供以下帮助：**\n- 🔍 搜索其他类别的商品（如电脑、平板、耳机、配件等）\n- 💡 根据您的使用场景和预算推荐其他电子产品\n- 📦 查询您的订单状态或物流信息\n- 🔧 处理售后问题或提交工单\n\n**请问您：**\n- 想了解其他类别的商品吗？\n- 或者您有订单需要查询？\n- 需要我转接人工客服为您进一步协助吗？\n\n期待您的回复！🌟', NULL, '2026-03-06 12:10:49', NULL);
INSERT INTO `ai_chat_message` VALUES (81, 19, 'user', '有什么热门商品推荐？', NULL, '2026-03-06 13:13:06', NULL);
INSERT INTO `ai_chat_message` VALUES (82, 19, 'assistant', '您好！😊 为您推荐几款热门商品：\n\n## 📱 手机类\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：高端旗舰，性能卓越\n   - 库存：95件\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n## 💻 电脑类\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n您对哪款商品感兴趣呢？我可以为您：\n- 🔍 查看商品详细信息\n- ⚖️ 对比两款商品参数\n- 🛒 帮您加入购物车\n\n请告诉我您的需求，我随时为您服务！👍', NULL, '2026-03-06 13:13:19', NULL);
INSERT INTO `ai_chat_message` VALUES (83, 20, 'user', '有什么热门商品推荐？', NULL, '2026-03-06 13:23:43', NULL);
INSERT INTO `ai_chat_message` VALUES (84, 20, 'assistant', '您好！😊 为您推荐几款当前热门商品：\n\n## 📱 手机类\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存：95件\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n## 💻 电脑类\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n这些商品都是近期销量和口碑都不错的选择！👍\n\n**您对哪款商品感兴趣呢？** 我可以帮您：\n- 📋 查看商品详细信息\n- ⚖️ 对比两款商品的参数\n- 🛒 引导您加入购物车\n\n请告诉我您的偏好，我随时为您服务！😊', NULL, '2026-03-06 13:23:55', NULL);
INSERT INTO `ai_chat_message` VALUES (85, 21, 'user', '有什么热门商品推荐？', NULL, '2026-03-06 13:57:24', NULL);
INSERT INTO `ai_chat_message` VALUES (86, 21, 'assistant', '您好！为您精选了几款热门商品推荐：\n\n📱 **手机类：**\n1. **iPhone 15 Pro Max 256GB** - ¥12,990 \n   - 核心卖点：这里是核心买点\n   - 库存充足（95件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n💻 **电脑类：**\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n请问您对哪款商品感兴趣？我可以为您查看更详细的产品信息，或者帮您对比不同商品的参数哦！😊\n\n您也可以直接加入购物车，方便统一结算🛒', NULL, '2026-03-06 13:57:36', NULL);
INSERT INTO `ai_chat_message` VALUES (87, 21, 'user', '今天天气这么有', NULL, '2026-03-06 13:57:58', NULL);
INSERT INTO `ai_chat_message` VALUES (88, 21, 'assistant', '您好呀！😊 今天天气确实很不错呢～ 阳光明媚，心情也会跟着变好！\n\n这样的好天气，很适合逛逛我们商城，给自己挑些心仪的商品哦！🛒\n\n您最近有想买的商品吗？我可以帮您：\n- 🔍 搜索特定商品\n- 💡 根据场景和预算推荐商品\n- 📱 查看热门商品详情\n- ⚖️ 对比不同商品参数\n\n或者您想看看最近的订单状态？有什么需要我帮忙的吗？😊', NULL, '2026-03-06 13:58:04', NULL);
INSERT INTO `ai_chat_message` VALUES (89, 21, 'user', '今天什么天气', NULL, '2026-03-06 13:58:21', NULL);
INSERT INTO `ai_chat_message` VALUES (90, 21, 'assistant', '您好呀！😊 \n\n很抱歉，我作为电商客服助手，无法查询实时天气信息呢～ 建议您查看手机天气 APP 或搜索\"天气\"来获取准确的天气预报哦！☀️🌧️\n\n不过，我可以帮您处理电商相关的事情，比如：\n- 🔍 搜索或推荐商品\n- 📦 查询订单状态和物流\n- 🛒 查看商品详情或对比参数\n- 📝 提交售后工单\n\n有什么我可以帮您的吗？😊', NULL, '2026-03-06 13:58:27', NULL);
INSERT INTO `ai_chat_message` VALUES (91, 23, 'user', '有什么热门商品推荐？', NULL, '2026-03-06 20:07:05', NULL);
INSERT INTO `ai_chat_message` VALUES (92, 23, 'assistant', '您好！我是小智，很高兴为您推荐热门商品！😊\n\n根据您的需求，我为您精选了以下几款热门商品：\n\n## 📱 手机类\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存充足（95件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n## 💻 电脑类\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n这些商品都是当前热销的数码产品哦！🔥\n\n**请问您对哪款商品感兴趣呢？** \n- 想了解某款商品的详细参数和规格？\n- 需要我帮您对比两款商品？\n- 或者有特定的使用场景和预算，我可以为您做更精准的推荐？\n\n您可以直接告诉我商品名称，我帮您查看更多详情！🛒', NULL, '2026-03-06 20:07:18', NULL);
INSERT INTO `ai_chat_message` VALUES (93, 23, 'user', '为我推荐一个手机', NULL, '2026-03-06 20:07:49', NULL);
INSERT INTO `ai_chat_message` VALUES (94, 23, 'assistant', '您好！我是小智，很高兴为您推荐手机！📱\n\n根据您的需求，我为您精选了以下热门手机：\n\n## 📱 推荐手机\n\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存充足（95件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n---\n\n这两款都是当前热销的旗舰手机哦！🔥\n\n**请问您对哪款更感兴趣呢？**\n- 想了解某款手机的详细参数和规格？\n- 需要我帮您对比这两款手机？\n- 或者有特定的预算范围和使用场景，我可以为您做更精准的推荐？\n\n您可以直接告诉我商品名称，我帮您查看更多详情！🛒', NULL, '2026-03-06 20:07:58', NULL);
INSERT INTO `ai_chat_message` VALUES (95, 23, 'user', '我已经买了那些商品了', NULL, '2026-03-07 14:51:19', NULL);
INSERT INTO `ai_chat_message` VALUES (96, 23, 'assistant', '您好！我是小智，我来帮您查看已购买的商品订单！📦\n\n## 您的订单列表\n\n| 订单编号 | 金额 | 状态 | 创建时间 |\n|---------|------|------|---------|\n| ORD2030166584999833600 | ¥71,971.90 | **已退款** ❌ | 2026-03-07 |\n| ORD2029731846887632896 | ¥24,688.00 | **已送达** ✅ | 2026-03-06 |\n| ORD2027960831975133184 | ¥38,970.00 | **已付款** 💳 | 2026-03-01 |\n| ORD2027692769887748096 | ¥9,999.00 | **已付款** 💳 | 2026-02-28 |\n\n---\n\n### 📋 订单状态说明：\n\n1. **已退款订单** (ORD2030166584999833600)\n   - 退款已完成，款项已退回\n\n2. **已送达订单** (ORD2029731846887632896)\n   - 商品已送达，请问您是否已收到商品？需要帮您**确认收货**吗？\n\n3. **已付款订单** (ORD2027960831975133184、ORD2027692769887748096)\n   - 等待商家发货中，请耐心等待哦~\n\n---\n\n**请问您需要：**\n- 🔍 查看某个订单的商品详情？\n- 📦 查询已送达订单的物流信息？\n- ✅ 确认收货（针对已送达订单）？\n- 💬 有其他售后问题需要帮助？\n\n请告诉我订单编号，我可以为您提供更详细的信息！😊', NULL, '2026-03-07 14:51:35', NULL);
INSERT INTO `ai_chat_message` VALUES (97, 23, 'user', '这四个订单分别买了什么东西', NULL, '2026-03-07 14:52:23', NULL);
INSERT INTO `ai_chat_message` VALUES (98, 23, 'assistant', '您好！我是小智，我来为您详细展示这四个订单的商品信息！📦\n\n## 订单商品明细\n\n### 1️⃣ 订单 ORD2030166584999833600\n**状态：已退款** ❌ | **金额：¥71,971.90**\n\n| 商品名称 | 数量 |\n|---------|------|\n| ChatGPT plus会员一个月 | 10 |\n| iPhone 15 Pro Max 256GB | 2 |\n| 华为 Mate 60 Pro | 1 |\n| 小米14 Ultra | 2 |\n| AirPods Pro 2 | 2 |\n| MacBook Pro 14英寸 M3 | 1 |\n| 联想 ThinkPad X1 Carbon | 1 |\n| 华为 FreeBuds Pro 3 | 1 |\n\n---\n\n### 2️⃣ 订单 ORD2029731846887632896\n**状态：已送达** ✅ | **金额：¥24,688.00** | **物流：中通快递**\n\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 1 |\n| 华为 MatePad Pro 13.2 | 1 |\n| 小米14 Ultra | 1 |\n\n> 📬 此订单已送达，请问您是否已收到商品？需要帮您**确认收货**吗？\n\n---\n\n### 3️⃣ 订单 ORD2027960831975133184\n**状态：已付款** 💳 | **金额：¥38,970.00**\n\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 3 |\n\n> ⏳ 此订单等待商家发货中，请耐心等待哦~\n\n---\n\n### 4️⃣ 订单 ORD2027692769887748096\n**状态：已付款** 💳 | **金额：¥9,999.00**\n\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 1 |\n\n> ⏳ 此订单等待商家发货中，请耐心等待哦~\n\n---\n\n## 📊 汇总统计\n您总共购买了 **7台 iPhone 15 Pro Max**，还有其他多款热门数码产品！看来您是一位数码爱好者呢！🔥\n\n**请问您需要：**\n- 📦 查询已送达订单的物流详情？\n- ✅ 确认收货（针对已送达订单）？\n- 🔍 查看某个商品的详细信息？\n- 💬 有其他问题需要帮助？\n\n随时告诉我哦！😊', NULL, '2026-03-07 14:52:41', NULL);
INSERT INTO `ai_chat_message` VALUES (99, 23, 'user', '我还有那些商品没有评价？', NULL, '2026-03-07 14:54:35', NULL);
INSERT INTO `ai_chat_message` VALUES (100, 23, 'assistant', '您好！我是小智，我来帮您查看哪些商品还没有评价！📝\n\n## 您的订单评价情况\n\n### ✅ 可以评价的订单（已送达）\n\n**订单 ORD2029731846887632896** - 状态：已送达\n| 商品名称 | 数量 | 评价状态 |\n|---------|------|---------|\n| iPhone 15 Pro Max 256GB | 1 | ⏳ 待评价 |\n| 华为 MatePad Pro 13.2 | 1 | ⏳ 待评价 |\n| 小米14 Ultra | 1 | ⏳ 待评价 |\n\n> 📬 这个订单已送达，您可以对以上3款商品进行评价哦！\n\n---\n\n### ⏳ 暂不能评价的订单\n\n| 订单编号 | 状态 | 原因 |\n|---------|------|------|\n| ORD2030166584999833600 | 已退款 | 退款订单无法评价 |\n| ORD2027960831975133184 | 已付款 | 等待发货中 |\n| ORD2027692769887748096 | 已付款 | 等待发货中 |\n\n---\n\n## 📊 总结\n您目前有 **3件商品** 可以评价但尚未评价：\n- iPhone 15 Pro Max 256GB\n- 华为 MatePad Pro 13.2\n- 小米14 Ultra\n\n**温馨提示：**\n- 只有\"已送达\"状态的订单才能进行评价\n- 其他订单需等待发货并送达后才能评价\n\n**请问您想：**\n- 📝 对已送达的商品进行评价？（需要您前往订单详情页操作）\n- 📦 查询其他订单的物流进度？\n- 💬 有其他问题需要帮助？\n\n随时告诉我哦！😊', NULL, '2026-03-07 14:55:04', NULL);
INSERT INTO `ai_chat_message` VALUES (101, 23, 'user', '为我评价这个订单 ORD2029731846887632896，分别打1星、2星', NULL, '2026-03-07 15:01:07', NULL);
INSERT INTO `ai_chat_message` VALUES (102, 23, 'assistant', '您好！我是小智，关于您提到的评价问题，我需要说明一下：📝\n\n## 订单信息确认\n**订单 ORD2029731846887632896**\n- 状态：已送达 ✅\n- 商品：iPhone 15 Pro Max 256GB、华为 MatePad Pro 13.2、小米14 Ultra\n- 物流：中通快递\n\n---\n\n## ⚠️ 关于评价的说明\n\n很抱歉，**我无法直接代为进行商品评价**。评价功能需要您本人在系统中操作，具体步骤如下：\n\n### 评价流程：\n1. **先确认收货**（如果还未确认）\n   - 我可以帮您确认这个订单已收到商品\n   \n2. **进入订单详情页**\n   - 在\"我的订单\"中找到此订单\n   \n3. **对每件商品分别评价**\n   - 您可以对 iPhone 15 Pro Max 打1星\n   - 对 华为 MatePad Pro 13.2 打2星\n   - 对 小米14 Ultra 进行评价\n\n---\n\n## 💡 我可以帮您：\n\n**是否需要我先帮您确认收货？** \n确认后可以更方便地进行评价操作。\n\n或者，如果您对商品有任何**不满意的地方**，我也可以帮您：\n- 📋 创建售后工单（投诉/退款/换货）\n- 💬 转接人工客服处理问题\n\n请问您想怎么处理呢？😊', NULL, '2026-03-07 15:01:30', NULL);
INSERT INTO `ai_chat_message` VALUES (103, 23, 'user', '列出我的所有收货地址', NULL, '2026-03-07 20:31:34', NULL);
INSERT INTO `ai_chat_message` VALUES (104, 23, 'assistant', '您好！我是小智，很高兴为您服务！😊\n\n## 📍 关于收货地址查询\n\n很抱歉，**当前系统暂未提供收货地址查询功能**。我们的客服系统主要支持以下服务：\n\n### ✅ 可提供的服务：\n- 🛒 商品搜索、推荐、详情查询、参数对比\n- 📦 订单查询、物流跟踪、确认收货、取消订单\n- 💬 售后工单提交、进度查询\n- 🎧 转接人工客服\n\n---\n\n### 💡 建议您：\n\n1. **查看订单详情**\n   - 我可以帮您查询具体订单，订单详情中会显示该订单的收货地址\n   - 请问您想查看哪个订单的收货信息？\n\n2. **登录商城官网/APP**\n   - 在\"个人中心\" → \"地址管理\"中可以查看和管理所有收货地址\n\n3. **转接人工客服**\n   - 如需帮助管理收货地址，我可以为您转接人工客服处理\n\n---\n\n**请问您想：**\n- 📦 查询某个订单的详情（包含收货地址）？\n- 🎧 转接人工客服协助处理地址问题？\n- 💬 还有其他我可以帮您的吗？\n\n随时告诉我哦！😊', NULL, '2026-03-07 20:31:47', NULL);
INSERT INTO `ai_chat_message` VALUES (105, 23, 'user', '查看我的个人信息', NULL, '2026-03-08 21:58:47', NULL);
INSERT INTO `ai_chat_message` VALUES (106, 23, 'assistant', '您好！我是小智，很高兴为您服务！😊\n\n## 👤 您的个人信息\n\n| 项目 | 信息 |\n|------|------|\n| **昵称** | test1 |\n| **性别** | 男 |\n| **手机号** | 暂未绑定 |\n| **邮箱** | 暂未绑定 |\n| **上次登录时间** | 2026-03-08 21:16:36 |\n\n---\n\n### 💡 温馨提示：\n- 您的手机号和邮箱暂未绑定，建议绑定后可以更方便地接收订单通知和找回密码哦！\n- 如需修改个人信息，可以前往\"个人中心\"进行设置\n\n**请问您还需要：**\n- 📍 查看或管理您的收货地址？\n- 📦 查询您的订单列表？\n- 🔔 查看未读通知？\n- 💬 其他需要帮助的地方？\n\n随时告诉我哦！😊', NULL, '2026-03-08 21:58:54', NULL);
INSERT INTO `ai_chat_message` VALUES (107, 23, 'user', '我有什么收货地址', NULL, '2026-03-08 22:01:53', NULL);
INSERT INTO `ai_chat_message` VALUES (108, 23, 'assistant', '您好！我是小智，很高兴为您服务！😊\n\n## 📍 您的收货地址列表\n\n| ID | 联系人 | 手机号 | 收货地址 | 状态 |\n|----|--------|--------|----------|------|\n| 4 | 123 | 156****7896 | 天津市和平区 12311 | ⭐ **默认地址** |\n| 6 | 123 | 123 | 12311w*** | |\n| 5 | 123 | 123 | 12311w*** | |\n| 3 | 123 | 123 | 123 | |\n| 2 | sun | 111****1111 | 贵州省贵阳市*** | |\n| 1 | sun | 111****1111 | 贵州省贵阳市*** | |\n\n---\n\n### 📊 地址统计\n- **总地址数**：6个\n- **默认地址**：1个（天津市和平区）\n\n---\n\n**请问您需要：**\n- 🔄 **更改默认地址**？（告诉我地址ID，我帮您设置）\n- ➕ **添加新地址**？（需前往个人中心操作）\n- 📦 **下单时使用哪个地址**？\n- 💬 其他需要帮助的地方？\n\n随时告诉我哦！😊', NULL, '2026-03-08 22:02:04', NULL);
INSERT INTO `ai_chat_message` VALUES (109, 23, 'user', '有新消息吗', NULL, '2026-03-08 22:02:35', NULL);
INSERT INTO `ai_chat_message` VALUES (110, 23, 'assistant', '您好！我是小智，很高兴为您服务！😊\n\n## 📬 您的消息通知\n\n**当前没有未读通知哦！** ✅\n\n所有消息都已处理完毕，您可以放心啦~\n\n---\n\n**温馨提示：**\n- 如有新订单状态更新、物流信息或促销活动，系统会及时通知您\n- 您可以随时问我\"有新消息吗\"来查看最新通知\n\n**请问您还需要：**\n- 📦 查看您的订单列表？\n- 🛒 搜索或推荐商品？\n- 💬 其他需要帮助的地方？\n\n随时告诉我哦！😊', NULL, '2026-03-08 22:02:41', NULL);
INSERT INTO `ai_chat_message` VALUES (111, 23, 'user', '帮我评价这个商品', NULL, '2026-03-08 22:03:50', NULL);
INSERT INTO `ai_chat_message` VALUES (112, 23, 'assistant', '您好！我是小智，很高兴帮您进行商品评价！📝\n\n不过我需要确认一下具体信息：\n\n## ❓ 需要确认的信息\n\n1. **要评价哪个商品？**\n   根据您之前的订单 ORD2029731846887632896，包含以下商品：\n   - iPhone 15 Pro Max 256GB\n   - 华为 MatePad Pro 13.2\n   - 小米14 Ultra\n   \n   请问您想评价哪一款？\n\n2. **评分是多少？**（1-5分，5分为最高）\n   您之前提到过1星、2星，请确认具体评分\n\n3. **评价内容是什么？**\n   请告诉我您想写的评价内容\n\n---\n\n## 💡 评价流程说明\n\n确认以上信息后，我会帮您：\n1. ✅ 检查该商品是否已评价过\n2. 📝 提交您的评价\n\n**请告诉我：**\n- 商品名称\n- 评分（1-5分）\n- 评价内容\n\n随时告诉我哦！😊', NULL, '2026-03-08 22:04:01', NULL);
INSERT INTO `ai_chat_message` VALUES (113, 23, 'user', '我还有什么商品没有评价', NULL, '2026-03-08 22:14:52', NULL);
INSERT INTO `ai_chat_message` VALUES (114, 23, 'assistant', '您好！我是小智，我来帮您查看哪些商品还没有评价！📝\n\n## 📊 您的订单评价情况\n\n### ✅ 可以评价的订单（已送达状态）\n\n**订单 ORD2029731846887632896** - 状态：已送达\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 1 |\n| 华为 MatePad Pro 13.2 | 1 |\n| 小米14 Ultra | 1 |\n\n---\n\n### ⏳ 暂不能评价的订单\n\n| 订单编号 | 状态 | 原因 |\n|---------|------|------|\n| ORD2030645615457333248 | 待付款 | 未付款，无法评价 |\n| ORD2030166584999833600 | 已退款 | 退款订单无法评价 |\n| ORD2027960831975133184 | 已付款 | 等待发货中 |\n| ORD2027692769887748096 | 已付款 | 等待发货中 |\n\n---\n\n## 📝 总结\n\n您目前有 **3件商品** 可以评价（来自已送达订单 ORD2029731846887632896）：\n1. iPhone 15 Pro Max 256GB\n2. 华为 MatePad Pro 13.2\n3. 小米14 Ultra\n\n**温馨提示：**\n- 只有\"已送达\"状态的订单才能进行评价\n- 其他订单需等待发货并送达后才能评价\n\n**请问您想：**\n- 📝 对以上商品进行评价？（请告诉我具体商品、评分和评价内容）\n- 📦 查询其他订单的物流进度？\n- 💬 有其他问题需要帮助？\n\n随时告诉我哦！😊', NULL, '2026-03-08 22:15:22', NULL);
INSERT INTO `ai_chat_message` VALUES (115, 25, 'user', '我买过什么商品了', NULL, '2026-03-08 23:43:39', NULL);
INSERT INTO `ai_chat_message` VALUES (116, 25, 'assistant', '您好！我为您查询了所有的订单记录，您购买过的商品如下：\n\n**📋 订单汇总：**\n\n1. **ORD2030645615457333248**（待付款）- ¥12,990\n   - iPhone 15 Pro Max 256GB × 1\n\n2. **ORD2030166584999833600**（已退款）- ¥71,971.90\n   - ChatGPT plus会员一个月 × 10\n   - iPhone 15 Pro Max 256GB × 2\n   - 华为 Mate 60 Pro × 1\n   - 小米14 Ultra × 2\n   - AirPods Pro 2 × 2\n   - MacBook Pro 14英寸 M3 × 1\n   - 联想 ThinkPad X1 Carbon × 1\n   - 华为 FreeBuds Pro 3 × 1\n\n3. **ORD2029731846887632896**（已发货）- ¥24,688\n   - iPhone 15 Pro Max 256GB × 1\n   - 华为 MatePad Pro 13.2 × 1\n   - 小米14 Ultra × 1\n   - 📦 物流：中通快递 ZTO246544201\n\n4. **ORD2027960831975133184**（已付款）- ¥38,970\n   - iPhone 15 Pro Max 256GB × 3\n\n5. **ORD2027692769887748096**（已付款）- ¥9,999\n   - iPhone 15 Pro Max 256GB × 1\n\n**💡 温馨提醒：**\n- 您有1个待付款订单（ORD2030645615457333248），需要尽快支付哦\n- 有1个已发货订单（ORD2029731846887632896），可以查询物流进度或确认收货\n- 有2个已付款订单等待发货\n\n需要我帮您查询某个订单的详细信息或物流进度吗？😊', NULL, '2026-03-08 23:43:58', NULL);
INSERT INTO `ai_chat_message` VALUES (117, 25, 'user', '帮我结算购物车', NULL, '2026-03-09 21:44:55', NULL);
INSERT INTO `ai_chat_message` VALUES (118, 25, 'assistant', '您好！我帮您查看了购物车，目前您的购物车是空的，没有商品可以结算哦~ 😊\n\n**💡 小建议：**\n- 您可以浏览一下我们的商品，看看有没有心仪的数码产品\n- 我可以为您推荐一些热门商品，或者帮您搜索特定类型的产品\n- 找到喜欢的商品后，加入购物车，就可以统一结算啦！\n\n需要我为您推荐一些商品，或者帮您搜索什么类型的产品吗？🛒', NULL, '2026-03-09 21:45:01', NULL);
INSERT INTO `ai_chat_message` VALUES (119, 25, 'user', '帮我结算购物车', NULL, '2026-03-09 21:45:44', NULL);
INSERT INTO `ai_chat_message` VALUES (120, 25, 'assistant', '您好！我帮您查看了购物车，目前您的购物车是空的，没有商品可以结算哦~ 😊\n\n**💡 小建议：**\n- 您可以浏览一下我们的商品，看看有没有心仪的数码产品\n- 我可以为您推荐一些热门商品，或者帮您搜索特定类型的产品\n- 找到喜欢的商品后，加入购物车，就可以统一结算啦！\n\n需要我为您推荐一些商品，或者帮您搜索什么类型的产品吗？🛒', NULL, '2026-03-09 21:45:50', NULL);
INSERT INTO `ai_chat_message` VALUES (121, 25, 'user', 'AI查询用户信息', NULL, '2026-03-09 21:46:10', NULL);
INSERT INTO `ai_chat_message` VALUES (122, 25, 'assistant', '您好，test1！这是您的账号信息：\n\n👤 **基本信息**\n- 昵称：test1\n- 性别：男\n- 手机号：未绑定\n- 邮箱：未绑定\n- 上次登录时间：2026年3月9日 20:55:16\n\n💡 **温馨提示：**\n- 建议您绑定手机号和邮箱，方便接收订单通知和找回密码\n- 如需修改个人信息或绑定联系方式，可以联系人工客服协助处理\n\n需要我帮您查询订单、地址或其他服务吗？😊', NULL, '2026-03-09 21:46:17', NULL);
INSERT INTO `ai_chat_message` VALUES (123, 25, 'user', '查询我的地址', NULL, '2026-03-09 21:46:50', NULL);
INSERT INTO `ai_chat_message` VALUES (124, 25, 'assistant', '您好！这是您当前的收货地址列表：\n\n📍 **您的收货地址**\n\n| ID | 联系人 | 电话 | 地址 | 默认 |\n|---|---|---|---|---|\n| 4 | 123 | 156****7896 | 天津市市辖区和平区 12*** | ✅ 是 |\n| 6 | 123 | *** | 12311w*** | 否 |\n| 5 | 123 | *** | 12311w*** | 否 |\n| 3 | 123 | *** | 12*** | 否 |\n| 2 | sun | 111****1111 | 贵州省贵阳市*** | 否 |\n| 1 | sun | 111****1111 | 贵州省贵阳市*** | 否 |\n\n**💡 地址管理提示：**\n- ✅ 当前默认地址是：**天津市市辖区和平区**（ID: 4）\n- 如需**新增地址**，请告诉我联系人、电话、省市区和详细地址\n- 如需**修改地址**，请告诉我要修改哪个地址ID及新信息\n- 如需**删除地址**，请告诉我要删除的地址ID\n- 如需**更改默认地址**，请告诉我想设为默认的地址ID\n\n需要我帮您管理地址吗？😊', NULL, '2026-03-09 21:47:03', NULL);
INSERT INTO `ai_chat_message` VALUES (125, 26, 'user', '帮我看看购物车', NULL, '2026-03-09 22:20:36', NULL);
INSERT INTO `ai_chat_message` VALUES (126, 26, 'assistant', '您好！您的购物车内容如下：\n\n🛒 **购物车商品**\n\n| 商品名称 | 单价 | 数量 | 小计 |\n|---------|------|------|------|\n| iPhone 15 Pro Max 256GB | ¥12,990.00 | 1 | ¥12,990.00 |\n| ChatGPT plus会员一个月 | ¥19.99 | 3 | ¥59.97 |\n\n---\n\n**📊 汇总信息**\n- 商品总数：2 件\n- 已勾选：2 件\n- **总计金额：¥13,049.97**\n\n---\n\n请问您需要：\n1. 🛍️ **直接结算下单**吗？\n2. ➕ **继续添加商品**？\n3. 🗑️ **移除或修改**某个商品？\n4. 🧹 **清空购物车**？\n\n随时告诉我您的需求哦！😊', NULL, '2026-03-09 22:20:45', NULL);
INSERT INTO `ai_chat_message` VALUES (127, 26, 'user', '帮我把华为 Mate 60 Pro 加入购物车', NULL, '2026-03-09 22:21:09', NULL);
INSERT INTO `ai_chat_message` VALUES (128, 26, 'assistant', '✅ **已成功将「华为 Mate 60 Pro」加入购物车！**\n\n📱 **商品信息**\n- 商品名称：华为 Mate 60 Pro\n- 价格：¥6,999.00\n- 数量：1 件\n- 核心配置：麒麟9000S芯片，支持卫星通话\n\n---\n\n请问您还需要：\n1. 🛒 **继续添加其他商品**到购物车吗？\n2. 📋 **查看购物车**全部内容？\n3. 💳 **直接结算下单**？\n4. ℹ️ **了解更多商品详情**（如详细参数、用户评价等）？\n\n随时告诉我您的需求哦！😊', NULL, '2026-03-09 22:21:18', NULL);
INSERT INTO `ai_chat_message` VALUES (129, 26, 'user', '帮我把商品：ChatGPT plus会员一个月 改成一个数量', NULL, '2026-03-09 22:23:17', NULL);
INSERT INTO `ai_chat_message` VALUES (130, 26, 'assistant', '您好！我查看了您的购物车，目前「ChatGPT plus会员一个月」的数量是 **3件**。\n\n⚠️ 当前系统暂不支持直接修改购物车商品数量，但我可以帮您通过以下方式调整：\n\n**方案：先移除该商品，再重新添加1件**\n\n请问您确认要将「ChatGPT plus会员一个月」的数量改为 **1件** 吗？确认后我将为您操作：\n1. 🗑️ 先移除购物车中的该商品\n2. ➕ 再重新添加1件到购物车\n\n请回复\"确认\"或\"是的\"，我立即为您处理！😊', NULL, '2026-03-09 22:23:31', NULL);
INSERT INTO `ai_chat_message` VALUES (131, 26, 'user', '帮我结算购物车', NULL, '2026-03-09 22:23:44', NULL);
INSERT INTO `ai_chat_message` VALUES (132, 26, 'assistant', '🛒 **您的购物车内容如下：**\n\n| 商品名称 | 单价 | 数量 | 小计 |\n|---------|------|------|------|\n| 华为 Mate 60 Pro | ¥6,999.00 | 1 | ¥6,999.00 |\n| iPhone 15 Pro Max 256GB | ¥12,990.00 | 1 | ¥12,990.00 |\n| ChatGPT plus会员一个月 | ¥19.99 | 3 | ¥59.97 |\n\n---\n\n**📊 结算信息**\n- 商品总数：3 件\n- 已勾选：3 件 ✅\n- **应付总额：¥20,048.97**\n- 收货地址：将使用您的默认收货地址\n\n---\n\n⚠️ **请注意：**\n- 结算后将生成订单，请确认商品和数量无误\n- 订单生成后需及时完成支付\n\n**请问确认要结算下单吗？** 请回复\"确认\"或\"是的\"，我立即为您生成订单！😊\n\n如需修改购物车内容（如调整数量、移除商品），请告诉我哦~', NULL, '2026-03-09 22:23:52', 1);

-- ----------------------------
-- Table structure for ai_chat_session
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_session`;
CREATE TABLE `ai_chat_session`  (
  `session_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID（关联sys_user.user_id）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '会话标题（取第一条消息摘要）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0已关闭 1活跃',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '对话会话表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_chat_session
-- ----------------------------
INSERT INTO `ai_chat_session` VALUES (1, 1, '你好', 1, '2026-02-28 10:04:28', '2026-02-28 10:04:28');
INSERT INTO `ai_chat_session` VALUES (2, 100, '你们的退货政策是什么？', 1, '2026-02-28 12:36:32', '2026-02-28 12:36:32');
INSERT INTO `ai_chat_session` VALUES (3, 100, '现在有什么商品可以购买？', 1, '2026-02-28 16:53:53', '2026-02-28 16:53:53');
INSERT INTO `ai_chat_session` VALUES (4, 100, '帮我查询一下我的订单状态', 1, '2026-03-01 12:23:36', '2026-03-01 12:23:36');
INSERT INTO `ai_chat_session` VALUES (5, 100, '推荐一个手机', 1, '2026-03-02 22:54:51', '2026-03-02 22:54:51');
INSERT INTO `ai_chat_session` VALUES (6, 100, '帮我查询一下我的订单状态', 1, '2026-03-02 23:25:53', '2026-03-02 23:25:53');
INSERT INTO `ai_chat_session` VALUES (7, 100, '推荐一个手机', 1, '2026-03-03 10:15:34', '2026-03-03 10:15:34');
INSERT INTO `ai_chat_session` VALUES (8, 100, '你们系统有什么商品卖', 1, '2026-03-03 12:57:08', '2026-03-03 12:57:08');
INSERT INTO `ai_chat_session` VALUES (9, 100, '你们系统有什么商品卖', 1, '2026-03-03 19:12:13', '2026-03-03 19:12:13');
INSERT INTO `ai_chat_session` VALUES (10, 100, '你们系统有什么商品卖', 1, '2026-03-03 21:33:05', '2026-03-03 21:33:05');
INSERT INTO `ai_chat_session` VALUES (11, 100, '你们有什么商品卖', 1, '2026-03-03 22:03:06', '2026-03-03 22:03:06');
INSERT INTO `ai_chat_session` VALUES (12, 100, '你们有什么商品卖', 1, '2026-03-03 22:22:20', '2026-03-03 22:22:20');
INSERT INTO `ai_chat_session` VALUES (13, 100, '你好', 1, '2026-03-04 13:26:49', '2026-03-04 13:26:49');
INSERT INTO `ai_chat_session` VALUES (14, 100, '你好', 1, '2026-03-04 13:27:50', '2026-03-04 13:27:50');
INSERT INTO `ai_chat_session` VALUES (15, 100, '有什么热门商品推荐？', 1, '2026-03-04 14:24:51', '2026-03-04 14:24:51');
INSERT INTO `ai_chat_session` VALUES (16, 100, '早上好', 1, '2026-03-05 10:15:04', '2026-03-05 10:15:04');
INSERT INTO `ai_chat_session` VALUES (17, 100, '有什么热门商品推荐？', 1, '2026-03-05 21:22:27', '2026-03-05 21:22:27');
INSERT INTO `ai_chat_session` VALUES (18, 100, '1', 1, '2026-03-06 10:29:48', '2026-03-06 10:29:48');
INSERT INTO `ai_chat_session` VALUES (19, 100, '有什么热门商品推荐？', 1, '2026-03-06 13:08:42', '2026-03-06 13:08:42');
INSERT INTO `ai_chat_session` VALUES (20, 100, '有什么热门商品推荐？', 1, '2026-03-06 13:23:39', '2026-03-06 13:23:39');
INSERT INTO `ai_chat_session` VALUES (21, 100, '有什么热门商品推荐？', 1, '2026-03-06 13:57:22', '2026-03-06 13:57:22');
INSERT INTO `ai_chat_session` VALUES (22, 100, '', 1, '2026-03-06 18:27:05', '2026-03-06 18:27:05');
INSERT INTO `ai_chat_session` VALUES (23, 100, '有什么热门商品推荐？', 1, '2026-03-06 18:30:48', '2026-03-06 18:30:48');
INSERT INTO `ai_chat_session` VALUES (24, 101, '', 1, '2026-03-08 11:39:07', '2026-03-08 11:39:07');
INSERT INTO `ai_chat_session` VALUES (25, 100, '我买过什么商品了', 1, '2026-03-08 23:43:30', '2026-03-08 23:43:30');
INSERT INTO `ai_chat_session` VALUES (26, 100, '帮我看看购物车', 1, '2026-03-09 22:20:34', '2026-03-09 22:20:34');

-- ----------------------------
-- Table structure for ai_chat_turn_audit
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_turn_audit`;
CREATE TABLE `ai_chat_turn_audit`  (
  `audit_id` bigint NOT NULL AUTO_INCREMENT COMMENT '审计记录ID',
  `session_id` bigint NULL DEFAULT NULL COMMENT '会话ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `user_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用户消息',
  `ai_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'AI回复',
  `rag_source` json NULL COMMENT 'RAG检索来源(JSON)',
  `tool_calls` json NULL COMMENT '工具调用列表(JSON)',
  `duration_ms` bigint NULL DEFAULT NULL COMMENT '本轮对话耗时(毫秒)',
  `has_rag_hit` tinyint NULL DEFAULT 0 COMMENT '是否命中RAG: 1是 0否',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`audit_id`) USING BTREE,
  INDEX `idx_session_id`(`session_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI对话轮次审计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_chat_turn_audit
-- ----------------------------
INSERT INTO `ai_chat_turn_audit` VALUES (1, 13, 100, '你好', '您好！我是小智，您的电商智能客服助手 😊\n\n很高兴为您服务！我可以帮您：\n- 🛒 **商品导购**：搜索商品、查看详情、对比参数、根据需求推荐\n- 📦 **订单服务**：查询订单状态、物流信息、取消订单、确认收货\n- 🎧 **售后支持**：提交工单、查询进度、转接人工客服\n\n请问今天有什么可以帮您的吗？', NULL, NULL, 4433, 0, '2026-03-04 13:27:17');
INSERT INTO `ai_chat_turn_audit` VALUES (2, 14, 100, '你好', '您好！我是小智，您的电商智能客服助手 😊\n\n很高兴为您服务！我可以帮您：\n\n🛍️ **商品导购** - 搜索商品、查看详情、对比参数、根据需求推荐\n📦 **订单服务** - 查询订单状态、物流信息、取消订单、确认收货\n🔧 **售后支持** - 提交工单、查询处理进度、转接人工客服\n\n请问今天有什么可以帮您的吗？比如想看看有什么商品，或者查询一下订单？', NULL, NULL, 5530, 0, '2026-03-04 13:28:07');
INSERT INTO `ai_chat_turn_audit` VALUES (3, 14, 100, '退货政策是什么', '您好！关于退货政策，我来为您介绍一下 📋\n\n## 🔄 退货政策概览\n\n**1. 退货期限**\n- 支持 **7天无理由退货**（自签收之日起计算）\n- 部分特殊商品（如定制类、生鲜类）除外\n\n**2. 退货条件**\n- ✅ 商品完好，不影响二次销售\n- ✅ 原包装、配件、标签齐全\n- ✅ 未使用、未洗涤、无损坏\n\n**3. 退货流程**\n1. 在订单页面申请退货/提交售后工单\n2. 等待客服审核通过\n3. 按指定地址寄回商品\n4. 仓库收货验货后退款\n\n**4. 运费说明**\n- 📦 质量问题：平台承担往返运费\n- 📦 无理由退货：买家承担寄回运费\n\n**5. 退款时效**\n- 仓库验货确认后，**3-7个工作日** 原路退回\n\n---\n\n⚠️ **温馨提示**：如果您有具体订单需要退货，我可以帮您提交售后工单。请问您是需要了解某个订单的退货事宜吗？或者有其他问题需要咨询？😊', NULL, NULL, 7608, 0, '2026-03-04 13:28:57');
INSERT INTO `ai_chat_turn_audit` VALUES (4, 14, 100, '查看我的订单', '您好！我为您查询到了以下订单信息 📦\n\n## 您的订单列表\n\n### 订单 1\n- **订单编号**：ORD2027960831975133184\n- **订单金额**：¥38,970.00\n- **下单时间**：2026-03-01 12:15\n- **订单状态**：✅ 已付款\n\n### 订单 2\n- **订单编号**：ORD2027692769887748096\n- **订单金额**：¥9,999.00\n- **下单时间**：2026-02-28 18:30\n- **订单状态**：✅ 已付款\n\n---\n\n💡 **温馨提示**：\n您的两个订单都已付款，接下来会进入发货流程。您可以：\n- 🔍 查询某个订单的详细信息（商品列表、物流等）\n- 📦 查看物流进度（发货后可查询）\n\n请问您想了解哪个订单的详细信息吗？或者需要查询物流信息？😊', NULL, '[\"queryUserOrders\"]', 8496, 0, '2026-03-04 13:30:48');
INSERT INTO `ai_chat_turn_audit` VALUES (5, 14, 100, '贵阳今天的天气怎么样', '您好！😊\n\n关于贵阳的天气查询，我这边主要是电商客服助手，暂时无法提供实时天气信息哦~\n\n建议您可以通过以下方式查询：\n- 📱 手机天气 APP\n- 🌐 搜索引擎搜索\"贵阳天气\"\n- 📺 当地气象部门官网\n\n---\n\n🛍️ **不过我可以帮您处理电商相关事务哦！**\n\n比如：\n- 🔍 搜索商品、查看商品详情\n- 📦 查询订单状态、物流信息\n- 🔧 提交售后工单、处理退换货\n- 💡 根据需求推荐商品\n\n请问有什么电商相关的问题需要我帮您处理吗？😊', NULL, NULL, 6507, 0, '2026-03-04 13:34:37');
INSERT INTO `ai_chat_turn_audit` VALUES (6, 15, 100, '有什么热门商品推荐？', '您好！😊 为您推荐几款热门商品：\n\n**📱 手机类：**\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存：96件\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：120件\n\n**💻 电脑类：**\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n这些都是当前比较受欢迎的商品哦！👍\n\n您对哪款商品感兴趣呢？是否需要了解更多详情，或者要不要加入购物车？🛒', NULL, '[\"recommendProducts\"]', 11162, 0, '2026-03-04 14:25:04');
INSERT INTO `ai_chat_turn_audit` VALUES (7, 16, 100, '早上好', '早上好！😊 我是小智，您的电商智能客服助手。\n\n今天有什么可以帮您的吗？比如：\n- 🛒 想看看有什么商品？\n- 📦 查询订单状态或物流？\n- 🎁 需要商品推荐？\n- 🔧 有售后问题需要处理？\n\n随时告诉我您的需求哦！', NULL, NULL, 4912, 0, '2026-03-05 10:15:12');
INSERT INTO `ai_chat_turn_audit` VALUES (8, 16, 100, '转接人工客服', '已为您成功转接人工客服！😊\n\n**工单号：TK2029380236642742272**\n\n客服人员会尽快与您联系处理您的问题，请您耐心等待。如有其他需要，随时告诉我哦！👍', NULL, '[\"escalateToHuman\"]', 7344, 0, '2026-03-05 10:15:31');
INSERT INTO `ai_chat_turn_audit` VALUES (9, 16, 100, '你好！我是谁', '您好！😊 \n\n根据系统信息，您的用户ID是 **100**。\n\n不过我这里没有您的更多个人信息（如姓名、联系方式等）。如果您需要查询自己的订单、工单或其他账户相关信息，我很乐意帮您查询！\n\n今天有什么可以帮您的吗？比如：\n- 🛒 浏览或搜索商品\n- 📦 查询订单状态\n- 🔧 处理售后问题\n- 💡 商品推荐\n\n随时告诉我哦！👍', NULL, NULL, 7946, 0, '2026-03-05 15:28:37');
INSERT INTO `ai_chat_turn_audit` VALUES (10, 17, 100, '有什么热门商品推荐？', '您好！为您精选了几款热门商品 👇\n\n**📱 手机类：**\n1. **iPhone 15 Pro Max 256GB** - ¥12,990 \n   - 核心卖点：这里是核心买点\n   - 库存充足（96件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：120件\n\n**💻 电脑类：**\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n您对哪款商品感兴趣呢？我可以为您：\n- 📦 查看商品详细参数和规格\n- 🔍 对比两款商品的差异\n- 🛒 帮您加入购物车\n\n请告诉我您的偏好，我随时为您服务！😊', NULL, '[\"recommendProducts\"]', 13684, 0, '2026-03-05 21:23:21');
INSERT INTO `ai_chat_turn_audit` VALUES (11, 17, 100, '退货流程是什么', '您好！我是小智，很高兴为您解答退货流程 😊\n\n## 📋 退货流程说明\n\n**1. 提交退货申请**\n- 在订单详情页点击\"申请售后\"\n- 或联系我帮您创建退款工单\n\n**2. 选择退货原因**\n- 商品质量问题\n- 七天无理由退货\n- 商品与描述不符\n- 其他原因\n\n**3. 等待审核**\n- 客服会在 1-2 个工作日内审核您的申请\n\n**4. 寄回商品**\n- 审核通过后，系统会提供退货地址\n- 请将商品原包装寄回（保持商品完好）\n\n**5. 退款处理**\n- 收到退货并验收合格后\n- 退款将在 3-5 个工作日内原路返回\n\n---\n\n## ⚠️ 注意事项\n- 退货商品需保持完好，不影响二次销售\n- 部分特殊商品（如定制类、生鲜类）不支持无理由退货\n- 请保留好物流单号，方便查询退货进度\n\n---\n\n**如果您需要办理退货**，请告诉我您的订单编号，我可以帮您直接提交退款工单 🛒\n\n请问有什么可以帮您的吗？😊', NULL, NULL, 10297, 0, '2026-03-06 09:47:03');
INSERT INTO `ai_chat_turn_audit` VALUES (12, 18, 100, '1', '您好！我是小智，您的电商智能客服助手 😊\n\n我看到您发送了\"1\"，请问有什么可以帮助您的吗？我可以为您提供以下服务：\n\n🛍️ **商品导购** - 搜索商品、查看商品详情、对比商品参数、根据场景推荐商品\n📦 **订单服务** - 查询订单状态和物流信息、取消订单、确认收货\n🔧 **售后支持** - 提交售后工单、查询处理进度、转接人工客服\n\n请告诉我您需要什么帮助吧！', NULL, NULL, 5645, 0, '2026-03-06 10:30:03');
INSERT INTO `ai_chat_turn_audit` VALUES (13, 18, 100, '2', '您好！我是小智，您的电商智能客服助手 😊\n\n我看到您发送了\"2\"，请问有什么可以帮助您的吗？我可以为您提供以下服务：\n\n🛍️ **商品导购**\n- 搜索商品、查看商品详情\n- 对比商品参数\n- 根据场景和预算推荐商品\n\n📦 **订单服务**\n- 查询订单状态和物流信息\n- 取消待付款订单\n- 确认收货\n\n🔧 **售后支持**\n- 提交售后工单（投诉/退款/换货/咨询）\n- 查询工单处理进度\n- 转接人工客服\n\n请告诉我您需要什么帮助吧！比如：\n- \"我想买一台笔记本电脑\"\n- \"帮我查一下订单状态\"\n- \"商品有问题要退款\"\n\n期待您的回复！🌟', NULL, NULL, 5880, 0, '2026-03-06 10:30:19');
INSERT INTO `ai_chat_turn_audit` VALUES (14, 18, 100, '为我推荐一款手机', '您好！根据您的需求，我为您推荐以下几款热门手机：\n\n## 📱 推荐商品\n\n**1. iPhone 15 Pro Max 256GB**\n- 💰 价格：¥12,990\n- 📦 库存：95件\n- ✨ 核心卖点：这里是核心买点\n\n**2. 华为 Mate 60 Pro**\n- 💰 价格：¥6,999\n- 📦 库存：80件\n\n---\n\n这两款手机各有特色，iPhone 15 Pro Max 适合追求高端体验和iOS生态的用户，华为 Mate 60 Pro 性价比更高。\n\n**请问您：**\n- 想了解哪款手机的详细参数和配置？\n- 需要我帮您对比这两款手机的差异吗？\n- 或者您有特定的预算范围和使用场景，我可以为您重新推荐？\n\n如果您看中某款，可以直接加入购物车，方便统一结算哦！🛒', NULL, '[\"recommendProducts\"]', 10116, 0, '2026-03-06 10:35:22');
INSERT INTO `ai_chat_turn_audit` VALUES (15, 18, 100, '为我推荐一款手机', '您好！根据您的手机需求，我为您推荐以下两款热门机型：\n\n## 📱 推荐商品\n\n**1. iPhone 15 Pro Max 256GB**\n- 💰 价格：¥12,990\n- 📦 库存：95件\n- ✨ 核心卖点：这里是核心买点\n\n**2. 华为 Mate 60 Pro**\n- 💰 价格：¥6,999\n- 📦 库存：80件\n\n---\n\n这两款手机各有优势：\n- **iPhone 15 Pro Max** 适合追求高端体验和iOS生态的用户\n- **华为 Mate 60 Pro** 性价比更高，适合追求实用性的用户\n\n**请问您：**\n- 📋 想了解哪款手机的详细参数和配置？\n- ⚖️ 需要我帮您对比这两款手机的差异吗？\n- 💰 或者您有特定的预算范围，我可以为您重新推荐？\n\n如果您看中某款，您可以直接加入购物车，方便统一结算哦！🛒', NULL, '[\"recommendProducts\"]', 9512, 0, '2026-03-06 11:08:56');
INSERT INTO `ai_chat_turn_audit` VALUES (16, 18, 100, 'e 60 Pro\n\n💰 价格：¥6,999\n📦 库存：80件\n这两款手机各有优势：\n\niPhone 15 Pro Max 适合追求高端体验和iOS生态的用户\n华为 Mate 60 Pro 性价比更高，适合追求实用性的用户\n请问您：\n\n📋 想了解哪款手机的详细参数和配置？\n⚖️ 需要我帮您对比这两款手机的差异吗？\n💰 或者您有特定的预算范围，我可以为您重新推荐？\n如果您看中某款，您可以直接加入购物车，方便', '您好！📱\n\n我刚刚查询了系统数据库，**当前系统暂无手机商品上架**。很抱歉无法为您推荐具体的手机型号。\n\n不过，我可以帮您：\n- 🔍 搜索其他类别的商品（如电脑、平板、配件等）\n- 💡 根据您的使用场景和预算推荐其他电子产品\n- 📦 查询您的订单状态或物流信息\n- 🔧 处理售后问题\n\n**请问您：**\n- 想了解其他类别的商品吗？\n- 或者您有订单需要查询？\n- 需要我转接人工客服为您进一步协助吗？\n\n期待您的回复！😊', NULL, '[\"searchProducts\"]', 11854, 0, '2026-03-06 11:45:17');
INSERT INTO `ai_chat_turn_audit` VALUES (17, 18, 100, '为我推荐一款手机', '您好！根据您的需求，我为您推荐以下两款热门手机：\n\n## 📱 推荐商品\n\n**1. iPhone 15 Pro Max 256GB**\n- 💰 价格：¥12,990\n- 📦 库存：95件\n- ✨ 核心卖点：这里是核心买点\n\n**2. 华为 Mate 60 Pro**\n- 💰 价格：¥6,999\n- 📦 库存：80件\n\n---\n\n这两款手机各有优势：\n- **iPhone 15 Pro Max**：高端旗舰，适合追求极致体验和iOS生态的用户\n- **华为 Mate 60 Pro**：性价比高，适合追求实用性的用户\n\n**请问您：**\n- 📋 想了解哪款手机的详细参数和配置？\n- ⚖️ 需要我帮您对比这两款手机的差异吗？\n- 💰 或者您有特定的预算范围，我可以为您重新推荐？\n\n如果您看中某款，您可以直接加入购物车，方便统一结算哦！🛒', NULL, '[\"recommendProducts\"]', 11051, 0, '2026-03-06 12:09:11');
INSERT INTO `ai_chat_turn_audit` VALUES (18, 18, 100, '为我对比这个两个手机', '您好！😊\n\n我刚刚查询了系统数据库，**当前系统暂无手机商品上架**，所以无法为您对比手机型号。\n\n**我可以为您提供以下帮助：**\n- 🔍 搜索其他类别的商品（如电脑、平板、耳机、配件等）\n- 💡 根据您的使用场景和预算推荐其他电子产品\n- 📦 查询您的订单状态或物流信息\n- 🔧 处理售后问题或提交工单\n\n**请问您：**\n- 想了解其他类别的商品吗？\n- 或者您有订单需要查询？\n- 需要我转接人工客服为您进一步协助吗？\n\n期待您的回复！🌟', NULL, '[\"searchProducts\"]', 9219, 0, '2026-03-06 12:10:49');
INSERT INTO `ai_chat_turn_audit` VALUES (19, 19, 100, '有什么热门商品推荐？', '您好！😊 为您推荐几款热门商品：\n\n## 📱 手机类\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：高端旗舰，性能卓越\n   - 库存：95件\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n## 💻 电脑类\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n您对哪款商品感兴趣呢？我可以为您：\n- 🔍 查看商品详细信息\n- ⚖️ 对比两款商品参数\n- 🛒 帮您加入购物车\n\n请告诉我您的需求，我随时为您服务！👍', NULL, '[\"recommendProducts\"]', 13091, 0, '2026-03-06 13:13:19');
INSERT INTO `ai_chat_turn_audit` VALUES (20, 20, 100, '有什么热门商品推荐？', '您好！😊 为您推荐几款当前热门商品：\n\n## 📱 手机类\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存：95件\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n## 💻 电脑类\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n这些商品都是近期销量和口碑都不错的选择！👍\n\n**您对哪款商品感兴趣呢？** 我可以帮您：\n- 📋 查看商品详细信息\n- ⚖️ 对比两款商品的参数\n- 🛒 引导您加入购物车\n\n请告诉我您的偏好，我随时为您服务！😊', NULL, '[\"recommendProducts\"]', 12131, 0, '2026-03-06 13:23:55');
INSERT INTO `ai_chat_turn_audit` VALUES (21, 21, 100, '有什么热门商品推荐？', '您好！为您精选了几款热门商品推荐：\n\n📱 **手机类：**\n1. **iPhone 15 Pro Max 256GB** - ¥12,990 \n   - 核心卖点：这里是核心买点\n   - 库存充足（95件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n💻 **电脑类：**\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n请问您对哪款商品感兴趣？我可以为您查看更详细的产品信息，或者帮您对比不同商品的参数哦！😊\n\n您也可以直接加入购物车，方便统一结算🛒', NULL, '[\"recommendProducts\"]', 12180, 0, '2026-03-06 13:57:36');
INSERT INTO `ai_chat_turn_audit` VALUES (22, 21, 100, '今天天气这么有', '您好呀！😊 今天天气确实很不错呢～ 阳光明媚，心情也会跟着变好！\n\n这样的好天气，很适合逛逛我们商城，给自己挑些心仪的商品哦！🛒\n\n您最近有想买的商品吗？我可以帮您：\n- 🔍 搜索特定商品\n- 💡 根据场景和预算推荐商品\n- 📱 查看热门商品详情\n- ⚖️ 对比不同商品参数\n\n或者您想看看最近的订单状态？有什么需要我帮忙的吗？😊', NULL, NULL, 5383, 0, '2026-03-06 13:58:04');
INSERT INTO `ai_chat_turn_audit` VALUES (23, 21, 100, '今天什么天气', '您好呀！😊 \n\n很抱歉，我作为电商客服助手，无法查询实时天气信息呢～ 建议您查看手机天气 APP 或搜索\"天气\"来获取准确的天气预报哦！☀️🌧️\n\n不过，我可以帮您处理电商相关的事情，比如：\n- 🔍 搜索或推荐商品\n- 📦 查询订单状态和物流\n- 🛒 查看商品详情或对比参数\n- 📝 提交售后工单\n\n有什么我可以帮您的吗？😊', NULL, NULL, 6287, 0, '2026-03-06 13:58:27');
INSERT INTO `ai_chat_turn_audit` VALUES (24, 23, 100, '有什么热门商品推荐？', '您好！我是小智，很高兴为您推荐热门商品！😊\n\n根据您的需求，我为您精选了以下几款热门商品：\n\n## 📱 手机类\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存充足（95件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n3. **小米14 Ultra** - ¥5,999\n   - 库存：119件\n\n## 💻 电脑类\n4. **MacBook Pro 14英寸 M3** - ¥12,999\n   - 库存：50件\n\n5. **联想 ThinkPad X1 Carbon** - ¥8,999\n   - 库存：60件\n\n---\n\n这些商品都是当前热销的数码产品哦！🔥\n\n**请问您对哪款商品感兴趣呢？** \n- 想了解某款商品的详细参数和规格？\n- 需要我帮您对比两款商品？\n- 或者有特定的使用场景和预算，我可以为您做更精准的推荐？\n\n您可以直接告诉我商品名称，我帮您查看更多详情！🛒', NULL, '[\"recommendProducts\"]', 13485, 0, '2026-03-06 20:07:18');
INSERT INTO `ai_chat_turn_audit` VALUES (25, 23, 100, '为我推荐一个手机', '您好！我是小智，很高兴为您推荐手机！📱\n\n根据您的需求，我为您精选了以下热门手机：\n\n## 📱 推荐手机\n\n1. **iPhone 15 Pro Max 256GB** - ¥12,990\n   - 核心卖点：这里是核心买点\n   - 库存充足（95件）\n\n2. **华为 Mate 60 Pro** - ¥6,999\n   - 库存：80件\n\n---\n\n这两款都是当前热销的旗舰手机哦！🔥\n\n**请问您对哪款更感兴趣呢？**\n- 想了解某款手机的详细参数和规格？\n- 需要我帮您对比这两款手机？\n- 或者有特定的预算范围和使用场景，我可以为您做更精准的推荐？\n\n您可以直接告诉我商品名称，我帮您查看更多详情！🛒', NULL, '[\"recommendProducts\"]', 8861, 0, '2026-03-06 20:07:58');
INSERT INTO `ai_chat_turn_audit` VALUES (26, 23, 100, '我已经买了那些商品了', '您好！我是小智，我来帮您查看已购买的商品订单！📦\n\n## 您的订单列表\n\n| 订单编号 | 金额 | 状态 | 创建时间 |\n|---------|------|------|---------|\n| ORD2030166584999833600 | ¥71,971.90 | **已退款** ❌ | 2026-03-07 |\n| ORD2029731846887632896 | ¥24,688.00 | **已送达** ✅ | 2026-03-06 |\n| ORD2027960831975133184 | ¥38,970.00 | **已付款** 💳 | 2026-03-01 |\n| ORD2027692769887748096 | ¥9,999.00 | **已付款** 💳 | 2026-02-28 |\n\n---\n\n### 📋 订单状态说明：\n\n1. **已退款订单** (ORD2030166584999833600)\n   - 退款已完成，款项已退回\n\n2. **已送达订单** (ORD2029731846887632896)\n   - 商品已送达，请问您是否已收到商品？需要帮您**确认收货**吗？\n\n3. **已付款订单** (ORD2027960831975133184、ORD2027692769887748096)\n   - 等待商家发货中，请耐心等待哦~\n\n---\n\n**请问您需要：**\n- 🔍 查看某个订单的商品详情？\n- 📦 查询已送达订单的物流信息？\n- ✅ 确认收货（针对已送达订单）？\n- 💬 有其他售后问题需要帮助？\n\n请告诉我订单编号，我可以为您提供更详细的信息！😊', NULL, '[\"queryUserOrders\"]', 15511, 0, '2026-03-07 14:51:35');
INSERT INTO `ai_chat_turn_audit` VALUES (27, 23, 100, '这四个订单分别买了什么东西', '您好！我是小智，我来为您详细展示这四个订单的商品信息！📦\n\n## 订单商品明细\n\n### 1️⃣ 订单 ORD2030166584999833600\n**状态：已退款** ❌ | **金额：¥71,971.90**\n\n| 商品名称 | 数量 |\n|---------|------|\n| ChatGPT plus会员一个月 | 10 |\n| iPhone 15 Pro Max 256GB | 2 |\n| 华为 Mate 60 Pro | 1 |\n| 小米14 Ultra | 2 |\n| AirPods Pro 2 | 2 |\n| MacBook Pro 14英寸 M3 | 1 |\n| 联想 ThinkPad X1 Carbon | 1 |\n| 华为 FreeBuds Pro 3 | 1 |\n\n---\n\n### 2️⃣ 订单 ORD2029731846887632896\n**状态：已送达** ✅ | **金额：¥24,688.00** | **物流：中通快递**\n\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 1 |\n| 华为 MatePad Pro 13.2 | 1 |\n| 小米14 Ultra | 1 |\n\n> 📬 此订单已送达，请问您是否已收到商品？需要帮您**确认收货**吗？\n\n---\n\n### 3️⃣ 订单 ORD2027960831975133184\n**状态：已付款** 💳 | **金额：¥38,970.00**\n\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 3 |\n\n> ⏳ 此订单等待商家发货中，请耐心等待哦~\n\n---\n\n### 4️⃣ 订单 ORD2027692769887748096\n**状态：已付款** 💳 | **金额：¥9,999.00**\n\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 1 |\n\n> ⏳ 此订单等待商家发货中，请耐心等待哦~\n\n---\n\n## 📊 汇总统计\n您总共购买了 **7台 iPhone 15 Pro Max**，还有其他多款热门数码产品！看来您是一位数码爱好者呢！🔥\n\n**请问您需要：**\n- 📦 查询已送达订单的物流详情？\n- ✅ 确认收货（针对已送达订单）？\n- 🔍 查看某个商品的详细信息？\n- 💬 有其他问题需要帮助？\n\n随时告诉我哦！😊', NULL, '[\"queryOrder\", \"queryOrder\", \"queryOrder\", \"queryOrder\"]', 17843, 0, '2026-03-07 14:52:41');
INSERT INTO `ai_chat_turn_audit` VALUES (28, 23, 100, '我还有那些商品没有评价？', '您好！我是小智，我来帮您查看哪些商品还没有评价！📝\n\n## 您的订单评价情况\n\n### ✅ 可以评价的订单（已送达）\n\n**订单 ORD2029731846887632896** - 状态：已送达\n| 商品名称 | 数量 | 评价状态 |\n|---------|------|---------|\n| iPhone 15 Pro Max 256GB | 1 | ⏳ 待评价 |\n| 华为 MatePad Pro 13.2 | 1 | ⏳ 待评价 |\n| 小米14 Ultra | 1 | ⏳ 待评价 |\n\n> 📬 这个订单已送达，您可以对以上3款商品进行评价哦！\n\n---\n\n### ⏳ 暂不能评价的订单\n\n| 订单编号 | 状态 | 原因 |\n|---------|------|------|\n| ORD2030166584999833600 | 已退款 | 退款订单无法评价 |\n| ORD2027960831975133184 | 已付款 | 等待发货中 |\n| ORD2027692769887748096 | 已付款 | 等待发货中 |\n\n---\n\n## 📊 总结\n您目前有 **3件商品** 可以评价但尚未评价：\n- iPhone 15 Pro Max 256GB\n- 华为 MatePad Pro 13.2\n- 小米14 Ultra\n\n**温馨提示：**\n- 只有\"已送达\"状态的订单才能进行评价\n- 其他订单需等待发货并送达后才能评价\n\n**请问您想：**\n- 📝 对已送达的商品进行评价？（需要您前往订单详情页操作）\n- 📦 查询其他订单的物流进度？\n- 💬 有其他问题需要帮助？\n\n随时告诉我哦！😊', NULL, '[\"queryUserOrders\", \"queryOrder\"]', 29054, 0, '2026-03-07 14:55:04');
INSERT INTO `ai_chat_turn_audit` VALUES (29, 23, 100, '为我评价这个订单 ORD2029731846887632896，分别打1星、2星', '您好！我是小智，关于您提到的评价问题，我需要说明一下：📝\n\n## 订单信息确认\n**订单 ORD2029731846887632896**\n- 状态：已送达 ✅\n- 商品：iPhone 15 Pro Max 256GB、华为 MatePad Pro 13.2、小米14 Ultra\n- 物流：中通快递\n\n---\n\n## ⚠️ 关于评价的说明\n\n很抱歉，**我无法直接代为进行商品评价**。评价功能需要您本人在系统中操作，具体步骤如下：\n\n### 评价流程：\n1. **先确认收货**（如果还未确认）\n   - 我可以帮您确认这个订单已收到商品\n   \n2. **进入订单详情页**\n   - 在\"我的订单\"中找到此订单\n   \n3. **对每件商品分别评价**\n   - 您可以对 iPhone 15 Pro Max 打1星\n   - 对 华为 MatePad Pro 13.2 打2星\n   - 对 小米14 Ultra 进行评价\n\n---\n\n## 💡 我可以帮您：\n\n**是否需要我先帮您确认收货？** \n确认后可以更方便地进行评价操作。\n\n或者，如果您对商品有任何**不满意的地方**，我也可以帮您：\n- 📋 创建售后工单（投诉/退款/换货）\n- 💬 转接人工客服处理问题\n\n请问您想怎么处理呢？😊', '[{\"title\": \"【商品】AirPods Pro 2\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"16\"}, {\"title\": \"【商品】iPad Air M2\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"19\"}, {\"title\": \"【商品】华为 MatePad Pro 13.2\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"10\"}]', '[\"queryOrder\"]', 22475, 1, '2026-03-07 15:01:30');
INSERT INTO `ai_chat_turn_audit` VALUES (30, 23, 100, '列出我的所有收货地址', '您好！我是小智，很高兴为您服务！😊\n\n## 📍 关于收货地址查询\n\n很抱歉，**当前系统暂未提供收货地址查询功能**。我们的客服系统主要支持以下服务：\n\n### ✅ 可提供的服务：\n- 🛒 商品搜索、推荐、详情查询、参数对比\n- 📦 订单查询、物流跟踪、确认收货、取消订单\n- 💬 售后工单提交、进度查询\n- 🎧 转接人工客服\n\n---\n\n### 💡 建议您：\n\n1. **查看订单详情**\n   - 我可以帮您查询具体订单，订单详情中会显示该订单的收货地址\n   - 请问您想查看哪个订单的收货信息？\n\n2. **登录商城官网/APP**\n   - 在\"个人中心\" → \"地址管理\"中可以查看和管理所有收货地址\n\n3. **转接人工客服**\n   - 如需帮助管理收货地址，我可以为您转接人工客服处理\n\n---\n\n**请问您想：**\n- 📦 查询某个订单的详情（包含收货地址）？\n- 🎧 转接人工客服协助处理地址问题？\n- 💬 还有其他我可以帮您的吗？\n\n随时告诉我哦！😊', NULL, NULL, 13583, 0, '2026-03-07 20:31:47');
INSERT INTO `ai_chat_turn_audit` VALUES (31, 23, 100, '查看我的个人信息', '您好！我是小智，很高兴为您服务！😊\n\n## 👤 您的个人信息\n\n| 项目 | 信息 |\n|------|------|\n| **昵称** | test1 |\n| **性别** | 男 |\n| **手机号** | 暂未绑定 |\n| **邮箱** | 暂未绑定 |\n| **上次登录时间** | 2026-03-08 21:16:36 |\n\n---\n\n### 💡 温馨提示：\n- 您的手机号和邮箱暂未绑定，建议绑定后可以更方便地接收订单通知和找回密码哦！\n- 如需修改个人信息，可以前往\"个人中心\"进行设置\n\n**请问您还需要：**\n- 📍 查看或管理您的收货地址？\n- 📦 查询您的订单列表？\n- 🔔 查看未读通知？\n- 💬 其他需要帮助的地方？\n\n随时告诉我哦！😊', NULL, '[\"queryUserInfo\"]', 8048, 0, '2026-03-08 21:58:54');
INSERT INTO `ai_chat_turn_audit` VALUES (32, 23, 100, '我有什么收货地址', '您好！我是小智，很高兴为您服务！😊\n\n## 📍 您的收货地址列表\n\n| ID | 联系人 | 手机号 | 收货地址 | 状态 |\n|----|--------|--------|----------|------|\n| 4 | 123 | 156****7896 | 天津市和平区 12311 | ⭐ **默认地址** |\n| 6 | 123 | 123 | 12311w*** | |\n| 5 | 123 | 123 | 12311w*** | |\n| 3 | 123 | 123 | 123 | |\n| 2 | sun | 111****1111 | 贵州省贵阳市*** | |\n| 1 | sun | 111****1111 | 贵州省贵阳市*** | |\n\n---\n\n### 📊 地址统计\n- **总地址数**：6个\n- **默认地址**：1个（天津市和平区）\n\n---\n\n**请问您需要：**\n- 🔄 **更改默认地址**？（告诉我地址ID，我帮您设置）\n- ➕ **添加新地址**？（需前往个人中心操作）\n- 📦 **下单时使用哪个地址**？\n- 💬 其他需要帮助的地方？\n\n随时告诉我哦！😊', NULL, '[\"queryUserAddresses\"]', 11787, 0, '2026-03-08 22:02:04');
INSERT INTO `ai_chat_turn_audit` VALUES (33, 23, 100, '有新消息吗', '您好！我是小智，很高兴为您服务！😊\n\n## 📬 您的消息通知\n\n**当前没有未读通知哦！** ✅\n\n所有消息都已处理完毕，您可以放心啦~\n\n---\n\n**温馨提示：**\n- 如有新订单状态更新、物流信息或促销活动，系统会及时通知您\n- 您可以随时问我\"有新消息吗\"来查看最新通知\n\n**请问您还需要：**\n- 📦 查看您的订单列表？\n- 🛒 搜索或推荐商品？\n- 💬 其他需要帮助的地方？\n\n随时告诉我哦！😊', NULL, '[\"queryUnreadNotifications\"]', 5872, 0, '2026-03-08 22:02:41');
INSERT INTO `ai_chat_turn_audit` VALUES (34, 23, 100, '帮我评价这个商品', '您好！我是小智，很高兴帮您进行商品评价！📝\n\n不过我需要确认一下具体信息：\n\n## ❓ 需要确认的信息\n\n1. **要评价哪个商品？**\n   根据您之前的订单 ORD2029731846887632896，包含以下商品：\n   - iPhone 15 Pro Max 256GB\n   - 华为 MatePad Pro 13.2\n   - 小米14 Ultra\n   \n   请问您想评价哪一款？\n\n2. **评分是多少？**（1-5分，5分为最高）\n   您之前提到过1星、2星，请确认具体评分\n\n3. **评价内容是什么？**\n   请告诉我您想写的评价内容\n\n---\n\n## 💡 评价流程说明\n\n确认以上信息后，我会帮您：\n1. ✅ 检查该商品是否已评价过\n2. 📝 提交您的评价\n\n**请告诉我：**\n- 商品名称\n- 评分（1-5分）\n- 评价内容\n\n随时告诉我哦！😊', '[{\"title\": \"【商品】华为 MatePad Pro 13.2\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"10\"}, {\"title\": \"【商品】iPad Air M2\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"19\"}, {\"title\": \"【商品】华为 Mate 60 Pro\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"12\"}]', NULL, 10704, 1, '2026-03-08 22:04:01');
INSERT INTO `ai_chat_turn_audit` VALUES (35, 23, 100, '我还有什么商品没有评价', '您好！我是小智，我来帮您查看哪些商品还没有评价！📝\n\n## 📊 您的订单评价情况\n\n### ✅ 可以评价的订单（已送达状态）\n\n**订单 ORD2029731846887632896** - 状态：已送达\n| 商品名称 | 数量 |\n|---------|------|\n| iPhone 15 Pro Max 256GB | 1 |\n| 华为 MatePad Pro 13.2 | 1 |\n| 小米14 Ultra | 1 |\n\n---\n\n### ⏳ 暂不能评价的订单\n\n| 订单编号 | 状态 | 原因 |\n|---------|------|------|\n| ORD2030645615457333248 | 待付款 | 未付款，无法评价 |\n| ORD2030166584999833600 | 已退款 | 退款订单无法评价 |\n| ORD2027960831975133184 | 已付款 | 等待发货中 |\n| ORD2027692769887748096 | 已付款 | 等待发货中 |\n\n---\n\n## 📝 总结\n\n您目前有 **3件商品** 可以评价（来自已送达订单 ORD2029731846887632896）：\n1. iPhone 15 Pro Max 256GB\n2. 华为 MatePad Pro 13.2\n3. 小米14 Ultra\n\n**温馨提示：**\n- 只有\"已送达\"状态的订单才能进行评价\n- 其他订单需等待发货并送达后才能评价\n\n**请问您想：**\n- 📝 对以上商品进行评价？（请告诉我具体商品、评分和评价内容）\n- 📦 查询其他订单的物流进度？\n- 💬 有其他问题需要帮助？\n\n随时告诉我哦！😊', NULL, '[\"queryUserOrders\", \"queryOrder\"]', 29045, 0, '2026-03-08 22:15:22');
INSERT INTO `ai_chat_turn_audit` VALUES (36, 25, 100, '我买过什么商品了', '您好！我为您查询了所有的订单记录，您购买过的商品如下：\n\n**📋 订单汇总：**\n\n1. **ORD2030645615457333248**（待付款）- ¥12,990\n   - iPhone 15 Pro Max 256GB × 1\n\n2. **ORD2030166584999833600**（已退款）- ¥71,971.90\n   - ChatGPT plus会员一个月 × 10\n   - iPhone 15 Pro Max 256GB × 2\n   - 华为 Mate 60 Pro × 1\n   - 小米14 Ultra × 2\n   - AirPods Pro 2 × 2\n   - MacBook Pro 14英寸 M3 × 1\n   - 联想 ThinkPad X1 Carbon × 1\n   - 华为 FreeBuds Pro 3 × 1\n\n3. **ORD2029731846887632896**（已发货）- ¥24,688\n   - iPhone 15 Pro Max 256GB × 1\n   - 华为 MatePad Pro 13.2 × 1\n   - 小米14 Ultra × 1\n   - 📦 物流：中通快递 ZTO246544201\n\n4. **ORD2027960831975133184**（已付款）- ¥38,970\n   - iPhone 15 Pro Max 256GB × 3\n\n5. **ORD2027692769887748096**（已付款）- ¥9,999\n   - iPhone 15 Pro Max 256GB × 1\n\n**💡 温馨提醒：**\n- 您有1个待付款订单（ORD2030645615457333248），需要尽快支付哦\n- 有1个已发货订单（ORD2029731846887632896），可以查询物流进度或确认收货\n- 有2个已付款订单等待发货\n\n需要我帮您查询某个订单的详细信息或物流进度吗？😊', '[{\"title\": \"【商品】华为 Mate 60 Pro\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"12\"}, {\"title\": \"【商品】AirPods Pro 2\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"16\"}, {\"title\": \"【商品】华为 FreeBuds Pro 3\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"17\"}]', '[\"queryUserOrders\", \"queryOrder\", \"queryOrder\", \"queryOrder\", \"queryOrder\", \"queryOrder\"]', 19428, 1, '2026-03-08 23:43:58');
INSERT INTO `ai_chat_turn_audit` VALUES (37, 25, 100, '帮我结算购物车', '您好！我帮您查看了购物车，目前您的购物车是空的，没有商品可以结算哦~ 😊\n\n**💡 小建议：**\n- 您可以浏览一下我们的商品，看看有没有心仪的数码产品\n- 我可以为您推荐一些热门商品，或者帮您搜索特定类型的产品\n- 找到喜欢的商品后，加入购物车，就可以统一结算啦！\n\n需要我为您推荐一些商品，或者帮您搜索什么类型的产品吗？🛒', NULL, '[\"viewCart\"]', 6370, 0, '2026-03-09 21:45:01');
INSERT INTO `ai_chat_turn_audit` VALUES (38, 25, 100, '帮我结算购物车', '您好！我帮您查看了购物车，目前您的购物车是空的，没有商品可以结算哦~ 😊\n\n**💡 小建议：**\n- 您可以浏览一下我们的商品，看看有没有心仪的数码产品\n- 我可以为您推荐一些热门商品，或者帮您搜索特定类型的产品\n- 找到喜欢的商品后，加入购物车，就可以统一结算啦！\n\n需要我为您推荐一些商品，或者帮您搜索什么类型的产品吗？🛒', NULL, '[\"viewCart\"]', 5480, 0, '2026-03-09 21:45:50');
INSERT INTO `ai_chat_turn_audit` VALUES (39, 25, 100, 'AI查询用户信息', '您好，test1！这是您的账号信息：\n\n👤 **基本信息**\n- 昵称：test1\n- 性别：男\n- 手机号：未绑定\n- 邮箱：未绑定\n- 上次登录时间：2026年3月9日 20:55:16\n\n💡 **温馨提示：**\n- 建议您绑定手机号和邮箱，方便接收订单通知和找回密码\n- 如需修改个人信息或绑定联系方式，可以联系人工客服协助处理\n\n需要我帮您查询订单、地址或其他服务吗？😊', NULL, '[\"queryUserInfo\"]', 6438, 0, '2026-03-09 21:46:17');
INSERT INTO `ai_chat_turn_audit` VALUES (40, 25, 100, '查询我的地址', '您好！这是您当前的收货地址列表：\n\n📍 **您的收货地址**\n\n| ID | 联系人 | 电话 | 地址 | 默认 |\n|---|---|---|---|---|\n| 4 | 123 | 156****7896 | 天津市市辖区和平区 12*** | ✅ 是 |\n| 6 | 123 | *** | 12311w*** | 否 |\n| 5 | 123 | *** | 12311w*** | 否 |\n| 3 | 123 | *** | 12*** | 否 |\n| 2 | sun | 111****1111 | 贵州省贵阳市*** | 否 |\n| 1 | sun | 111****1111 | 贵州省贵阳市*** | 否 |\n\n**💡 地址管理提示：**\n- ✅ 当前默认地址是：**天津市市辖区和平区**（ID: 4）\n- 如需**新增地址**，请告诉我联系人、电话、省市区和详细地址\n- 如需**修改地址**，请告诉我要修改哪个地址ID及新信息\n- 如需**删除地址**，请告诉我要删除的地址ID\n- 如需**更改默认地址**，请告诉我想设为默认的地址ID\n\n需要我帮您管理地址吗？😊', NULL, '[\"queryUserAddresses\"]', 12421, 0, '2026-03-09 21:47:03');
INSERT INTO `ai_chat_turn_audit` VALUES (41, 26, 100, '帮我看看购物车', '您好！您的购物车内容如下：\n\n🛒 **购物车商品**\n\n| 商品名称 | 单价 | 数量 | 小计 |\n|---------|------|------|------|\n| iPhone 15 Pro Max 256GB | ¥12,990.00 | 1 | ¥12,990.00 |\n| ChatGPT plus会员一个月 | ¥19.99 | 3 | ¥59.97 |\n\n---\n\n**📊 汇总信息**\n- 商品总数：2 件\n- 已勾选：2 件\n- **总计金额：¥13,049.97**\n\n---\n\n请问您需要：\n1. 🛍️ **直接结算下单**吗？\n2. ➕ **继续添加商品**？\n3. 🗑️ **移除或修改**某个商品？\n4. 🧹 **清空购物车**？\n\n随时告诉我您的需求哦！😊', NULL, '[\"viewCart\"]', 8901, 0, '2026-03-09 22:20:45');
INSERT INTO `ai_chat_turn_audit` VALUES (42, 26, 100, '帮我把华为 Mate 60 Pro 加入购物车', '✅ **已成功将「华为 Mate 60 Pro」加入购物车！**\n\n📱 **商品信息**\n- 商品名称：华为 Mate 60 Pro\n- 价格：¥6,999.00\n- 数量：1 件\n- 核心配置：麒麟9000S芯片，支持卫星通话\n\n---\n\n请问您还需要：\n1. 🛒 **继续添加其他商品**到购物车吗？\n2. 📋 **查看购物车**全部内容？\n3. 💳 **直接结算下单**？\n4. ℹ️ **了解更多商品详情**（如详细参数、用户评价等）？\n\n随时告诉我您的需求哦！😊', '[{\"title\": \"【商品】华为 Mate 60 Pro\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"12\"}, {\"title\": \"【商品】华为 MatePad Pro 13.2\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"10\"}, {\"title\": \"【商品】iPhone 15 Pro Max 256GB\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"9\"}]', '[\"searchProducts\", \"addToCart\"]', 8945, 1, '2026-03-09 22:21:18');
INSERT INTO `ai_chat_turn_audit` VALUES (43, 26, 100, '帮我把商品：ChatGPT plus会员一个月 改成一个数量', '您好！我查看了您的购物车，目前「ChatGPT plus会员一个月」的数量是 **3件**。\n\n⚠️ 当前系统暂不支持直接修改购物车商品数量，但我可以帮您通过以下方式调整：\n\n**方案：先移除该商品，再重新添加1件**\n\n请问您确认要将「ChatGPT plus会员一个月」的数量改为 **1件** 吗？确认后我将为您操作：\n1. 🗑️ 先移除购物车中的该商品\n2. ➕ 再重新添加1件到购物车\n\n请回复\"确认\"或\"是的\"，我立即为您处理！😊', '[{\"title\": \"【商品】ChatGPT plus会员一个月\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"11\"}, {\"title\": \"【商品】华为 Mate 60 Pro\", \"category\": \"PRODUCT_INFO\", \"knowledgeId\": \"12\"}]', '[\"viewCart\"]', 13737, 1, '2026-03-09 22:23:31');
INSERT INTO `ai_chat_turn_audit` VALUES (44, 26, 100, '帮我结算购物车', '🛒 **您的购物车内容如下：**\n\n| 商品名称 | 单价 | 数量 | 小计 |\n|---------|------|------|------|\n| 华为 Mate 60 Pro | ¥6,999.00 | 1 | ¥6,999.00 |\n| iPhone 15 Pro Max 256GB | ¥12,990.00 | 1 | ¥12,990.00 |\n| ChatGPT plus会员一个月 | ¥19.99 | 3 | ¥59.97 |\n\n---\n\n**📊 结算信息**\n- 商品总数：3 件\n- 已勾选：3 件 ✅\n- **应付总额：¥20,048.97**\n- 收货地址：将使用您的默认收货地址\n\n---\n\n⚠️ **请注意：**\n- 结算后将生成订单，请确认商品和数量无误\n- 订单生成后需及时完成支付\n\n**请问确认要结算下单吗？** 请回复\"确认\"或\"是的\"，我立即为您生成订单！😊\n\n如需修改购物车内容（如调整数量、移除商品），请告诉我哦~', NULL, '[\"viewCart\"]', 7853, 0, '2026-03-09 22:23:52');

-- ----------------------------
-- Table structure for ai_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `ai_knowledge`;
CREATE TABLE `ai_knowledge`  (
  `knowledge_id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '知识内容（纯文本）',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类：FAQ/POLICY/PRODUCT_INFO/GUIDE',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'MANUAL' COMMENT '来源类型：MANUAL手动 PRODUCT_AUTO商品自动',
  `source_id` bigint NULL DEFAULT NULL COMMENT '来源ID（商品ID等）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`knowledge_id`) USING BTREE,
  INDEX `idx_source`(`source_type` ASC, `source_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '知识库条目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_knowledge
-- ----------------------------
INSERT INTO `ai_knowledge` VALUES (1, '退货政策', '本店退货政策如下：\n1. 商品签收后7天内可申请无理由退货\n2. 退货商品需保持原包装完整，配件齐全\n3. 已激活的电子产品（手机、电脑等）不支持无理由退货\n4. 质量问题可在15天内申请退换货\n5. 退款将在收到退货商品并检验合格后3个工作日内原路退回', 'POLICY', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (2, '保修政策', '保修政策说明：\n1. 所有商品享受国家三包政策\n2. 手机类产品：整机保修1年，电池保修6个月\n3. 电脑类产品：整机保修2年\n4. 配件类产品：保修1年\n5. 人为损坏不在保修范围内\n6. 保修期内免费维修，过保收取工本费', 'POLICY', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (3, '配送说明', '配送信息：\n1. 下单后24小时内发货（节假日顺延）\n2. 默认顺丰快递，偏远地区使用圆通/中通\n3. 一线城市次日达，二三线城市2-3天\n4. 满99元免运费，不满99元收取10元运费\n5. 支持货到付款（仅限部分地区）\n6. 可在订单详情中查看物流信息', 'POLICY', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (4, '支付方式', '支持以下支付方式：\n1. 微信支付\n2. 支付宝\n3. 银联在线支付\n4. 花呗分期（3/6/12期）\n5. 信用卡支付\n所有支付均通过加密通道，请放心使用。', 'FAQ', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (5, '常见问题 - 如何查询订单', '查询订单方法：\n1. 在聊天中直接告诉我您的订单编号，我可以帮您查询\n2. 登录后进入\"我的订单\"页面查看\n3. 订单编号格式为 ORD 开头，如 ORD20250001\n4. 如需查询物流进度，也可以直接询问我', 'FAQ', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (6, 'iPhone 15 Pro Max 产品信息', 'iPhone 15 Pro Max 详细信息：\n- 处理器：A17 Pro 芯片\n- 屏幕：6.7英寸 Super Retina XDR 常亮显示屏\n- 存储：256GB/512GB/1TB\n- 摄像头：4800万像素主摄 + 1200万超广角 + 1200万长焦（5倍光学变焦）\n- 电池：持久续航，支持MagSafe无线充电\n- 材质：钛金属边框\n- 颜色：原色钛金属、蓝色钛金属、白色钛金属、黑色钛金属\n- 支持USB-C接口\n- 价格：9999元起', 'PRODUCT_INFO', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (7, '华为 Mate 60 Pro 产品信息', '华为 Mate 60 Pro 详细信息：\n- 处理器：麒麟9000S\n- 屏幕：6.82英寸 OLED 曲面屏\n- 存储：256GB/512GB/1TB\n- 摄像头：5000万像素超光变主摄 + 1200万超广角 + 4800万超微距长焦\n- 特色功能：天通卫星通话、昆仑玻璃\n- 电池：5000mAh，支持88W有线快充\n- 颜色：雅丹黑、雅川青、南糯紫、白沙银\n- 价格：6999元起', 'PRODUCT_INFO', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (8, '售后联系方式', '售后服务联系方式：\n1. 在线客服：通过智能客服对话即可处理大部分售后问题\n2. 客服热线：400-888-8888（工作日 9:00-18:00）\n3. 邮箱：service@smartcs.com\n4. 微信公众号：SmartCS官方商城\n5. 工单系统：可通过对话让AI客服帮您创建售后工单', 'FAQ', 1, 'MANUAL', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `ai_knowledge` VALUES (9, '【商品】iPhone 15 Pro Max 256GB', 'iPhone 15 Pro Max 256GB\n分类：手机\n价格：12990.00元\n核心卖点：这里是核心买点\n商品规格：苹果最新旗舰手机，A17 Pro芯片，钛金属设计\n库存：95', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 1, '2026-03-01 10:18:27', '2026-03-01 10:18:27');
INSERT INTO `ai_knowledge` VALUES (10, '【商品】华为 MatePad Pro 13.2', '华为 MatePad Pro 13.2\n分类：平板\n价格：5699.00元\n商品规格：华为旗舰平板，星闪连接，OLED柔性屏\n库存：8', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 10, '2026-03-07 12:22:00', '2026-03-07 12:22:00');
INSERT INTO `ai_knowledge` VALUES (11, '【商品】ChatGPT plus会员一个月', 'ChatGPT plus会员一个月\n分类：ai服务\n价格：19.99元\n核心卖点：Chat GPT 官方订阅plus一个月会员，直充到号，稳定快速\n商品规格：一次性服务\n退换货政策：激活后不可退\n保修信息：正常使用，质保一月\n售后注意事项：请勿随意切换地区节点访问，触发风控封号不予退款售后\n库存：10', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 11, '2026-03-07 12:27:04', '2026-03-07 12:27:04');
INSERT INTO `ai_knowledge` VALUES (12, '【商品】华为 Mate 60 Pro', '华为 Mate 60 Pro\n分类：手机\n价格：6999.00元\n商品规格：华为旗舰手机，麒麟9000S芯片，卫星通话\n库存：80', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 2, '2026-03-07 14:17:08', '2026-03-07 14:17:08');
INSERT INTO `ai_knowledge` VALUES (13, '【商品】小米14 Ultra', '小米14 Ultra\n分类：手机\n价格：5999.00元\n商品规格：小米影像旗舰，徕卡光学镜头，骁龙8 Gen3\n库存：119', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 3, '2026-03-07 14:17:09', '2026-03-07 14:17:09');
INSERT INTO `ai_knowledge` VALUES (14, '【商品】MacBook Pro 14英寸 M3', 'MacBook Pro 14英寸 M3\n分类：电脑\n价格：12999.00元\n商品规格：苹果笔记本电脑，M3芯片，Liquid Retina XDR显示屏\n库存：50', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 4, '2026-03-07 14:17:09', '2026-03-07 14:17:09');
INSERT INTO `ai_knowledge` VALUES (15, '【商品】联想 ThinkPad X1 Carbon', '联想 ThinkPad X1 Carbon\n分类：电脑\n价格：8999.00元\n商品规格：商务轻薄本，14英寸，酷睿i7处理器\n库存：60', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 5, '2026-03-07 14:17:09', '2026-03-07 14:17:09');
INSERT INTO `ai_knowledge` VALUES (16, '【商品】AirPods Pro 2', 'AirPods Pro 2\n分类：配件\n价格：1799.00元\n商品规格：苹果无线降噪耳机，USB-C充电\n库存：200', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 6, '2026-03-07 14:17:10', '2026-03-07 14:17:10');
INSERT INTO `ai_knowledge` VALUES (17, '【商品】华为 FreeBuds Pro 3', '华为 FreeBuds Pro 3\n分类：配件\n价格：1199.00元\n商品规格：华为旗舰降噪耳机，超感知原声双单元\n库存：150', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 7, '2026-03-07 14:17:10', '2026-03-07 14:17:10');
INSERT INTO `ai_knowledge` VALUES (18, '【商品】Apple Watch Series 9', 'Apple Watch Series 9\n分类：配件\n价格：2999.00元\n商品规格：苹果智能手表，S9芯片，双指互点手势\n库存：80', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 8, '2026-03-07 14:17:10', '2026-03-07 14:17:10');
INSERT INTO `ai_knowledge` VALUES (19, '【商品】iPad Air M2', 'iPad Air M2\n分类：平板\n价格：4799.00元\n商品规格：苹果平板电脑，M2芯片，10.9英寸\n库存：70', 'PRODUCT_INFO', 1, 'PRODUCT_AUTO', 9, '2026-03-07 14:17:10', '2026-03-07 14:17:10');

-- ----------------------------
-- Table structure for ai_knowledge_doc
-- ----------------------------
DROP TABLE IF EXISTS `ai_knowledge_doc`;
CREATE TABLE `ai_knowledge_doc`  (
  `doc_id` bigint NOT NULL AUTO_INCREMENT,
  `file_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件存储路径',
  `file_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件类型：txt/md/pdf',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `chunk_count` int NULL DEFAULT 0 COMMENT '分片数量',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING/PROCESSING/COMPLETED/FAILED',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`doc_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '知识库文档表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_knowledge_doc
-- ----------------------------

-- ----------------------------
-- Table structure for ai_tool_call_log
-- ----------------------------
DROP TABLE IF EXISTS `ai_tool_call_log`;
CREATE TABLE `ai_tool_call_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `session_id` bigint NULL DEFAULT NULL COMMENT '会话ID',
  `tool_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工具名称',
  `tool_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '调用参数（JSON）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '调用时间',
  `success_flag` tinyint NULL DEFAULT 1 COMMENT '1成功 0失败',
  `duration_ms` bigint NULL DEFAULT NULL COMMENT '执行耗时(毫秒)',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误信息',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_tool_name`(`tool_name` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI工具调用日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_tool_call_log
-- ----------------------------
INSERT INTO `ai_tool_call_log` VALUES (1, 12, 'searchProducts', 'keyword=, category=null, minPrice=null, maxPrice=null', '2026-03-03 22:22:32', 1, NULL, NULL);
INSERT INTO `ai_tool_call_log` VALUES (2, 12, 'queryUserOrders', '100', '2026-03-03 22:27:32', 1, NULL, NULL);
INSERT INTO `ai_tool_call_log` VALUES (3, 12, 'recommendProducts', 'scene=手机, budget=null', '2026-03-04 11:26:59', 1, NULL, NULL);
INSERT INTO `ai_tool_call_log` VALUES (4, 14, 'queryUserOrders', '100', '2026-03-04 13:30:43', 1, 81, NULL);
INSERT INTO `ai_tool_call_log` VALUES (5, 15, 'recommendProducts', 'scene=null, budget=null', '2026-03-04 14:24:57', 1, 16, NULL);
INSERT INTO `ai_tool_call_log` VALUES (6, 16, 'escalateToHuman', 'reason=用户主动要求转接人工客服', '2026-03-05 10:15:27', 1, 45, NULL);
INSERT INTO `ai_tool_call_log` VALUES (7, 17, 'recommendProducts', 'scene=null, budget=null', '2026-03-05 21:23:12', 1, 22, NULL);
INSERT INTO `ai_tool_call_log` VALUES (8, 18, 'recommendProducts', 'scene=手机, budget=null', '2026-03-06 10:35:16', 1, 28, NULL);
INSERT INTO `ai_tool_call_log` VALUES (9, 18, 'recommendProducts', 'scene=手机, budget=null', '2026-03-06 11:08:50', 1, 7, NULL);
INSERT INTO `ai_tool_call_log` VALUES (10, 18, 'searchProducts', 'keyword=手机, category=null, minPrice=null, maxPrice=null', '2026-03-06 11:45:11', 1, 8, NULL);
INSERT INTO `ai_tool_call_log` VALUES (11, 18, 'recommendProducts', 'scene=手机, budget=null', '2026-03-06 12:09:04', 1, 14, NULL);
INSERT INTO `ai_tool_call_log` VALUES (12, 18, 'searchProducts', 'keyword=手机, category=null, minPrice=null, maxPrice=null', '2026-03-06 12:10:44', 1, 9, NULL);
INSERT INTO `ai_tool_call_log` VALUES (13, 19, 'recommendProducts', 'scene=null, budget=null', '2026-03-06 13:13:10', 1, 13, NULL);
INSERT INTO `ai_tool_call_log` VALUES (14, 20, 'recommendProducts', 'scene=null, budget=null', '2026-03-06 13:23:47', 1, 6, NULL);
INSERT INTO `ai_tool_call_log` VALUES (15, 21, 'recommendProducts', 'scene=null, budget=null', '2026-03-06 13:57:30', 1, 8, NULL);
INSERT INTO `ai_tool_call_log` VALUES (16, 23, 'recommendProducts', 'scene=null, budget=null', '2026-03-06 20:07:09', 1, 15, NULL);
INSERT INTO `ai_tool_call_log` VALUES (17, 23, 'recommendProducts', 'scene=手机, budget=null', '2026-03-06 20:07:53', 1, 11, NULL);
INSERT INTO `ai_tool_call_log` VALUES (18, 23, 'queryUserOrders', '100', '2026-03-07 14:51:22', 1, 12, NULL);
INSERT INTO `ai_tool_call_log` VALUES (19, 23, 'queryOrder', 'ORD2030166584999833600', '2026-03-07 14:52:30', 1, 6, NULL);
INSERT INTO `ai_tool_call_log` VALUES (20, 23, 'queryOrder', 'ORD2029731846887632896', '2026-03-07 14:52:30', 1, 3, NULL);
INSERT INTO `ai_tool_call_log` VALUES (21, 23, 'queryOrder', 'ORD2027960831975133184', '2026-03-07 14:52:30', 1, 1, NULL);
INSERT INTO `ai_tool_call_log` VALUES (22, 23, 'queryOrder', 'ORD2027692769887748096', '2026-03-07 14:52:30', 1, 5, NULL);
INSERT INTO `ai_tool_call_log` VALUES (23, 23, 'queryUserOrders', '100', '2026-03-07 14:54:43', 1, 7, NULL);
INSERT INTO `ai_tool_call_log` VALUES (24, 23, 'queryOrder', 'ORD2029731846887632896', '2026-03-07 14:54:52', 1, 4, NULL);
INSERT INTO `ai_tool_call_log` VALUES (25, 23, 'queryOrder', 'ORD2029731846887632896', '2026-03-07 15:01:16', 1, 5, NULL);
INSERT INTO `ai_tool_call_log` VALUES (26, 23, 'queryUserInfo', 'userId=100', '2026-03-08 21:58:50', 1, 13, NULL);
INSERT INTO `ai_tool_call_log` VALUES (27, 23, 'queryUserAddresses', 'userId=100', '2026-03-08 22:01:55', 1, 9, NULL);
INSERT INTO `ai_tool_call_log` VALUES (28, 23, 'queryUnreadNotifications', 'userId=100', '2026-03-08 22:02:38', 1, 10, NULL);
INSERT INTO `ai_tool_call_log` VALUES (29, 23, 'queryUserOrders', '100', '2026-03-08 22:14:58', 1, 15, NULL);
INSERT INTO `ai_tool_call_log` VALUES (30, 23, 'queryOrder', 'ORD2029731846887632896', '2026-03-08 22:15:03', 1, 11, NULL);
INSERT INTO `ai_tool_call_log` VALUES (31, 25, 'queryUserOrders', '100', '2026-03-08 23:43:43', 1, 79, NULL);
INSERT INTO `ai_tool_call_log` VALUES (32, 25, 'queryOrder', 'ORD2030645615457333248', '2026-03-08 23:43:48', 1, 12, NULL);
INSERT INTO `ai_tool_call_log` VALUES (33, 25, 'queryOrder', 'ORD2030166584999833600', '2026-03-08 23:43:48', 1, 6, NULL);
INSERT INTO `ai_tool_call_log` VALUES (34, 25, 'queryOrder', 'ORD2029731846887632896', '2026-03-08 23:43:48', 1, 4, NULL);
INSERT INTO `ai_tool_call_log` VALUES (35, 25, 'queryOrder', 'ORD2027960831975133184', '2026-03-08 23:43:48', 1, 7, NULL);
INSERT INTO `ai_tool_call_log` VALUES (36, 25, 'queryOrder', 'ORD2027692769887748096', '2026-03-08 23:43:48', 1, 6, NULL);
INSERT INTO `ai_tool_call_log` VALUES (37, 25, 'viewCart', 'userId=100', '2026-03-09 21:44:58', 1, 32, NULL);
INSERT INTO `ai_tool_call_log` VALUES (38, 25, 'viewCart', 'userId=100', '2026-03-09 21:45:47', 1, 6, NULL);
INSERT INTO `ai_tool_call_log` VALUES (39, 25, 'queryUserInfo', 'userId=100', '2026-03-09 21:46:12', 1, 8, NULL);
INSERT INTO `ai_tool_call_log` VALUES (40, 25, 'queryUserAddresses', 'userId=100', '2026-03-09 21:46:53', 1, 6, NULL);
INSERT INTO `ai_tool_call_log` VALUES (41, 26, 'viewCart', 'userId=100', '2026-03-09 22:20:39', 1, 27, NULL);
INSERT INTO `ai_tool_call_log` VALUES (42, 26, 'searchProducts', 'keyword=华为 Mate 60 Pro, category=null, minPrice=null, maxPrice=null', '2026-03-09 22:21:12', 1, 9, NULL);
INSERT INTO `ai_tool_call_log` VALUES (43, 26, 'addToCart', 'productId=2,quantity=1,userId=100', '2026-03-09 22:21:14', 1, 16, NULL);
INSERT INTO `ai_tool_call_log` VALUES (44, 26, 'viewCart', 'userId=100', '2026-03-09 22:23:23', 1, 36, NULL);
INSERT INTO `ai_tool_call_log` VALUES (45, 26, 'viewCart', 'userId=100', '2026-03-09 22:23:46', 1, 28, NULL);

-- ----------------------------
-- Table structure for biz_address
-- ----------------------------
DROP TABLE IF EXISTS `biz_address`;
CREATE TABLE `biz_address`  (
  `address_id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '区',
  `detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '详细地址',
  `is_default` tinyint NULL DEFAULT 0 COMMENT '是否默认(0否1是)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_address
-- ----------------------------
INSERT INTO `biz_address` VALUES (1, 100, 'sun', '11111111111', '', '', '', '贵州省贵阳市观山湖区猪笼城寨201号', 0, '2026-03-07 14:19:32', '2026-03-07 18:02:36');
INSERT INTO `biz_address` VALUES (2, 100, 'sun', '11111111111', '', '', '', '贵州省贵阳市观山湖区快乐街区201号', 0, '2026-03-07 14:19:52', '2026-03-07 18:13:35');
INSERT INTO `biz_address` VALUES (3, 100, '123', '123', '', '', '', '123', 0, '2026-03-07 18:04:45', '2026-03-07 18:32:52');
INSERT INTO `biz_address` VALUES (4, 100, '123', '15645697896', '天津市', '市辖区', '和平区', '12311', 1, '2026-03-07 18:04:59', '2026-03-08 18:38:17');
INSERT INTO `biz_address` VALUES (5, 100, '123', '123', '', '', '', '12311wwwwwwwwwwwwwwwwwwwwww', 0, '2026-03-07 18:05:06', '2026-03-07 18:05:06');
INSERT INTO `biz_address` VALUES (6, 100, '123', '123', '', '', '', '12311ww哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇哇wwwwwwwwwwwwwwwwwww', 0, '2026-03-07 18:05:19', '2026-03-07 18:13:37');

-- ----------------------------
-- Table structure for biz_cart_item
-- ----------------------------
DROP TABLE IF EXISTS `biz_cart_item`;
CREATE TABLE `biz_cart_item`  (
  `cart_item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `checked` tinyint NOT NULL DEFAULT 1 COMMENT '是否选中(0否1是)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`cart_item_id`) USING BTREE,
  UNIQUE INDEX `uk_user_product`(`user_id` ASC, `product_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购物车项表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_cart_item
-- ----------------------------
INSERT INTO `biz_cart_item` VALUES (1, 100, 11, 3, 1, '2026-03-09 22:20:13', '2026-03-09 22:20:13');
INSERT INTO `biz_cart_item` VALUES (2, 100, 1, 1, 1, '2026-03-09 22:20:18', '2026-03-09 22:20:18');
INSERT INTO `biz_cart_item` VALUES (3, 100, 2, 1, 1, '2026-03-09 22:21:14', '2026-03-09 22:21:14');

-- ----------------------------
-- Table structure for biz_notification
-- ----------------------------
DROP TABLE IF EXISTS `biz_notification`;
CREATE TABLE `biz_notification`  (
  `notification_id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '通知内容',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知类型: ORDER_STATUS/TICKET_REPLY/STOCK_WARNING',
  `ref_id` bigint NULL DEFAULT NULL COMMENT '关联业务ID',
  `is_read` tinyint(1) NULL DEFAULT 0 COMMENT '是否已读: 0未读/1已读',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`notification_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_user_read`(`user_id` ASC, `is_read` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of biz_notification
-- ----------------------------
INSERT INTO `biz_notification` VALUES (1, 100, '订单状态变更', '您的订单 ORD2027692769887748096 状态已更新为: 已付款', 'ORDER_STATUS', 7, 1, '2026-03-01 11:47:10');
INSERT INTO `biz_notification` VALUES (2, 100, '订单状态变更', '您的订单 ORD2027960831975133184 状态已更新为: 已付款', 'ORDER_STATUS', 8, 1, '2026-03-01 12:23:14');
INSERT INTO `biz_notification` VALUES (3, 100, '订单状态变更', '您的订单 ORD2029731846887632896 状态已更新为: 已付款', 'ORDER_STATUS', 9, 1, '2026-03-06 09:32:44');
INSERT INTO `biz_notification` VALUES (4, 100, '订单状态变更', '您的订单 ORD2030166584999833600 状态已更新为: 已付款', 'ORDER_STATUS', 10, 1, '2026-03-07 14:20:25');
INSERT INTO `biz_notification` VALUES (5, 100, '退款审核通过', '您的工单 TK2030166901682368512 退款申请已通过审核', 'TICKET_REFUND', 6, 1, '2026-03-07 14:22:08');
INSERT INTO `biz_notification` VALUES (6, 100, '工单回复', '您的工单 TK2030166901682368512 收到新的客服回复', 'TICKET_REPLY', 6, 1, '2026-03-07 14:22:18');
INSERT INTO `biz_notification` VALUES (7, 100, '订单状态变更', '您的订单 ORD2030166584999833600 状态已更新为: 已退款', 'ORDER_STATUS', 10, 1, '2026-03-07 14:23:13');
INSERT INTO `biz_notification` VALUES (8, 100, '退款已完成', '您的工单 TK2030166901682368512 退款已完成', 'TICKET_REFUND', 6, 1, '2026-03-07 14:23:13');
INSERT INTO `biz_notification` VALUES (9, 100, '订单状态变更', '您的订单 ORD2029731846887632896 状态已更新为: 已发货', 'ORDER_STATUS', 9, 1, '2026-03-07 14:39:28');
INSERT INTO `biz_notification` VALUES (10, 100, '订单状态变更', '您的订单 ORD2029731846887632896 状态已更新为: 已签收', 'ORDER_STATUS', 9, 1, '2026-03-07 14:47:36');

-- ----------------------------
-- Table structure for biz_order
-- ----------------------------
DROP TABLE IF EXISTS `biz_order`;
CREATE TABLE `biz_order`  (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NOT NULL COMMENT '用户ID（关联sys_user.user_id）',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '订单总金额',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PENDING' COMMENT '订单状态：PENDING/PAID/SHIPPED/DELIVERED/CANCELLED/REFUNDED',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '付款时间',
  `ship_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货地址',
  `logistics_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  `logistics_company` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of biz_order
-- ----------------------------
INSERT INTO `biz_order` VALUES (1, 'ORD20250001', 2, 9999.00, 'DELIVERED', NULL, NULL, '北京市朝阳区建国路88号', 'SF1234567890', '顺丰速运', '请小心轻放', '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_order` VALUES (2, 'ORD20250002', 2, 1799.00, 'SHIPPED', NULL, NULL, '北京市朝阳区建国路88号', 'YT9876543210', '圆通快递', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_order` VALUES (3, 'ORD20250003', 2, 12999.00, 'PAID', NULL, NULL, '北京市朝阳区建国路88号', NULL, NULL, '需要发票', '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_order` VALUES (4, 'ORD20250004', 1, 6999.00, 'PENDING', NULL, NULL, '上海市浦东新区陆家嘴金融中心', NULL, NULL, NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_order` VALUES (5, 'ORD20250005', 1, 5699.00, 'SHIPPED', NULL, NULL, '上海市浦东新区陆家嘴金融中心', 'ZT1122334455', '中通快递', NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_order` VALUES (6, 'ORD20250006', 2, 5999.00, 'CANCELLED', NULL, NULL, '北京市朝阳区建国路88号', NULL, NULL, '不想要了', '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_order` VALUES (7, 'ORD2027692769887748096', 100, 9999.00, 'PAID', '2026-03-01 11:47:11', NULL, '1', NULL, NULL, '1', '2026-02-28 18:30:03', '2026-02-28 18:30:03');
INSERT INTO `biz_order` VALUES (8, 'ORD2027960831975133184', 100, 38970.00, 'PAID', '2026-03-01 12:23:14', NULL, '222', NULL, NULL, '2', '2026-03-01 12:15:14', '2026-03-01 12:15:14');
INSERT INTO `biz_order` VALUES (9, 'ORD2029731846887632896', 100, 24688.00, 'DELIVERED', '2026-03-06 09:32:44', '2026-03-07 14:39:29', '1', 'ZTO246544201', '中通快递', '1', '2026-03-06 09:32:37', '2026-03-06 09:32:37');
INSERT INTO `biz_order` VALUES (10, 'ORD2030166584999833600', 100, 71971.90, 'REFUNDED', '2026-03-07 14:20:26', NULL, 'sun 11111111111 贵州省贵阳市观山湖区快乐街区201号', NULL, NULL, '快点发货噢', '2026-03-07 14:20:07', '2026-03-07 14:20:07');
INSERT INTO `biz_order` VALUES (11, 'ORD2030645615457333248', 100, 12990.00, 'PENDING', NULL, NULL, '123 15645697896 天津市 市辖区 和平区 12311', NULL, NULL, '', '2026-03-08 22:03:36', '2026-03-08 22:03:36');

-- ----------------------------
-- Table structure for biz_order_item
-- ----------------------------
DROP TABLE IF EXISTS `biz_order_item`;
CREATE TABLE `biz_order_item`  (
  `item_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称（冗余）',
  `price` decimal(10, 2) NOT NULL COMMENT '下单时价格',
  `quantity` int NOT NULL COMMENT '数量',
  PRIMARY KEY (`item_id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of biz_order_item
-- ----------------------------
INSERT INTO `biz_order_item` VALUES (1, 1, 1, 'iPhone 15 Pro Max 256GB', 9999.00, 1);
INSERT INTO `biz_order_item` VALUES (2, 2, 6, 'AirPods Pro 2', 1799.00, 1);
INSERT INTO `biz_order_item` VALUES (3, 3, 4, 'MacBook Pro 14英寸 M3', 12999.00, 1);
INSERT INTO `biz_order_item` VALUES (4, 4, 2, '华为 Mate 60 Pro', 6999.00, 1);
INSERT INTO `biz_order_item` VALUES (5, 5, 10, '华为 MatePad Pro 13.2', 5699.00, 1);
INSERT INTO `biz_order_item` VALUES (6, 6, 3, '小米14 Ultra', 5999.00, 1);
INSERT INTO `biz_order_item` VALUES (7, 7, 1, 'iPhone 15 Pro Max 256GB', 9999.00, 1);
INSERT INTO `biz_order_item` VALUES (8, 8, 1, 'iPhone 15 Pro Max 256GB', 12990.00, 3);
INSERT INTO `biz_order_item` VALUES (9, 9, 1, 'iPhone 15 Pro Max 256GB', 12990.00, 1);
INSERT INTO `biz_order_item` VALUES (10, 9, 10, '华为 MatePad Pro 13.2', 5699.00, 1);
INSERT INTO `biz_order_item` VALUES (11, 9, 3, '小米14 Ultra', 5999.00, 1);
INSERT INTO `biz_order_item` VALUES (12, 10, 11, 'ChatGPT plus会员一个月', 19.99, 10);
INSERT INTO `biz_order_item` VALUES (13, 10, 1, 'iPhone 15 Pro Max 256GB', 12990.00, 2);
INSERT INTO `biz_order_item` VALUES (14, 10, 2, '华为 Mate 60 Pro', 6999.00, 1);
INSERT INTO `biz_order_item` VALUES (15, 10, 3, '小米14 Ultra', 5999.00, 2);
INSERT INTO `biz_order_item` VALUES (16, 10, 6, 'AirPods Pro 2', 1799.00, 2);
INSERT INTO `biz_order_item` VALUES (17, 10, 4, 'MacBook Pro 14英寸 M3', 12999.00, 1);
INSERT INTO `biz_order_item` VALUES (18, 10, 5, '联想 ThinkPad X1 Carbon', 8999.00, 1);
INSERT INTO `biz_order_item` VALUES (19, 10, 7, '华为 FreeBuds Pro 3', 1199.00, 1);
INSERT INTO `biz_order_item` VALUES (20, 11, 1, 'iPhone 15 Pro Max 256GB', 12990.00, 1);

-- ----------------------------
-- Table structure for biz_product
-- ----------------------------
DROP TABLE IF EXISTS `biz_product`;
CREATE TABLE `biz_product`  (
  `product_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品描述',
  `highlights` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核心卖点',
  `refund_policy` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '退换货政策',
  `warranty_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '保修信息',
  `after_sale_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '售后注意事项',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0下架 1上架',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of biz_product
-- ----------------------------
INSERT INTO `biz_product` VALUES (1, 'iPhone 15 Pro Max 256GB', '手机', 12990.00, 94, '苹果最新旗舰手机，A17 Pro芯片，钛金属设计', '这里是核心买点', NULL, NULL, NULL, '/profile/upload/2026/03/01/f3ba407116845c66e0e4c4a11dea12b0_20260301101744A001.png', 1, '2026-02-27 20:16:28', '2026-03-08 22:03:36');
INSERT INTO `biz_product` VALUES (2, '华为 Mate 60 Pro', '手机', 6999.00, 80, '华为旗舰手机，麒麟9000S芯片，卫星通话', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-03-07 14:23:13');
INSERT INTO `biz_product` VALUES (3, '小米14 Ultra', '手机', 5999.00, 119, '小米影像旗舰，徕卡光学镜头，骁龙8 Gen3', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-03-07 14:23:13');
INSERT INTO `biz_product` VALUES (4, 'MacBook Pro 14英寸 M3', '电脑', 12999.00, 50, '苹果笔记本电脑，M3芯片，Liquid Retina XDR显示屏', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-03-07 14:23:13');
INSERT INTO `biz_product` VALUES (5, '联想 ThinkPad X1 Carbon', '电脑', 8999.00, 60, '商务轻薄本，14英寸，酷睿i7处理器', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-03-07 14:23:13');
INSERT INTO `biz_product` VALUES (6, 'AirPods Pro 2', '配件', 1799.00, 200, '苹果无线降噪耳机，USB-C充电', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-03-07 14:23:13');
INSERT INTO `biz_product` VALUES (7, '华为 FreeBuds Pro 3', '配件', 1199.00, 150, '华为旗舰降噪耳机，超感知原声双单元', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-03-07 14:23:13');
INSERT INTO `biz_product` VALUES (8, 'Apple Watch Series 9', '配件', 2999.00, 80, '苹果智能手表，S9芯片，双指互点手势', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_product` VALUES (9, 'iPad Air M2', '平板', 4799.00, 70, '苹果平板电脑，M2芯片，10.9英寸', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_product` VALUES (10, '华为 MatePad Pro 13.2', '平板', 5699.00, 8, '华为旗舰平板，星闪连接，OLED柔性屏', '', '', '', '', '', 1, '2026-02-27 20:16:28', '2026-03-07 12:22:00');
INSERT INTO `biz_product` VALUES (11, 'ChatGPT plus会员一个月', 'ai服务', 19.99, 10, '一次性服务', 'Chat GPT 官方订阅plus一个月会员，直充到号，稳定快速', '激活后不可退', '正常使用，质保一月', '请勿随意切换地区节点访问，触发风控封号不予退款售后', '/profile/upload/2026/03/07/images_20260307122411A001.jpg', 1, '2026-03-07 12:27:04', '2026-03-07 14:23:13');

-- ----------------------------
-- Table structure for biz_review
-- ----------------------------
DROP TABLE IF EXISTS `biz_review`;
CREATE TABLE `biz_review`  (
  `review_id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_item_id` bigint NOT NULL COMMENT '订单项ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `rating` tinyint NOT NULL COMMENT '评分(1-5)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评价内容',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(0隐藏1显示)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_reply` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家回复内容',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '回复时间',
  PRIMARY KEY (`review_id`) USING BTREE,
  UNIQUE INDEX `uk_order_item`(`order_item_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_review
-- ----------------------------
INSERT INTO `biz_review` VALUES (1, 9, 9, 1, 100, 5, '苹果手机就是好用啊 五星', 1, '2026-03-07 14:48:48', NULL, NULL);
INSERT INTO `biz_review` VALUES (2, 9, 10, 10, 100, 3, '遥遥领先的平板还是一般般，溢价太高了', 1, '2026-03-07 14:49:17', NULL, NULL);
INSERT INTO `biz_review` VALUES (3, 9, 11, 3, 100, 5, '科技改变生活，相信一切美好的事情即将发生', 1, '2026-03-07 14:49:48', NULL, NULL);

-- ----------------------------
-- Table structure for biz_ticket
-- ----------------------------
DROP TABLE IF EXISTS `biz_ticket`;
CREATE TABLE `biz_ticket`  (
  `ticket_id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单编号',
  `user_id` bigint NOT NULL COMMENT '提交用户ID（关联sys_user.user_id）',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联订单ID（可为空）',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型：COMPLAINT/REFUND/EXCHANGE/CONSULT',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '问题描述',
  `refund_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `refund_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款原因',
  `refund_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款进度(PENDING_REVIEW/APPROVED/REFUNDED/REJECTED)',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OPEN' COMMENT '状态：OPEN/PROCESSING/RESOLVED/CLOSED',
  `priority` int NULL DEFAULT 0 COMMENT '优先级: 0普通/1紧急/2特急',
  `assignee_id` bigint NULL DEFAULT NULL COMMENT '指派客服ID',
  `reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '管理员回复',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ticket_id`) USING BTREE,
  UNIQUE INDEX `ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of biz_ticket
-- ----------------------------
INSERT INTO `biz_ticket` VALUES (1, 'TK20250001', 2, 1, 'COMPLAINT', '手机屏幕有划痕', '收到的iPhone 15 Pro Max屏幕上有一道明显的划痕，要求更换', NULL, NULL, NULL, 'RESOLVED', 0, NULL, '非常抱歉给您带来不便，我们已安排换货，新机将于3个工作日内发出。', '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_ticket` VALUES (2, 'TK20250002', 1, 4, 'REFUND', '申请退款', '订单还未发货，我不想要了，请退款', NULL, NULL, NULL, 'OPEN', 0, NULL, NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_ticket` VALUES (3, 'TK20250003', 2, NULL, 'CONSULT', '产品保修咨询', '请问iPhone的保修期是多久？海外购买的可以在国内保修吗？', NULL, NULL, NULL, 'PROCESSING', 0, NULL, NULL, '2026-02-27 20:16:28', '2026-02-27 20:16:28');
INSERT INTO `biz_ticket` VALUES (4, 'TK2027963370745470976', 100, 7, 'COMPLAINT', '退货', '不满意', NULL, NULL, NULL, 'RESOLVED', 0, NULL, '好的老弟 同意退货', '2026-03-01 12:25:19', '2026-03-01 12:25:19');
INSERT INTO `biz_ticket` VALUES (5, 'TK2029380236642742272', 100, NULL, 'CONSULT', '【转人工】用户主动要求转接人工客服', '用户在AI对话中请求转人工服务。原因：用户主动要求转接人工客服', NULL, NULL, NULL, 'OPEN', 1, NULL, NULL, '2026-03-05 10:15:27', '2026-03-05 10:15:27');
INSERT INTO `biz_ticket` VALUES (6, 'TK2030166901682368512', 100, 10, 'REFUND', '不满意退款', '不喜欢', 71971.90, '不想要了/多拍了', 'REFUNDED', 'RESOLVED', 0, NULL, NULL, '2026-03-07 14:21:22', '2026-03-07 14:21:22');

-- ----------------------------
-- Table structure for biz_ticket_reply
-- ----------------------------
DROP TABLE IF EXISTS `biz_ticket_reply`;
CREATE TABLE `biz_ticket_reply`  (
  `reply_id` bigint NOT NULL AUTO_INCREMENT COMMENT '回复ID',
  `ticket_id` bigint NOT NULL COMMENT '工单ID',
  `user_id` bigint NOT NULL COMMENT '回复用户ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '回复内容',
  `reply_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'USER' COMMENT '回复类型: USER(用户)/STAFF(客服)/SYSTEM(系统)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`reply_id`) USING BTREE,
  INDEX `idx_ticket_id`(`ticket_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工单回复表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of biz_ticket_reply
-- ----------------------------
INSERT INTO `biz_ticket_reply` VALUES (1, 4, 0, '好的老弟 同意退货', 'STAFF', '2026-03-01 19:07:52');
INSERT INTO `biz_ticket_reply` VALUES (2, 6, 100, '我要退款', 'USER', '2026-03-07 14:21:52');
INSERT INTO `biz_ticket_reply` VALUES (3, 6, 0, '您的退款申请已审核通过，等待退款处理。', 'STAFF', '2026-03-07 14:22:08');
INSERT INTO `biz_ticket_reply` VALUES (4, 6, 1, '好的亲亲', 'STAFF', '2026-03-07 14:22:18');
INSERT INTO `biz_ticket_reply` VALUES (5, 6, 100, '欧克 麻烦了', 'USER', '2026-03-07 14:22:43');
INSERT INTO `biz_ticket_reply` VALUES (6, 6, 0, '退款已完成，退款金额：¥71971.90，请注意查收。', 'STAFF', '2026-03-07 14:23:13');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-02-27 20:15:48', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-02-27 20:15:48', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-02-28 10:04:09');
INSERT INTO `sys_logininfor` VALUES (101, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-02-28 12:36:17');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-02-28 15:36:04');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-02-28 15:36:12');
INSERT INTO `sys_logininfor` VALUES (104, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-02-28 15:36:34');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-02-28 18:34:23');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-02-28 21:00:33');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-01 10:15:31');
INSERT INTO `sys_logininfor` VALUES (108, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码错误', '2026-03-01 11:27:03');
INSERT INTO `sys_logininfor` VALUES (109, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-01 11:27:07');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-01 18:59:57');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-01 19:00:10');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '用户不存在/密码错误', '2026-03-01 19:00:31');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-01 19:00:54');
INSERT INTO `sys_logininfor` VALUES (114, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-01 19:08:33');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-02 22:51:57');
INSERT INTO `sys_logininfor` VALUES (116, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-02 22:52:47');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-03 10:14:07');
INSERT INTO `sys_logininfor` VALUES (118, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-03 10:15:04');
INSERT INTO `sys_logininfor` VALUES (119, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-03 19:11:50');
INSERT INTO `sys_logininfor` VALUES (120, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-03 22:59:37');
INSERT INTO `sys_logininfor` VALUES (121, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-03 22:59:43');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-04 09:57:41');
INSERT INTO `sys_logininfor` VALUES (123, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-04 10:00:13');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-04 11:26:16');
INSERT INTO `sys_logininfor` VALUES (125, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-04 11:26:38');
INSERT INTO `sys_logininfor` VALUES (126, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-04 13:26:43');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-04 14:23:49');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-04 14:24:26');
INSERT INTO `sys_logininfor` VALUES (129, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-04 14:24:33');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-04 16:16:55');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-04 16:17:03');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码已失效', '2026-03-04 19:47:47');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-04 19:47:53');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-04 20:15:51');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '1', '验证码已失效', '2026-03-05 10:13:33');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-05 10:13:35');
INSERT INTO `sys_logininfor` VALUES (137, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 10:14:57');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码错误', '2026-03-05 10:49:12');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 10:49:19');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-05 10:49:26');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码错误', '2026-03-05 10:50:14');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 10:50:20');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-05 10:53:30');
INSERT INTO `sys_logininfor` VALUES (144, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 10:53:45');
INSERT INTO `sys_logininfor` VALUES (145, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码已失效', '2026-03-05 14:05:08');
INSERT INTO `sys_logininfor` VALUES (146, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 14:05:15');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-05 15:09:35');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 15:27:34');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-05 15:27:43');
INSERT INTO `sys_logininfor` VALUES (150, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 15:27:52');
INSERT INTO `sys_logininfor` VALUES (151, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-05 15:33:00');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 15:33:08');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-05 15:33:16');
INSERT INTO `sys_logininfor` VALUES (154, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 15:33:28');
INSERT INTO `sys_logininfor` VALUES (155, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-05 15:34:41');
INSERT INTO `sys_logininfor` VALUES (156, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码已失效', '2026-03-05 17:21:17');
INSERT INTO `sys_logininfor` VALUES (157, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 17:21:23');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 19:44:32');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-05 19:44:40');
INSERT INTO `sys_logininfor` VALUES (160, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-05 19:44:48');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-06 08:23:23');
INSERT INTO `sys_logininfor` VALUES (162, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-06 08:28:15');
INSERT INTO `sys_logininfor` VALUES (163, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码已失效', '2026-03-06 09:31:57');
INSERT INTO `sys_logininfor` VALUES (164, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-06 09:32:03');
INSERT INTO `sys_logininfor` VALUES (165, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码已失效', '2026-03-06 09:32:03');
INSERT INTO `sys_logininfor` VALUES (166, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-06 11:44:19');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-06 11:47:02');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '1', '验证码已失效', '2026-03-06 15:03:06');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-06 15:03:13');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '1', '验证码已失效', '2026-03-06 18:26:11');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-06 18:26:14');
INSERT INTO `sys_logininfor` VALUES (172, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-06 18:26:45');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-06 19:44:36');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '1', '验证码错误', '2026-03-07 12:21:24');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-07 12:21:27');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 12:41:23');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 12:41:33');
INSERT INTO `sys_logininfor` VALUES (178, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 12:41:40');
INSERT INTO `sys_logininfor` VALUES (179, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 13:13:54');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码已失效', '2026-03-07 13:20:21');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 13:20:26');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 13:20:37');
INSERT INTO `sys_logininfor` VALUES (183, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 13:20:43');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-07 13:52:21');
INSERT INTO `sys_logininfor` VALUES (185, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 15:08:32');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 15:22:54');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 15:23:02');
INSERT INTO `sys_logininfor` VALUES (188, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 15:23:10');
INSERT INTO `sys_logininfor` VALUES (189, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 15:46:15');
INSERT INTO `sys_logininfor` VALUES (190, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 15:52:03');
INSERT INTO `sys_logininfor` VALUES (191, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 16:48:05');
INSERT INTO `sys_logininfor` VALUES (192, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码已失效', '2026-03-07 17:01:14');
INSERT INTO `sys_logininfor` VALUES (193, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 17:01:19');
INSERT INTO `sys_logininfor` VALUES (194, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 17:05:42');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-07 18:02:08');
INSERT INTO `sys_logininfor` VALUES (196, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 18:02:18');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '退出成功', '2026-03-07 18:05:53');
INSERT INTO `sys_logininfor` VALUES (198, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 18:11:47');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-07 18:13:08');
INSERT INTO `sys_logininfor` VALUES (200, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 18:13:26');
INSERT INTO `sys_logininfor` VALUES (201, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 18:14:59');
INSERT INTO `sys_logininfor` VALUES (202, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '1', '验证码错误', '2026-03-07 18:21:03');
INSERT INTO `sys_logininfor` VALUES (203, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 18:21:11');
INSERT INTO `sys_logininfor` VALUES (204, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 18:34:51');
INSERT INTO `sys_logininfor` VALUES (205, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 18:38:04');
INSERT INTO `sys_logininfor` VALUES (206, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 20:28:40');
INSERT INTO `sys_logininfor` VALUES (207, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 20:30:17');
INSERT INTO `sys_logininfor` VALUES (208, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-07 20:30:53');
INSERT INTO `sys_logininfor` VALUES (209, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-07 20:32:27');
INSERT INTO `sys_logininfor` VALUES (210, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '注册成功', '2026-03-08 11:38:40');
INSERT INTO `sys_logininfor` VALUES (211, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 11:38:53');
INSERT INTO `sys_logininfor` VALUES (212, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-08 11:59:21');
INSERT INTO `sys_logininfor` VALUES (213, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 12:05:03');
INSERT INTO `sys_logininfor` VALUES (214, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-08 12:11:20');
INSERT INTO `sys_logininfor` VALUES (215, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 12:14:50');
INSERT INTO `sys_logininfor` VALUES (216, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-08 12:20:01');
INSERT INTO `sys_logininfor` VALUES (217, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 12:33:04');
INSERT INTO `sys_logininfor` VALUES (218, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-08 12:38:06');
INSERT INTO `sys_logininfor` VALUES (219, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 12:41:17');
INSERT INTO `sys_logininfor` VALUES (220, 'test2', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-08 12:44:23');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 15:14:57');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-08 15:15:04');
INSERT INTO `sys_logininfor` VALUES (223, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 15:31:42');
INSERT INTO `sys_logininfor` VALUES (224, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '退出成功', '2026-03-08 16:57:50');
INSERT INTO `sys_logininfor` VALUES (225, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 16:58:16');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-08 17:24:35');
INSERT INTO `sys_logininfor` VALUES (227, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-08 21:16:35');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-09 20:53:24');
INSERT INTO `sys_logininfor` VALUES (229, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-09 20:55:15');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-09 21:48:17');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-10 12:50:52');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-10 13:52:22');
INSERT INTO `sys_logininfor` VALUES (233, 'test1', '127.0.0.1', '内网IP', 'Chrome 147', 'Windows10', '0', '登录成功', '2026-03-10 13:53:29');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2049 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 10, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-02-27 20:15:48', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-02-27 20:15:48', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-02-27 20:15:48', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-02-27 20:15:48', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-02-27 20:15:48', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-02-27 20:15:48', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-02-27 20:15:48', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-02-27 20:15:48', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2001, 'AI 对话', 0, 2, 'ai-chat', 'ai/chat/index', NULL, '', 1, 0, 'C', '0', '0', 'ai:chat:list', 'message', 'admin', '2026-02-27 20:16:28', '', NULL, 'AI对话菜单');
INSERT INTO `sys_menu` VALUES (2002, '知识库管理', 0, 3, 'ai-knowledge', 'ai/knowledge/index', NULL, '', 1, 0, 'C', '0', '0', 'ai:knowledge:list', 'documentation', 'admin', '2026-02-27 20:16:28', '', NULL, '知识库管理菜单');
INSERT INTO `sys_menu` VALUES (2003, '知识新增', 2002, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'ai:knowledge:add', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '知识编辑', 2002, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'ai:knowledge:edit', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '知识删除', 2002, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'ai:knowledge:remove', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '文档上传', 2002, 4, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'ai:knowledge:upload', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '商品管理', 0, 4, 'biz-product', 'business/product/index', NULL, '', 1, 0, 'C', '0', '0', 'business:product:list', 'shopping', 'admin', '2026-02-27 20:16:28', '', NULL, '商品管理菜单');
INSERT INTO `sys_menu` VALUES (2010, '商品新增', 2009, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:add', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '商品编辑', 2009, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:edit', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '商品删除', 2009, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:remove', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2013, '订单管理', 0, 5, 'biz-order', 'business/order/index', NULL, '', 1, 0, 'C', '0', '0', 'business:order:list', 'list', 'admin', '2026-02-27 20:16:28', '', NULL, '订单管理菜单');
INSERT INTO `sys_menu` VALUES (2014, '订单编辑', 2013, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:edit', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '订单状态修改', 2013, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:status', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '工单管理', 0, 6, 'biz-ticket', 'business/ticket/index', NULL, '', 1, 0, 'C', '0', '0', 'business:ticket:list', 'form', 'admin', '2026-02-27 20:16:28', '', NULL, '工单管理菜单');
INSERT INTO `sys_menu` VALUES (2017, '工单回复', 2016, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:reply', '#', 'admin', '2026-02-27 20:16:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '工单删除', 2016, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:remove', '#', 'admin', '2026-02-27 20:18:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2019, '订单新增', 2013, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:add', '#', 'admin', '2026-02-28 10:03:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '商品中心', 0, 7, 'shop-product', 'shop/product/index', NULL, '', 1, 0, 'C', '0', '0', 'shop:product:list', 'shopping', 'admin', '2026-02-28 12:49:57', '', NULL, '用户端商品浏览');
INSERT INTO `sys_menu` VALUES (2032, '我的订单', 0, 8, 'my-order', 'business/order/my', NULL, '', 1, 0, 'C', '0', '0', 'business:order:my', 'list', 'admin', '2026-02-28 12:49:57', '', NULL, '用户端订单列表');
INSERT INTO `sys_menu` VALUES (2033, '我的工单', 0, 9, 'my-ticket', 'business/ticket/my', NULL, '', 1, 0, 'C', '0', '0', 'business:ticket:my', 'form', 'admin', '2026-02-28 12:49:57', '', NULL, '用户端工单列表');
INSERT INTO `sys_menu` VALUES (2034, '工单创建', 2033, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:add', '#', 'admin', '2026-02-28 12:49:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '工单回复', 2033, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:reply', '#', 'admin', '2026-02-28 12:49:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '用户下单', 2032, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:add', '#', 'admin', '2026-02-28 18:28:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '我的通知', 0, 5, 'my-notification', 'business/notification/index', NULL, '', 1, 0, 'C', '0', '0', 'business:notification:list', 'message', 'admin', '2026-02-28 20:20:31', '', NULL, '用户端通知历史');
INSERT INTO `sys_menu` VALUES (2040, '用户端页面', 0, 8, 'user-pages', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', '2026-02-28 16:37:36', '', NULL, '管理员查看的用户端功能集合');
INSERT INTO `sys_menu` VALUES (2041, '商品中心', 2040, 2, 'shop-product', 'shop/product/index', NULL, 'UserShopProduct', 1, 0, 'C', '0', '0', 'shop:product:list', 'shopping', 'admin', '2026-02-28 16:37:36', '', NULL, '管理员视角-用户商品浏览');
INSERT INTO `sys_menu` VALUES (2042, '我的订单', 2040, 3, 'my-order', 'business/order/my', NULL, 'UserMyOrder', 1, 0, 'C', '0', '0', 'business:order:my', 'list', 'admin', '2026-02-28 16:37:36', '', NULL, '管理员视角-用户订单列表');
INSERT INTO `sys_menu` VALUES (2043, '我的工单', 2040, 4, 'my-ticket', 'business/ticket/my', NULL, 'UserMyTicket', 1, 0, 'C', '0', '0', 'business:ticket:my', 'form', 'admin', '2026-02-28 16:37:36', '', NULL, '管理员视角-用户工单列表');
INSERT INTO `sys_menu` VALUES (2044, 'AI 对话', 2040, 1, 'ai-chat', 'ai/chat/index', NULL, 'UserAiChat', 1, 0, 'C', '0', '0', 'ai:chat:list', 'message', 'admin', '2026-02-28 18:36:55', '', NULL, '管理员视角-用户AI对话');
INSERT INTO `sys_menu` VALUES (2045, '我的通知', 2040, 5, 'my-notification', 'business/notification/index', NULL, 'UserMyNotification', 1, 0, 'C', '0', '0', 'business:notification:list', 'message', 'admin', '2026-02-28 20:20:31', '', NULL, '管理员视角-用户通知历史');
INSERT INTO `sys_menu` VALUES (2046, '评价管理', 0, 7, 'biz-review', 'business/review/index', NULL, '', 1, 0, 'C', '0', '0', 'business:review:list', 'star', 'admin', '2026-03-09 21:42:41', '', NULL, '评价管理菜单');
INSERT INTO `sys_menu` VALUES (2047, '评价编辑', 2046, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:review:edit', '#', 'admin', '2026-03-09 21:42:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '评价删除', 2046, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:review:remove', '#', 'admin', '2026-03-09 21:42:41', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-02-27 20:15:48', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-02-27 20:15:48', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":100,\"nickName\":\"test1\",\"params\":{},\"postIds\":[],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userId\":100,\"userName\":\"test1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-28 12:36:03', 237);
INSERT INTO `sys_oper_log` VALUES (101, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'test1', '若依科技', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"新密码不能与旧密码相同\",\"code\":500}', 0, NULL, '2026-03-07 14:12:13', 223);
INSERT INTO `sys_oper_log` VALUES (102, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'test1', '若依科技', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-08 15:33:17', 222);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-02-27 20:15:48', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-02-27 20:15:48', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-02-27 20:15:48', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 1);
INSERT INTO `sys_role_menu` VALUES (1, 100);
INSERT INTO `sys_role_menu` VALUES (1, 101);
INSERT INTO `sys_role_menu` VALUES (1, 102);
INSERT INTO `sys_role_menu` VALUES (1, 105);
INSERT INTO `sys_role_menu` VALUES (1, 108);
INSERT INTO `sys_role_menu` VALUES (1, 500);
INSERT INTO `sys_role_menu` VALUES (1, 501);
INSERT INTO `sys_role_menu` VALUES (1, 1000);
INSERT INTO `sys_role_menu` VALUES (1, 1001);
INSERT INTO `sys_role_menu` VALUES (1, 1002);
INSERT INTO `sys_role_menu` VALUES (1, 1003);
INSERT INTO `sys_role_menu` VALUES (1, 1004);
INSERT INTO `sys_role_menu` VALUES (1, 1005);
INSERT INTO `sys_role_menu` VALUES (1, 1006);
INSERT INTO `sys_role_menu` VALUES (1, 1007);
INSERT INTO `sys_role_menu` VALUES (1, 1008);
INSERT INTO `sys_role_menu` VALUES (1, 1009);
INSERT INTO `sys_role_menu` VALUES (1, 1010);
INSERT INTO `sys_role_menu` VALUES (1, 1011);
INSERT INTO `sys_role_menu` VALUES (1, 1012);
INSERT INTO `sys_role_menu` VALUES (1, 1013);
INSERT INTO `sys_role_menu` VALUES (1, 1014);
INSERT INTO `sys_role_menu` VALUES (1, 1015);
INSERT INTO `sys_role_menu` VALUES (1, 1025);
INSERT INTO `sys_role_menu` VALUES (1, 1026);
INSERT INTO `sys_role_menu` VALUES (1, 1027);
INSERT INTO `sys_role_menu` VALUES (1, 1028);
INSERT INTO `sys_role_menu` VALUES (1, 1029);
INSERT INTO `sys_role_menu` VALUES (1, 1039);
INSERT INTO `sys_role_menu` VALUES (1, 1040);
INSERT INTO `sys_role_menu` VALUES (1, 1041);
INSERT INTO `sys_role_menu` VALUES (1, 1042);
INSERT INTO `sys_role_menu` VALUES (1, 1043);
INSERT INTO `sys_role_menu` VALUES (1, 1044);
INSERT INTO `sys_role_menu` VALUES (1, 1045);
INSERT INTO `sys_role_menu` VALUES (1, 2002);
INSERT INTO `sys_role_menu` VALUES (1, 2003);
INSERT INTO `sys_role_menu` VALUES (1, 2004);
INSERT INTO `sys_role_menu` VALUES (1, 2005);
INSERT INTO `sys_role_menu` VALUES (1, 2006);
INSERT INTO `sys_role_menu` VALUES (1, 2009);
INSERT INTO `sys_role_menu` VALUES (1, 2010);
INSERT INTO `sys_role_menu` VALUES (1, 2011);
INSERT INTO `sys_role_menu` VALUES (1, 2012);
INSERT INTO `sys_role_menu` VALUES (1, 2013);
INSERT INTO `sys_role_menu` VALUES (1, 2014);
INSERT INTO `sys_role_menu` VALUES (1, 2015);
INSERT INTO `sys_role_menu` VALUES (1, 2016);
INSERT INTO `sys_role_menu` VALUES (1, 2017);
INSERT INTO `sys_role_menu` VALUES (1, 2018);
INSERT INTO `sys_role_menu` VALUES (1, 2019);
INSERT INTO `sys_role_menu` VALUES (1, 2036);
INSERT INTO `sys_role_menu` VALUES (1, 2046);
INSERT INTO `sys_role_menu` VALUES (1, 2047);
INSERT INTO `sys_role_menu` VALUES (1, 2048);
INSERT INTO `sys_role_menu` VALUES (2, 2001);
INSERT INTO `sys_role_menu` VALUES (2, 2015);
INSERT INTO `sys_role_menu` VALUES (2, 2031);
INSERT INTO `sys_role_menu` VALUES (2, 2032);
INSERT INTO `sys_role_menu` VALUES (2, 2033);
INSERT INTO `sys_role_menu` VALUES (2, 2034);
INSERT INTO `sys_role_menu` VALUES (2, 2035);
INSERT INTO `sys_role_menu` VALUES (2, 2036);
INSERT INTO `sys_role_menu` VALUES (2, 2037);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-03-10 13:52:23', '2026-02-27 20:15:48', 'admin', '2026-02-27 20:15:48', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-02-27 20:15:48', '2026-02-27 20:15:48', 'admin', '2026-02-27 20:15:48', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (100, 100, 'test1', 'test1', '00', '', '', '0', '', '$2a$10$IFytkBm1yYnzL258hXHshe3II7hEsbG6fJg0x5THWJj6hLBG/9xXa', '0', '0', '127.0.0.1', '2026-03-10 13:53:29', '2026-03-08 15:33:16', 'admin', '2026-02-28 12:36:03', '', '2026-03-08 15:33:16', NULL);
INSERT INTO `sys_user` VALUES (101, NULL, 'test2', 'test2', '00', '', '', '0', '', '$2a$10$mJmYssJc5FOjUIQ1ovZgM.H0ZgqlKiZ5loYQxy5OwOxzH/m5RuTPu', '0', '0', '127.0.0.1', '2026-03-08 12:41:17', '2026-03-08 11:38:38', '', '2026-03-08 11:38:38', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 2);
INSERT INTO `sys_user_role` VALUES (101, 2);

SET FOREIGN_KEY_CHECKS = 1;
