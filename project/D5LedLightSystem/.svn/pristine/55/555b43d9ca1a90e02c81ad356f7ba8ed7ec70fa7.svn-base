//
//  D5LedUpdateBleProgress.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedUpdateBleProgress.h"

@implementation D5LedUpdateBleProgress

- (void)ledUpdateBleProgress {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Led_Operate withSubCmd:SubCmd_Led_Update_Ble_Progress];
        
        int16_t len = sizeof(LedHeader) + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        int8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(int8_t)];
        
        [self sendData:data];
    }
}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Led_Update_Ble_Progress) {
            return;
        }
        [self cmdRecivedResult];
        
        uint8_t progress = *((uint8_t*)body);
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledUpdateBleProgressReturn:)]) {
                    [obj ledUpdateBleProgressReturn:progress];
                }
            }
        }];
    }
}


@end
