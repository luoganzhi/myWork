//
//  D5LedLinkDeviceAddFromApp.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedLinkDeviceAddFromApp.h"

@implementation D5LedLinkDeviceAddFromApp

/**
 * 主中控添加从属中控
 */
- (void)ledLinkDeviceAddFromApp:(NSArray *)addInfos {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Link_Devices withSubCmd:SubCmd_Device_Add_From_App];
        
        NSMutableData *body = [[NSMutableData alloc] init];
        if (addInfos.count > 0) {
            for (NSData *addInfo in addInfos) {
                [body appendData:addInfo];
            }
        }
        
        int16_t len = sizeof(LedHeader) + body.length + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        [data appendData:body];
        int8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(int8_t)];
        
        [self sendData:data];
    }
}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_Link_Devices || header->subCmd != SubCmd_Device_Add_From_App) {
            return;
        }
        
        [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:(long)status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledLinkDeviceAddFromAppReturn:)]) {
                    [obj ledLinkDeviceAddFromAppReturn:status];
                }
            }
        }];
        
    }
}

@end
