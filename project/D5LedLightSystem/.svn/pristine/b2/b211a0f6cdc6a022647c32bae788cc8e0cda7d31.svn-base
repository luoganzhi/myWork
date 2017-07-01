//
//  D5Udp.h
//  Network
//
//  Created by anthonyxoing on 15/9/7.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "D5Socket.h"
#import "D5CmdMuticast.h"
#import "D5NetRecvieDataArray.h"

@protocol D5UdpDelegate <NSObject>

@optional
- (void)udpReciveData:(NSData *)data from:(NSString *)ip withTag:(NSInteger)tag fromSocket:(id)socket;
- (void)udpError:(D5SocketErrorCodeType)errorCode otherError:(NSInteger)otherCode withTag:(NSInteger)tag;
- (void)udpClosed:(uint16_t)port;
@end

@interface D5Udp : NSObject<GCDAsyncUdpSocketDelegate>

@property (retain,nonatomic) GCDAsyncUdpSocket *udpSocket;
@property (retain,nonatomic) NSString *remoteIp;
@property (assign,nonatomic) uint16_t port;
@property (assign,nonatomic) BOOL isEnableBroadcast,isManualClosed;
@property (retain,nonatomic) D5NetRecvieDataArray *reciveData;
@property (retain,nonatomic) D5CmdMuticast *dataSourceCast;

- (void)beginRecive;
- (void)connect;
- (void)sendData:(NSData *)data toHost:(NSString *)ip toPort:(uint16_t)port withTag:(NSInteger)tag;
- (void)close;
@end
