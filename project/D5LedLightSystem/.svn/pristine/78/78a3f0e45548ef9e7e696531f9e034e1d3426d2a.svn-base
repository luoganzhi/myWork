//
//  D5MusicConfigPlayEffect.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/29.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicConfigPlayEffect.h"

@implementation D5MusicConfigPlayEffect

- (void)ledMusicConfigPlayEffect:(LedConfigPlayEffect)configPlayEffect
{
        @autoreleasepool {
            LedHeader *header = [self headerForCmd:Cmd_Music_Operate withSubCmd:SubCmd_Config_PlayEffect];
            
            if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
                configPlayEffect.type = [D5BigLittleEndianExchange changeInt:configPlayEffect.type];
                configPlayEffect.effectId = [D5BigLittleEndianExchange changeInt:configPlayEffect.effectId];
            }
            
            NSData *body = [NSData dataWithBytes:&configPlayEffect length:sizeof(LedMusicPlay)];
            int16_t len = body.length + sizeof(LedHeader) + 1;
            header->len = len;
            [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
            NSMutableData *data = [[NSMutableData alloc] init];
            [data appendBytes:header length:sizeof(LedHeader)];
            [data appendData:body];
            int8_t checkSum = [self getCheckSum:data];
            [data appendBytes:&checkSum length:sizeof(int8_t)];
            
            //NSLog(@"senddata = %@", data);
            [self sendData:data];
        }

}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_Music_Operate || header->subCmd != SubCmd_Config_PlayEffect) {
            return;
        }
        
        [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledMusicConfigPlayEffectReturn:)]) {
                    [obj ledMusicConfigPlayEffectReturn:status];
                }
            }
        }];
    }
}


@end
