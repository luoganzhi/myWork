//
//  D5NetWork.m
//  D5Home_new
//
//  Created by PangDou on 16/1/7.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import "D5NetWork.h"
#import "Reachability.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "D5BigLittleEndianExchange.h"
#include "IPAddress.h"
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation D5NetWork

+ (BOOL) isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.ipangdou.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            ////DLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            ////DLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            ////DLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}

+ (BOOL)isConnectedWIFI {
    @autoreleasepool {
        BOOL isExistenceNetwork = NO;
        Reachability *reach = [Reachability reachabilityWithHostName:@"www.ipangdou.com"];
        switch ([reach currentReachabilityStatus]) {
            case NotReachable:
                isExistenceNetwork = NO;
                ////DLog(@"notReachable");
                break;
            case ReachableViaWiFi:
                isExistenceNetwork = YES;
                ////DLog(@"WIFI");
                break;
            case ReachableViaWWAN:
                isExistenceNetwork = NO;
                ////DLog(@"3G");
                break;
        }
        
        return isExistenceNetwork;
    }
}

+ (BOOL)isOpenWIFI {
    @autoreleasepool {
        NSCountedSet * cset = [NSCountedSet new];
        
        struct ifaddrs *interfaces;
        
        if (!getifaddrs(&interfaces)) {
            for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
                if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                    [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
                }
            }
        }
        
        return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
    }
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
        
        //DLog(@"wifiName:%@", wifiName);
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

//获取本机IP地址
+(NSString*)getLocalIPAddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    NSData *localInetAddrData = nil;
    Byte localIpBytes[4];
    for (int i=0; i<MAXADDRS; ++i)
    {
        static unsigned long localHost = 0x100007F;            // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        
        localIpBytes[0] = (theAddr & 0xff)          >> 0;
        localIpBytes[1] = (theAddr & 0xff00)        >> 8;
        localIpBytes[2] = (theAddr & 0xff0000)      >> 16;
        
    }
    
    localInetAddrData = [[NSData alloc]initWithBytes:localIpBytes length:4];
    
    FreeAddresses();
    
    Byte byte1 = 0;
    Byte byte2 = 0;
    Byte byte3 = 0;
    Byte byte4 = 0;
    
    [localInetAddrData getBytes:&byte1 range:NSMakeRange(0, 1)];
    [localInetAddrData getBytes:&byte2 range:NSMakeRange(1, 1)];
    [localInetAddrData getBytes:&byte3 range:NSMakeRange(2, 1)];
    [localInetAddrData getBytes:&byte4 range:NSMakeRange(3, 1)];
    
    
    NSLog(@"ESP_NetUtil:: %d.%d.%d.%d", byte1,byte2,byte3,byte4);
    
    
    
    NSString*ip = [NSString stringWithFormat:@"%d.%d.%d.%d",byte1,byte2,byte3,byte4];
    
    return ip;
    
}
// Get IP Address

+ (NSString *)getDeviceIp
{
    
    return  [self getLocalIPAddress];

    NSString *ip = @"Error";
    struct ifaddrs *interfaces = nil;
    struct ifaddrs *temp_addr = nil;
    
    int success = getifaddrs(&interfaces);
    //获取地址成功
    if (!success)
    {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return ip;
}

@end
