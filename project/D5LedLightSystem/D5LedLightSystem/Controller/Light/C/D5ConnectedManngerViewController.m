//
//  D5ConnectedManngerViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2017/2/10.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5ConnectedManngerViewController.h"
#import "D5WiredController.h"
#import "D5WifiConnectedController.h"
#import "D5NoConnectedViewController.h"

#define ConnectManngerHelp @"帮助"

#define WiredStoryboardVc @"WiredStoryboard"
#define WifiStoryboardVc @"WifiStoryboard"
#define NoConnectedStoryboardVc @"NoConnectedStoryboard"
@interface D5ConnectedManngerViewController ()

/** wiredVC */
@property (nonatomic, strong) D5WiredController *wiredVC;

/** wifiVC */
@property (nonatomic, strong) D5WifiConnectedController *wifiVC;

/** noConnectedVC */
@property (nonatomic, strong) D5NoConnectedViewController *noConnectedVC;

@end

@implementation D5ConnectedManngerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

    self.title = @"连接管理";
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wiredOrWifiView) name:SETBOXINFO object:nil];
    


}

- (void)wiredOrWifiView
{
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.wiredVC.view removeFromSuperview];
        [self.wifiVC.view removeFromSuperview];
        [self.noConnectedVC.view removeFromSuperview];
        self.noConnectedVC = nil;
        self.wifiVC = nil;
        self.wiredVC = nil;
        [self initView];
    });
}

- (D5WiredController *)wiredVC
{
    if (!_wiredVC) {
        _wiredVC = [self.storyboard instantiateViewControllerWithIdentifier:WiredStoryboardVc];
        _wiredVC.view.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64);
    }
    return _wiredVC;
}


- (D5WifiConnectedController *)wifiVC
{
    if (!_wifiVC) {
        _wifiVC = [self.storyboard instantiateViewControllerWithIdentifier:WifiStoryboardVc];
        _wifiVC.view.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64);
    }
    return _wifiVC;
}

- (D5NoConnectedViewController *)noConnectedVC
{
    if (!_noConnectedVC) {
        _noConnectedVC = [self.storyboard instantiateViewControllerWithIdentifier:NoConnectedStoryboardVc];
        _noConnectedVC.view.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64);
    }
    return _noConnectedVC;
}


- (void)initView{
       D5DeviceInfo *deviceInfo = [D5CurrentBox currentBoxDeviceInfo];
    switch (deviceInfo.connectType) {
        case NetConnectTypeWIFI:   // 无线连接
            [self addConnectWIFI];
            break;
            
        case NetConnectTypeWired:  // 有线连接
            
            [self addConncetWired];
            break;
            
        default:
            
            [self addNoConnected];
            break;
    }
}

#pragma mark - 页面跳转
- (void)addConnectWIFI // 无线界面
{
    if (self.wifiVC) {
        [self.view addSubview:self.wifiVC.view];
    }
}

- (void)addConncetWired // 有线界面
{
    if (self.wiredVC) {
        [self.view addSubview:self.wiredVC.view];
    }
}

- (void)addNoConnected
{
    if (self.noConnectedVC) {
        [self.view addSubview:self.noConnectedVC.view];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end