//
//  D5LedBoxSetTimeTask.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxSetTimeTask.h"

@implementation D5LedBoxSetTimeTask

- (void)ledBoxSetTimeTask:(NSArray *)tasks {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Set_TimeTask];
        
        NSMutableData *body = [[NSMutableData alloc] init];
        if (tasks && tasks.count > 0) {
            for (NSData *taskData in tasks) {
                @autoreleasepool {
                    if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
                        LedOperateTimeTask *task = (LedOperateTimeTask *)[taskData bytes];
                        
                        LedReadTimeTask readTask = task->timeTask;
                        readTask.key = [D5BigLittleEndianExchange changeLong:(long)readTask.key];
                        readTask.time = [D5BigLittleEndianExchange changeLong:(long)readTask.time];
                    }
                    [body appendData:taskData];
                }
            }
        }
        
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
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Set_TimeTask) {
            return;
        }
        [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:(long)status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledBoxSetTimeTaskReturn:)]) {
                    [obj ledBoxSetTimeTaskReturn:status];
                }
            }
        }];
    }
}

@end
