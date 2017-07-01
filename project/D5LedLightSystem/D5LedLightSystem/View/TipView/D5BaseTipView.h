//
//  D5BaseTipView.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+runtime.h"

@interface D5BaseTipView : UIView

/**
 隐藏tipview
 */
- (void)hideTipView;

/**
 添加view到窗口
 */
- (void)addViewToWindow;

/**
 移除view
 */
- (void)removeViewFromWindow;

/**
 显示View
 */
- (void)showView;

- (void)addLineToBtn:(UIButton *)btn;

- (void)showUploadIngViewByIndex:(int)index totalCount:(int)totalCount musicName:(NSString *)name progress:(int)progress;

- (void)updateProgress:(int)progress currentIndex:(int)index musicName:(NSString *)name;
@end
