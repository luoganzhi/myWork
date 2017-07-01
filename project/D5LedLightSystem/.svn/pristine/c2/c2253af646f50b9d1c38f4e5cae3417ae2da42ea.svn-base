//
//  D5D5LedMusicDelete.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/24.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedMusicDelete.h"

@implementation D5LedMusicDelete

- (void)ledMusicDelete:(NSArray *)musicIds
{
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Music_Operate withSubCmd:SubCmd_Music_Delete];
        
        NSMutableData *body = [[NSMutableData alloc] init];
        if (musicIds && musicIds.count > 0) {
            for (NSData *deleteDatas in musicIds) {
                @autoreleasepool {
                    [body appendData:deleteDatas];
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
        if (header->cmd != Cmd_Music_Operate || header->subCmd != SubCmd_Music_Delete) {
            return;
        }
        
        [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeMac:status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledMusicDeleteReturn:)]) {
                    [obj ledMusicDeleteReturn:status];
                }
            }
        }];
    }
}


@end
