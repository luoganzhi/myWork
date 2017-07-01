//
//  D5ZKTSettingViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/15.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ZKTSettingViewController.h"
#import "D5LightGroupManagerViewController.h"
#import "D5AlarmSettingViewController.h"
#import "D5MultiLightFollowViewController.h"
//#import "YWFeedbackFMWK/YWFeedbackKit.h"
//#import "YWFeedbackFMWK/YWFeedbackViewController.h"
#import "TWMessageBarManager.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import "AppDelegate.h"
#import "D5CheckUpdate.h"
#import "D5WebViewController.h"
#import "D5ConnectedManngerViewController.h"

#define USE_GUIDE_HTML  @"zhinan"
#define Connected_Mannger @"ConnectedMannger"
/**
 *  修改为你自己的appkey。
 *  同时，也需要替换yw_1222.jpg这个安全图片。
 */
static NSString * const kAppKey = @"23552936";

@interface D5ZKTSettingViewController() <UITableViewDelegate, UIGestureRecognizerDelegate, D5LedListDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@end

@implementation D5ZKTSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self initView];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    [D5LedList sharedInstance].delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: WHITE_COLOR};
    UITableView *tableView = [[_containerView subviews] objectAtIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
}

- (void)judgeNeedShowUpdateByLedList:(D5LedList *)list {
    @autoreleasepool {
        BOOL allOffline = list.allOffline;
        
        NSArray *array = list.addedLedList;
        BOOL hasLight = (array && array.count > 0);
        
        [self isNeedShowUpdateBy:allOffline hasLight:hasLight];
    }
}

- (void)ledList:(D5LedList *)list getFinished:(BOOL)isFinished {
    if (isFinished) {
        [self judgeNeedShowUpdateByLedList:list];
    }
}

- (void)viewDidDisappear:(BOOL)animated  {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.pushSuggest = NO;
    
}

#pragma mark - 初始化
- (void)initView {
    self.title = @"设置";
    UIImage *image=[UIImage imageNamed:@"back.png"];
    [D5BarItem setLeftBarItemWithImage:image target:self action:@selector(popVC)];

    
    @autoreleasepool {
        UITableView *tableView = [[_containerView subviews] objectAtIndex:0];
        tableView.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self judgeNeedShowUpdateByLedList:[D5LedList sharedInstance]];       // 检查更新完成
}

- (UIImageView *)getBoxImage {
    @autoreleasepool {
        UITableView *tableView = [[_containerView subviews] objectAtIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:1];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        UIImageView *image = (UIImageView *)[cell viewWithTag:3333];
        return image;
    }
}

- (UIImageView *)getAppImage {
    @autoreleasepool {
        UITableView *tableView = [[_containerView subviews] objectAtIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:2];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        UIImageView *image = (UIImageView *)[cell viewWithTag:3334];
        return image;
    }
}

- (void)showAPPRedPointByIsNeed:(BOOL)isNeed {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *appImage = [self getAppImage];
        BOOL hide = (!isNeed || [[NSUserDefaults standardUserDefaults] boolForKey:SHOW_UPDATE_APP_RED_POINT]);
        appImage.hidden = hide;
    });
}

- (void)showBoxRedPointByIsNeed:(BOOL)isNeed {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *boxImage = [self getBoxImage];
        NSString *currentBoxKey = [NSString stringWithFormat:@"%@_%@", SHOW_UPDATE_BOX_RED_POINT, [D5CurrentBox currentBoxId]];
        BOOL isClicked = [[NSUserDefaults standardUserDefaults]  boolForKey:currentBoxKey];
        boxImage.hidden =  (!isNeed || isClicked);
    });
}

- (void)isNeedShowUpdateBy:(BOOL)allOffline hasLight:(BOOL)hasLight {
    @autoreleasepool {
        D5CheckUpdate *check = [D5CheckUpdate sharedInstance];
        
        if (check.appStatus == CheckUpdateStatusIng) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAppFinish:) name:CHECK_UPDATE_APP_FINISH_PUSH_NAME object:nil];
        } else {
            D5UpdateModel *appUpdate = check.appUpdate;
            BOOL isNeed = NO;
            if (appUpdate) {
                isNeed = appUpdate.isNeedUpdate;
            }
            [self showAPPRedPointByIsNeed:isNeed];
        }
        
        
        BOOL isNeedBox = NO;
        if (check.boxStatus == CheckUpdateStatusIng) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBoxFinish:) name:CHECK_UPDATE_BOX_FINISH_PUSH_NAME object:nil];
        } else {
            D5UpdateModel *boxUpdate = check.boxUpdate;
            if (boxUpdate) {
                isNeedBox = boxUpdate.isNeedUpdate;
            }
        }
        
        BOOL isNeedBt = NO;
        if (allOffline || !hasLight) {
            [self showBoxRedPointByIsNeed:(isNeedBox || isNeedBt)];
            return;
        }
        
        if (check.btStatus == CheckUpdateStatusIng) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBtFinish:) name:CHECK_UPDATE_BT_FINISH_PUSH_NAME object:nil];
        } else {
            D5UpdateModel *bluetoothUpdate = check.bluetoothUpdate;
            if (bluetoothUpdate) {
                isNeedBt = bluetoothUpdate.isNeedUpdate;
            }
            [self showBoxRedPointByIsNeed:(isNeedBox || isNeedBt)];
        }
    }
}

- (void)checkAppFinish:(NSNotification *)notificaiton {
    @autoreleasepool {
        NSDictionary *dict = notificaiton.userInfo;
        BOOL isNeed = [dict[CHECK_UPDATE_ISNEED] boolValue];
        [self showAPPRedPointByIsNeed:isNeed];
    }
}

- (void)checkBoxFinish:(NSNotification *)notificaiton {
    @autoreleasepool {
        NSDictionary *dict = notificaiton.userInfo;
        BOOL isNeed = [dict[CHECK_UPDATE_ISNEED] boolValue];
        if (!isNeed) {  // 不需要更新,则看蓝牙是否需要更新
            D5UpdateModel *bluetoothUpdate = [D5CheckUpdate sharedInstance].bluetoothUpdate;
            if (bluetoothUpdate) {
                isNeed = bluetoothUpdate.isNeedUpdate;
            }
        }
        [self showBoxRedPointByIsNeed:isNeed];
    }
}

- (void)checkBtFinish:(NSNotification *)notificaiton {
    @autoreleasepool {
        NSDictionary *dict = notificaiton.userInfo;
        BOOL isNeed = [dict[CHECK_UPDATE_ISNEED] boolValue];
        if (!isNeed) {  // 不需要更新,则看中控盒子是否需要更新
            D5UpdateModel *boxUpdate = [D5CheckUpdate sharedInstance].boxUpdate;
            if (boxUpdate) {
                isNeed = boxUpdate.isNeedUpdate;
            }
        }
        [self showBoxRedPointByIsNeed:isNeed];
    }
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.pushSuggest = NO;

}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (row == 8) {
        // 删除中控
        [self.navigationController popViewControllerAnimated:YES];
    } else if (section == 1) {
        if (row == 0) {
            [self pushToLightGroupManagerVC];
        } else if (row == 1) {
            [self pushToConnectedMannger];
        }
    } else if (section == 0) {
        if (row == 0) {
            [self pushAlarmSettingVC];
        } else if (row == 1) {
            [self pushMultilightFollowVC];
        }
    } else if (section == 2) { // 意见反馈
        if (row == 0) {
            [self pushToUseGuideVC];
        } else if (row == 1) {
            
            if (delegate.pushSuggest) return;
            delegate.pushSuggest = YES;
            
            [self openFeedbackViewController];
        }
    }
    
    // 取消红点
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentBoxKey = [NSString stringWithFormat:@"%@_%@", SHOW_UPDATE_BOX_RED_POINT, [D5CurrentBox currentBoxId]];
    if (section == 1 && row == 1) {
        [userDefaults setObject:@(YES) forKey:currentBoxKey];
    } else if (section == 2 && row == 2) {
        [userDefaults setObject:@(YES) forKey:SHOW_UPDATE_APP_RED_POINT];
    }
    [userDefaults synchronize];
}

#pragma mark - 跳转事件

- (void)pushToConnectedMannger {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"D5ConnectedManngerViewController" bundle:nil];
    
    D5ConnectedManngerViewController *vc = [sb instantiateViewControllerWithIdentifier:Connected_Mannger];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)pushAlarmSettingVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:ALARMSETTING_STORYBOARD_ID bundle:nil];
        D5AlarmSettingViewController *alarmSettingVC = [sb instantiateViewControllerWithIdentifier:ALARMSETTING_VC_ID];
        if (alarmSettingVC) {
            [self.navigationController pushViewController:alarmSettingVC animated:YES];
        }
    }
}

- (void)pushMultilightFollowVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:MULTILIGHTFOLLOW_STORYBOARD_ID bundle:nil];
        D5MultiLightFollowViewController *multiLightVC = [sb instantiateViewControllerWithIdentifier:MULTILIGHT_FOLLOW_VC_ID];
        if (multiLightVC) {
            [self.navigationController pushViewController:multiLightVC animated:YES];
        }
    
    }
}

- (void)pushToUseGuideVC {
    @autoreleasepool {
        D5WebViewController *webVC = [[UIStoryboard storyboardWithName:@"Web" bundle:nil] instantiateViewControllerWithIdentifier:WEB_VC_ID];
        if (webVC) {
            webVC.titleStr = @"使用指南";
            webVC.htmlFileName = USE_GUIDE_HTML;
            webVC.url = USE_GUIDE_URL;
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (void)pushToLightGroupManagerVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:LIGHTGROUP_STORYBOARD_ID bundle:nil];
        D5LightGroupManagerViewController *managerVC = [sb instantiateViewControllerWithIdentifier:LIGHT_GROUP_MANAGER_VC_ID];
        if (managerVC) {
            managerVC.from = PushFromSetting;
            [self.navigationController pushViewController:managerVC animated:YES];
        }
    }
}

#pragma mark - methods
/** 打开用户反馈页面 */
- (void)openFeedbackViewController {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
    self.feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"登陆->关于->反馈",
                                 @"userid":@"yourid",
                                 @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
    //  初始化方式,或者参考下方的`- (YWFeedbackKit *)feedbackKit`方法。
    __weak typeof(self) weakSelf = self;

    
    
    [weakSelf.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {

        if (viewController != nil) {
            [weakSelf.navigationController pushViewController:viewController animated:YES];
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
            
            
//            UIView *nav_back = [weakSelf.navigationController.navigationBar.subviews objectAtIndex:2];
//            if ([nav_back isKindOfClass:NSClassFromString(@"UINavigationItemButtonView")]) {
//                nav_back.userInteractionEnabled = YES;
//                // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
//                // [nav_back addGestureRecognizer:tap];
//                UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(-(image.frame.size.width / 2), -(image.frame.size.height / 2), image.frame.size.width * 2, image.frame.size.height * 2)];
//                [backButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
//                [nav_back addSubview:backButton];
//
//            }
            
//            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(-(image.frame.size.width / 2), -(image.frame.size.height / 2), image.frame.size.width * 2, image.frame.size.height * 2)];
//            [btn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
//            [image addSubview:btn];
//            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:image];
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
            
            viewController.navigationItem.leftBarButtonItem = item;
            viewController.navigationItem.backBarButtonItem = nil;

            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [weakSelf.navigationController popViewControllerAnimated:YES];
                delegate.pushSuggest = NO;
            }];
        } else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            NSString *title = [error.userInfo objectForKey:@"msg"] ?  : @"接口调用失败，请保持网络通畅！";
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:nil
                                                                  type:TWMessageBarMessageTypeError];
        }
    }];
    
}



@end
