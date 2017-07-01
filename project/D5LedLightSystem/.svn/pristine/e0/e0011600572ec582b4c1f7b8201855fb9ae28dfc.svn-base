//
//  D5WarningViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2017/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5WarningViewController.h"

@interface D5WarningViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation D5WarningViewController
static D5WarningViewController *instance = nil;


- (void)viewDidLoad {
    [super viewDidLoad];

}

+ (instancetype)warningView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil].instantiateInitialViewController;
    });
    return instance;

}

- (void)showView
{
    [instance.view removeFromSuperview];

    [[UIApplication sharedApplication].keyWindow addSubview:instance.view];

}

- (void)hideView
{
    [instance.view removeFromSuperview];
}


- (IBAction)sureBtnClikc:(id)sender {
    [self hideView];
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.btnClickBlock) {
        weakSelf.btnClickBlock();
    }
}

@end
