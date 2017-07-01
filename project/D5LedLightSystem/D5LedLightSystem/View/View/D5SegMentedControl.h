//
//  D5SegMentedControl.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class D5SegMentedControl;

@protocol D5SegMentedControlDelegate <NSObject>
/**
 *  按钮点击事件
 *
 *  @param segMented 目标segMented
 *  @param index     点击的index
 */
- (void)segMentedControl:(D5SegMentedControl *)segMented index:(NSInteger)index;
@end

@interface D5SegMentedControl : UIView
/**
 *  选中状态背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundSeletedColor;

/**
 *  默认状态背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundNormalColor;

/**
 *  文字大小
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 *  文字默认状态颜色
 */
@property (nonatomic, strong) UIColor *textNormalColor;

/**
 *  文字选中状态颜色
 */
@property (nonatomic, strong) UIColor *textSeletedColor;

@property (weak, nonatomic) id<D5SegMentedControlDelegate> delegate;

/**
 *  加载标题显示的方法
 */
- (void)loadTitleArray:(NSArray *)titleArray;

@end
