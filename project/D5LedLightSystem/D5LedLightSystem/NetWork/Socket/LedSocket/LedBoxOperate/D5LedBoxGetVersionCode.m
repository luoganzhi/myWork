//
//  D5LedBoxGetVersionCode.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/9/1.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBoxGetVersionCode.h"

@implementation D5LedBoxGetVersionCode

- (void)ledBoxGetVersionCode {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Box_Operate withSubCmd:SubCmd_Box_Get_VersionCode];
        
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
        if (header->cmd != Cmd_Box_Operate || header->subCmd != SubCmd_Box_Get_VersionCode) {
            return;
        }
        [self cmdRecivedResult];
        
        uint32_t version = *((uint32_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            version = [D5BigLittleEndianExchange changeInt:version];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledBoxGetVersionCodeReturn:)]) {
                    [obj ledBoxGetVersionCodeReturn:version];
                }
            }
        }];
    }
}


@end
