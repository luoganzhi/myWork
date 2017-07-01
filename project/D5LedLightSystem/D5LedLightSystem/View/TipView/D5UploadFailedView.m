//
//  D5UploadFailedView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5UploadFailedView.h"
#import "D5UploadingView.h"
#import "D5UploadSuccessView.h"
#import "D5MoubileTanslateSongsController.h"

#import "D5TFOrUsbViewController.h"


static D5UploadFailedView *instance = nil;

@interface D5UploadFailedView() {
    Class _oldClass;
}

/** 上传失败 */
@property (weak, nonatomic) IBOutlet UIButton *btnReUpload;
- (IBAction)btnReUploadClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCancelUpload;
- (IBAction)btnCancelUploadClicked:(UIButton *)sender;
@end

@implementation D5UploadFailedView

#pragma mark - 检查和设置代理
- (void)setDelegate:(id<D5UploadFailedViewDelegate>)delegate {
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

- (BOOL)checkDelegate {
    if (!_delegate) {
        return NO;
    }
    
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == _oldClass);
}

- (void)layoutSubviews {
    [self addLineToBtn:_btnReUpload];
    [self addLineToBtn:_btnCancelUpload];
}

+ (instancetype)sharedUploadFailedView {
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

- (void)btnReUploadClicked:(UIButton *)sender {
    [self hideTipView];
    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(uploadViewReUpload:)]) {
        [_delegate uploadViewReUpload:self];
    }
}

- (void)showView {
    @autoreleasepool {
        NSArray *childVCs = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        if (childVCs && childVCs.count > 0) {
            UIViewController *vc = [childVCs lastObject];
            if (vc && ([vc isKindOfClass:[D5MoubileTanslateSongsController class]] || [vc isKindOfClass:[D5TFOrUsbViewController class]])) {
                [super showView];
            }
        }
    }
}

- (IBAction)btnCancelUploadClicked:(UIButton *)sender {
    [self hideTipView];
}
@end
