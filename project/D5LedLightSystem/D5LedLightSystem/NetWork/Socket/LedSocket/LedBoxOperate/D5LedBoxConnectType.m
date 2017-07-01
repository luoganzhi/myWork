//
//  D5LedBoxConnectType.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/2.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxConnectType.h"

@implementation D5LedBoxConnectType

- (void)ledBoxConnectType
{
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Connect_Type];
        
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
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Connect_Type) {
            return;
        }
        [self cmdRecivedResult];
        
        uint8_t type = *((uint8_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            type = [D5BigLittleEndianExchange changeInt:type];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledBoxConnectTypeReturn:)]) {
                    [obj ledBoxConnectTypeReturn:type];
                }
            }
        }];
    }
}

@end
