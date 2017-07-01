//
//  D5LedOnOffSingle.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedOnOffSingle.h"

@implementation D5LedOnOffSingle

- (void)ledOnOffSingle:(NSArray *)datas forLedMac:(int32_t)macInt {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Led_Operate withSubCmd:SubCmd_Led_OnOff_Single];
        
        NSMutableData *body = [[NSMutableData alloc] init];
        if (datas && datas.count > 0) {
            for (NSData *onoffSingleData in datas) {
                @autoreleasepool {
                    [body appendData:onoffSingleData];
                }
            }
        }
        
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            macInt = [D5BigLittleEndianExchange changeInt:macInt];
        }
        
        [body appendBytes:&macInt length:sizeof(int32_t)];
        
        int16_t len = body.length + sizeof(LedHeader) + 1;
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
        if (header->cmd != Cmd_Led_Operate || header->subCmd != SubCmd_Led_OnOff_Single) {
            return;
        }
        
        [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledOnOffSingleReturn:)]) {
                    [obj ledOnOffSingleReturn:status];
                }
            }
        }];

    }
}

@end
