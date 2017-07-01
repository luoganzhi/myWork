//
//  D5loadingViewController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/29.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5UploadFileViewController.h"


@implementation D5UploadFileViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (IBAction)tap:(id)sender {
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self startRotateForImg:_imageView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopRotateForImg:_imageView];
}

//设置进度条
-(void)initView
{
    self.progressView3.tintColor =[UIColor colorWithRed:6/255.0 green:152.0/255.0 blue:137.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    self.progressView3.centralView = label;
    [label setFont:[UIFont systemFontOfSize:11]];
    
    self.progressView3.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
        NSString*formate=(progress == 1.0) ? @"%d%%":@"%.1f%%";
        
        if (progress == 1.0) {
            [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:formate, (int)progress * 100]];
        }else
        {
            [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:formate, (float)progress * 100]];
        }
        
    };
    

    

}
//显示上传进度view
-(void)show:(UIViewController*)vc
{
    [vc.navigationController.view insertSubview:self.view atIndex:vc.view.subviews.count];
}
//删除上传进度view
-(void)hiden
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    

}
@end
