//
//  D5Udp.h
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/16.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _udp_error{
    D5Udp_NO_Error,
    D5Udp_Socket_Closed = 2000,
    D5Udp_Send_Timeout,
    D5Udp_Remote_IP_Empty,
    D5Udp_Remote_IP_Error,
    D5Udp_Remote_Port_Zero,
    D5Udp_BroadCast_Open_Error,
    D5Udp_Send_error,
    D5Udp_LocalPort_Error,
    D5Udp_Receive_Error,
    D5Udp_Close_Error,
    D5Udp_Ohter_Error
}D5UdpError;

@class D5Udp;
@protocol D5UdpDelegate <NSObject>

@optional

- (void)udpError:(D5Udp *)udp errorCode:(D5UdpError) code message:(NSString *)string;
- (void)udp:(D5Udp *)udp receivedData:(NSData *)data from:(NSString *)ip;
- (void)udpClose:(D5Udp *)udp errorCode:(D5UdpError)errorCode message:(NSString *)message;
- (void)udpSendSuccess:(D5Udp *)udp;

@end


@interface D5Udp : NSObject

//远程ip地址(目的ip地址）
@property (strong,nonatomic) NSString * remoteIP;

//远程端口号（目的端口号）
@property (assign,nonatomic) uint16_t remotePort;

//本地端口号，如果不设置，则随机使用一个没有被占用的端口号
@property (assign,nonatomic) uint16_t localPort;

//是否使用ipv6的标识,默认不使用
@property (assign,nonatomic) BOOL isIpV6Enable;

//是否使用使用广播的标识
@property (assign,nonatomic) BOOL isBroadCast;


@property (weak,nonatomic) id<D5UdpDelegate> delegate;

/**
 *  发送数据,只管发送，不管多久接收到数据
 *
 *  @param remoteIp   目的ip
 *  @param remotePort 目的端口
 *  @param data 发送的数据
 */
- (void)sendData:(NSData *)data toRemote:(NSString *)remoteIp toPort:(uint16_t)remotePort;

/**
 *  发送数据,并且要求在一定时间内接收到数据
 *
 *  @param remoteIp   目的ip
 *  @param remotePort 目的端口
 *  @param data 发送的数据
 *  @param timeOut 发送数据超时时间
 */
- (void)sendData:(NSData *)data toRemote:(NSString *)remoteIp toPort:(uint16_t)remotePort withTimeOut:(NSTimeInterval)timeOut;

/**
 *  关闭udp
 *
 */
- (void)close;


- (BOOL )initialUdp;

- (void)beginReceive;

@end
