//
//  D5DeviceModule.h
//  Network
//
//  Created by anthonyxoing on 15/9/8.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5CmdMuticast.h"
#import "D5LedCmds.h"
#import "D5Socket.h"
#import "D5Udp.h"
#import "D5Tcp.h"

@interface D5DeviceModule : NSObject <D5TcpDelegate, D5UdpDelegate>

@property (strong, nonatomic) D5CmdMuticast *cmds;

/**
 *  建立TCP链接
 *
 *  @param serverIP   服务器IP
 *  @param serverPort 服务器端口
 */
- (void)addServer:(NSString *)serverIP port:(uint16_t)serverPort;

/**
 *  建立UDP链接
 *
 *  @param port
 */
- (void)addPing:(uint16_t)port;

/**
 *  发送UDP数据
 *
 *  @param remoteIP   目的远程IP
 *  @param remotePort 目的远程端口
 *  @param data       发送的数据
 *
 *  @return UDP实例
 */
- (D5Udp *)sendUdpData:(NSString *)remoteIP port:(uint16_t)remotePort withData:(NSData *)data;
/**
 *  发送TCP数据
 *
 *  @param serverIP   目的服务器IP
 *  @param serverPort 母的端口
 *  @param data       发送的数据
 */
- (void)sendTcpData:(NSString *)serverIP port:(uint16_t)serverPort withData:(NSData *)data;

/**
 *  接收到tcp数据
 *
 *  @param data
 */
- (void)receiveTcpData:(NSData *)data;

/**
 *  接收到UDP数据
 *
 *  @param data
 *  @param ip   来自IP地址
 */
- (void)receiveUdpData:(NSData *)data from:(NSString *)ip;

/**
 *  接收数据时网络错误
 *
 *  @param type         网络错误类型
 *  @param errorMessage 错误信息
 *  @param socketType   UDP/TCP
 */
- (void)networkError:(int)type errorMessage:(NSString *)errorMessage netType:(D5SocketType)socketType;
@end
