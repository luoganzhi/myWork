//
//  D5WheelView.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5WheelView.h"
#import "D5RotateGestureRecognizer.h"
#import "D5WheelItem.h"

@implementation D5WheelView

@synthesize baseWheelItem = _baseWheelItem;
@synthesize numberOfItems = _numberOfItems;

#pragma mark - 初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    _bgImage = [UIImage imageNamed:@"color_palette"];
    
    @autoreleasepool {
        D5RotateGestureRecognizer *rotateGR = [[D5RotateGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
        [self addGestureRecognizer:rotateGR];
    }
}

- (D5WheelItem *)baseWheelItem {
    if (!_baseWheelItem) {
        _baseWheelItem = [[D5WheelItem alloc] initWithWheelView:self];
        
        CGRect baseWheelItemFrame = self.baseWheelItem.frame;
        baseWheelItemFrame.origin.x = CGRectGetMinX(self.frame) + (CGRectGetWidth(self.frame) - CGRectGetWidth(baseWheelItemFrame)) / 2;
        baseWheelItemFrame.origin.y = CGRectGetMidY(self.frame); //如果是上面点，则为minY，如果下面点，则为midY
        self.baseWheelItem.frame = baseWheelItemFrame;
        
        self.baseWheelItem.backgroundColor = [UIColor clearColor];
    }
    return _baseWheelItem;
}

- (NSInteger)numberOfItems {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInWheelView:)]) {
        _numberOfItems = [self.delegate numberOfItemsInWheelView:self];
    }
    return _numberOfItems;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @autoreleasepool {
        CGRect frame = self.frame;
        frame.size.height = frame.size.width;
        self.frame = frame;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.bgImage drawInRect:rect];
    
    @autoreleasepool {
        CGFloat radius = CGRectGetHeight(rect) / 2;
        CGFloat degree = START_ITEM;         //开始点是最下面的点
        
        for (int i = 0; i < self.numberOfItems; i ++) {
            @autoreleasepool {
                D5WheelItem *item = [[D5WheelItem alloc] initWithWheelView:self];
                item.tag = i;
                
                CGFloat centerX = radius + (radius / 2 * cos(DEGREES_TO_RADIANS(degree)));
                CGFloat centerY = radius + (radius / 2 * sin(DEGREES_TO_RADIANS(degree)));
               
                item.center = CGPointMake(centerX, centerY);
                item.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degree + 90.0f));
                
                degree += 360 / self.numberOfItems;
                [self addSubview:item];
            }
        }
        self.baseWheelItem.userInteractionEnabled = NO;
        [self.superview insertSubview:self.baseWheelItem aboveSubview:self];
    }
}

#pragma mark - 旋转手势的处理
- (void)handleRotateGesture:(D5RotateGestureRecognizer *)gesture {
    @autoreleasepool {
        if (gesture.state == UIGestureRecognizerStateChanged) {//rotate
            self.transform = CGAffineTransformRotate(self.transform, gesture.degrees);
        } else if (gesture.state == UIGestureRecognizerStateEnded) {//tap
            [UIView animateWithDuration:0.3f animations:^{
                self.transform = CGAffineTransformRotate(self.transform, gesture.degrees);
            } completion:^(BOOL finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(wheelView:didSelectedItemAtIndex:)]) {
                    [self.delegate wheelView:self didSelectedItemAtIndex:gesture.seletedIndex];
                }
            }];
        }
    }
}

@end
