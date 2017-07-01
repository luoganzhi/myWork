//
//  D5LightViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LightViewController.h"
#import "D5NewManualViewController.h"
#import "D5SpecialController.h"
@interface D5LightViewController ()<D5LedCmdDelegate, D5LedNetWorkErrorDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIView *lightView;
@property (weak, nonatomic) IBOutlet UIView *scenceView;
@property (weak, nonatomic) IBOutlet UIView *specialView;
@property (weak, nonatomic) IBOutlet UIView *handView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewConstraint;

@property(strong,nonatomic)  D5NewManualViewController *manualVC;
@end

@implementation D5LightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = (UIButton *)[self.toolView  viewWithTag:1001];
    
    if ([[btn class] isSubclassOfClass:[UIButton class]]){

        [self toolBtnClick:btn];
    }

     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideTitleView:) name:@"ManualScreen" object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.handView.hidden == NO) {
        UIButton *btn = (UIButton *)[self.toolView viewWithTag:1004];
        if ([[btn class] isSubclassOfClass:[UIButton class]] && btn.tag == 1004) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewManualClick" object:nil];
            });

        } else if ([[btn class] isSubclassOfClass:[UIButton class]] && btn.tag == 1001) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LightClick" object:nil];
            });
        }
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)toolBtnClick:(UIButton *)sender {

    for (UIButton *btn in self.toolView.subviews) {
        if ([[btn class] isSubclassOfClass:[UIButton class]]){
 
            btn.selected = NO;
        }

    }
    
    sender.selected = YES;
    [self setChildViewHiddenWithTag:sender.tag];
    
    if (sender.tag == 1004) {
        [self.view layoutIfNeeded];
        [self.handView insertSubview:self.manualVC.view atIndex:self.view.subviews.count];
    } else {
        [self.manualVC.view removeFromSuperview];
        
//        if (self.manualVC.isOpenManualMode) {
//            [[D5ManualMode sharedInstance] setManualMode:NO];
//        }
    }
    
    if (sender.tag == 1003) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickSpecial" object:nil];
        });
    }
    
    
}

-(CGFloat)getToolViewHeight
{

    [self.view layoutIfNeeded];
    return self.toolView.bounds.size.height;
}

-(D5NewManualViewController*)manualVC
{
    //顶部菜单选项卡的高度
    [self.view layoutIfNeeded];
    float toolViewHeight=[self getToolViewHeight];
    
    if (_manualVC==nil) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:MANUAL_STORYBOARD_ID bundle:nil];
        
        _manualVC = [sb instantiateViewControllerWithIdentifier:NewManualVC];
    }
    [_manualVC.view setFrame:CGRectMake(0.0f, 0.0f, MainScreenWidth, MainScreenHeight+toolViewHeight)];
//    _manualVC.delegate=self;
    return _manualVC;

}


-(void)hideTitleView:(NSNotification*)noti
{
    
    float result=[noti.object floatValue];

    if (result<0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.toolView  setFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
            [self.toolView setHidden:NO];
        });
    }
    
    
}

-(void)didScrollViewFrame:(CGFloat)currentOffsetY;
{
    if (currentOffsetY > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            float toolHeight=[self getToolViewHeight];

            self.handView.frame = CGRectMake(0, -toolHeight, MainScreenWidth, MainScreenHeight);
            self.toolView.alpha = 0;
          NSNumber *number=  [NSNumber numberWithFloat:currentOffsetY/2.0];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ManualScreen" object:number];
            });
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            float toolHeight=[self getToolViewHeight];

            self.handView.frame = CGRectMake(0, toolHeight, MainScreenWidth, MainScreenHeight);
            self.toolView.alpha = 1;
            NSNumber *number=  [NSNumber numberWithFloat:currentOffsetY/2.0];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ManualScreen" object:number];
            });
        }];
    }
    
}
-(void)willBeginDraggingViewFrame:(CGFloat)currentOffsetY;
{

}
-(void)didEndDraggingViewFrame:(CGFloat)currentOffsetY;
{

}


- (void)setChildViewHiddenWithTag:(NSInteger)tag
{
    self.lightView.hidden = (tag == 1001) ? NO : YES;
    self.scenceView.hidden = (tag == 1002) ? NO : YES;
    self.specialView.hidden = (tag == 1003) ? NO : YES;
    self.handView.hidden = (tag == 1004) ? NO : YES;


}

#pragma mark - <D5LedCmdDelegate>
- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header
{
    
}


@end
