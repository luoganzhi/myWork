//
//  D5AlertDisconnectController.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/10/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AlertDisconnectVC  @"D5AlertDisconnectController"
@interface D5AlertDisconnectController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *regainConnet;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (weak, nonatomic) IBOutlet UILabel *connectStatus;

- (IBAction)reConnect:(UIButton *)sender;
-(void)removeView;
@end
