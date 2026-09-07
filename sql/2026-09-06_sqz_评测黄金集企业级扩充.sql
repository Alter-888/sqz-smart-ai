-- =============================================================================
-- 说明：P6 离线评测 —— 黄金集（企业级 v2，跨意图+多措辞）
-- 命名：2026-09-06_sqz_评测黄金集企业级扩充.sql
-- 依据：docx/改造多agent规划/设计/05-指标与评测设计.md §4 黄金集设计
-- 约定：
--   1) ground truth 用「条目级 entryKey」（knowledge_N，去 _c{n} 块后缀），
--      全部来自 PG vector_store 已向量化条目（28 条：商品23/FAQ3/政策2）。
--   2) expect_tools 只用只读工具白名单，绝不含写操作工具（GoldenRules 已卡）。
--   3) ORDER/ACCOUNT/CHITCHAT/HUMAN_HANDOFF/CROSS_DOMAIN 为「意图仅用」用例：
--      不挂 ground truth（truth_chunk_ids 置空），只评意图路由准确率。
--   4) 幂等：先清空 dataset='v1'，再整体插入，可重复执行。
--   5) 注意：knowledge_33 在 PG 未向量化，本集合一律不用。
-- =============================================================================

DELETE FROM `ai_eval_golden` WHERE `dataset`='v1';

INSERT INTO `ai_eval_golden`
(`dataset`,`question`,`expect_intent`,`expect_tools`,`truth_chunk_ids`,`answer_points`,`category`) VALUES
('v1','华为 Mate 70 Pro 12+256GB 现在多少钱？','PRODUCT','["searchProducts"]','["knowledge_34"]','Mate70Pro 价格 6499','PRODUCT_INFO'),
('v1','华为 Mate 70 Pro 有哪些配置规格？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_34"]','Mate70Pro 配置 麒麟','PRODUCT_INFO'),
('v1','华为 Mate 70 Pro 有现货吗？','PRODUCT','["searchProducts"]','["knowledge_34"]','Mate70Pro 库存','PRODUCT_INFO'),
('v1','小米15 Pro 12+256GB 卖多少钱？','PRODUCT','["searchProducts"]','["knowledge_35"]','小米15Pro 价格 4599','PRODUCT_INFO'),
('v1','小米15 Pro 和 三星 S25 Ultra 哪个更值得买？','PRODUCT','["compareProducts"]','["knowledge_35","knowledge_36"]','小米15Pro 三星S25Ultra 对比','PRODUCT_INFO'),
('v1','三星 Galaxy S25 Ultra 12+256GB 报价多少？','PRODUCT','["searchProducts"]','["knowledge_36"]','S25Ultra 价格 8999','PRODUCT_INFO'),
('v1','OPPO Find X8 Pro 16+256GB 屏幕怎么样？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_37"]','FindX8 屏幕 卖点','PRODUCT_INFO'),
('v1','MacBook Air 13英寸 M4 16+256GB 现在多少钱？','PRODUCT','["searchProducts"]','["knowledge_38"]','MacBookAir M4 价格 7999','PRODUCT_INFO'),
('v1','华为 MateBook X Pro 酷睿Ultra 7 配置信息？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_39"]','MateBookXPro 配置','PRODUCT_INFO'),
('v1','Apple iPad Pro 11英寸 M4 256GB WiFi 版多少钱？','PRODUCT','["searchProducts"]','["knowledge_43"]','iPadPro M4 价格','PRODUCT_INFO'),
('v1','华为 MatePad Pro 13.5英寸 麒麟9000s 卖多少钱？','PRODUCT','["searchProducts"]','["knowledge_44"]','MatePadPro 价格','PRODUCT_INFO'),
('v1','Apple AirPods Pro 3 多少钱？','PRODUCT','["searchProducts"]','["knowledge_45"]','AirPodsPro3 价格 1899','PRODUCT_INFO'),
('v1','联想 ThinkPad X1 Carbon 2025 是什么配置？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_20"]','ThinkPadX1 配置 Ultra7','PRODUCT_INFO'),
('v1','索尼 WH-1000XM6 头戴式降噪耳机价格多少？','PRODUCT','["searchProducts"]','["knowledge_21"]','WH1000XM6 价格 3499','PRODUCT_INFO'),
('v1','华为 FreeBuds 6i 真无线耳机多少钱？','PRODUCT','["searchProducts"]','["knowledge_22"]','FreeBuds6i 价格 349','PRODUCT_INFO'),
('v1','vivo Pad5 Pro 13英寸 天玑9400 12+256GB 多少钱？','PRODUCT','["searchProducts"]','["knowledge_23"]','vivoPad5Pro 价格','PRODUCT_INFO'),
('v1','小米 Redmi Pad SE 11英寸 价格是多少？','PRODUCT','["searchProducts"]','["knowledge_24"]','RedmiPadSE 价格 899','PRODUCT_INFO'),
('v1','小米 Buds 5 Pro WiFi版 耳机价格？','PRODUCT','["searchProducts"]','["knowledge_25"]','Buds5Pro 价格 1099','PRODUCT_INFO'),
('v1','西圣 H1 Pro 头戴式蓝牙耳机多少钱？','PRODUCT','["searchProducts"]','["knowledge_26"]','西圣H1Pro 价格 229','PRODUCT_INFO'),
('v1','Apple Watch Series 10 46mm GPS 价格？','PRODUCT','["searchProducts"]','["knowledge_27"]','AppleWatchS10 价格','PRODUCT_INFO'),
('v1','华为 Watch GT5 Pro 46mm 智能手表怎么样？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_28"]','GT5Pro 卖点','PRODUCT_INFO'),
('v1','小米手环9 NFC版 多少钱？','PRODUCT','["searchProducts"]','["knowledge_29"]','手环9 NFC 价格 299','PRODUCT_INFO'),
('v1','Anker 安克 Prime 200W 氮化镓充电器价格多少？','PRODUCT','["searchProducts"]','["knowledge_30"]','Anker200W 价格 499','PRODUCT_INFO'),
('v1','倍思 65W 氮化镓快充充电器多少钱？','PRODUCT','["searchProducts"]','["knowledge_31"]','倍思65W 价格 79','PRODUCT_INFO'),
('v1','Apple Pencil Pro 触控笔价格？','PRODUCT','["searchProducts"]','["knowledge_32"]','PencilPro 价格 999','PRODUCT_INFO'),
('v1','ChatGPT plus 会员一个月多少钱？','PRODUCT','["searchProducts"]','["knowledge_11"]','ChatGPTplus 月费 19.99','PRODUCT_INFO'),
('v1','华为 Mate 70 Pro 电池容量多大？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_34"]','Mate70Pro 电池','PRODUCT_INFO'),
('v1','小米15 Pro 屏幕是几寸的？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_35"]','小米15Pro 屏幕','PRODUCT_INFO'),
('v1','三星 S25 Ultra 有什么卖点？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_36"]','S25Ultra 卖点 配置','PRODUCT_INFO'),
('v1','OPPO Find X8 Pro 有白色吗？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_37"]','FindX8 颜色','PRODUCT_INFO'),
('v1','想买个降噪耳机，帮我推荐一下','PRODUCT','["recommendProducts"]','["knowledge_21"]','推荐 降噪耳机','PRODUCT_INFO'),
('v1','我想买台轻薄笔记本，预算8000推荐一个','PRODUCT','["recommendProducts"]','["knowledge_38"]','推荐 轻薄本 MacBookAir','PRODUCT_INFO'),
('v1','给我推荐一款200W氮化镓充电器','PRODUCT','["recommendProducts"]','["knowledge_30"]','推荐 200W 充电器','PRODUCT_INFO'),
('v1','帮我推荐一款智能手表','PRODUCT','["recommendProducts"]','["knowledge_28"]','推荐 智能手表','PRODUCT_INFO'),
('v1','索尼和西圣的耳机哪个好？','PRODUCT','["compareProducts"]','["knowledge_21","knowledge_26"]','对比 索尼 西圣','PRODUCT_INFO'),
('v1','华为 Mate 70 Pro 用户评价怎么样？','PRODUCT','["getProductReviews"]','["knowledge_34"]','评价 华为Mate70Pro','PRODUCT_INFO'),
('v1','帮我推荐一款适合学生党的平板','PRODUCT','["recommendProducts"]','["knowledge_24"]','推荐 学生党 平板','PRODUCT_INFO'),
('v1','华为 FreeBuds 6i 和 小米 Buds 5 Pro 哪个好？','PRODUCT','["compareProducts"]','["knowledge_22","knowledge_25"]','对比 FreeBuds6i Buds5Pro','PRODUCT_INFO'),
('v1','小米手环9 NFC能刷公交卡吗？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_29"]','手环9 NFC 功能','PRODUCT_INFO'),
('v1','Apple Watch Series 10 支持血氧检测吗？','PRODUCT','["searchProducts","getProductDetail"]','["knowledge_27"]','WatchS10 功能 血氧','PRODUCT_INFO'),
('v1','你们商城支持哪些支付方式？','KNOWLEDGE','[]','["knowledge_4"]','支付方式 微信 支付宝','FAQ'),
('v1','支持花呗分期吗？','KNOWLEDGE','[]','["knowledge_4"]','花呗分期','FAQ'),
('v1','可以用信用卡付款吗？','KNOWLEDGE','[]','["knowledge_4"]','信用卡支付','FAQ'),
('v1','怎么查询我的订单？','KNOWLEDGE','[]','["knowledge_5"]','订单查询方法 订单编号','FAQ'),
('v1','订单编号在哪里看？','KNOWLEDGE','[]','["knowledge_5"]','订单编号 我的订单','FAQ'),
('v1','订单多久能发货？','KNOWLEDGE','[]','["knowledge_3"]','发货时间 24小时','POLICY'),
('v1','偏远地区发什么快递？','KNOWLEDGE','[]','["knowledge_3"]','快递 偏远 圆通 中通','POLICY'),
('v1','下单后几天能到？','KNOWLEDGE','[]','["knowledge_3"]','配送时效 次日达','POLICY'),
('v1','手机电池保修多久？','AFTERSALES','[]','["knowledge_2"]','电池保修 6个月','POLICY'),
('v1','电脑保修几年？','AFTERSALES','[]','["knowledge_2"]','电脑保修 2年','POLICY'),
('v1','售后怎么联系你们？','AFTERSALES','[]','["knowledge_8"]','售后 在线客服 热线','FAQ'),
('v1','售后热线是多少？','AFTERSALES','[]','["knowledge_8"]','客服热线 400','FAQ'),
('v1','手机坏了能保修吗？','AFTERSALES','[]','["knowledge_2"]','保修 三包 手机','POLICY'),
('v1','商品保修多长时间？','AFTERSALES','[]','["knowledge_2"]','保修政策 三包','POLICY'),
('v1','帮我查一下我的订单','ORDER','[]','[]','','ORDER'),
('v1','订单到哪里了？','ORDER','[]','[]','','ORDER'),
('v1','我的快递什么时候到？','ORDER','[]','[]','','ORDER'),
('v1','改一下收货地址','ACCOUNT','[]','[]','','ACCOUNT'),
('v1','我要改绑手机号','ACCOUNT','[]','[]','','ACCOUNT'),
('v1','你好','CHITCHAT','[]','[]','','CHITCHAT'),
('v1','谢谢','CHITCHAT','[]','[]','','CHITCHAT'),
('v1','转人工客服','HUMAN_HANDOFF','[]','[]','','HUMAN_HANDOFF'),
('v1','我要找真人客服','HUMAN_HANDOFF','[]','[]','','HUMAN_HANDOFF'),
('v1','我想买个手机，顺便查一下昨天的订单','CROSS_DOMAIN','[]','[]','','CROSS_DOMAIN');