                                                                                                                                                                                                                                                                                                                                                        //
//  D5LedSendReceiveCmd.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedSendReceiveCmd.h"
#import "NSObject+runtime.h"
#import "D5LedCommunication.h"
#import "D5DisconnectTipView.h"
#import "D5BtLightUpdateViewController.h"
#import "AppDelegate.h"

@interface D5LedSendReceiveCmd () {
    Class _errorClass;
    Class _receiveClass;
}

@property (strong, nonatomic) D5Udp *tempUdp;

@end

@implementation D5LedSendReceiveCmd

#pragma mark - 设置代理
-(void)setReceiveDelegate:(id<D5LedCmdDelegate>)receiveDelegate{
    _receiveDelegate = receiveDelegate;
    _receiveClass = [self objectGetClass:_receiveDelegate];
}

- (void)setErrorDelegate:(id<D5LedNetWorkErrorDelegate>)errorDelegate {
    _errorDelegate = errorDelegate;
    _errorClass = [self objectGetClass:_errorDelegate];
}

#pragma mark - 检测代理是否存在
- (BOOL)checkReceiveDelegate {
    if (!_receiveDelegate) {
        return NO;
    }
    Class nowClass = [self objectGetClass:_receiveDelegate];
    return nowClass && (nowClass == _receiveClass);
}

- (BOOL)checkErrorDelegate {
    if (!_errorDelegate) {
        return NO;
    }
    Class nowClass = [self objectGetClass:_errorDelegate];
    return nowClass && (nowClass == _errorClass);
}

- (void)closeUdp {
    if (_tempUdp) { // 关闭广播的UDP
        [_tempUdp close];
        _tempUdp = nil;
    }
}

#pragma mark - 封装发送的data
- (NSMutableData *)packageSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict {
    @autoreleasepool {
        LedHeader *header = [self headerForCmd:cmd withSubCmd:subCmd];
        uint16_t len = sizeof(LedHeader) + 1; // 不包含body的len
        
        NSData *body = nil;
        if (dict) { // 是否有body
            body = [NSJSONSerialization jsonDataFromDict:dict];
            len += body.length;
        }
        
        header->len = len;
        [D5LedBaseCmd changeHeader:header remoteCpuModel:self.remoteModel];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendBytes:header length:sizeof(LedHeader)];
        
        if (body) {
            [data appendData:body];
        }
        
        uint8_t checkSum = [self getCheckSum:data];
        [data appendBytes:&checkSum length:sizeof(uint8_t)];
        
        return data;
    }
}

#pragma mark - 发送数据
- (void)sendData:(NSData *)data needAddToTempList:(BOOL)isNeed {
    if (self.remoteLocalTag == tag_local) {  // UDP发送
        DLog(@"UDP send");
        if ([self.localIp isNULL]) {
            NSAssert([self.localIp isNULL], @" self.header->cmd IP地址为空");
        }
        [self startCmd];
        _tempUdp = [[D5LedCommunication sharedLedModule] sendUdpData:self.localIp removePort:self.remotePort localPort:0 withData:data];
    } else {            // TCP发送
        [self startCmd];
        [[D5LedCommunication sharedLedModule] sendTcpData:data toServer:self.remoteIp port:self.remotePort needAddToTempList:isNeed];
    }
}

- (void)sendBroadCastData:(NSData *)data {}

- (void)sendHeartData:(NSData *)data {}

- (void)sendPushData:(NSData *)data {}

- (NSMutableData *)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict {
    @autoreleasepool {
        NSMutableData *data = [self packageSendData:cmd withSubCmd:subCmd withData:dict];
        
        BOOL isLoginCmd = (cmd == Cmd_Box_Operate && subCmd == SubCmd_Box_App_Login);
        BOOL isLoginSucess = ([D5LedZKTList defaultList].loginStatus == LedLoginStatusLoginSuccess);
        
        _isNeedAddToList = (!isLoginSucess && !isLoginCmd);
        return data;
    }
}

- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd {
    [self ledSendData:cmd withSubCmd:subCmd withData:nil];
}

#pragma mark - 接收到数据的处理
- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip {
    @autoreleasepool {
        
        if (header->cmd == 4 && header->subCmd == 9) {
            NSLog(@"进入4-9 222222");
        }
        
        if (header->cmd == 4 && header->subCmd == 7) {
            DLog(@"进入4-7");
            if ([_receiveDelegate respondsToSelector:@selector(ledCmdReceivedData:withData:)]) {
                if (header->cmd == 4 && header->subCmd == 7) {
                    NSLog(@"进入4-9 99999");
                }
                [_receiveDelegate ledCmdReceivedData:header withData:body];
            }
        }
        
        
        if (header->cmd == self.headerCmd && header->subCmd == self.headerSubCmd){
            
            if (header->cmd == 4 && header->subCmd == 9) {
                NSLog(@"进入4-9 333333");
            }
            
            if ([self checkReceiveDelegate]) {
                
                if (header->cmd == 4 && header->subCmd == 9) {
                    NSLog(@"进入4-9 444444");
                }
                
                if (!body) {     // 没有body
                    if (header->cmd == 4 && header->subCmd == 9) {
                        NSLog(@"进入4-9 55555");
                    }
                    if ([_receiveDelegate respondsToSelector:@selector(ledCmdReceivedData:)]) {
                        if (header->cmd == 4 && header->subCmd == 9) {
                            NSLog(@"进入4-9 7777");
                        }
                        [_receiveDelegate ledCmdReceivedData:header];
                    }
                } else {   // 有body
                    if (header->cmd == 4 && header->subCmd == 9) {
                        NSLog(@"进入4-9 66666");
                    }
                    if ([_receiveDelegate respondsToSelector:@selector(ledCmdReceivedData:withData:withIP:)]) {
                        if (header->cmd == 4 && header->subCmd == 9) {
                            NSLog(@"进入4-9 88888");
                        }
                        [_receiveDelegate ledCmdReceivedData:header withData:body withIP:ip];
                    } else if ([_receiveDelegate respondsToSelector:@selector(ledCmdReceivedData:withData:)]) {
                        if (header->cmd == 4 && header->subCmd == 9) {
                            NSLog(@"进入4-9 99999");
                        }
                        [_receiveDelegate ledCmdReceivedData:header withData:body];
                    }
                }
            }

        }
        
    }
}

#pragma mark - 接收数据出现错误
- (void)cmdError:(int)errorCode withMsg:(NSString *)msg withHeader:(LedHeader *)header withData:(NSDictionary *)data from:(NSString *)ip {
    @autoreleasepool {
        [self processErrorCode:errorCode];//处理常见错误信息
        if ([self checkErrorDelegate] &&
            [_errorDelegate respondsToSelector:@selector(d5NetWorkError:errorMessage:data:forHeader:)]) {
            [_errorDelegate d5NetWorkError:errorCode errorMessage:msg data:data forHeader:header];
            if (errorCode == D5SocketErrorCodeTypeLedInUploading) {
                [self pushToBtUpdateVCWithErrorDelegate:_errorDelegate];
            }
        }
    }
}

- (void)pushToBtUpdateVCWithErrorDelegate:(id)errorDelegate {
    @autoreleasepool {
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        DLog(@"visible VC = %@", ((UINavigationController *)vc).visibleViewController);
//        if (vc && [vc isKindOfClass:[UINavigationController class]]) {
//           UIViewController *topVC = ((UINavigationController *)vc).topViewController;
//            if (topVC && [topVC isKindOfClass:[D5BtLightUpdateViewController class]]) {
//                return;
//            }
//        }
        
        D5BtLightUpdateViewController *btVC = [[UIStoryboard storyboardWithName:MAIN_STORYBOARD_ID bundle:nil] instantiateViewControllerWithIdentifier:BTLIGHT_UPDATE_VC_ID];
        
        
        if (btVC) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                DLog(@"----push1----  %d", delegate.btIsPush);

                if (delegate.btIsPush) {
                    return;
                }
                
                DLog(@"----push2----  %d", delegate.btIsPush);

                btVC.from = BtUpdatePushFromMain;
                if ([errorDelegate isKindOfClass:[UIViewController class]]) {
                        delegate.btIsPush = YES;
                        [((UIViewController *)errorDelegate).navigationController pushViewController:btVC animated:NO];
                            DLog(@"----push3----  %d", delegate.btIsPush);
                }
            });
        }
    }
}


#pragma mark - 错误信息的描述
- (void)processErrorCode:(int64_t)errorcode {
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

@end
