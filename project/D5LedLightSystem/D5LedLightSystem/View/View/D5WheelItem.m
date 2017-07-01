//
//  D5WheelItem.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5WheelItem.h"
#import "D5WheelView.h"

@interface D5WheelItem ()

@property (nonatomic, assign) CGFloat startRadians; //弧度
@property (nonatomic, assign) CGFloat endRadians;
@property (nonatomic, assign) CGFloat radius; //半径

@end

@implementation D5WheelItem

- (instancetype)initWithWheelView:(D5WheelView *)wheelView {
    @autoreleasepool {
        _radius = CGRectGetWidth(wheelView.frame) / 2;
        
        CGFloat singleItemDegree = 360 / wheelView.numberOfItems; //每个item的弧度
        _startRadians = DEGREES_TO_RADIANS(START_ITEM - (singleItemDegree / 2)); //180-->PI
        _endRadians = DEGREES_TO_RADIANS(START_ITEM + (singleItemDegree / 2));
        
        CGRect frame = wheelView.bounds;
        if (wheelView.numberOfItems > 1) {
            UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_radius, _radius) radius:_radius startAngle:_startRadians endAngle:_endRadians clockwise:YES]; //以顺时针方向创建一段弧线
            frame = CGRectMake(0, 0, CGRectGetWidth(arcPath.bounds), _radius);
        }
        
        if (self = [super initWithFrame:frame]) {
            self.backgroundColor = [UIColor clearColor];
            self.layer.anchorPoint = CGPointMake(0.5f, 0.25f); //旋转的支点
        }
        
        return self;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), self.radius); //如果是上面点，则为self.radius，是下面点就是0 //--
    self.bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:self.startRadians endAngle:self.endRadians clockwise:YES];
    
    [self.bezierPath addArcWithCenter:center radius:0 startAngle:self.startRadians endAngle:self.endRadians clockwise:YES]; //--
    [self.bezierPath closePath];
}

@end
