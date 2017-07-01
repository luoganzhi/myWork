//
//  D5DeviceNetWork.h
//  D5Home
//
//  Created by anthonyxoing on 31/1/15.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _network_type{
    D5Network_type_udp = 1,
    D5Network_type_tcp =  1 << 1
}NetWorkType;

typedef enum _net_error{
    networking_udp_timeout = 0,
    networking_udp_send_error,
    networking_udp_connect_error
}NetError;
@class D5DeviceNetWork;

@protocol D5DeviceNetWorkDelegate <NSObject>

-(void)d5network:(D5DeviceNetWork *)networking udpRecevied:(NSData *)data withAddress:(NSString *)ipAddress;
-(void)d5network:(D5DeviceNetWork *)networking errorCode:(NetError)errorCode withMessage:(NSString *)message withTag:(long)tag;
-(void)d5network:(D5DeviceNetWork *)networking tcpRecevied:(NSData *)data;
@end

@interface D5DeviceNetWork : NSObject

@property (assign,nonatomic) id<D5DeviceNetWorkDelegate> delegate;
@property (assign,nonatomic) NetWorkType networktype;
@property (retain,nonatomic) NSString * tcpAddress;
@property (assign,nonatomic) int16_t tcpPort,udpPort;
@property (assign,nonatomic) BOOL isEnableBroadCast;

-(void)sendUdpData:(NSData *)data withIpAddress:(NSString *)address withTag:(long)tag;
-(void)sendTcpData:(NSData *)data withTag:(long)tag;

-(void)initialTcpConnect;
-(void)initialUdpConnect;
@end
