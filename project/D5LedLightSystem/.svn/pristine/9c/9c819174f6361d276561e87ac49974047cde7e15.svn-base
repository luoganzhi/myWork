//
//  UIColor+Image.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/28.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Image)

/**
 *  从image的point处获取RGB颜色值
 *
 *  @param point 图片上要取颜色值的位置
 *  @param image 要取颜色值的图片
 *
 *  @return image上point处的颜色值
 */
+ (UIColor *)getPixelColorAtLocation:(CGPoint)point fromeImage:(UIImage *)image view:(UIView *)view;


/**
 *  从image中创建bitmap context
 *
 *  @param inImage 目标image
 *
 *  @return bitmap context
 */
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage;

/**
 *  模拟按钮高亮状态的颜色（正常状态下的颜色加深）
 *
 *  @param color 正常状态下的颜色
 *
 *  @return 高亮状态下的颜色
 */
+ (UIColor *)highLightedColor:(UIColor*)color;
@end
