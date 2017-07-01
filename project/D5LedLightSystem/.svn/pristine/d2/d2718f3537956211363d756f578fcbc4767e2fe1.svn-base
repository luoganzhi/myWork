//
//  D5NetWork.m
//  D5Home_new
//
//  Created by PangDou on 16/1/7.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import "D5NetWork.h"
#import "Reachability.h"

@implementation D5NetWork

+ (BOOL) isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.ipangdou.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}

#pragma mark - get current wifi bssid
+ (NSString *)getCurrentWifiName {
    @autoreleasepool {
        NSString *wifiName = WIFI_NOT_FOUND;
        CFArrayRef myArray = CNCopySupportedInterfaces();
        if (myArray != nil) {
            CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
            if (myDict != nil) {
                NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
                wifiName = [dict valueForKey:@"SSID"];
            }
            CFRelease(myArray);
        }
        
        NSLog(@"wifiName:%@", wifiName);
        return wifiName;
    }
}

+ (NSString *)getCurrentBssid {
    @autoreleasepool {
        NSString *bssid = WIFI_NOT_FOUND;
        CFArrayRef myArray = CNCopySupportedInterfaces();
        if (myArray != nil) {
            CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
            if (myDict != nil) {
                NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
                bssid = [dict valueForKey:@"BSSID"];
            }
            CFRelease(myArray);
        }
        
        return bssid;
    }
}

@end
