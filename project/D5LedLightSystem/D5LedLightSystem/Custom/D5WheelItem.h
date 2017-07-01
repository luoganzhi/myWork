//
//  D5WheelItem.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#define START_ITEM 90.0f

@class D5WheelView;
@interface D5WheelItem : UIView

@property (nonatomic, retain) UIBezierPath *bezierPath;
- (instancetype)initWithWheelView:(D5WheelView *)wheelView;

@end
