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

@interface D5DeviceModule()<D5TcpDelegate,D5UdpDelegate>
@property (retain,nonatomic) NSMutableArray *tempConnectArray;
@property (assign,nonatomic) uint16_t pingPort;
@property (retain,nonatomic) D5Udp *pingUdp;
@end

@implementation D5DeviceModule

- (D5CmdMuticast *)cmds {
    if (_cmds == nil) {
        _cmds = [[D5CmdMuticast alloc] init];
    }
    return _cmds;
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
            [tcp sendData:data withTag:arc4random()];
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
- (void)tcpError:(D5SocketErrorCodeType)errorCode {
    
}

- (void)tcpReciveData:(NSData *)data {
    [self reciveTcpData:data];
}

- (void)reciveTcpData:(NSData *)data {
    
}

#pragma mark - udp delegate
- (void)udpError:(D5SocketErrorCodeType)errorCode otherError:(NSInteger)otherCode withTag:(NSInteger)tag {
    
}

- (void)udpReciveData:(NSData *)data from:(NSString *)ip withTag:(NSInteger)tag fromSocket:(id)socket{
    [self reciveUdpData:data from:ip];
}

- (void)reciveUdpData:(NSData *)data from:(NSString *)ip {
    
}

- (void)networkError:(int)type errorMessage:(NSString *)errorMessage netType:(D5SocketType)socketType {
}

- (void)udpClosed:(uint16_t)port {
    if (port == _pingPort) {
        [[D5UdpPingManager defaultUdpPingManager] reCreatePing:_pingPort];
    }
}
@end
