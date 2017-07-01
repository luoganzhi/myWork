//
//  D5LedBoxSetInfo.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxSetInfo.h"

@implementation D5LedBoxSetInfo

- (void)ledBoxSetInfo:(NSString *)boxName {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Set_Info];
        
        NSData *body = [boxName dataUsingEncoding:NSUTF8StringEncoding];
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
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Set_Info) {
            return;
        }
        [self cmdRecivedResult];
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledBoxSetInfoReturn:)]) {
                    [obj ledBoxSetInfoReturn:status];
                }
            }
        }];
    }
}

@end
