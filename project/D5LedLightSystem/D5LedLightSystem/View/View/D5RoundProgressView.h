//
//  D5RoundProgressView.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2017/1/6.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface D5RoundProgressView : UIView

/** 进度:0~1 */
@property (nonatomic, assign) CGFloat progress;

/** 进度宽 */
@property (nonatomic, assign) CGFloat progressWidth;

/** 底圈颜色 */
@property (nonatomic, strong) UIColor *maskCircleColor;

/** label颜色 */
@property (nonatomic, strong) UIColor *labelColor;

/** 进度圈颜色 */
@property (nonatomic, strong) UIColor *realCircleColor;

@property (nonatomic, assign) NSTimeInterval totalInterval;

@end
