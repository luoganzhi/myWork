//
//  D5NetWork.h
//  D5Home_new
//
//  Created by PangDou on 16/1/7.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "D5Socket.h"
#import "D5Tcp.h"
#import "D5Udp.h"

#define WIFI_NOT_FOUND @"Not Found"

@interface D5NetWork : NSObject

+ (BOOL)isConnectionAvailable;
+ (BOOL)isConnectedWIFI;
+ (BOOL)isOpenWIFI;

+ (NSString *)getCurrentWifiName;
+ (NSString *)getCurrentBssid;

/**
 *  获取手机IP
 *
 *  @return 
 */
+ (NSString *)getDeviceIp;
@end
