//
//  UIControl+D5IntervalOperation.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/10/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "UIControl+D5IntervalOperation.h"
#import <objc/runtime.h>

#define INindentier @"INindentier"



@implementation UIControl (D5IntervalOperation)
#pragma mark --属性方法

-(void)setIntervalTime:(NSTimeInterval)intervalTime
{
    objc_setAssociatedObject(self, INindentier, @(intervalTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(NSTimeInterval)intervalTime
{
    return [objc_getAssociatedObject(self, INindentier)doubleValue];
    
}

+(void)load
{
    //获取系统方法
    Method systemMethond = class_getClassMethod(self, @selector(addTarget:action:forControlEvents:));
    Method myMethond=class_getClassMethod(self, @selector(InterValSendAction:to:forEvent:));
    method_exchangeImplementations(systemMethond, myMethond);//交换

}
//间隔发送相应消息
- (void)InterValSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
  
    if (NSDate.date.timeIntervalSince1970 - self.intervalTime < self.intervalTime)
    {
        return;
    }
    //间隔大于零是延迟
    if (self.intervalTime > 0)
    {
        self.intervalTime = NSDate.date.timeIntervalSince1970;
        
    }

    
       //执行系统的操作方法
    [self InterValSendAction:action to:target forEvent:event];

}

@end
