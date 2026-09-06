-- =============================================
-- 电子产品测试数据 - 2026-03-11
-- 包含手机、笔记本、平板、耳机、手表、配件等品类
-- imageUrl 留空，请自行上传对应图片后填入
-- 使用 NOT EXISTS 动态查询避免重复插入
-- =============================================

-- ========== 手机 ==========

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '苹果 iPhone 16 Pro Max 256GB', '手机', 8999.00, 50,
'屏幕：6.9英寸超视网膜XDR OLED\n处理器：A18 Pro仿生芯片\n内存/存储：8GB/256GB\n摄像头：4800万主摄+4800万超广角+1200万长焦(5倍光学变焦)\n电池：4685mAh\n重量：227g\n颜色：沙漠钛金属/原色钛金属/白色钛金属/黑色钛金属',
'A18 Pro芯片 性能强劲\n钛金属边框 坚固轻盈\n4800万像素融合式摄像头系统\n支持Apple智能AI功能\nUSB-C接口 传输速度更快',
'未激活7天无理由退换，已激活不支持退换', '全国联保一年，支持官方售后', '请保留原装包装及配件，激活后仅支持保修', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '苹果 iPhone 16 Pro Max 256GB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '华为 Mate 70 Pro 12+256GB', '手机', 6499.00, 35,
'屏幕：6.9英寸等深微曲OLED 120Hz\n处理器：麒麟9020\n内存/存储：12GB/256GB\n摄像头：5000万主摄OIS+4000万超广角+4800万长焦(3.5倍光学变焦)\n电池：5700mAh 100W有线快充\n重量：225g\n系统：HarmonyOS 5.0',
'麒麟9020旗舰芯片\n鸿蒙5.0原生系统\n5700mAh大电池 100W快充\n3D人脸识别\nIP69K防尘防水',
'未拆封7天无理由退换', '全国联保一年', '请保留购买凭证，人为损坏不在保修范围内', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '华为 Mate 70 Pro 12+256GB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '小米15 Pro 12+256GB', '手机', 4599.00, 60,
'屏幕：6.73英寸2K AMOLED 120Hz\n处理器：骁龙8至尊版\n内存/存储：12GB/256GB\n摄像头：5000万主摄OIS+5000万超广角+5000万长焦\n电池：6100mAh 90W有线快充\n重量：213g\n系统：澎湃OS 2.0',
'骁龙8至尊版旗舰性能\n6100mAh超大电池\n全焦段5000万三摄系统\n2K超清护眼屏\n金属中框 质感出色',
'未拆封7天无理由退换', '全国联保一年', '请通过官方渠道维修', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '小米15 Pro 12+256GB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '三星 Galaxy S25 Ultra 12+256GB', '手机', 8999.00, 25,
'屏幕：6.86英寸QHD+ Dynamic AMOLED 2X 120Hz\n处理器：骁龙8至尊版(Galaxy定制)\n内存/存储：12GB/256GB\n摄像头：2亿主摄+5000万超广角+1000万3倍长焦+5000万5倍潜望长焦\n电池：5000mAh 45W快充\n重量：218g\nS Pen内置',
'2亿像素四摄影像系统\n骁龙8至尊版Galaxy定制芯片\n内置S Pen书写体验\nGalaxy AI智能助手\n钛金属边框',
'未激活7天无理由退换', '全国联保一年', '屏幕碎裂不在免费保修范围，建议购买Samsung Care+', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '三星 Galaxy S25 Ultra 12+256GB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'OPPO Find X8 Pro 16+256GB', '手机', 5299.00, 40,
'屏幕：6.78英寸2K LTPO AMOLED 120Hz\n处理器：天玑9400\n内存/存储：16GB/256GB\n摄像头：5000万主摄+5000万超广角+5000万长焦+5000万潜望长焦\n电池：5910mAh 80W快充\n重量：215g',
'天玑9400旗舰芯片\n哈苏影像四摄系统\n5910mAh大电池全天候续航\nColorOS 15 AI体验\nIP69级防水',
'未拆封7天无理由退换', '全国联保一年', '请勿自行拆机，以免影响保修', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'OPPO Find X8 Pro 16+256GB');

-- ========== 笔记本电脑 ==========

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'MacBook Air 13英寸 M4 16+256GB', '笔记本电脑', 7999.00, 30,
'屏幕：13.6英寸Liquid Retina 2560x1664\n芯片：Apple M4 10核CPU+10核GPU\n内存/存储：16GB/256GB\n电池：最长18小时续航\n重量：1.24kg\n接口：2x Thunderbolt/USB 4, MagSafe 3, 3.5mm',
'M4芯片 性能全面提升\n18小时超长续航\n仅1.24kg极致轻薄\n12MP Center Stage摄像头\n天蓝色等4色可选',
'未激活14天无理由退换', '全国联保一年，AppleCare+可延长', '激活后仅支持保修服务，不支持退换', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'MacBook Air 13英寸 M4 16+256GB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '华为 MateBook X Pro 酷睿Ultra 7 16+1TB', '笔记本电脑', 11199.00, 15,
'屏幕：14.2英寸OLED 3120x2080 120Hz 93%屏占比\n处理器：英特尔酷睿Ultra 7 155H\n内存/存储：16GB/1TB\n电池：70Wh 65W快充\n重量：仅980g\n厚度：仅13.5mm',
'全球最轻14英寸性能本 仅980g\n14.2英寸OLED原色全面屏\n酷睿Ultra 7处理器\n15小时超长续航\n微绒金属机身 高级质感',
'未拆封15天无理由退换', '全国联保两年', '请通过华为官方服务中心维修', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '华为 MateBook X Pro 酷睿Ultra 7 16+1TB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '联想 ThinkPad X1 Carbon 2025 Ultra7 32+1TB', '笔记本电脑', 12999.00, 20,
'屏幕：14英寸2.8K OLED 120Hz\n处理器：英特尔酷睿Ultra 7 258V\n内存/存储：32GB LPDDR5x/1TB PCIe 5.0 SSD\n电池：57Wh 65W快充\n重量：1.09kg\nAI算力：120 TOPS',
'经典ThinkPad商务旗舰\n120 TOPS AI算力\n2.8K OLED高色域屏\n32GB大内存 专业办公\nMIL-STD-810H军标认证',
'未拆封15天无理由退换', '全国联保三年，支持上门服务', '企业客户可享延保服务', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '联想 ThinkPad X1 Carbon 2025 Ultra7 32+1TB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '火影 T7A 游戏本 R9-8945HX RTX5060', '笔记本电脑', 6599.00, 25,
'屏幕：16英寸2.5K IPS 300Hz 500nit\n处理器：AMD R9-8945HX\n显卡：NVIDIA RTX 5060 8GB\n内存/存储：32GB DDR5/1TB NVMe SSD\n散热：170W双烤性能释放\n重量：2.3kg',
'R9-8945HX+RTX5060强劲组合\n300Hz高刷电竞屏\n32GB大内存+1TB存储\n170W满血性能释放\n白色金属机身 颜值在线',
'未拆封7天无理由退换', '全国联保两年', '游戏本发热属正常现象，请保持散热通畅', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '火影 T7A 游戏本 R9-8945HX RTX5060');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '戴尔 Dell 14 Plus 酷睿Ultra5 16+512GB', '笔记本电脑', 6999.00, 20,
'屏幕：14英寸2.8K OLED 120Hz\n处理器：英特尔酷睿Ultra 5 226V\n内存/存储：16GB LPDDR5x/512GB SSD\n电池：55Wh\n重量：1.5kg\n接口：Thunderbolt 4×2, USB-A, HDMI, SD卡槽',
'2.8K OLED绚丽屏幕\n酷睿Ultra 5高效处理器\n全功能接口丰富\nDell全新品牌设计语言\n支持AI智能助手功能',
'未拆封15天无理由退换', '全国联保两年', '请通过戴尔官方客服报修', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '戴尔 Dell 14 Plus 酷睿Ultra5 16+512GB');

-- ========== 平板电脑 ==========

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'Apple iPad Pro 11英寸 M4 256GB WiFi', '平板电脑', 8999.00, 20,
'屏幕：11英寸超精视网膜XDR OLED (Tandem OLED)\n芯片：Apple M4\n存储：256GB\n厚度：仅5.3mm\n重量：444g\n接口：USB-C Thunderbolt/USB 4\n支持：Apple Pencil Pro, 妙控键盘',
'M4芯片 专业级性能\nTandem OLED极致显示\n仅5.3mm 史上最薄苹果产品\n支持Apple Pencil Pro\n38万亿次/秒AI算力',
'未激活14天无理由退换', '全国联保一年', '建议搭配Apple Pencil Pro获得最佳体验', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'Apple iPad Pro 11英寸 M4 256GB WiFi');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '华为 MatePad Pro 13.5英寸 麒麟9000s 12+256GB', '平板电脑', 5499.00, 18,
'屏幕：13.5英寸OLED原色屏 144Hz\n处理器：麒麟9000s\n内存/存储：12GB/256GB\n电池：10100mAh 88W快充\n重量：580g\n系统：HarmonyOS 4.2',
'13.5英寸超大OLED屏\n鸿蒙分布式跨屏协同\n麒麟9000s芯片\n10100mAh大电池 88W快充\n支持M-Pencil触控笔',
'未拆封7天无理由退换', '全国联保一年', '请使用原装充电器', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '华为 MatePad Pro 13.5英寸 麒麟9000s 12+256GB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'vivo Pad5 Pro 13英寸 天玑9400 12+256GB', '平板电脑', 2999.00, 45,
'屏幕：13英寸3.1K 3:2比例 144Hz\n处理器：天玑9400\n内存/存储：12GB/256GB UFS 4.1\n电池：12050mAh 66W快充\n扬声器：8扬声器全景声\n重量：620g',
'13英寸3.1K超清大屏\n天玑9400旗舰芯片\n12050mAh超大电池\n8扬声器全景声学系统\n3000元以内性价比之王',
'未拆封7天无理由退换', '全国联保一年', '大尺寸平板请注意防摔保护', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'vivo Pad5 Pro 13英寸 天玑9400 12+256GB');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '小米 Redmi Pad SE 11英寸 4+128GB', '平板电脑', 899.00, 80,
'屏幕：11英寸FHD+ 1920x1200 90Hz\n处理器：骁龙680\n内存/存储：4GB/128GB\n电池：8000mAh\n重量：478g\n认证：莱茵双护眼认证',
'11英寸FHD+护眼大屏\n8000mAh超长续航\n90Hz高刷新率\n莱茵双护眼认证\n百元级性价比平板',
'未拆封7天无理由退换', '全国联保一年', '入门级平板适合影音娱乐和学习', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '小米 Redmi Pad SE 11英寸 4+128GB');

-- ========== 耳机 ==========

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'Apple AirPods Pro 3', '耳机', 1899.00, 55,
'芯片：H2\n降噪：主动降噪(ANC) 前代2倍\n防护等级：IP57\n续航：降噪8小时/通透10小时\n耳塞：5种尺寸(含XXS)\n特色：光学心率传感器 256Hz监测\n充电盒：触控操作 精确查找',
'降噪性能为AirPods Pro 2的2倍\n内置心率传感器 健康监测\n5种耳塞尺寸精准贴合\n触控充电盒 滑动切歌\nIP57防水防尘',
'未拆封7天无理由退换', '全国联保一年', '耳塞属消耗品，请定期更换', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'Apple AirPods Pro 3');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '索尼 WH-1000XM6 头戴式降噪耳机', '耳机', 3499.00, 30,
'处理器：QN3(运算能力7倍提升)\n麦克风：12个\n降噪：自适应AI降噪\n续航：约30小时\n重量：约228g\n连接：蓝牙5.3 LDAC\n颜色：黑色/铂金银/午夜蓝',
'全新QN3处理器 降噪性能飞跃\n12麦克风阵列 极致降噪体验\nLDAC高解析度无线传输\nAI通话降噪 清晰人声\n可折叠设计 便携出行',
'未拆封7天无理由退换', '全国联保一年', '请避免在高温潮湿环境使用', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '索尼 WH-1000XM6 头戴式降噪耳机');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '华为 FreeBuds 6i 真无线降噪耳机', '耳机', 349.00, 100,
'降噪深度：最高27dB\n续航：降噪8小时 总35小时\n防护等级：IP54\n连接：蓝牙5.3\n驱动单元：11mm动圈\n重量：单耳约5.2g',
'27dB智慧动态降噪\n千元级降噪效果 百元级价格\n35小时超长总续航\nIP54防水适合运动\n华为音频分享',
'未拆封7天无理由退换', '全国联保一年', '耳塞请定期清洁以保证降噪效果', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '华为 FreeBuds 6i 真无线降噪耳机');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '小米 Buds 5 Pro WiFi版 真无线耳机', '耳机', 1099.00, 40,
'降噪深度：最高55dB\n续航：降噪6.5小时 总30小时\n驱动单元：11mm+6mm双单元\n连接：蓝牙5.4+WiFi低延迟\n编码：LHDC 5.0\n重量：单耳约6.2g',
'55dB超深度主动降噪\nWiFi低延迟音频传输\nLHDC 5.0高清音频编码\n双单元声学架构 HiFi音质\n空间音频沉浸体验',
'未拆封7天无理由退换', '全国联保一年', '请避免长时间大音量使用以保护听力', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '小米 Buds 5 Pro WiFi版 真无线耳机');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '西圣 H1 Pro 头戴式蓝牙耳机', '耳机', 229.00, 120,
'芯片：蓝牙6.0\n降噪：混合主动降噪\n续航：60小时\n驱动单元：40mm\n连接：蓝牙5.3 支持双设备\n重量：约260g\n折叠：可折叠便携',
'60小时超长续航\n蓝牙6.0芯片 稳定连接\n双设备同时连接\n百元价位降噪体验\n可折叠便携设计',
'未拆封7天无理由退换', '全国联保一年', '百元档性价比之选', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '西圣 H1 Pro 头戴式蓝牙耳机');

-- ========== 智能手表/手环 ==========

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'Apple Watch Series 10 46mm GPS', '智能手表', 3499.00, 35,
'屏幕：46mm OLED 广角显示\n芯片：Apple S10\n厚度：9.7mm\n防水：50米\n续航：18小时\n快充：30分钟充至80%\n传感器：心率/血氧/温度/加速度计',
'苹果迄今最大最薄的显示屏\n可视角度提升40%\n30分钟快充至80%\n睡眠呼吸暂停检测\n车祸和摔倒检测',
'未激活14天无理由退换', '全国联保一年', '建议佩戴时保持表底清洁以确保传感器准确性', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'Apple Watch Series 10 46mm GPS');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '华为 Watch GT5 Pro 46mm', '智能手表', 2488.00, 30,
'屏幕：1.43英寸AMOLED 466x466\n材质：钛金属表壳+蓝宝石玻璃\n续航：约14天\n防水：5ATM+潜水认证\n定位：双频GPS\n传感器：心率/血氧/体温/ECG',
'钛金属+蓝宝石 高端质感\n14天超长续航\nECG心电图功能\n高尔夫球场/潜水模式\n鸿蒙智能手表生态',
'未拆封7天无理由退换', '全国联保一年', '皮质表带不防水，运动时请更换硅胶表带', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '华为 Watch GT5 Pro 46mm');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '小米手环9 NFC版', '智能手环', 299.00, 150,
'屏幕：1.62英寸AMOLED 192x490 60Hz 1200nit\n处理器：BES 2700IMP\n电池：233mAh 续航约21天\n防水：5ATM 50米\n连接：蓝牙5.4\n重量：约15.8g(不含腕带)\n运动模式：150+种',
'全金属质感设计\n1200nit高亮AMOLED屏\n21天超长续航\n150+运动模式\nNFC交通卡/门禁卡',
'未拆封7天无理由退换', '全国联保一年', '表带属消耗品，可另购替换', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '小米手环9 NFC版');

-- ========== 充电器/配件 ==========

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'Anker 安克 Prime 200W 氮化镓充电器', '充电配件', 499.00, 60,
'总功率：200W (最高单口100W)\n接口：3x USB-C + 1x USB-A\n技术：GaN III 氮化镓\n尺寸：约98x70x33mm\n重量：约340g\n兼容：PD3.1/QC5/PPS/AFC',
'200W大功率 同时充4台设备\nGaN III氮化镓 小体积大功率\n单口最高100W 可充笔记本\n全协议兼容 通用性强\n智能温控 安全可靠',
'未拆封7天无理由退换', '全国联保18个月', '请使用原装线缆以获得最佳充电效率', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'Anker 安克 Prime 200W 氮化镓充电器');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '倍思 65W 氮化镓快充充电器', '充电配件', 79.00, 200,
'总功率：65W\n接口：1x USB-C + 1x USB-A\n技术：GaN 氮化镓\n尺寸：约55x32x32mm\n重量：约95g\n兼容：PD3.0/QC4+/PPS/SCP',
'65W快充 可充笔记本\n仅95g 口红大小便携\n氮化镓技术 高效散热\n双口设计 手机电脑同充\n多协议兼容',
'未拆封7天无理由退换', '全国联保一年', '充电时微热属正常现象', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '倍思 65W 氮化镓快充充电器');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT 'Apple Pencil Pro 触控笔', '数码配件', 999.00, 40,
'兼容：iPad Pro M4 / iPad Air M2\n功能：挤压手势/触觉反馈/桶状旋转/悬停\n连接：蓝牙/磁吸配对充电\n重量：约20.7g\n长度：约166mm',
'挤压感应 快速切换工具\n桶状旋转 精确控制角度\n悬停预览 未触屏即可操作\n触觉反馈 精准触感\n磁吸充电配对 使用方便',
'未拆封14天无理由退换', '全国联保一年', '请避免跌落以保护压力传感器', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = 'Apple Pencil Pro 触控笔');

INSERT INTO biz_product (name, category, price, stock, description, highlights, refund_policy, warranty_info, after_sale_note, image_url, status, create_time)
SELECT '罗马仕 40000mAh 大容量移动电源', '充电配件', 199.00, 90,
'容量：40000mAh\n输出：22.5W有线快充\n接口：2x USB-A + 1x USB-C + 1x Micro\n尺寸：约155x77x43mm\n重量：约560g\n显示：LED数显电量',
'40000mAh超大容量\n22.5W快充 充电不等待\n可充手机约8-10次\n数显电量 一目了然\n多接口多设备同充',
'未拆封7天无理由退换', '全国联保一年', '首次使用前请充满电，不可托运上飞机', '', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM biz_product WHERE name = '罗马仕 40000mAh 大容量移动电源');
