//
//  D5BaseViewController.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationController.h"
#import "D5NetWork.h"
#import "D5BarItem.h"
typedef enum _guide_bg_direction {
    GuideBgDirectionLeft,
    GuideBgDirectionCenter,
    GuideBgDirectionRight
}GuideBgDirection;

#define GUIDE_TIP_TAG 12121

#define BTN_DISABLED_COLOR [UIColor colorWithWhite:0.086 alpha:1.000]

@interface D5BaseViewController : UIViewController

@property(nonatomic, assign) BOOL translucent;

- (void)setStatusBarStyle:(UIBarStyle)style;
/**
 * navigation是否隐藏
 */
- (void)setNavigationBarHidden:(BOOL)isHide;

/**
 * 设置navigationbar的颜色
 */
- (void)setNavigationBarWithColor:(UIColor *)color;

/**
 * 设置navigation标题颜色
 */
- (void)setNavigationTitleColor:(UIColor *)color;

/**
 * 设置navigation标题大小
 */
- (void)setNavigationTitleSize:(CGFloat)size;

/**
 * 设置navigation透明
 */
- (void)setNavigationBarTranslucent;

/**
 * 设置statusBar的style为白色
 */
- (void)setLightContentBar;

/**
 * 设置statusBar的style为黑色
 */
- (void)setBlackBar;

/**
 * 返回
 */
- (void)back;

/**
 * 改变右上角baritem的标题 -- 不闪烁
 */
- (void)changeRightBarItemTitle:(NSString *)title;

/**
 * 改变右上角baritem的enable
 */
- (void)changeRightBarItemEnabled:(BOOL)enabled;

/**
 * 设置btn的标题 -- 不闪烁
 */
- (void)setBtnTitle:(NSString *)title forBtn:(UIButton *)btn;

/**
 * 设置btn的enable
 */
- (void)setBtnEnable:(UIButton *)btn enable:(BOOL)isEnable;

/**
 * 开始旋转
 */
- (void)startRotateForImg:(UIImageView *)imgView;
/**
 * 停止旋转动画
 */
- (void)stopRotateForImg:(UIImageView *)imgView;

/**
 添加引导提示view,  如果方向向右，这时传的point的x是与屏幕右边距离,  如果方向在中间，这时传的point的x是箭头指向的x点

 @param point view的位置
 @param tipStr 提示内容
 @param direction 背景图片pop的方向
 */
- (void)addGuideViewWithPoint:(CGPoint)point tipStr:(NSString *)tipStr direction:(GuideBgDirection)direction;

/**
 移除引导提示
 */
- (void)removeGuideTip;

- (void)addGuideViewWithPoint:(CGPoint)point tipStr:(NSString *)tipStr direction:(GuideBgDirection)direction toView:(UIView *)view;

- (void)removeGuideTipFromView:(UIView *)view;

- (void)resignGuideTip;

@end
