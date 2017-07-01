//
//  D5LedMusicConfigEffectList.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/29.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedMusicConfigEffectList.h"

@implementation D5LedMusicConfigEffectList

- (void)ledMusicConfigEffectList
{
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Music_Operate withSubCmd:SubCmd_Config_EffectList];
        
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
        if (header->cmd != Cmd_Music_Operate || header->subCmd != SubCmd_Config_EffectList) {
            return;
        }
        
        [self cmdRecivedResult];
        
        NSData *data = [NSData dataWithBytes:body length:header -> len - sizeof(LedHeader) - 1];
        NSArray *array = [NSJSONSerialization arrayFromJsonData:data];
        
//        NSArray *array = dict[@"data"];
        
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledMusicConfigEffectListReturn:)]) {
                    [obj ledMusicConfigEffectListReturn:array];
                }
            }
        }];
    }
}


@end
