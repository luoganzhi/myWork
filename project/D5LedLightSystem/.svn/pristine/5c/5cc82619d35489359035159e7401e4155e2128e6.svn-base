//
//  D5LoadingViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LoadingViewController.h"
#import "D5ConnectZKTViewController.h"
#import "D5LightGroupManagerViewController.h"
#import "AppDelegate.h"
#import "D5FileModules.h"
#import "D5MainViewController.h"

#define IS_OPENED_APP @"isOpenedApp"
#define APP_VERSION @"appVersion"

@interface D5LoadingViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation D5LoadingViewController

- (void)viewDidLoad {
//    [self setStatusBarStyle:UIBarStyleBlack];
    [super viewDidLoad];
    
//    [self initView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setStatusBarStyle:UIBarStyleBlack];

    [super viewWillAppear:animated];
    [self initView];

}

- (void)initView {
    @autoreleasepool {
        [self checkVersion];
        [self setNavigationBarTranslucent];
        
        [self.indicator startAnimating];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.indicator stopAnimating];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - check version
- (void)checkVersion {
    @autoreleasepool {
        NSString *nowVersion = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:APP_VERSION];
        if (![NSString isValidateString:lastVersion] || ![lastVersion isEqualToString:nowVersion] ) {
            [[NSUserDefaults standardUserDefaults] setObject:nowVersion forKey:APP_VERSION];
        }
        [self getBoxInfoFromLocal];
    }
}

#pragma mark - 获取中控盒子信息
- (void)getBoxInfoFromLocal {
    @autoreleasepool {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *localZKT = [userDefaults objectForKey:SELECTED_ZKT_KEY];

        if (!localZKT) { //没有中控盒子 -->进入连接中控界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self pushToConnectVC];
            });
            return;
        }

         //有中控 -- 是否设置过灯组编号
        BOOL isSetNO = [userDefaults boolForKey:LIGHTGROUP_SET_NO];
        if (!isSetNO) { //没设置过
            dispatch_async(dispatch_get_main_queue(), ^{
                [self pushToLightManagerVC];
            });
            return;
        }

        //+ 注意：上次选择的中控是否存在中控列表中 进入主界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self goMainVC];
        });
    }
}

#pragma mark - 跳转到界面
- (void)pushToConnectVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:ZKTSOFTWARE_STORYBOARD_ID bundle:nil];
        D5ConnectZKTViewController *connectZKTVC = [sb instantiateViewControllerWithIdentifier:CONNECT_ZKT_VC_ID];
        if (connectZKTVC) {
            [self.navigationController pushViewController:connectZKTVC animated:YES];
        }
    }
}

- (void)pushToLightManagerVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:LIGHTGROUP_STORYBOARD_ID bundle:nil];
        D5LightGroupManagerViewController *managerVC = [sb instantiateViewControllerWithIdentifier:LIGHT_GROUP_MANAGER_VC_ID];
        if (managerVC) {
            [self.navigationController pushViewController:managerVC animated:YES];
        }
    }
}

#pragma mark - go main 如果本来就在主界面  则不再跳转
- (void)goMainVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:MAIN_STORYBOARD_ID bundle:nil];
//
        D5MainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"123"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
