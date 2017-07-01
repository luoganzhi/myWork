//
//  D5DeviceBaseCommunication.h
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5MutiCmd.h"
#import "D5Tcp.h"
#import "D5Udp.h"

@interface D5DeviceBaseCommunication : NSObject<D5TcpDelegate, D5UdpDelegate>

/**
 *命令列表
 *作用：保存发送过的命令
 */
@property (strong,nonatomic) D5MutiCmd * cmds;

#pragma mark - TCP连接
/**
 *  建立TCP链接
 *
 *  @param serverIP   服务器IP
 *  @param serverPort 服务器端口
 */
- (void)tcpConnect:(NSString *)serverIP port:(uint16_t)serverPort;

/**
 发送TCP数据

 @param data 发送的数据
 @param serverIP 目的服务器IP
 @param serverPort 目的端口
 @param isNeed 是否需要加入队列中
 */
- (void)sendTcpData:(NSData *) data toServer:(NSString *) serverIP port:(uint16_t) serverPort needAddToTempList:(BOOL)isNeed;

/**
 *  接收到TCP数据
 *
 *  @param tcp 
 *  @param data 接收到的数据
 */
- (void)tcp:(D5Tcp *)tcp receivedData:(NSData *)data;

/**
 TCP未连接时，将要发送的数据包data加入到一个dict中，key为ip+port (子类去实现)
 
 @param data
 @param serverIP
 @param serverPort
 */
- (void)addTcpData:(NSData *)data serverIp:(NSString *)serverIP port:(uint16_t)serverPort;

/**
 发送未发送的数据包 -- 连接失败的、未登录先登录的

 @param tcp 
 */
- (void)sendNotSendDatasByTcp:(D5Tcp *)tcp;

/**
 手动断开TCP连接

 @param serverIP ip
 @param serverPort 端口
 */
- (void)disConnectTcp:(NSString *)serverIP port:(uint16_t)serverPort;

/**
 tcp断开连接（手动、自动）

 @param tcp tcp
 @param code 断开code
 @param message 断开消息
 */
- (void)tcpError:(D5Tcp *)tcp errCode:(D5TcpError) code errorMessage:(NSString *)message;

//链接成功回调
- (void)tcpConnected:(D5Tcp *)tcp arg:(NSObject *)obj;

//tcp发送数据成功回调
- (void)tcpSendedData:(D5Tcp *)tcp tag:(NSInteger)tag;

#pragma mark - UDP连接
/**
 *  建立UDP链接
 *
 *  @param port 端口
 *
 *  @return UDP实例
 */
- (D5Udp *)udpConnect:(uint16_t)port;

/**
 *  发送UDP数据
 *
 *  @param remoteIP   目的远程IP
 *  @param remotePort 目的远程端口
 *  @param lcoalPort  本地接收端口
 *  @param data       发送的数据
 *
 *  @return UDP实例
 */
- (D5Udp *)sendUdpData:(NSString *)remoteIP removePort:(uint16_t)remotePort localPort:(uint16_t)localPort withData:(NSData *)data;

/**
 *  接收到UDP数据
 *
 *  @param udp
 *  @param data 发送的数据
 *  @param ip   来自IP地址
 */
- (void)udp:(D5Udp *)udp receivedData:(NSData *)data from:(NSString *)ip;

- (void)udpError:(D5Udp *)udp errorCode:(D5UdpError) code message:(NSString *)string;

- (void)udpClose:(D5Udp *)udp errorCode:(D5UdpError)errorCode message:(NSString *)message;

- (void)udpSendSuccess:(D5Udp *)udp;

- (void)disConnectUdp:(uint16_t)port;
@end
