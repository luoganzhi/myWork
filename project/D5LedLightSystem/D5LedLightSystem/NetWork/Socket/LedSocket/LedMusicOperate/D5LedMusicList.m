//
//  D5LedMusicList.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedMusicList.h"
#import "MJExtension.h"
#import "D5MusicListModel.h"

@implementation D5LedMusicList

- (void)ledMusicList:(int32_t)index {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:Cmd_Music_Operate withSubCmd:SubCmd_Music_List];
        
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            index = [D5BigLittleEndianExchange changeInt:index];
        }
        
        int16_t len = sizeof(int32_t) + sizeof(LedHeader) + 1;
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        [data appendBytes:&index length:sizeof(int32_t)];
        int8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(int8_t)];
        
        [self sendData:data];
    }
}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_Music_Operate || header->subCmd != SubCmd_Music_List) {
            return;
        }
        
        [self cmdRecivedResult];
        
        NSData *data = [NSData dataWithBytes:body length:header -> len - sizeof(LedHeader) - 1];
        
        
        NSDictionary *dict = [NSJSONSerialization dictFromJsonData:data];
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj && [obj respondsToSelector:@selector(ledMusicListReturn:)]) {
                    [obj ledMusicListReturn:dict];
                }
            }
        }];
    }
}
@end
