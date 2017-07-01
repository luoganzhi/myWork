//
//  D5LedLinkDeviceListFromApp.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedLinkDeviceListFromApp.h"

@implementation D5LedLinkDeviceListFromApp

/**
 * 获取主从中控信息
 */
- (void)ledLinkDeviceListFromApp {
    LedHeader *header = [self headerForCmd:Cmd_Link_Devices withSubCmd:SubCmd_Device_List_From_App];
    
    int16_t len = sizeof(LedHeader) + 1;
    header->len = len;
    [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendBytes:header length:sizeof(LedHeader)];
    int8_t checkSum = [self getCheckSum:data];
    [data appendBytes:&checkSum length:sizeof(int8_t)];
    
    [self sendData:data];
}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    if (header->cmd != Cmd_Link_Devices || header->subCmd != SubCmd_Device_List_From_App) {
        return;
    }
    
    [self cmdRecivedResult];
    
    NSData *data = [NSData dataWithBytes:body length:header -> len - sizeof(LedHeader) - 1];
    NSDictionary *dict = [NSJSONSerialization dictFromJsonData:data];
    
    [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            if (obj && [obj respondsToSelector:@selector(ledLinkDeviceListFromAppReturn:)]) {
                [obj ledLinkDeviceListFromAppReturn:dict];
            }
        }
    }];
}

@end
