//
//  D5DeviceBaseCommunication.m
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import "D5DeviceBaseCommunication.h"
#import "NSObject+runtime.h"
#import "D5TcpManager.h"
#import "D5UdpPingManager.h"

@interface D5DeviceBaseCommunication() 

@end

@implementation D5DeviceBaseCommunication

- (D5MutiCmd *)cmds {
    if (!_cmds) {
        _cmds = [[D5MutiCmd alloc] init];
    }
    return _cmds;
}

#pragma mark - TCP
- (void)tcp:(D5Tcp *)tcp receivedData:(NSData *)data {}

- (void)tcpConnected:(D5Tcp *)tcp arg:(NSObject *)obj {}

- (void)tcpSendedData:(D5Tcp *)tcp tag:(NSInteger)tag {}

- (void)tcpError:(D5Tcp *)tcp errCode:(D5TcpError)code errorMessage:(NSString *)message {}

- (void)tcpConnect:(NSString *)serverIP port:(uint16_t)serverPort {
    [[D5TcpManager defaultTcpManager] addTcp:serverIP port:serverPort delegate:self];
}

- (void)sendTcpData:(NSData *)data toServer:(NSString *)serverIP port:(uint16_t)serverPort needAddToTempList:(BOOL)isNeed {
    @autoreleasepool {
        D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:serverIP port:serverPort];
        
        if (!isNeed && tcp && tcp.isConnected) {
            [tcp sendData:data withTag:arc4random()];
        } else {
            [self addTcpData:data serverIp:serverIP port:serverPort];
        }
    }
}

- (void)addTcpData:(NSData *)data serverIp:(NSString *)serverIP port:(uint16_t)serverPort {
}

- (void)sendNotSendDatasByTcp:(D5Tcp *)tcp {}

- (void)disConnectTcp:(NSString *)serverIP port:(uint16_t)serverPort {
    @autoreleasepool {
        D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:serverIP port:serverPort];
        if (tcp && tcp.isConnected) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MANUAL_DISCONNECT object:tcp];
            });
        }
    }
}

#pragma mark - UDP
- (D5Udp *)udpConnect:(uint16_t)port {
    DLog(@"升级---udpConnect");
    D5Udp *udp = [[D5UdpPingManager defaultUdpManager] addPing:port delegate:self];
    return udp;
}

- (D5Udp *)sendUdpData:(NSString *)remoteIP removePort:(uint16_t)remotePort localPort:(uint16_t)localPort withData:(NSData *)data {
    @autoreleasepool {
        D5Udp *udp = [[D5Udp alloc] init];
        udp.localPort = localPort;
        [udp setDelegate:self];
        [udp sendData:data toRemote:remoteIP toPort:remotePort];
        
        return udp;
    }
}

- (void)disConnectUdp:(uint16_t)port {
    [[D5UdpPingManager defaultUdpManager] removePing:port];
}

- (void)udp:(D5Udp *)udp receivedData:(NSData *)data from:(NSString *)ip {}

- (void)udpError:(D5Udp *)udp errorCode:(D5UdpError) code message:(NSString *)string {}

- (void)udpClose:(D5Udp *)udp errorCode:(D5UdpError)errorCode message:(NSString *)message {}

- (void)udpSendSuccess:(D5Udp *)udp {}

@end
