//
//  D5LedBoxGetInfo.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxGetInfo.h"

@implementation D5LedBoxGetInfo

- (void)ledBoxGetInfo {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Get_Info];
        
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
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Get_Info) {
            return;
        }
        [self cmdRecivedResult];
       
        NSData *data = [NSData dataWithBytes:body length:header->len - sizeof(LedHeader) - 1];
        if (data) {
            NSDictionary *dict = [NSJSONSerialization dictFromJsonData:data];

//            NSString *name = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    if (obj && [obj respondsToSelector:@selector(ledBoxGetInfoReturn:)]) {
                        [obj ledBoxGetInfoReturn:dict];
                    }
                }
            }];
        }
       
        
    }
}
@end
