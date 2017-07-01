//
//  D5LedSceneNew.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/10/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedSceneNew.h"

@implementation D5LedSceneNew

- (void)ledSceneNewWithScene:(uint8_t)scene Type:(uint8_t)type Colors:(NSArray *)colors
{
    LedHeader *header = [self headerForCmd:Cmd_Led_Operate withSubCmd:SubCmd_Led_Scene_New];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    [body appendBytes:&scene length:sizeof(uint8_t)];
    [body appendBytes:&type length:sizeof(uint8_t)];

    if (colors && colors.count > 0) {
        for (NSData *color in colors) {
            @autoreleasepool {
                [body appendData:color];
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

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_Led_Operate || header->subCmd != SubCmd_Led_Scene_New  ) {
            return;
        }
                [self cmdRecivedResult];
        
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
        
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledSceneNewReturn:)]) {
                    [obj ledSceneNewReturn:status];
                }
            }
        }];
    }
}



@end
