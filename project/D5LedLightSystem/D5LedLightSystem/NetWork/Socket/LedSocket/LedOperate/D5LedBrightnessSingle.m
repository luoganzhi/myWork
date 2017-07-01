//
//  D5LedBrightnessSingle.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBrightnessSingle.h"

@implementation D5LedBrightnessSingle

- (void)ledBrightnessSingle:(NSArray *)brightnesses {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Led_Operate withSubCmd:SubCmd_Led_Brightness_Single];
        
        NSMutableData *body = [[NSMutableData alloc] init];
        if (brightnesses && brightnesses.count > 0) {
            for (NSData *brightnessData in brightnesses) {
                @autoreleasepool {
                    [body appendData:brightnessData];
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
        if (header->cmd != Cmd_Led_Operate || header->subCmd != SubCmd_Led_Brightness_Single) {
            return;
        }
        [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledBrightnessSingleReturn:)]) {
                    [obj ledBrightnessSingleReturn:status];
                }
            }
        }];

    }
}

@end
