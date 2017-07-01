//
//  D5LedCmd.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SocketBaseTool.h"
#import "D5UdpPingManager.h"

@interface D5LedCmd ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) D5Udp *tempUdp;
@property (nonatomic, assign) uint16_t appVersion;

@end

@implementation D5LedCmd

- (instancetype)init {
    if (self = [super init]) {
        _remoteModel = ENDIAN_LITTLE;
        _serailNumber = 0;
    }
    return self;
}

#pragma mark - setter and getter
- (NSMutableData *)receiveData {
    if (!_receiveData) {
        _receiveData = [NSMutableData data];
    }
    return _receiveData;
}

- (uint16_t)appVersion {
    @autoreleasepool {
        int build = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] intValue];
        return (uint16_t)build;
    }
}

/**
 设置strSrcMac,并且设置mac的srcMac

 @param strSrcMac
 */
- (void)setStrSrcMac:(NSString *)strSrcMac {
    _strSrcMac = strSrcMac;
    Byte *srcMacByte = [D5SocketBaseTool macByteArrFromStr:strSrcMac];
    memcpy(_mac.srcMac, srcMacByte, 6);
}


/**
 设置strDestMac,并且设置mac的destMac

 @param strDestMac
 */
- (void)setStrDestMac:(NSString *)strDestMac {
    @autoreleasepool {
        _strDestMac = strDestMac;
        NSString *str = [D5SocketBaseTool strFromMacFormatStr:strDestMac];
        Byte *destMacByte  = [D5SocketBaseTool macByteArrFromStr:str];
        memcpy(_mac.destMac, destMacByte, 6);
    }
}

#pragma mark - header的设置
- (LedHeader *)headerForCmd:(int8_t)cmd withSubCmd:(uint8_t)subCmd {
    @autoreleasepool {
        //sn从0开始，每次+1，存在全局
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger serialNum =  [userDefaults integerForKey:CMD_SERIALNUMBER];
        _serailNumber = serialNum % 256 + 1;
        _header.sn = _serailNumber;
        
        [userDefaults setInteger:(serialNum + 1) forKey:CMD_SERIALNUMBER];
        [userDefaults synchronize];
        
        _header.protocolVersion = HEADER_PROTOCAOL_VERSION;
        _header.appVersion = self.appVersion;
        _header.type = HEADER_TYPE_APP;
        _header.subType = HEADER_SUBTYPE_IOS;
        
        _header.cmd = cmd;
        _headerCmd = cmd;
        
        _header.subCmd = subCmd;
        _headerSubCmd = subCmd;
        
        _strSrcMac = SRC_MAC_STR;  // 默认手机号码
        
        memcpy(_header.srcMac, _mac.srcMac, 6);
        memcpy(_header.destMac, _mac.destMac, 6);
        
        _header.flag = 1;   // 需回复
        _header.code = HEADER_CODE;
        
        _isNeedEndCmd = YES;
        
        return &_header;
    }
}

+ (void)changeHeader:(LedHeader *)header remoteCpuModel:(CPUModel)remoteModel{
    CPUModel model = [D5BigLittleEndianExchange deviceCpuModel];
    if (model != remoteModel) {
        header->len = [D5BigLittleEndianExchange changeShort:header->len];
        header->code = [D5BigLittleEndianExchange changeShort:header->code];
    }
}

#pragma mark - 转换IP
- (NSString *)convertIp {
    @autoreleasepool {
        NSString *phoneIP = [D5NetWork getDeviceIp];
        __block NSString *resultIP = nil;
        if ([NSString isValidateString:phoneIP]) {
            NSArray *arr = [phoneIP componentsSeparatedByString:@"."];
            if (arr && arr.count > 0) {
                NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:arr];
                [mutableArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @autoreleasepool {
                        if (idx == mutableArr.count - 1) {
                            [mutableArr insertObject:@"255" atIndex:mutableArr.count - 1];
                            [mutableArr removeLastObject];
                            
                            resultIP = [mutableArr componentsJoinedByString:@"."];
                        }
                    }
                }];
            }
        }
        
        return resultIP;
    }
}

#pragma mark - 添加移除cmd
- (void)startCmd {
    [[D5LedModule sharedLedModule].cmds addCmdMuticastDelegate:self];
    
    // (self.header.cmd == Cmd_Box_Operate && self.header.subCmd == SubCmd_Box_Scan) ||
    if ((self.header.cmd == Cmd_Led_Operate && self.header.subCmd == SubCmd_Led_List) ||
        (self.header.cmd == Cmd_Box_Operate && self.header.subCmd == SubCmd_Box_Runtime_Info)) { //广播的
        return;
    }
    
    [self startTimer];
}

- (void)endCmd {
    //DLog(@"endCmd %@", [self class]);
    [[D5LedModule sharedLedModule].cmds removeCmdMuticastDelegate:self];
    if (_tempUdp) {
        [_tempUdp close];
        _tempUdp = nil;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //+
    });
}

#pragma mark - 定时器
/**
 *  检测超时
 */
- (void)startTimer {
    @autoreleasepool {
        NSTimeInterval interval = REMOTE_TIMEOUT_INTERVAL;
        if (_remoteLocalTag == tag_local) {
            interval = LOCAL_TIMEOUT_INTERVAL;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(cmdTimeOut) userInfo:nil repeats:NO];
        });
    }
}
/**
 *  超时处理
 */
- (void)cmdTimeOut {
    @autoreleasepool {
        DLog(@"超时结束接收数据 ----  %d-%d", _headerCmd, _headerSubCmd);
        [self cmdReceivedResult];
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (_errorDelegate == obj && [_errorDelegate respondsToSelector:@selector(d5NetWorkError:errorMessage:data:forHeader:)]) {
                    NSString *error = [NSString stringWithFormat:@"%u", D5SocketErrorCodeTypeTimeOut];
                    [obj d5NetWorkError:D5SocketErrorCodeTypeTimeOut errorMessage:CustomLocalizedStringFromTable(error, @"D5SocketMessage", nil) data:nil forHeader:&_header];
                    
                    *stop = YES;
                }
            }
        }];
    }
}

/**
 关闭定时器
 */
- (void)stopTimer {
    @autoreleasepool {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

#pragma mark - 获取校验码
- (int8_t)getCheckSum:(NSData *)data {
    @autoreleasepool {
        Byte *byte = (Byte *)[data bytes];
        NSUInteger sum = 0;
        for (NSUInteger i = 0; i < [data length]; i ++) {
            sum = (Byte)byte[i] + sum;
        }
        return sum % 256;
    }
}

#pragma mark - 接收到数据停止定时器（不存在超时了）
- (void)cmdReceivedResult {
//    DLog(@"cmdReceivedResult %d-- %d -- sn = %d  %@", self.header.cmd, self.header.subCmd, self.header.sn, self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
        [self endCmd];
    });
}

#pragma mark - 接收数据出现错误
- (void)cmdError:(int)errorCode withMsg:(NSString *)msg withHeader:(LedHeader *)header withData:(NSDictionary *)data from:(NSString *)ip {
    @autoreleasepool {
        if ((header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Scan) ||
            (header->cmd == Cmd_Led_Operate && header->subCmd == SubCmd_Led_List) ||
            (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Runtime_Info)) { //广播的都不用result
        } else {
            [self cmdReceivedResult];
        }
        
        [self processErrorCode:errorCode];//处理常见错误信息
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj &&
                    [obj class] != nil &&
                    [obj respondsToSelector:@selector(d5NetWorkError:errorMessage:data:forHeader:)]) {
                    [obj d5NetWorkError:errorCode errorMessage:msg data:data forHeader:header];
                }
            }
        }];
    }
}

#pragma mark - 错误信息的描述
-(void)processErrorCode:(int64_t)errorcode {
    NSString*errorMessage;
    
    switch (errorcode) {
            
        case D5SocketErrorCodeMACERROR:
            errorMessage=@"mac地址错误,设备或APP收到的destMac与自身Mac不匹配时使用.";
            break;
        case D5SocketErrorCodeCHECKSUMMISMATCH:
            errorMessage=@"校验码数据，checkSum值与计算出的值不匹配";
            break;
        case D5SocketErrorCodeDATALENTHERROR:
            errorMessage=@"包长度错误，len与实现包长度不匹配";
            break;
        case D5SocketErrorCodePERSSIONERROR:
            errorMessage=@"权限错误，已被其他手机绑定";
            break;
        case D5SocketErrorCodeDEVICEOFFLINE:
            errorMessage=@"设备不在线";
            break;
        case D5SocketErrorCodeSTARTUPDATEFAILURE:
            errorMessage=@"启动更新失败";
            break;
        case D5SocketErrorCodeREPEATEDSTARTUPDATEE:
            errorMessage=@"已经启动更新了，不能重复启用";
            break;
        case D5SocketErrorCodeSERVERCONNECTIONFAILED:
            errorMessage=@"服务器连接失败";
            break;
        case D5SocketErrorCodeFIRMWAREDOWNLOADFAILED:
            errorMessage=@"固件下载失败";
            break;
        case D5SocketErrorCodeBODYERROR:
            errorMessage=@"Body错误";
            break;
        case D5SocketErrorCodeBODYNULL:
            errorMessage=@"Body为空";
            break;
        case D5SocketErrorCodeUNKNOWNERROR:
            errorMessage=@"未知错误";
            break;
        case D5SocketErrorCode1003:
            errorMessage=@"";
            break;
        case D5SocketErrorCodeADDINGLIGHTS:
            errorMessage=@"正在添加新灯时不能进行灯的控制";
            break;
        case D5SocketErrorCodeTOOMANYLIGHTS:
            errorMessage=@"歌曲已被删除，请刷新";
            break;
        case D5SocketErrorCode1006:
            errorMessage=@"";
            break;
        case D5SocketErrorCodeOPERATIONFAILURE:
            errorMessage=@"操作失败";
            break;
        case D5SocketErrorCode1008:
            errorMessage=@"";
            break;
        case D5SocketErrorCodeBOXCLOSE:
            errorMessage=@"盒子已经关闭不能执行当前操作";
            break;
        case D5SocketErrorCodeBOXWIFINOTCONFIGURED:
            errorMessage=@"盒子WIFI未配置";
            break;
        default:
            break;
    }
    
    if (errorcode==D5SocketErrorCodePERSSIONERROR||errorcode==D5SocketErrorCodeDEVICEOFFLINE||errorcode==D5SocketErrorCodeSTARTUPDATEFAILURE||errorcode==D5SocketErrorCodeREPEATEDSTARTUPDATEE||errorcode==D5SocketErrorCodeSERVERCONNECTIONFAILED||errorcode==D5SocketErrorCodeFIRMWAREDOWNLOADFAILED||errorcode==D5SocketErrorCodeADDINGLIGHTS||errorcode==D5SocketErrorCodeTOOMANYLIGHTS||errorcode==D5SocketErrorCodeBOXCLOSE||errorcode==D5SocketErrorCodeBOXWIFINOTCONFIGURED) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [iToast showButtomTitile:errorMessage]; //弹出错误信息
            
        });
    }

}

#pragma mark - 发送数据
- (void)sendData:(NSData *)data {
    @autoreleasepool {
        if (_remoteLocalTag == tag_local) {  //UDP发送
            if ([self.localIp isNULL]) {
                NSAssert([_localIp isNULL], @" self.header->cmd IP地址为空");
            }
            [self startCmd];
            _tempUdp = [[D5LedModule sharedLedModule] sendUdpData:self.localIp port:self.localPort withData:data];
        } else { //TCP发送
            [self startCmd];
            [[D5LedModule sharedLedModule] sendTcpData:_remoteIp port:_remotePort withData:data];
        }
    }
}

- (void)sendBroadCastData:(NSData *)data {
    @autoreleasepool {
        [self startCmd];
        D5Udp *udp = [[D5UdpPingManager defaultUdpPingManager] getPing:LED_BOX_SEND_PORT deviceModule:[D5LedModule sharedLedModule]];
        if (!udp) {
            udp = [[D5UdpPingManager defaultUdpPingManager] addPing:LED_BOX_SEND_PORT deviceModule:[D5LedModule sharedLedModule]];
        }
        [udp sendData:data toHost:[self convertIp] toPort:LED_BOX_RECEIVE_PORT withTag:tag_local];
    }
}

- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict {
    [self ledSendData:cmd withSubCmd:subCmd withData:dict isNeedEndCmd:YES];
}

- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd {
    [self ledSendData:cmd withSubCmd:subCmd withData:nil];
}

- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict isNeedEndCmd:(BOOL)isNeedEndCmd {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:cmd withSubCmd:subCmd];
        uint16_t len = sizeof(LedHeader) + 1; // 不包含body的len
        
        NSData *body = nil;
        if (dict) { // 是否有body
            body = [NSJSONSerialization jsonDataFromDict:dict];
            len += body.length;
        }
        
        header->len = len;
        [D5LedCmd changeHeader:header remoteCpuModel:self.remoteModel];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        
        if (body) {
            [data appendData:body];
        }
        
        uint8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(uint8_t)];
        
        _isNeedEndCmd = isNeedEndCmd;
        
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Scan) { // 搜索盒子
            [self sendBroadCastData:data];
        } else {
            [self sendData:data];
        }
        
        DLog(@"------发送数据 %d-%d %@", _headerCmd, _headerSubCmd, data);
    }
}

- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd isNeedEndCmd:(BOOL)isNeedEndCmd {
    [self ledSendData:cmd withSubCmd:subCmd withData:nil isNeedEndCmd:isNeedEndCmd];
}

#pragma mark - 接收到数据的处理
- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip {
    @autoreleasepool {
        if (header->cmd != _headerCmd || header->subCmd != _headerSubCmd) {
            return;
        }
        
        if (header->cmd == 2 && header->subCmd == 1) {
//             DLog(@"返回数据了  %d-%d", header->cmd, header->subCmd);
        }
        
        if (_isNeedEndCmd) {
            [self cmdReceivedResult];
        }
        
        [[D5LedModule sharedLedModule].resultMuticast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (obj) {
                    if (!body) {     // 没有body
                        if ([obj respondsToSelector:@selector(ledCmdReceivedData:)]) {
                            [obj ledCmdReceivedData:header];
                        }
                    } else {   // 有body
                        if ([obj respondsToSelector:@selector(ledCmdReceivedData:withData:withIP:)]) {
                            [obj ledCmdReceivedData:header withData:body withIP:ip];
                        } else if ([obj respondsToSelector:@selector(ledCmdReceivedData:withData:)]) {
                            [obj ledCmdReceivedData:header withData:body];
                        }
                    }
                }
            }
        }];
    }
}
@end
