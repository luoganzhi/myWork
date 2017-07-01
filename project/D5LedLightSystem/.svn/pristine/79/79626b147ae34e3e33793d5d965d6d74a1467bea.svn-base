//
//  D5Tcp.h
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _tcp_error_code{
    D5Tcp_NO_Error = -1,
    D5Tcp_Background_Error = 10000,
    D5Tcp_Heart_Timeout,
    D5Tcp_Connect_Timeout,
    D5TCP_Connect_error,
    D5Tcp_Senddata_timeout,
    D5Tcp_ReceiveData_timeout,
    D5Tcp_Host_IP_error,
    D5Tcp_Host_Port_error,
    D5Tcp_Disconnected_error,
    D5Tcp_Manual_Disconnected_error,
    D5Tcp_Other_error
    
}D5TcpError;

@protocol D5TcpDelegate;

@interface D5Tcp : NSObject

//链接的服务器（远程）ip地址
@property (strong,nonatomic) NSString * serverIP;

//链接的服务器（远程)端口号
@property (assign,nonatomic) uint16_t serverPort;

//本地ip地址，如果不指定，则为随机的ip地址
@property (assign,nonatomic) uint16_t localPort;

//链接超时时间
@property (assign,nonatomic) NSTimeInterval connectTimeout;

//发送数据超时时间
@property (assign,nonatomic) NSTimeInterval sendDataTimeOut;

//接收数据超时
@property (assign,nonatomic) NSTimeInterval receiveDataTimeout;

//上一次收到数据的时间戳
@property (assign,nonatomic) NSTimeInterval lastReceiveDataStamp;

//委托 -- D5DeviceBaseCommunication及其子类 ([[D5TcpManager defaultTcpManager] addTcp:serverIP port:serverPort delegate:self];中设置）
@property (weak,nonatomic) id<D5TcpDelegate> delegate;

//链接远程服务器
- (void)connectToHost:(NSString *)ip port:(uint16_t)port;

//链接远程服务器
//参数 timeout 链接建立超时时间 单位秒
- (void)connectToHost:(NSString *)ip port:(uint16_t)port withTimeout:(NSTimeInterval)timeout;

//断开链接
- (void)disconnect;

//是否已经链接
- (BOOL)isConnected;

//数据发送
- (void)sendData:(NSData *)data withTag:(NSInteger)tag;

//数据发送
//参数 timeout 发送数据超时时间 单位秒
- (void)sendData:(NSData *)data withTag:(NSInteger)tag withTimeOut:(NSTimeInterval) timeout;

@end


//  Tcp 相关回调
//
//
@protocol D5TcpDelegate <NSObject>

@optional
//链接成功回调
- (void)tcpConnected:(D5Tcp *)tcp arg:(NSObject *)obj;

//tcp出错回调
- (void)tcpError:(D5Tcp *)tcp errCode:(D5TcpError) code errorMessage:(NSString *)message;

//tcp发送数据成功回调
- (void)tcpSendedData:(D5Tcp *)tcp tag:(NSInteger)tag;

//tcp接收到数据
- (void)tcp:(D5Tcp *)tcp receivedData:(NSData *)data;

@end
