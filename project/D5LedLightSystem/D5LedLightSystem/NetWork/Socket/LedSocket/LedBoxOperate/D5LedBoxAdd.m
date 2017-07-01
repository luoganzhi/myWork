//
//  D5LedBoxAdd.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/15.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxAdd.h"
#import "D5UdpPingManager.h"
#import "D5LedZKTBoxData.h"

const NSString *WIFI_BSSID = @"bssid";
const NSString *WIFI_SSID = @"wifiName";
const NSString *WIFI_PASSWORD = @"wifiPwd";

@implementation D5LedBoxAdd

- (void)ledBoxAddBSSID:(NSString *)bssid withSSID:(NSString *)ssid withPwd:(NSString *)pwd isBroadCast:(BOOL)broadCast {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Scan];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:bssid, WIFI_BSSID, ssid, WIFI_SSID, pwd, WIFI_PASSWORD, nil];
        NSData *body = [NSJSONSerialization jsonDataFromDict:dict];

        int16_t len = body.length + sizeof(LedHeader) + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
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

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip {
    @autoreleasepool {
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Scan) {
            return;
        }
        
        NSData *data = [NSData dataWithBytes:body length:header->len - sizeof(LedHeader) - 1];
        if (data) {
            NSDictionary *dict = [NSJSONSerialization dictFromJsonData:data];
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutableDict setObject:ip forKey:ZKT_BOX_IP];
            
            NSString *srcMac = [D5SocketBaseTool macFormatStrFromMacByte:header->srcMac];
            [mutableDict setObject:srcMac ? srcMac : @"" forKey:ZKT_BOX_MAC];
            
            [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    if (obj && [obj respondsToSelector:@selector(ledBoxAddReturn:)]) {
                        [obj ledBoxAddReturn:mutableDict];
                    }
                }
            }];
        }
    }
}

@end
