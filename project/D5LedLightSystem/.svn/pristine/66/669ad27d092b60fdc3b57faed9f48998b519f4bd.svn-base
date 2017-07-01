//
//  D5LedModule.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedModule.h"
#import "D5LedResult.h"
@interface D5LedModule()
/** D5LedResult */
@property (nonatomic, strong) D5LedResult *result;
@end

@implementation D5LedModule

- (D5LedResult *)result
{
    if (!_result) {
        _result = [[D5LedResult alloc] init];
    }
    return _result;
}

/**
 *  创建单例
 *
 *  @return 单例
 */
+ (D5LedModule *)sharedLedModule {
    @autoreleasepool {
        static D5LedModule *ledModule = nil;
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            ledModule = [[D5LedModule alloc] init];
        });
        return ledModule;
    }
}

- (D5CmdMuticast *)resultMuticast {
    if (!_resultMuticast) {
        _resultMuticast = [[D5CmdMuticast alloc] init];
    }
    return _resultMuticast;
}

#pragma mark - tcp delegate
/**
 *  接收tcp数据
 *
 *  @param data
 */
- (void)receiveTcpData:(NSData *)data {
    @autoreleasepool {
        [super receiveTcpData:data];
        static dispatch_queue_t tcpDataQueue = NULL;
        if (tcpDataQueue == NULL) {
            tcpDataQueue = dispatch_queue_create("tcpdata.led.d5", DISPATCH_QUEUE_SERIAL); //创建串行队列
        }
        
        dispatch_async(tcpDataQueue, ^{

            [self.result receivedData:data from:nil networkType:D5SocketTypeTcp];
          
        });
    }
}

// 连接超时或者连接断开
- (void)tcpError:(D5SocketErrorCodeType)errorCode {
    switch (errorCode) {
        case D5SocketErrorCodeTypeTimeOut: {        // 超时
            
        }
            break;
        case D5SocketErrorCodeTypeTcpDisconnect: {  // 断开连接
            
        }
            break;
        default:
            break;
    }
}

/**
 *  接收到UDP数据
 *
 *  @param data
 *  @param ip
 */
- (void)receiveUdpData:(NSData *)data from:(NSString *)ip {
    @autoreleasepool {
        [super receiveUdpData:data from:ip];
        static dispatch_queue_t udpDataQueue = NULL;
        if (udpDataQueue == NULL) {
            udpDataQueue = dispatch_queue_create("udpdata.led.d5", DISPATCH_QUEUE_SERIAL);
        }
        
        dispatch_async(udpDataQueue, ^{
            D5LedResult *result = [[D5LedResult alloc] init];
            [result receivedData:data from:ip networkType:D5SocketTypeUdp];
        });
    }
}
@end
