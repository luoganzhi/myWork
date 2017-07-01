//
//  MySlider.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "MySlider.h"

#define SUPER_VIEW_HEIGHT 55

@implementation MySlider

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self setThumbImage:[UIImage imageNamed:@"bright_thumb"] forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"bright_thumb"] forState:UIControlStateSelected];
        [self setThumbImage:[UIImage imageNamed:@"bright_thumb"] forState:UIControlStateHighlighted];
    }
    return self;
}

/**
 *  改变滑动条中间横条的高度
 *
 *  @param bounds 滑动条的整个bounds（包括两边的图片宽度）
 *
 *  @return 滑动条中间横条的frame
 */
- (CGRect)trackRectForBounds:(CGRect)bounds {
    if (self.minimumValueImage || self.maximumValueImage) {
        return CGRectMake(35, 12, bounds.size.width - 80, 5);
    }
    
    return CGRectMake(0, 8, bounds.size.width, 5);
}

/**
 *  中间thumb超出横条左右的距离
 *
 *  @param bounds 滑动条的整个bounds（包括两边的图片宽度
 *  @param rect   中间thumb的frame
 *  @param value  滑动条的值
 *
 *  @return 中间thumb的frame
 */
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 5;
    rect.size.width = rect.size.width + 10;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 5, 5);
}

@end