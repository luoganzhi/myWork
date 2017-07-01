//
//  MBProgressHUD+NJ.m
//  NJWisdomCard
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "MBProgressHUD+NJ.h"

#define CURRENT_LOADING_PROGRESSHUD_TAG  121212

@implementation MBProgressHUD (NJ)

+ (UIView *)lastWindow {
    @autoreleasepool {
        NSArray *windows = [UIApplication sharedApplication].windows;
        if (windows && windows.count > 0) {
            for (int i = 0; i < (int)windows.count; i ++) {
                @autoreleasepool {
                    if ([windows[i] isKindOfClass:[UIWindow class]]) {
                        return windows[i];
                    }
                }
            }
        }
        
        return nil;
    }
}

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    @autoreleasepool {
        if (view == nil) {
            view = [self lastWindow];
        }
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        if ([NSString isValidateString:text]) {
            hud.label.text = text;
        }
        
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1秒之后再消失
        [hud hideAnimated:YES afterDelay:0.8f];
    }
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"success.png" view:view];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"error.png" view:view];
}

/**
 *  显示信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */

+ (void)showMessage:(NSString *)message longTime:(BOOL)isLongTime {
    [self showMessage:message toView:nil longTime:isLongTime];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    [self showMessage:message toView:view longTime:NO];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view longTime:(BOOL)isLongTime {
    [self showMessage:message toView:view location:MBProgressHUDLocationBottom longTime:isLongTime];
}

+ (void)showMessage:(NSString *)message {
    [self showMessage:message longTime:NO];
}

+ (void)showLoading:(NSString *)message {
    [self showLoading:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (void)showLoading:(NSString *)message toView:(UIView *)view {
    @autoreleasepool {
        if (view == nil) {
            view = [self lastWindow];
        }
        
        if ([[NSThread currentThread] isMainThread]) {
            // 快速显示一个提示信息
            MBProgressHUD *hud = [view viewWithTag:CURRENT_LOADING_PROGRESSHUD_TAG];
            if (hud != nil) {
                [hud removeFromSuperview];
            }
            
            hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.tag = CURRENT_LOADING_PROGRESSHUD_TAG;
            
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            
            if ([NSString isValidateString:message]) {
                hud.label.text = message;
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 快速显示一个提示信息
                MBProgressHUD *hud = [view viewWithTag:CURRENT_LOADING_PROGRESSHUD_TAG];
                if (hud != nil) {
                    [hud removeFromSuperview];
                }
                
                hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                hud.tag = CURRENT_LOADING_PROGRESSHUD_TAG;
                
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                
                if ([NSString isValidateString:message]) {
                    hud.label.text = message;
                }

            });
        }
    }
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view location:(MBProgressHUDLocation)location {
    [self showMessage:message toView:view location:location longTime:NO];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view location:(MBProgressHUDLocation)location longTime:(BOOL)isLongTime {
    if (![NSString isValidateString:message]) {
        return;
    }
    
    @autoreleasepool {
        if (view == nil) {
            view = [self lastWindow];
        }
        
        if ([[NSThread currentThread] isMainThread]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.location = location;
            hud.label.text = message;
            // Move to bottm center.
            if (location == MBProgressHUDLocationTop) {
                hud.offset = CGPointMake(0, 64);
            } else if (location == MBProgressHUDLocationCenter) {
                hud.offset = CGPointMake(0, 0);
            } else {
                hud.offset = CGPointMake(0, -60);
            }
            
            CGFloat time = 0.6f;
            if (message.length >= 10) {
                time = 1.2f;
            }
            
            if (isLongTime) {
                time = 2.0f;
            }
            
            [hud hideAnimated:YES afterDelay:time];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.location = location;
                hud.label.text = message;
                // Move to bottm center.
                if (location == MBProgressHUDLocationTop) {
                    hud.offset = CGPointMake(0, 64);
                } else if (location == MBProgressHUDLocationCenter) {
                    hud.offset = CGPointMake(0, 0);
                } else {
                    hud.offset = CGPointMake(0, -60);
                }
                
                CGFloat time = 0.6f;
                if (message.length >= 10) {
                    time = 1.2f;
                } 
                
                if (isLongTime) {
                    time = 2.0f;
                }
                
                [hud hideAnimated:YES afterDelay:time];
            });
        }
    }
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD {
    if ([[NSThread currentThread] isMainThread]) {
        [self hideHUDForView:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUDForView:nil];
        });
    }
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        view = [MBProgressHUD lastWindow];
    }
    if ([[NSThread currentThread] isMainThread]) {
        [self hideHUDForView:view animated:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUDForView:view animated:YES];
        });
    }
}

@end
