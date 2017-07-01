//
//  D5DeviceModule.h
//  Network
//
//  Created by anthonyxoing on 15/9/8.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5CmdMuticast.h"
#import "D5Socket.h"
#import "D5Udp.h"

@interface D5DeviceModule : NSObject

@property (retain,nonatomic) D5CmdMuticast * cmds;

- (void)addServer:(NSString *)serverIP port:(uint16_t)serverPort;
- (void)addPing:(uint16_t)port;
- (D5Udp *)sendUdpData:(NSString *)remoteIP port:(uint16_t)remotePort withData:(NSData *)data;
- (void)sendTcpData:(NSString *)serverIP port:(uint16_t)serverPort withData:(NSData *)data;
- (void)reciveTcpData:(NSData *)data;
- (void)reciveUdpData:(NSData *)data from:(NSString *)ip;
- (void)networkError:(int)type errorMessage:(NSString *)errorMessage netType:(D5SocketType)socketType;
@end
