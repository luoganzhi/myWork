//
//  D5Tcp.h
//  Network
//
//  Created by anthonyxoing on 15/9/7.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "D5Socket.h"
#import "D5CmdMuticast.h"

@protocol D5TcpDelegate <NSObject>

@optional
- (void)tcpReciveData:(NSData *)data;
- (void)tcpError:(D5SocketErrorCodeType)errorCode;

@end

@interface D5Tcp : NSObject<GCDAsyncSocketDelegate>

@property (retain,nonatomic) GCDAsyncSocket * tcpSocket;
@property (retain,nonatomic) NSString * remoteIP;
@property (assign,nonatomic) uint16_t remotePort;
@property (assign,nonatomic) BOOL isBackGround;
@property (assign,nonatomic) NSTimeInterval reconnectTimeInterval;

@property (retain,nonatomic) D5CmdMuticast * dataSourceCast;
- (void)connectTo:(NSString *)ip port:(uint16_t)port;
- (void)sendData:(NSData *)data withTag:(NSInteger)tag;
- (BOOL)isConnect;
- (void)disconnect;
@end
