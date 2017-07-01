//
//  D5HLedReachability.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5HLedReachability.h"
#import "D5ConnectZKTViewController.h"
#import "D5DisconnectTipView.h"

@interface D5HLedReachability()

@property(strong) Reachability * googleReach;
@property(strong) Reachability * localWiFiReach;
@property(strong) Reachability * internetConnectionReach;
//@property(nonatomic,strong)D5AlertDisconnectController *alertVC;


@end
//static //
@implementation D5HLedReachability

//-(D5AlertDisconnectController*)alertVC
//{
//    if (_alertVC==nil) {
//        
//        UIStoryboard*storyBoad=[UIStoryboard storyboardWithName:@"Loading" bundle:nil];
//        _alertVC=[storyBoad instantiateViewControllerWithIdentifier:AlertDisconnectVC];
//    }
//    return _alertVC;
//    
//}
//- (void)showConnectAlert {
//    if ([[UIApplication sharedApplication].keyWindow.rootViewController.view.subviews containsObject:self.alertVC.view] || [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0] isKindOfClass:[D5ConnectZKTViewController class]]) {
//        return;
//        
//    }
//    [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:self.alertVC];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.alertVC.view];
//    
//}


+(id)shareReachability
{
    static dispatch_once_t once;
    static D5HLedReachability*obj;
    dispatch_once(&once, ^{
        
        obj=[[D5HLedReachability alloc]init];
    });
    return obj;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startNoti {
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.localWiFiReach = [Reachability reachabilityForLocalWiFi];
    BOOL isResult = [self.localWiFiReach isReachableViaWiFi];
    
    
    if (YES == isResult) {
        DLog(@"WiFi可以使用");

    } else {
        DLog(@"WiFi不可以使用");

    }
    
    // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable connectivity
    self.localWiFiReach.reachableOnWWAN = NO;
    [self.localWiFiReach startNotifier];
    
    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    BOOL isUsenetworking = [self.internetConnectionReach isReachable];
    
    if (YES == isUsenetworking) {
       DLog(@"当前网络可以使用");
    } else {
        DLog(@"当前网络不可以使用");
        dispatch_async(dispatch_get_main_queue(), ^{
             [[D5DisconnectTipView sharedDisconnectTipView] showView];
        });

    }
    [self.internetConnectionReach startNotifier];
}

+(BOOL)isWifiCanUse
{
    return [[Reachability reachabilityForLocalWiFi] isReachableViaWiFi];
}

- (void)reachabilityChanged:(NSNotification*)note {
    Reachability *reach = [note object];
    
    NetworkStatus netStatus =  [reach currentReachabilityStatus];
    DLog(@"wifi netStatus = %d", (int)netStatus);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_STATUS_CHANGED object:nil]; // userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:netStatus], NETWORK_TYPE, nil]
    });
    
    if (reach == self.localWiFiReach) {
        if ([reach isReachable]) {  //WiFi状态被切换为打开
            DLog(@"WiFi状态被切换为打开");
        } else { //WiFi状态被切换为关闭
            DLog(@"WiFi状态被切换为关闭");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[D5DisconnectTipView sharedDisconnectTipView] showView];
            });
        }
    } else if (reach == self.internetConnectionReach) {
        if ([reach isReachable]) {
            DLog(@"网络状态被切换为可以使用");
//            [self.alertVC removeFromParentViewController];
//            [self.alertVC.view removeFromSuperview];
//            self.alertVC = nil;
            
        } else {
            DLog(@"网络状态被切换为不可以使用");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[D5DisconnectTipView sharedDisconnectTipView] showView];
            });

        }
    }
    
}

@end
