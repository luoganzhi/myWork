//
//  D5ToastViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/12/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ToastViewController.h"

@interface D5ToastViewController ()

@end

@implementation D5ToastViewController
static D5ToastViewController *instance = nil;

+ (instancetype)shareView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil].instantiateInitialViewController;
    });
    return instance;
}

- (IBAction)leftBtnClick:(id)sender {
    [instance hideView];
    if (self.leftBtnClickBlock) {
        self.leftBtnClickBlock();
    }
}

- (IBAction)rightBtnClick:(id)sender {
    [instance hideView];
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock();
    }
}

- (void)showView{
    [[UIApplication sharedApplication].keyWindow addSubview:instance.view];
}

- (void)hideView{
    [instance.view removeFromSuperview];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)setLabelWithTitle:(NSString *)title LeftBtn:(NSString *)left RightBtn:(NSString *)right{
    
    [self.view layoutSubviews];
    instance.mainLabel.text = title ? title : @"是否取消";
    
    if (left) {
        [instance.leftButton setTitle:left forState:UIControlStateNormal];
    } else {
        [instance.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    
    if (right) {
        [instance.rightButton setTitle:right forState:UIControlStateNormal];
    }else {
        [instance.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}

@end
