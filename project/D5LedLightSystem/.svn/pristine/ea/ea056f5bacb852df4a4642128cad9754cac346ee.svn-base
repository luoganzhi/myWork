//
//  MyButton.m
//  D5LedLightSystem
//
//  Created by ; on 16/6/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

/**
 *  将BUTTON的文字和图片垂直排列
 */
- (void)layoutSubviews {
    @autoreleasepool {
        [super layoutSubviews];
        
        // Center image
        CGPoint center = self.imageView.center;
        center.x = self.frame.size.width / 2;
        center.y = CGRectGetHeight(self.frame) * 0.35;
        self.imageView.center = center;
        
        //Center text
        CGRect newFrame = [self titleLabel].frame;
        newFrame.origin.x = 0;
        newFrame.size.width = self.frame.size.width;
        self.titleLabel.frame = newFrame;
        
        CGPoint titleCenter = [self titleLabel].center;
        titleCenter.y = CGRectGetHeight(self.frame) * 0.8;
        [self titleLabel].center = titleCenter;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

@end
