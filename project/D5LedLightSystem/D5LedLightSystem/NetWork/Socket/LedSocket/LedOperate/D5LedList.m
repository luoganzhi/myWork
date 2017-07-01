//
//  D5LedList.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedList.h"

@implementation D5LedList
- (void)ledList:(LedListType)type {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Led_Operate withSubCmd:SubCmd_Led_List];
        
        uint8_t body = (uint8_t)type;
        int16_t len = sizeof(body) + sizeof(LedHeader) + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        [data appendBytes:&body length:sizeof(uint8_t)];
        int8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(int8_t)];
        
        [self sendData:data];
    }
}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_Led_Operate || header->subCmd != SubCmd_Led_List) {
            return;
        }
        
        NSData *data = [NSData dataWithBytes:body length:header->len - sizeof(LedHeader) - 1];
        if (data) {
            NSDictionary *dict = [NSJSONSerialization dictFromJsonData:data];
            NSLog(@"getresult list  %d type = %@", (int)[[dict objectForKey:@"data"] count], [dict objectForKey:@"type"]);
            [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    if (obj && [obj respondsToSelector:@selector(ledListReturn:)]) {
                        [obj ledListReturn:dict];
                    }
                }
            }];
        }
    }
}

@end
