//
//  D5ModelViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ModelViewController.h"
#import "MyButton.h"

@implementation D5ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden:YES];
    [self.view layoutIfNeeded];
    _topBtnTopMargin.constant = CGRectGetMaxY(self.view.frame) - 300;
    _btnIndoor.alpha = 0;
    _btnSweet.alpha = 0;
    _btnRelax.alpha = 0;
    _btnCinema.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    CGFloat value = CGRectGetHeight(self.view.frame) / 5;
    
    [UIView animateWithDuration:0.3f animations:^{
        _btnIndoor.alpha = 1;
        _btnSweet.alpha = 1;
        _btnRelax.alpha = 1;
        _btnCinema.alpha = 1;
        
        _topBtnTopMargin.constant = value - 20;
        
        [_btnIndoor layoutIfNeeded];
        [_btnSweet layoutIfNeeded];
        [_btnRelax layoutIfNeeded];
        [_btnCinema layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            _topBtnTopMargin.constant = value + 20;
            
            [_btnIndoor layoutIfNeeded];
            [_btnSweet layoutIfNeeded];
            [_btnRelax layoutIfNeeded];
            [_btnCinema layoutIfNeeded];
        }];
    }];
}

- (void)setNavigationBarHidden:(BOOL)isHide {
    [self.navigationController setNavigationBarHidden:isHide animated:NO];
}

- (IBAction)btnCloseClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
