//
//  D5UploadSuccessView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5UploadSuccessView.h"
#import "D5UploadingView.h"
#import "D5UploadFailedView.h"
#import "D5MoubileTanslateSongsController.h"
#import "D5TFOrUsbViewController.h"

static D5UploadSuccessView *instance = nil;

@implementation D5UploadSuccessView

#pragma mark - 实例化
+ (instancetype)sharedUploadSuccessView {
    @autoreleasepool {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            instance.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        });
        return instance;
    }
}

- (void)showView {
    @autoreleasepool {
        NSArray *childVCs = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        if (childVCs && childVCs.count > 0) {
            UIViewController *vc = [childVCs lastObject];
            if (vc && ([vc isKindOfClass:[D5MoubileTanslateSongsController class]] || [vc isKindOfClass:[D5TFOrUsbViewController class]])) {
                [super showView];
            }        }
    }
}

@end
