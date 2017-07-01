//
//  UIImage+Color.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 *  根据color创建image
 *
 *  @param color 目标color
 *
 *  @return 创建的image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据colors中的颜色创建渐变色的image
 *
 *  @param colours 目标colors
 *
 *  @return 创建的渐变色的image
 */
+ (UIImage *)imageWithGradients:(NSArray *)colours;
@end
