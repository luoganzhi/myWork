//
//  D5LedResult.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/26.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedResult.h"

@interface D5LedResult ()

@property (nonatomic, strong) NSMutableData *receiveData;

@end

@implementation D5LedResult

- (NSMutableData *)receiveData {
    if (!_receiveData) {
        _receiveData = [NSMutableData data];
    }
    return _receiveData;
}

- (void)receivedData:(NSData *)data from:(NSString *)ip networkType:(D5SocketType)socketType {
    @autoreleasepool {
        NSData *analyzedData = nil;
        if (self.receiveData.length > 0) {
            [self.receiveData appendData:data];
            analyzedData = self.receiveData;
        } else {
            analyzedData = data;
        }
        
        while (analyzedData.length > 0) {
            __block LedHeader *header = nil;
            header = (LedHeader *)[analyzedData bytes];
            
            [D5LedCmd changeHeader:header remoteCpuModel:ENDIAN_LITTLE];
            
            __block Byte *receivedData = (Byte *)[analyzedData bytes];
            __block NSString *remoteIp = ip;
            
            if (header->len <= analyzedData.length) {
                if (header->code == HEADER_CODE) {
                    NSMutableArray *delegates = [D5LedModule sharedLedModule].cmds.delegateList;
                    if (!delegates || [delegates isEqual:[NSNull null]] || delegates.count == 0) {
                        return;
                    }
                    
                    LedFlag *flag = (LedFlag *)&header->flag;
                    
                    Byte *body = (Byte *)header + sizeof(LedHeader);
                    
                    uint16_t bodyLen = header->len - sizeof(LedHeader) - 1;
                    if (flag->hasExtentData) { // 有扩展数据
                        Byte *extension = (Byte *)header + sizeof(LedHeader);
                        
                        uint8_t extensionLen = *((uint8_t *)extension);
                        bodyLen -= extensionLen;
                        
                        body = extension + extensionLen;
                    }
                    
                    NSDictionary *resultDict = nil;
                    if (bodyLen > 0) {
                        NSData *bodyData = [NSData dataWithBytes:body length:bodyLen];
                        resultDict = [NSJSONSerialization dictFromJsonData:bodyData];
                    }
                    
                    int code = -1;
                    if (resultDict) {       // 有body -- 有code（成功/失败)
                        code = [resultDict[LED_STR_CODE] intValue];
                    }
                    
                    if (code == LedCodeNotLogin) {  //未登录 -- 先登录
                        DLog(@"------未登录 需要先登录");
                        LedLoginStatus status = [D5LedZKTList defaultList].loginStatus;
                        if (status == LedLoginStatusLoginSuccess) {
                            [D5LedZKTList defaultList].loginStatus = LedLoginStatusLoginFailed;
                        }
                        
                        [[D5LedZKTList defaultList] sendLoginToBox:[D5CurrentBox currentBoxIP] withMac:[D5CurrentBox currentBoxMac]];
                    } else if (!resultDict || code == LedCodeSuccess) { // 没body或者有body且成功
                        [delegates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            @autoreleasepool {
                                if (obj &&
                                    [obj class] != nil &&
                                    [obj respondsToSelector:@selector(getResult:body:from:)] &&
                                    ((D5LedCmd *)obj).headerCmd == header->cmd &&
                                    ((D5LedCmd *)obj).headerSubCmd == header->subCmd) {
                                    //(header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Scan) ||
                                    
                                    if ((header->cmd == Cmd_Led_Operate && header->subCmd == SubCmd_Led_List) ||
                                        (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Runtime_Info) ||
                                        (((D5LedCmd *)obj).serailNumber == header->sn)) { //广播的
                                        // 接收到ledlist的推送  心跳 获取音乐状态
                                        DLog(@"------接收到数据  %d-%d", header->cmd, header->subCmd);
                                        if (header->cmd == 2 && header->subCmd == 3) {
                                            
                                        }
                                        [obj getResult:header body:resultDict from:remoteIp];
                                    }
                                }
                            }
                        }];
                    } else {
                        [delegates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            @autoreleasepool {
                                if (obj &&
                                    [obj class] != nil &&
                                    [obj respondsToSelector:@selector(cmdError:withMsg:withHeader:withData:from:)] &&
                                    ((D5LedCmd *)obj).headerCmd == header->cmd &&
                                    ((D5LedCmd *)obj).headerSubCmd == header->subCmd  &&
                                    ((D5LedCmd *)obj).serailNumber == header->sn) {
                                    DLog(@"------接收到错误信息  %d-%d %d-%@", header->cmd, header->subCmd, code, resultDict[LED_STR_MSG]);
                                    [obj cmdError:code withMsg:resultDict[LED_STR_MSG] withHeader:header withData:resultDict[LED_STR_DATA]  from:remoteIp];
                                }
                            }
                        }];
                    }
                   
                    if (header->len < analyzedData.length) { //继续解析下一个包的数据
                        NSData *nextData = [NSData dataWithBytes:receivedData + header->len length:(analyzedData.length - header->len)];
                        analyzedData = nil;
                        analyzedData = nextData;
                    } else {
                        analyzedData = nil;
                        self.receiveData = [NSMutableData dataWithData:analyzedData]; // 新加的
                        break;
                    }
                }
            } else {
                self.receiveData = [NSMutableData dataWithData:analyzedData];
                break;
            }
        }
    }

}

@end
