package com.ruoyi.common.utils;

import java.awt.*;
import java.awt.geom.QuadCurve2D;
import java.awt.image.BufferedImage;
import java.security.SecureRandom;

/**
 * 自定义验证码图片生成工具（Graphics2D 实现）
 * 深色科技风格，匹配系统暗色毛玻璃主题
 *
 * @author sqz
 */
public class CaptchaImageUtil
{
    private CaptchaImageUtil() {}

    /** 图片宽度 */
    private static final int WIDTH = 160;

    /** 图片高度 */
    private static final int HEIGHT = 60;

    /** 验证码字符数 */
    private static final int CODE_LENGTH = 4;

    /**
     * 字符集：大写字母 + 数字，排除易混淆字符 (0/O, 1/I/L)
     */
    private static final char[] CHAR_SET = "2346789ABCDEFGHJKMNPQRSTUVWXYZ".toCharArray();

    /** 背景色：深蓝黑（匹配登录页遮罩层） */
    private static final Color BG_COLOR = new Color(15, 22, 40);

    /** 文字颜色候选（科技蓝色系） */
    private static final Color[] TEXT_COLORS = {
        new Color(64, 158, 255),   // #409eff  主题蓝
        new Color(100, 181, 246),  // #64b5f6  亮科技蓝
        new Color(80, 200, 255),   // #50c8ff  浅天蓝
        new Color(130, 170, 255),  // #82aaff  淡紫蓝
    };

    /** 干扰线颜色（半透明科技蓝/青色） */
    private static final Color[] LINE_COLORS = {
        new Color(64, 158, 255, 80),
        new Color(0, 200, 200, 60),
        new Color(100, 181, 246, 70),
    };

    /** 噪点颜色 */
    private static final Color NOISE_COLOR = new Color(64, 158, 255, 40);

    /** 可用字体 */
    private static final String[] FONT_NAMES = { "Arial", "Consolas", "Verdana", "Tahoma" };

    private static final int FONT_SIZE_MIN = 30;

    private static final int FONT_SIZE_MAX = 38;

    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * 生成随机验证码文本
     *
     * @return 4位大写字母+数字混合验证码
     */
    public static String generateCode()
    {
        StringBuilder sb = new StringBuilder(CODE_LENGTH);
        for (int i = 0; i < CODE_LENGTH; i++)
        {
            sb.append(CHAR_SET[RANDOM.nextInt(CHAR_SET.length)]);
        }
        return sb.toString();
    }

    /**
     * 根据验证码文本生成深色科技风格图片
     *
     * @param code 验证码文本
     * @return 验证码图片
     */
    public static BufferedImage generateImage(String code)
    {
        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();

        // 开启抗锯齿
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_LCD_HRGB);

        // 1. 填充深色背景
        g2d.setColor(BG_COLOR);
        g2d.fillRect(0, 0, WIDTH, HEIGHT);

        // 2. 绘制噪点
        drawNoise(g2d);

        // 3. 绘制干扰曲线（贝塞尔曲线）
        drawInterferenceLines(g2d);

        // 4. 绘制验证码字符（每个字符独立旋转/偏移）
        drawText(g2d, code);

        g2d.dispose();
        return image;
    }

    /**
     * 绘制散落噪点
     */
    private static void drawNoise(Graphics2D g2d)
    {
        g2d.setColor(NOISE_COLOR);
        for (int i = 0; i < 60; i++)
        {
            int x = RANDOM.nextInt(WIDTH);
            int y = RANDOM.nextInt(HEIGHT);
            g2d.fillRect(x, y, 1, 1);
        }
    }

    /**
     * 绘制干扰贝塞尔曲线
     */
    private static void drawInterferenceLines(Graphics2D g2d)
    {
        int lineCount = 3 + RANDOM.nextInt(3);
        for (int i = 0; i < lineCount; i++)
        {
            g2d.setColor(LINE_COLORS[RANDOM.nextInt(LINE_COLORS.length)]);
            g2d.setStroke(new BasicStroke(1.2f + RANDOM.nextFloat() * 0.8f));

            QuadCurve2D curve = new QuadCurve2D.Float(
                RANDOM.nextInt(WIDTH / 4),
                RANDOM.nextInt(HEIGHT),
                WIDTH / 2 + RANDOM.nextInt(40) - 20,
                RANDOM.nextInt(HEIGHT),
                WIDTH - RANDOM.nextInt(WIDTH / 4),
                RANDOM.nextInt(HEIGHT)
            );
            g2d.draw(curve);
        }
    }

    /**
     * 绘制验证码文字（逐字符，带随机旋转和Y轴偏移）
     */
    private static void drawText(Graphics2D g2d, String code)
    {
        int charWidth = WIDTH / (CODE_LENGTH + 1);
        for (int i = 0; i < code.length(); i++)
        {
            String fontName = FONT_NAMES[RANDOM.nextInt(FONT_NAMES.length)];
            int fontSize = FONT_SIZE_MIN + RANDOM.nextInt(FONT_SIZE_MAX - FONT_SIZE_MIN + 1);
            int fontStyle = RANDOM.nextBoolean() ? Font.BOLD : Font.PLAIN;
            g2d.setFont(new Font(fontName, fontStyle, fontSize));

            g2d.setColor(TEXT_COLORS[RANDOM.nextInt(TEXT_COLORS.length)]);

            // 随机旋转角度: -15度 ~ +15度
            double angle = (RANDOM.nextDouble() - 0.5) * Math.toRadians(30);

            int x = charWidth * (i + 1) - 10;
            int y = HEIGHT / 2 + fontSize / 3 + RANDOM.nextInt(8) - 4;

            g2d.rotate(angle, x, y);
            g2d.drawString(String.valueOf(code.charAt(i)), x, y);
            g2d.rotate(-angle, x, y);
        }
    }
}
