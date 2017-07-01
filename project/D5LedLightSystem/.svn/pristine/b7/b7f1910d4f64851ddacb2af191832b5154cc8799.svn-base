//
//  D5HDowlandMusicToCentreBox.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/20.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5HDowlandMusicToCentreBox.h"

@implementation D5HDowlandMusicToCentreBox
//SubCmd_File_Download_Music
//Cmd_IO_Operate
//下载音乐文件到中控
-(void)downloadMusicToCentreBox:(NSArray *)MusicIds
{
    NSMutableData*data = [[NSMutableData alloc]init];
    [self setProperty];
    LedHeader* header = [self headerForCmd:Cmd_IO_Operate withSubCmd:SubCmd_File_Download_Music];
//    Int32_t
    header->len = sizeof(self.header)+1+sizeof(int32_t)*MusicIds.count;
    [D5LedBaseCmd changeHeader:header remoteCpuModel:self.remoteModel];
    [data appendBytes:header length:sizeof(LedHeader)];
    for (NSData* musicID in MusicIds) {
        [data appendData:musicID];
    }
  
    int8_t checkSum = [self getCheckSum:data];
    [data appendBytes:&checkSum length:sizeof(int8_t)];
    [self sendData:data];
    
}

-(void)setProperty
{
    self.strSrcMac = SRC_MAC_STR;
    self.localIp = nil;
    self.localPort = LED_BOX_RECEIVE_PORT;
    self.strDestMac = [NSString getCentreBoxMac];
    self.remoteIp = [NSString getCentreBoxIP];
    self.remoteLocalTag = tag_remote;
    self.remotePort = LED_TCP_LONG_CONN_PORT;
    

}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip{
    @autoreleasepool {
        if (header->cmd != Cmd_IO_Operate || header->subCmd != SubCmd_File_Download_Music) {
            return;
        }
        
        [self cmdReceivedResult];
        
        /*
        int64_t status = *((int64_t*)body);
        if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            status = [D5BigLittleEndianExchange changeLong:status];
        }
#warning 收到结果通知刷新界面
        if(status>0) {
        
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DOWNLOADMUIC_SUCESS object:nil];
            
        }
        */
//        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            @autoreleasepool {
//                if (obj && [obj respondsToSelector:@selector(downloadMusicToCentreBoxResult:)]) {
//                    [obj downloadMusicToCentreBoxResult:status];
//                }
//            }
//        }];
//        
    }
}

@end
