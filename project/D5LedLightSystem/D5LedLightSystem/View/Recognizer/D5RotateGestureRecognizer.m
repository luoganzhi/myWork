//
//  D5RotateGestureRecognizer.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5RotateGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "D5WheelItem.h"
#import "D5WheelView.h"

@implementation D5RotateGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { //只能单手指操作
    self.state = (touches.count == 1) ? UIGestureRecognizerStateBegan : UIGestureRecognizerStateFailed;
}

//旋转中
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    @autoreleasepool {
        self.state = UIGestureRecognizerStateChanged;
        UITouch *touch = [touches anyObject];
        CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)); //self.view == wheelview 的中心点
        
        CGPoint currentLocation = [touch locationInView:self.view];
        CGPoint previousLocation = [touch previousLocationInView:self.view];
        
        self.degrees =  atan2((currentLocation.y - center.y), (currentLocation.x - center.x)) - atan2((previousLocation.y - center.y), (previousLocation.x - center.x)); //获取旋转角度
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    @autoreleasepool {
        NSArray *subViews = self.view.subviews;
        if (self.state == UIGestureRecognizerStateChanged) {
            D5WheelView *wheelView = (D5WheelView *)self.view;
            for (D5WheelItem *itemView in subViews) {
                @autoreleasepool {
                    CGPoint itemViewCenterPoint = CGPointMake(CGRectGetMidX(itemView.bounds), CGRectGetMidY(itemView.bounds));
                    CGPoint itemCenterPointInWindow = [itemView convertPoint:itemViewCenterPoint toView:nil];
                    CGRect baseWheelItemRectInWindow = [wheelView.baseWheelItem.superview convertRect:wheelView.baseWheelItem.frame toView:nil];
                    //判断itemCenterPointInWindow是否在baseWheelItemRectInWindow中
                    if (CGRectContainsPoint(baseWheelItemRectInWindow, itemCenterPointInWindow)) {
                        CGPoint itemCenterPointInBaseWheelItem = [itemView convertPoint:itemViewCenterPoint toView:wheelView.baseWheelItem];
                        if ([self point:itemCenterPointInBaseWheelItem at:itemView]) {
                            break;
                        }
                    }
                }
            }
        } else if (self.state == UIGestureRecognizerStateBegan) {
            for (D5WheelItem *itemView in subViews) {
                @autoreleasepool {
                    CGPoint touchPoint = [self locationInView:itemView];
                    if ([self point:touchPoint at:itemView]) {
                        break;
                    }
                }
            }
        }
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
}

/**
 *  判断point是否在itemView.bezierPath.CGPath区域内，在则设置degree和selectedIndex
 *
 *  @param point    目标point
 *  @param itemView 目标item
 *
 *  @return point是否在itemView.bezierPath.CGPath区域内
 */
- (BOOL)point:(CGPoint)point at:(D5WheelItem *)itemView {
    UIBezierPath *path = itemView.bezierPath;
   if (CGPathContainsPoint(path.CGPath, NULL, point, NO)) {
       self.degrees = DEGREES_TO_RADIANS(180) + atan2(self.view.transform.a, self.view.transform.b) + atan2(itemView.transform.a, itemView.transform.b); //如果是上面点，则DEGREES_TO_RADIANS(180) + ，否则不要
       
       //DLog(@"%f - %f - %f - %f", self.view.transform.a, self.view.transform.b, self.view.transform.c, self.view.transform.d);
       self.selectedIndex = itemView.tag;
       return YES;
    }
    return NO;
}

@end
