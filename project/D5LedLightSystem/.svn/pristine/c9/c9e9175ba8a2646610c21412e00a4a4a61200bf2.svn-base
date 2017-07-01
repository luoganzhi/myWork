//
//  D5Tcp.m
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import "D5Tcp.h"
#import "GCDAsyncSocket.h"
#import "NSObject+runtime.h"
#import "D5TcpManager.h"

#define D5TCP_QUEUE_LABLE "D5TCP_QUEUE"
#define D5TCP_QUEUE_DELEGATE_LABLE "D5TCP_DELEGATE_QUEUE"

@interface D5Tcp()<GCDAsyncSocketDelegate>{
    Class _oldClass;
}
@property (strong,nonatomic) GCDAsyncSocket * socket;

@end

@implementation D5Tcp

-(void)setDelegate:(id<D5TcpDelegate>)delegate{
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

- (BOOL)checkDelegate{
    Class nowClass = [self objectGetClass:_delegate];
    return _delegate && nowClass && (nowClass == _oldClass);
}

- (instancetype) init{
    if(self = [super init]){
       
        _connectTimeout = -1;
        _sendDataTimeOut = -1;
        _receiveDataTimeout = -1;
        
        [self addNotification];
    }
    return self;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeoutDisConnect:) name:HEART_TIMEOUT_DISCONNECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manualDisConnect:) name:MANUAL_DISCONNECT object:nil];
}

- (void)enterBackground {
    [self disconnect];
    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]) {
        [_delegate tcpError:self errCode:D5Tcp_Background_Error errorMessage:@"APP进入后台"];
    }
}

/**
 心跳超时--手动断开连接
 */
- (void)timeoutDisConnect:(NSNotification *)notification {
    @autoreleasepool {
        D5Tcp *tcp = notification.object;
        DLog(@"timeoutDisConnect   %@",tcp);
        if ([tcp isEqual:self]) {
            [self disconnect];
            if ([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]) {
                [_delegate tcpError:self errCode:D5Tcp_Heart_Timeout errorMessage:@"心跳超时时间过长"];
            }
        }
    }
}

/**
 切换中控--手动断开连接
 */
- (void)manualDisConnect:(NSNotification *)notification {
    @autoreleasepool {
        D5Tcp *tcp = notification.object;
        DLog(@"manualDisConnect   %@",tcp);
        if (!tcp) {
            tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
        }
        
        if (tcp && [tcp isEqual:self]) {
            [self disconnect];
            if ([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]) {
                [_delegate tcpError:self errCode:D5Tcp_Manual_Disconnected_error errorMessage:@"切换中控中手动断开连接"];
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) initialSocket{
    if (NULL == _socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("D5TCP_DELEGATE_QUEUE", 0) socketQueue:dispatch_queue_create("D5TCP_QUEUE", 0)];
    }
}
- (void)connect{
    NSError * error = NULL;
    
    [self initialSocket];
    
    //判断服务器ip地址是否为空
    if(_serverIP == NULL || !_serverIP || [@"" isEqualToString:_serverIP] || [_serverIP isEqual:[NSNull null]]){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]){
            [_delegate tcpError:self errCode:D5Tcp_Host_IP_error errorMessage:[NSString stringWithFormat:@"服务器ip地址不合法--%@", _serverIP]];
        }
        return;
    }
    //判断服务器ip地址的长度是否合法
    NSArray * tempArray = [_serverIP componentsSeparatedByString:@"."];
    if(tempArray.count != 4 && tempArray.count != 6){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]){
            [_delegate tcpError:self errCode:D5Tcp_Host_IP_error errorMessage:[NSString stringWithFormat:@"服务器ip地址不合法--%@", _serverIP]];
        }
        return;
    }
    //判断服务器端口号是否合法
    if(_serverPort == 0){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]){
            [_delegate tcpError:self errCode:D5Tcp_Host_Port_error errorMessage:@"服务器端口号不合法"];
        }
        return;
    }
    //判断使用ipV6还是ipv4
    if(tempArray.count == 6){
        _socket.IPv6Enabled = YES;
        _socket.IPv4Enabled = NO;
        
    }else{
        _socket.IPv4Enabled = YES;
        _socket.IPv6Enabled = NO;
    }

    //发起链接
    if(![_socket connectToHost:_serverIP onPort:_serverPort withTimeout:_connectTimeout error:&error]){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]){
            [_delegate tcpError:self errCode:D5TCP_Connect_error errorMessage:[error localizedDescription]];
        }
    }
}

-(void)connectToHost:(NSString *)ip port:(uint16_t)port{
    _serverPort = port;
    _serverIP = ip;
    _connectTimeout = -1;
    [self connect];
}

-(void)connectToHost:(NSString *)ip port:(uint16_t)port withTimeout:(NSTimeInterval)timeout{
    _serverPort = port;
    _serverIP = ip;
    _connectTimeout = timeout;
    [self connect];
}

- (void)disconnect{
    if(_socket.isConnected){
        [_socket disconnect];
    }
    
    _socket = NULL;
}

- (BOOL)isConnected{
    if(NULL == _socket){
        return NO;
    }
    return  _socket.isConnected;
}

- (void)sendData:(NSData *)data withTag:(NSInteger)tag{
    [self sendData:data withTag:tag withTimeOut:-1];
}

- (void)sendData:(NSData *)data withTag:(NSInteger)tag withTimeOut:(NSTimeInterval)timeout{
    _sendDataTimeOut = timeout;
    
    if([self isConnected]){        
        [_socket writeData:data withTimeout:_sendDataTimeOut tag:tag = 0];

    }else{
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]){
            [_delegate tcpError:self errCode:D5Tcp_Disconnected_error errorMessage:@"tcp链接已经断开"];
        }
    }
}

- (void)beginReceiveData{
    if (_socket){
        [_socket readDataWithTimeout:_receiveDataTimeout tag:0];
    }
}
#pragma mark - 处理GCDAsyncSocket代理
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    DLog(@"socket didReadData -- %@", _delegate);
    _lastReceiveDataStamp = [D5Date currentTimeStamp];
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcp:receivedData:)]){
        [_delegate tcp:self receivedData:data];
    }
    [self beginReceiveData];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpSendedData:tag:)]){
        [_delegate tcpSendedData:self tag:tag];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpConnected:arg:)]){
        [_delegate tcpConnected:self arg:host];
    }
    [self beginReceiveData];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    D5TcpError error = D5Tcp_NO_Error;
    NSString * message = NULL;
    if(err){
        switch (err.code) {
            case GCDAsyncSocketConnectTimeoutError:
                error = D5Tcp_Connect_Timeout;
                message = @"链接超时";
                break;
            case GCDAsyncSocketReadTimeoutError:
                error = D5Tcp_ReceiveData_timeout;
                message = @"接收数据超时";
                break;
            case GCDAsyncSocketWriteTimeoutError:
                error = D5Tcp_Senddata_timeout;
                message = @"发送数据超时";
                break;
                break;
            default:
                error = D5Tcp_Other_error;
                message = err.localizedDescription;
                break;
        }
    }
    DLog(@"socketDidDisconnect");
    
    if(error == D5Tcp_NO_Error){
        
    }
    
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(tcpError:errCode:errorMessage:)]){
        [_delegate tcpError:self errCode:error errorMessage:message];
    }
}

@end
