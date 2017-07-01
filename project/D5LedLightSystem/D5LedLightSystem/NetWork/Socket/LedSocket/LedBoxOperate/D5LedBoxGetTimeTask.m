//
//  D5LedBoxGetTimeTask.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxGetTimeTask.h"

@implementation D5LedBoxGetTimeTask

- (void)ledBoxGetTimeTask {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Get_TimeTask];
        
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
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Get_TimeTask) {
            return;
        }
        [self cmdRecivedResult];
        
        NSMutableArray *arr = [NSMutableArray array];
        LedReadTimeTask *task = (__bridge LedReadTimeTask *)(body);
        int numberOfTimer = (header->len - sizeof(LedHeader) - 1) / sizeof(LedReadTimeTask);
        
        LedReadTimeTask tasks[numberOfTimer];
        @autoreleasepool {
            for (int i = 0; i < numberOfTimer; i ++) {
                tasks[i] = *(task + i);
                if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
                    tasks[i].key = [D5BigLittleEndianExchange changeLong:(long)tasks[i].key];
                    tasks[i].time = [D5BigLittleEndianExchange changeLong:tasks[i].time];
                }
                [arr addObject:[NSData dataWithBytes:&tasks[i] length:sizeof(LedReadTimeTask)]];
            }
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledBoxGetTimeTaskReturn:)]) {
                    [obj ledBoxGetTimeTaskReturn:arr];
                }
            }
        }];
    }
}


@end
