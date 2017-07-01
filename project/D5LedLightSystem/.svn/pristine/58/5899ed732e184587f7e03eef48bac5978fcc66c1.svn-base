//
//  D5LedBoxAdd.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/15.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxAdd.h"
#import "NSDictionary+Helper.h"
#import "D5UdpPingManager.h"


const NSString *WIFI_BSSID = @"mBSSID";
const NSString *WIFI_SSID = @"mWifiSsid";
const NSString *WIFI_PASSWORD = @"mWifiPassword";

@implementation D5LedBoxAdd

- (void)ledBoxAddBSSID:(NSString *)bssid withSSID:(NSString *)ssid withPwd:(NSString *)pwd isBroadCast:(BOOL)broadCast {
    @autoreleasepool {
        LedHeader *header = [self headerForDevice:D5LedType withCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Add withVersion:D5LedVersion withSrc:self.srcMac withDestination:self.destMac];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:bssid, WIFI_BSSID, ssid, WIFI_SSID, pwd, WIFI_PASSWORD, nil];
        NSData *body = [NSString jsonDataFromDict:dict];

        int16_t len = body.length + sizeof(LedHeader) + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:ENDIAN_LITTLE];
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        [data appendData:body];
        int8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(int8_t)];
        
        if (broadCast) {
            [self sendBroadCastData:data];
        } else {
            [self sendData:data];
        }
    }
}

- (void)getResult:(LedHeader *)header body:(Byte *)body from:(NSString *)ip {
    @autoreleasepool {
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Add) {
            return;
        }
        
        [self cmdRecivedResult];
        NSData *data = [NSData dataWithBytes:body length:sizeof(body)];
        if (data) {
            NSDictionary *dict = [NSDictionary dictFromJsonData:data];
            if (dict) {
                [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj && [obj respondsToSelector:@selector(ledBoxAddReturn:)]) {
                        [obj ledBoxAddReturn:dict];
                    }
                }];
            }
        }
    }
}

@end
