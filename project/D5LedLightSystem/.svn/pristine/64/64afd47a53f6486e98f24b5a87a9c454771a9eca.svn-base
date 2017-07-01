//
//  D5BaseTipView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseTipView.h"
#import "D5ConnectZKTViewController.h"
#import "D5loadingViewController.h"
#import "D5DisconnectTipView.h"

@implementation D5BaseTipView

#pragma mark - 隐藏view
- (void)hideTipView {
    [self removeViewFromWindow];
}

- (void)addLineToBtn:(UIButton *)btn {
    @autoreleasepool {
        NSString *title = btn.currentTitle;
        [btn setAttributedTitle:[D5String attrStringWithString:title fontColor:btn.currentTitleColor] forState:UIControlStateNormal];
    }
}

- (void)showUploadIngViewByIndex:(int)index totalCount:(int)totalCount musicName:(NSString *)name progress:(int)progress {}

- (void)updateProgress:(int)progress currentIndex:(int)index musicName:(NSString *)name {}

#pragma mark - 添加和移除view
- (void)addViewToWindow {
    @autoreleasepool {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSArray *childVcs = [window.rootViewController childViewControllers];
        
        if (childVcs && childVcs.count > 0) {
            UIViewController *vc = [childVcs lastObject];
            if ([vc isKindOfClass:[D5ConnectZKTViewController class]] || [vc isKindOfClass:[D5LoadingViewController class]]) {
                [D5DisconnectTipView sharedDisconnectTipView].isShow = NO;
                return;
            }
        }
        
        NSArray *subViews = window.subviews;
        if (subViews) {
            for (UIView *view in subViews) {
                if ([view isKindOfClass:[D5BaseTipView class]]) {
                    [view removeFromSuperview];
                }
            }
        
            [window addSubview:self];
        }
    }
}

- (void)removeViewFromWindow {
    @autoreleasepool {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        NSArray *subViews = window.subviews;
        if (subViews && [subViews containsObject:self]) {
            [self removeFromSuperview];
        }
    }
}

- (void)showView {
    [self layoutSubviews];
    [self addViewToWindow];
}

@end
