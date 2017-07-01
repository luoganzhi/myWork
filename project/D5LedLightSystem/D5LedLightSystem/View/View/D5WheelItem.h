//
//  D5WheelItem.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#define START_ITEM 270.0f //如果是上面的点270  下面的点90

@class D5WheelView;

@interface D5WheelItem : UIView

@property (nonatomic, strong) UIBezierPath *bezierPath;

- (instancetype)initWithWheelView:(D5WheelView *)wheelView;

@end
