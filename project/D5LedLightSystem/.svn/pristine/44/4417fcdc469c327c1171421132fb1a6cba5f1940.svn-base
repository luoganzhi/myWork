//
//  D5LedBoxScan.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxScan.h"

static D5LedBoxScan *instance = nil;

@implementation D5LedBoxScan

+ (D5LedBoxScan *)defaultBoxScan {
    if (!instance) {
        instance = [[D5LedBoxScan alloc] init];
    }
    return instance;
}

- (void)ledBoxScanBroadCast:(BOOL)isBroadCast {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Scan];
        
        int16_t len = sizeof(LedHeader) + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        int8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(int8_t)];
        
        if (isBroadCast) {
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
        
        [self stopTimer];
        NSData *data = [NSData dataWithBytes:body length:header->len - sizeof(LedHeader) - 1];
        if (data) {
            NSDictionary *dict = [NSJSONSerialization dictFromJsonData:data];
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutableDict setObject:ip forKey:ZKT_BOX_IP];
            
            NSString *srcMac = [D5SocketBaseTool macFormatStrFromMacByte:header->srcMac];
            [mutableDict setObject:srcMac ? srcMac : @"" forKey:ZKT_BOX_MAC];
            
            [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    if (obj && [obj respondsToSelector:@selector(ledBoxScanReturn:)]) {
                        [obj ledBoxScanReturn:mutableDict];
                    }
                }
            }];
        }
    }
}

@end
