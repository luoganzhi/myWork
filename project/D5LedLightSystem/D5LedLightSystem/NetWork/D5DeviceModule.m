//
//  D5DeviceModule.m
//  Network
//
//  Created by anthonyxoing on 15/9/8.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5DeviceModule.h"
#import "D5Udp.h"
#import "D5Tcp.h"
#import "D5TcpManager.h"
#import "D5UdpPingManager.h"

@interface D5DeviceModule()

@property (strong, nonatomic) NSMutableDictionary *tempCmdsDict;
@property (strong, nonatomic) NSMutableArray *tempConnectArray;
@property (assign,nonatomic) uint16_t pingPort;
@property (strong, nonatomic) D5Udp *pingUdp;
@property (nonatomic, strong) dispatch_semaphore_t sema;

@end

@implementation D5DeviceModule

- (D5CmdMuticast *)cmds {
    if (_cmds == nil) {
        _cmds = [[D5CmdMuticast alloc] init];
    }
    return _cmds;
}

- (NSMutableDictionary *)tempCmdsDict {
    if (!_tempCmdsDict) {
        _tempCmdsDict = [NSMutableDictionary new];
    }
    return _tempCmdsDict;
}

- (NSMutableArray *)tempConnectArray {
    if (_tempConnectArray == nil) {
        _tempConnectArray = [[NSMutableArray alloc] init];
    }
    return _tempConnectArray;
}

- (void)addServer:(NSString *)serverIP port:(uint16_t)serverPort {
    [[D5TcpManager defaultSocketManager] addConnect:serverIP port:serverPort deviceModule:self];
}

- (void)addPing:(uint16_t)port {
    _pingPort = port;
    [[D5UdpPingManager defaultUdpPingManager] addPing:port deviceModule:self];
}

- (void)sendTcpData:(NSString *)serverIP port:(uint16_t)serverPort withData:(NSData *)data {
    @autoreleasepool {
        D5Tcp *tcp = [[D5TcpManager defaultSocketManager] getConenct:serverIP port:serverPort deviceModule:self];
        if (tcp == nil) {
            [self addServer:serverIP port:serverPort];
            tcp = [[D5TcpManager defaultSocketManager] getConenct:serverIP port:serverPort deviceModule:self];
        }
        if (tcp) {
            if (![tcp isConnect]) { // 没连接 -- 将data加入tempCmdsDict中， 连接成功后以此发送
                NSString *key = [[D5TcpManager defaultSocketManager] socketKey:serverIP port:serverPort];
                
                NSMutableArray *arr = [self.tempCmdsDict objectForKey:key];
                if (!arr || arr.count == 0) {
                    arr = [NSMutableArray new];
                }
                [arr addObject:data];
                [self.tempCmdsDict setObject:arr forKey:key];
                
                [tcp connectTo:serverIP port:serverPort];
            } else {
                [tcp sendData:data withTag:arc4random()];
            }
        }
    }
}

- (D5Udp *)sendUdpData:(NSString *)remoteIP port:(uint16_t)remotePort withData:(NSData *)data {
    @autoreleasepool {
        D5Udp *udp = [[D5Udp alloc] init];
        udp.port = 0;
        [udp.dataSourceCast addCmdMuticastDelegate:self];
        [udp sendData:data toHost:remoteIP toPort:remotePort withTag:arc4random()];
        return udp;
    }
}

#pragma mark - tcp delegate
- (void)tcpReceiveData:(NSData *)data {
    [self receiveTcpData:data];
}

// 连接成功了 -- 发送队列里的命令
- (void)tcpConnected:(D5Tcp *)tcp {
    @autoreleasepool {
        NSString *key = [[D5TcpManager defaultSocketManager] socketKey:[D5CurrentBox currentBoxIP] port:LED_TCP_LONG_CONN_PORT];
        NSMutableArray *arr = [self.tempCmdsDict objectForKey:key];
        if (!arr || arr.count == 0) {
            return;
        }
        
        for (NSData *data in arr) {
            [tcp sendData:data withTag:arc4random()];
        }
        [self.tempCmdsDict removeObjectForKey:key];
    }
}

// 连接超时或者连接断开
- (void)tcpError:(D5SocketErrorCodeType)errorCode {
    switch (errorCode) {
        case D5SocketErrorCodeTypeTimeOut: {        // 超时
            
        }
            break;
        case D5SocketErrorCodeTypeTcpDisconnect: {  // 断开连接
            NSString *ip = [D5CurrentBox currentBoxIP];
            D5Tcp *tcp = [[D5TcpManager defaultSocketManager] getConenct:ip port:LED_TCP_LONG_CONN_PORT deviceModule:self];
            if (tcp) {
                [[D5TcpManager defaultSocketManager] deleteConnect:ip port:LED_TCP_LONG_CONN_PORT deviceModule:self];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - udp delegate
- (void)udpReceiveData:(NSData *)data from:(NSString *)ip withTag:(NSInteger)tag fromSocket:(id)socket {
    [self receiveUdpData:data from:ip];
}

- (void)udpClosed:(uint16_t)port {
    if (port == _pingPort) {
        [[D5UdpPingManager defaultUdpPingManager] reCreatePing:_pingPort];
    }
}

#pragma mark - received data
- (void)receiveTcpData:(NSData *)data {
}

- (void)receiveUdpData:(NSData *)data from:(NSString *)ip {
}

- (void)networkError:(int)type errorMessage:(NSString *)errorMessage netType:(D5SocketType)socketType {
}
@end
