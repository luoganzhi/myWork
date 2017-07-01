//
//  D5TcpConnect.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/29.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5TcpConnect.h"

static D5TcpConnect *instance = nil;

@interface D5TcpConnect()<GCDAsyncSocketDelegate>
@property(nonatomic,strong)dispatch_queue_t quenue;
@end

@implementation D5TcpConnect

+ (D5TcpConnect *)sharedTcpConnect {
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
}
- (void)connectTo:(NSString *)ip port:(uint16_t)port {
    _remoteIP = ip;
    _remotePort = port;
   
//    if (_tcpSocket.isConnected) {
//        [_tcpSocket disconnect];//断开socket
//    }
    _tcpSocket = nil;
    _failedCount = 0;
    [self initialTcpConnect];
}
- (BOOL)isConnect {
    return [_tcpSocket isConnected];
}
- (void)initialTcpConnect {
    
//    if (![D5NetWork isConnectionAvailable]) {
//       
//        return;
//    }
    if (_tcpSocket == nil) {
//        _quenue=dispatch_queue_create("reConnect", 0);
        _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue: dispatch_queue_create("reConnect", 0)];
    }
    
    NSError*error = nil;
    if ([_tcpSocket connectToHost:_remoteIP onPort:_remotePort error:&error]) {
        //开始读取数据
        int8_t a = 4;
        NSData*data= [[NSData alloc]initWithBytes:&a length:sizeof(int8_t)];
        [_tcpSocket writeData:data withTimeout:-1 tag:1];
        
        [_tcpSocket readDataWithTimeout:-1 tag:0];
//        if (!_timeoutTimer) {
//            _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_INTERVAL target:self selector:@selector(tcpConnectTimeOut:) userInfo:nil repeats:NO];
//            //DLog(@"%@新建Timer = %@", self, _timeoutTimer);
//        }
        //DLog(@"tcp重新连接链接成功");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReConnectSucess" object:nil];
    } else {
        //DLog(@"tcp重新连接链接失败");
    }
    
    if (error !=nil ) {
        
        //DLog(@"------重新连接发生错误---------%@",error);
    }
}

//超时
- (void)tcpConnectTimeOut:(NSTimer *)timer {
    @autoreleasepool {
      
//        [self connectFailed];
    }
}
#pragma  mark -- 收到数据中

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

//    //DLog(@"重连连接收到数据成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReConnectSucess" object:nil];
}
#pragma mark -- 发送数据中
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
//    //DLog(@"重连连接收到数据成功:%ld",tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReConnectSucess" object:nil];
    
}

#pragma mark --连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    _failedCount = 0;
    
    if ([_tcpSocket isConnected]) {
        [_tcpSocket disconnect];//断开socket
    }

  //DLog(@"重连连接收到数据成功");
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ReConnectSucess" object:nil];
}
#pragma  mark --连接失败

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {

 //DLog(@"重连连接收到数据失败");
    //失败三次
    _failedCount++;
    if (_failedCount == 5) {
        //发送连接失败通知
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"ReConnectSucessFail" object:nil];
        _failedCount = 0;
        //如果五次都没连接上断开socket
        if ([_tcpSocket isConnected]) {
            [_tcpSocket disconnect];//断开socket
        }
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reconnectTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self initialTcpConnect];
        
        _reconnectTimeInterval = _reconnectTimeInterval * 2;
    });


}
@end
