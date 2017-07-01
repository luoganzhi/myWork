//
//  D5LedBrightnessStatus.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/10/13.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBrightnessStatus.h"

@implementation D5LedBrightnessStatus

- (void)ledBrightnessStatus {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Led_Operate withSubCmd:SubCmd_Led_Brightness_Status];
        
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
//        if (header->cmd != Cmd_Led_Operate || header->subCmd != SubCmd_Led_Brightness_Status  ) {
//            return;
//        }
//        [self cmdRecivedResult];
//        
//        uint8_t status = *((uint8_t*)body);
//        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
//            status = [D5BigLittleEndianExchange changeLong:status];
//        }
//        
//        
//        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            @autoreleasepool {
//                if (obj && [obj respondsToSelector:@selector(ledBrightnessStatusReturn:)]) {
//                    [obj ledBrightnessStatusReturn:status];
//                }
//            }
//        }];
    }
}

@end
