//
//  D5LedCommunication.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCommunication.h"
#import "D5TcpManager.h"
#import "D5DeviceReceiveDataAnalyer.h"
#import "D5DisconnectTipView.h"
#import "AppDelegate.h"

static D5LedCommunication *instance = nil;

@interface D5LedCommunication()

/** 还未发送的数据的dict -- 键：ip+port-- 值：arr */
@property (nonatomic, strong) NSMutableDictionary *notSendDataDict;

/** 接收数据 */
@property (nonatomic, strong) D5DeviceReceiveDataAnalyer *result;

@end

@implementation D5LedCommunication

+ (D5LedCommunication *)sharedLedModule {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[D5LedCommunication alloc] init];
    });
    return instance;
}

- (NSMutableDictionary *)notSendDataDict {
    if (!_notSendDataDict) {
        _notSendDataDict = [NSMutableDictionary dictionary];
    }
    return _notSendDataDict;
}

- (D5DeviceReceiveDataAnalyer *)result {
    if (!_result) {
        _result = [[D5DeviceReceiveDataAnalyer alloc] init];
    }
    return _result;
}

/**
 由ip+port拼接成的key字符串
 
 @param tcpRemoteIP ip
 @param tcpRmotePort port
 @return key字符串
 */
- (NSString *)socketKey:(NSString *)tcpRemoteIP port:(uint16_t)tcpRmotePort {
    return [NSString stringWithFormat:@"%@+%d" ,tcpRemoteIP, tcpRmotePort];
}

/**
 根据key从dict中获取value--arr,如果为空，则会创建一个新的arr
 
 @param key 指定key
 @return 指定key所对应的value
 */
- (NSMutableArray *)arrWithKey:(NSString *)key {
    @autoreleasepool {
        NSMutableArray *arr = self.notSendDataDict[key];
        if (!arr) {
            arr = [NSMutableArray array];
        }
        return arr;
    }
}

- (void)addTcpData:(NSData *)data serverIp:(NSString *)serverIP port:(uint16_t)serverPort {
    @autoreleasepool {
        // 将数据包加入dict中
        NSString *key = [self socketKey:serverIP port:serverPort];
        NSMutableArray *arr = [self arrWithKey:key];
        [arr addObject:data];
        
        self.notSendDataDict[key] = arr;
        
        // 建立连接
//        [self tcpConnect:serverIP port:serverPort];--- 不用去连接
    }
}

- (void)sendNotSendDatasByTcp:(D5Tcp *)tcp {
    @autoreleasepool {
        NSString *key = [self socketKey:tcp.serverIP port:tcp.serverPort];
        NSMutableArray *arr = [self arrWithKey:key];
        
        if (!arr || arr.count == 0) {
            return;
        }
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                NSData *data = (NSData *)obj;
                DLog(@"----发送未发送的数据包 ---- %@",data);
                [tcp sendData:data withTag:arc4random()];
                
                [arr removeObject:obj];
            }
        }];
    }
}

#pragma mark - tcp delegate
- (void)tcpConnected:(D5Tcp *)tcp arg:(NSObject *)obj {
    @autoreleasepool {
        DLog(@"-------- TCP --- Connect Success  %@", tcp);
        [D5DisconnectTipView sharedDisconnectTipView].status = ConnectStatusReConnectSuccess;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TCP_CONNECT_SUCCESS object:tcp];
        });
    }
}

- (void)tcpError:(D5Tcp *)tcp errCode:(D5TcpError)code errorMessage:(NSString *)message {
    @autoreleasepool {
        DLog(@"------ TCP Connect Error ----  %@ %d  %@", tcp, code, message);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [[NSNotificationCenter defaultCenter] postNotificationName:TCP_DISCONNET object:tcp];
        });
        // 移除TCP
        [[D5TcpManager defaultTcpManager] deleteTcp:tcp.serverIP port:tcp.serverPort];
        
        // 关闭心跳
        [[D5LedZKTList defaultList] finishHeart];
        
        [[D5LedList sharedInstance] stopHeartTimer];
        
        // 登录状态改为失败
        [D5LedZKTList defaultList].loginStatus = LedLoginStatusLoginFailed;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TCP_DISCONNET_MANNGER object:tcp];
        
        if ([D5DisconnectTipView sharedDisconnectTipView].status == ConnectStatusReConnectIng) { // 重连中
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:TCP_CONNECT_FAILED object:tcp];
            });
            return ;
        }
       
        if (code == D5Tcp_Manual_Disconnected_error || code == D5Tcp_NO_Error) { // 手动断开 (重置中控、心跳超时后手动断开)
           
        } else {
            if (code == D5Tcp_Background_Error) {
                return;
            }
            
            // 界面弹出
            dispatch_async(dispatch_get_main_queue(), ^{
                DLog(@"连接断开  添加  eorr = %@ ",  message);
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if (!delegate.isChangeWifiOrWired) {
                    DLog(@"显示断开连接提示");
                    [[D5DisconnectTipView sharedDisconnectTipView] showView];
                }
            });
        }
    }
}

- (void)tcpSendedData:(D5Tcp *)tcp tag:(NSInteger)tag {
    @autoreleasepool {
        DLog(@"------send success --");
    }
}

- (void)tcp:(D5Tcp *)tcp receivedData:(NSData *)data {
    @autoreleasepool {
        [super tcp:tcp receivedData:data];
        
        static dispatch_queue_t tcpDataQueue = NULL;
        if (tcpDataQueue == NULL) {
            tcpDataQueue = dispatch_queue_create("tcpdata.led.d5", DISPATCH_QUEUE_SERIAL); //创建串行队列
        }
        
        dispatch_async(tcpDataQueue, ^{
            [self.result receivedData:data from:nil networkType:D5SocketTypeTcp];     
        });
    }
}

#pragma mark - udp delegate
- (void)udp:(D5Udp *)udp receivedData:(NSData *)data from:(NSString *)ip {
    @autoreleasepool {
        [super udp:udp receivedData:data from:ip];
        static dispatch_queue_t udpDataQueue = NULL;
        if (udpDataQueue == NULL) {
            udpDataQueue = dispatch_queue_create("udpdata.led.d5", DISPATCH_QUEUE_SERIAL);
        }
        
        dispatch_async(udpDataQueue, ^{
            D5DeviceReceiveDataAnalyer *analyer = [[D5DeviceReceiveDataAnalyer alloc] init];
            [analyer receivedData:data from:ip networkType:D5SocketTypeUdp];
        });
    }
}
@end
