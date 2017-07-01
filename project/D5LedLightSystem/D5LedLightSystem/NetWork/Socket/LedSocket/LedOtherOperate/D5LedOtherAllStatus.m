//
//  D5LedOtherAllStatus.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/10/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedOtherAllStatus.h"

@implementation D5LedOtherAllStatus

- (void)ledOtherAllStatus
{
    LedHeader *header = [self headerForCmd:Cmd_Other_Operate withSubCmd:SubCmd_Other_AllStatus];
    
    int16_t len = sizeof(LedHeader) + 1;
    header->len = len;
    [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendBytes:header length:sizeof(LedHeader)];
    int8_t checkSum = [self getCheckSum:data];
    [data appendBytes:&checkSum length:sizeof(int8_t)];
    
    [self sendData:data];

}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    if (header->cmd != Cmd_Other_Operate || header->subCmd != SubCmd_Other_AllStatus) {
        return;
    }
    
    NSData *data = [NSData dataWithBytes:body length:header -> len - sizeof(LedHeader) - 1];
    
    //NSLog(@"other status = %@", data);
    LedOtherAllStatus status;
    [data getBytes:&status length:sizeof(LedOtherAllStatus)];
    
    if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
        status.versionCode = [D5BigLittleEndianExchange changeLong:status.versionCode];
    }
    
    [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            if (obj && [obj respondsToSelector:@selector(ledOtherAllStatusReturn:)]) {
                [obj ledOtherAllStatusReturn:status];
            }
        }
    }];

}

@end
