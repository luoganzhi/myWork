//
//  D5LedSceneAll.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedSceneAll.h"

@implementation D5LedSceneAll

- (void)ledSceneAll:(LedAllScene)scene {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Led_Operate withSubCmd:SubCmd_Led_Scene_All];
        
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            scene.type = [D5BigLittleEndianExchange changeInt:scene.type];
            scene.R = [D5BigLittleEndianExchange changeInt:scene.R];
            scene.G = [D5BigLittleEndianExchange changeInt:scene.G];
            scene.B = [D5BigLittleEndianExchange changeInt:scene.B];

            
        }

        
        NSData *body = [NSData dataWithBytes:&scene length:sizeof(LedAllScene)];

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
        if (header->cmd != Cmd_Led_Operate || header->subCmd != SubCmd_Led_Scene_All) {
            return;
        }
        
        [self cmdRecivedResult];
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledSceneAllReturn:)]) {
                    [obj ledSceneAllReturn:status];
                }
            }
        }];
    }
}

@end
