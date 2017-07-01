//
//  D5ColorPickerView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2017/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5ColorPickerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation D5ColorPickerView

/**
 初始化色盘
 */
- (void)initColourDiskImageView {
    @autoreleasepool {
        UIImage *colourDiskImg = [UIImage imageNamed:@"manual_colour_disk"];
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        UIImageView *colourDiskImgView = [[UIImageView alloc] initWithImage:colourDiskImg];
        CGFloat width = size.width - CGRectGetMinX(self.frame) * 2;
        colourDiskImgView.frame = CGRectMake(0, 0, width, width);
        self.colourDiskView = colourDiskImgView;
        
        [self addSubview:self.colourDiskView];
    }
}

/**
 初始化光标
 */
- (void)initCursorImageView {
    @autoreleasepool {
        UIImage *cursorImg = [UIImage imageNamed:@"manual_cursor"];
        UIImageView *cursorImgView = [[UIImageView alloc] initWithImage:cursorImg];
        
        cursorImgView.contentMode = UIViewContentModeScaleAspectFit;
        cursorImgView.frame = CGRectMake(0, 0, cursorImg.size.width, cursorImg.size.height);
        self.cursorView = cursorImgView;
        
        [self addSubview:self.cursorView];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
        
        [self initColourDiskImageView];
        [self initCursorImageView];
    }
    return self;
}


- (void)setCurrentHSV:(HSVType)currentHSV {
    _currentHSV = currentHSV;
    
    _currentHSV.v = 1.0f;
    
    double angle = _currentHSV.h * 2.0 * M_PI;
    CGPoint center = CGPointMake(CGRectGetMidX(self.colourDiskView.bounds), CGRectGetMidY(self.colourDiskView.bounds));
    
    double radius = CGRectGetMidX(self.colourDiskView.bounds);  // - 3.0f
    radius *= _currentHSV.s;
    
    CGFloat x = center.x + cosf(angle) * radius;
    CGFloat y = center.y - sinf(angle) * radius;
    
    x = roundf(x - CGRectGetMidX(self.cursorView.bounds)) + CGRectGetMidX(self.cursorView.bounds);
    y = roundf(y - CGRectGetMidY(self.cursorView.bounds)) + CGRectGetMidY(self.cursorView.bounds);
    self.cursorView.center = CGPointMake(x + CGRectGetMinX(self.colourDiskView.frame), y + CGRectGetMinY(self.colourDiskView.frame));
}

- (void)mapPointToColor:(CGPoint)point {
    @autoreleasepool {
        CGPoint center = CGPointMake(CGRectGetMidX(self.colourDiskView.bounds), CGRectGetMidY(self.colourDiskView.bounds));
        
        double radius = CGRectGetMidX(self.colourDiskView.bounds);
        
        double dx = ABS(point.x - center.x);
        double dy = ABS(point.y - center.y);
        double angle = atan(dy / dx);
        if (isnan(angle))
            angle = 0.0;
        
        double dist = sqrt(pow(dx, 2) + pow(dy, 2));
        double saturation = MIN(dist/radius, 1.0);
        
        if (dist < 10)
            saturation = 0; // snap to center
        
        if (point.x < center.x)
            angle = M_PI - angle;
        
        if (point.y > center.y)
            angle = 2.0 * M_PI - angle;
        
        self.currentHSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark Touches
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    @autoreleasepool {
        CGPoint mousepoint = [touch locationInView:self];
        if (!CGRectContainsPoint(self.colourDiskView.frame, mousepoint))
            return NO;
        
//        [self mapPointToColor:[touch locationInView:self.colourDiskView]];
        return YES;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [self mapPointToColor:[touch locationInView:self.colourDiskView]];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [self continueTrackingWithTouch:touch withEvent:event];
    [self mapPointToColor:[touch locationInView:self.colourDiskView]];
}

@end
