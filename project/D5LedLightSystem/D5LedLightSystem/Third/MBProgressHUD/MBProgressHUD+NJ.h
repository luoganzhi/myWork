//
//  MBProgressHUD+NJ.h
//  NJWisdomCard
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (NJ)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message longTime:(BOOL)isLongTime;
+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showMessage:(NSString *)message toView:(UIView *)view longTime:(BOOL)isLongTime;
+ (void)showMessage:(NSString *)message toView:(UIView *)view location:(MBProgressHUDLocation)location longTime:(BOOL)isLongTime;
+ (void)showMessage:(NSString *)message toView:(UIView *)view location:(MBProgressHUDLocation)location;

+ (void)showLoading:(NSString *)message;
+ (void)showLoading:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
