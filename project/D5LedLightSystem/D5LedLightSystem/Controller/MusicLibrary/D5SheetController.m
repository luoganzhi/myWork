//
//  D5SheetController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SheetController.h"

#define SHEET_HEIGHT 133 //sheet的高度
#define SHEET_ANIMATION_TIME  0.5f // 弹出动画时间

@implementation D5SheetController

#pragma  mark -- 用户交互

- (IBAction)mobileAction:(id)sender {
    
    [self hideAnimation:YES];
    _mobileTranslate();
    
    
}
- (IBAction)pcAction:(id)sender {
    [self hideAnimation:YES];
    _pcTranslate();
    
}
- (IBAction)usbAction:(id)sender {
    [self hideAnimation:YES];
    _usbTfTranslate();
}


#pragma  mark -- public 方法
-(void)setAnimation:(UIViewController*)vc animation:(BOOL)animation;

{
    float interval = (YES == animation) ? SHEET_ANIMATION_TIME : 0;
    
//    [self.buttomView setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, SHEET_HEIGHT)];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:interval animations:^{
        
//        [self.buttomView setFrame:CGRectMake(0, MainScreenHeight-SHEET_HEIGHT, MainScreenWidth, SHEET_HEIGHT)];
        [vc.navigationController.view addSubview:weakSelf.view];
    }];
    
    
}

-(void)hideAnimation:(BOOL)animation
{
    float interval =(YES == animation) ? SHEET_ANIMATION_TIME : 0;
    
//    [self.buttomView setFrame:CGRectMake(0, MainScreenHeight-SHEET_HEIGHT, MainScreenWidth, SHEET_HEIGHT)];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:interval animations:^{
//        [self.buttomView setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, SHEET_HEIGHT)];
//        
        [weakSelf removeFromParentViewController];
        [weakSelf.view removeFromSuperview];
        
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //除了sheet的view添加手势
    UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.topview addGestureRecognizer:gesture];
    

}
#pragma  mark --私有方法

-(void)tap
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

}

@end
