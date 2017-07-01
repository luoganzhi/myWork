 //
//  D5HMusicPCUpload.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5HMusicPCUpload.h"
#import "D5SocketBaseTool.h"

@implementation D5HMusicPCUpload


+(id)shareInstance
{
    static D5HMusicPCUpload*obj;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        obj=[[D5HMusicPCUpload alloc]init];
    });
    return obj;
}

-(void)setProperty
{
    
    self.strSrcMac = SRC_MAC_STR;
    self.localIp = nil;
    self.localPort = LED_BOX_RECEIVE_PORT;
    self.strDestMac = [NSString getCentreBoxMac];
    self.remoteLocalTag = tag_remote;
    self.remotePort=LED_TCP_LONG_CONN_PORT;
}
-(void)uploadPcMusic
{
    NSMutableData*data=[[NSMutableData alloc]init];
    [self setProperty];
    int8_t subCmd;
    subCmd=self.isOpen ? SubCmd_File_Trans_Music_PC_On:SubCmd_File_Trans_Music_PC_Off;
    LedHeader* header=[self headerForCmd:Cmd_IO_Operate withSubCmd:subCmd];
    header->len=sizeof(self.header)+1;
    [D5LedBaseCmd changeHeader:header remoteCpuModel:self.remoteModel];
    [data appendBytes:header length:sizeof(LedHeader)];
    int8_t checkSum = [self getCheckSum:data];
    [data appendBytes:&checkSum length:sizeof(int8_t)];
    
#ifdef HJPhoneDEBUG
    
//    self.remoteIp=@"192.168.20.122";
 
#endif
//    self.remoteIp=@"192.168.20.120";
    [self sendData:data];
    
    
}

-(void)setIsOpen:(BOOL)isOpen
{
    _isOpen=isOpen;

}
-(void)getResult:(LedHeader *)header body:(Byte *)body from:(NSString *)ip
{
   
    if (header->cmd==Cmd_IO_Operate&&(header->subCmd==SubCmd_File_Trans_Music_PC_On||header->subCmd==SubCmd_File_Trans_Music_PC_Off)) {
        [self cmdReceivedResult];
        if (header->subCmd==SubCmd_File_Trans_Music_PC_On) {
        
            LedFileTransMusicOn*openData=(LedFileTransMusicOn*)body;
             if ([D5BigLittleEndianExchange deviceCpuModel] != self.remoteModel) {
            
            
            openData->type=[D5BigLittleEndianExchange changeInt:openData->type];
            openData->ipv4IP=[D5BigLittleEndianExchange changeInt:openData->ipv4IP];
            openData->port=[D5BigLittleEndianExchange changeInt:openData->port];
             }
            
           NSString*ipAdress= [D5SocketBaseTool ipFromInt:openData->ipv4IP];
            NSString*port=[NSString stringWithFormat:@"%d",openData->port];
            BOOL isopen ;
            if (header->subCmd==SubCmd_File_Trans_Music_PC_On) {
                
                isopen = YES;
                
            }else{
                isopen=NO;
            }
           
            [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    if (obj && [obj respondsToSelector:@selector(getUPloadStartService:ip:port:)]) {
                        [obj getUPloadStartService:isopen ip:ipAdress port:port];
                    }
                }
            }];

        }
      }
}
@end
