//
//  AppDelegate.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "AppDelegate.h"
#import "D5HLedReachability.h"
#import "D5HLocalMusicList.h"
#import "D5LedZKTList.h"
#import "D5TcpManager.h"
#import "D5HLedReachability.h"
#import "D5ConnectZKTViewController.h"
#import "UIWindow+D5Helper.h"
#import "D5PrepareConnectViewController.h"
#import "D5ConnectedViewController.h"
#import "D5DisconnectTipView.h"
#import "D5loadingViewController.h"
#import "D5UploadingView.h"
#import "D5UploadFailedView.h"
#import "D5UploadSuccessView.h"
#import "D5DeviceInfo.h"
#import <Bugly/Bugly.h>
#import "D5HJMusicDownloadList.h"
#import "RealReachability.h"
#import "D5RuntimeShareInstance.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bugly startWithAppId:BUGLY_APPID];
    
    //友盟
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UMKEY;
    UMConfigInstance.channelId = @"Develop";
  
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];
    [MobClick setLogEnabled:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[D5LedZKTList defaultList] connectLocalZKT];
        [[D5HLedReachability shareReachability] startNoti];
    });
    
    [D5DisconnectTipView sharedDisconnectTipView];
    [D5UploadingView sharedUploadingView];
    [D5UploadFailedView sharedUploadFailedView];
    [D5UploadSuccessView sharedUploadSuccessView];
    
    [D5RuntimeShareInstance sharedInstance];
    
    self.isNeedRefresh = NO;
    self.isChangeWifiOrWired = NO;
    
       return YES;
}

- (void)networkChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    

    if ([D5DisconnectTipView sharedDisconnectTipView].isShow) {
        return;
    }
    [[D5LedCommunication sharedLedModule] tcpConnect:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

//程序退出保存数据
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [[D5HJMusicDownloadList shareInstance]saveData];
    NSLog(@"程序进入后台");
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //DLog(@"register the push service error:%@",error.description);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    @autoreleasepool {
        NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
        NSString *dt = [[[token stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *oldToken = [D5LedInitialInfoData sharedLedInitialInfoData].deviceToken;
        if (![NSString isValidateString:oldToken] || ![oldToken isEqualToString:dt]) {
//            //DLog(@"不一样再存");
            [[D5LedInitialInfoData sharedLedInitialInfoData] setDeviceToken:dt];
            [[D5LedInitialInfoData sharedLedInitialInfoData] saveInfo];
            
//            //DLog(@"D5LedInitialInfoData = %@", [D5LedInitialInfoData sharedLedInitialInfoData]);
        }
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    //DLog(@"local notification:%@", notification);
}

#pragma mark - local and push notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
}

@end
