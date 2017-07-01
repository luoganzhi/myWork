//
//  D5LedMusicControl.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedMusicControl.h"

@implementation D5LedMusicControl

- (void)ledMusicControl:(LedMusicControlType)type
{
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Music_Operate withSubCmd:SubCmd_Music_Control];

        uint8_t body = (uint8_t)type;
//        NSData *body = [NSData dataWithBytes:&(*(uint8_t*)type) length:sizeof(uint8_t)];
        int16_t len = sizeof(body) + sizeof(LedHeader) + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        [data appendBytes:&body length:sizeof(body)];
        int8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(int8_t)];
        
        [self sendData:data];
    }

}



- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_Music_Operate || header->subCmd != SubCmd_Music_Control) {
            return;
        }
        
        [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledMusicControlReturn:)]) {
                    [obj ledMusicControlReturn:status];
                }
            }
        }];
    }
}



@end
