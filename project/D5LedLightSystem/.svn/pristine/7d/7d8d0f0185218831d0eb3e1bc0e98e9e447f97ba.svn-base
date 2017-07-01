//
//  UIImage+LGZExtension.m
//  百思不得姐
//
//  Created by LGZwr on 16/5/16.
//  Copyright © 2016年 LGZ. All rights reserved.
//

#import "UIImage+LGZExtension.h"
#import <QuartzCore/QuartzCore.h>
#define PI 3.14159265358979323846

@implementation UIImage (LGZExtension)

- (UIImage *)circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    // 获得图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // 给上下文添加圆
    CGContextAddEllipseInRect(ref, CGRectMake(0, 0, self.size.width, self.size.height));
    
        // 裁剪
    CGContextClip(ref);
    
    
    // 将图片绘制上去
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}
@end
