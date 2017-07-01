//
//  D5Tcp.m
//  Network
//
//  Created by anthonyxoing on 15/9/7.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5Tcp.h"
#import "D5NetWork.h"

@interface D5Tcp()
@property (assign,nonatomic) UIBackgroundTaskIdentifier bgTask;
@end

@implementation D5Tcp
- (instancetype)init {
    if (self == [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForGround) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)enterBackGround {
    _isBackGround = YES;
    UIApplication *app = [UIApplication sharedApplication];
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
    }];
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        // Do the work associated with the task.
        [_tcpSocket disconnect];
        [app endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)enterForGround {
    _isBackGround = NO;
    if (![_tcpSocket isConnected]) {
        [self initialTcpConnect];
    }
}

- (D5CmdMuticast *)dataSourceCast {
    if (_dataSourceCast == nil) {
        _dataSourceCast = [[D5CmdMuticast alloc] init];
    }
    return _dataSourceCast;
}

- (void)connectTo:(NSString *)ip port:(uint16_t)port {
    _remoteIP = ip;
    _remotePort = port;
    if (_tcpSocket.isConnected) {
        [_tcpSocket disconnect];
    }
    _tcpSocket = nil;
    [self initialTcpConnect];
}

- (void)initialTcpConnect {
    if (![D5NetWork isConnectionAvailable]) {
        return;
    }
    if (_tcpSocket == nil) {
        _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("tcp", 0)];
    }
    
    if ([_tcpSocket connectToHost:_remoteIP onPort:_remotePort error:nil]) {
        [_tcpSocket readDataWithTimeout:-1 tag:0];
        NSLog(@"tcp 发起链接成功");
    } else {
        NSLog(@"tcp 发起链接失败");
    }
}

- (void)disconnect {
    [_tcpSocket disconnect];
}

- (BOOL)isConnect {
    return [_tcpSocket isConnected];
}

- (void)sendData:(NSData *)data withTag:(NSInteger)tag {
//    if(!_tcpSocket.isConnected){
//        [self initialTcpConnect];
//    }
    [_tcpSocket writeData:data withTimeout:-1 tag:tag];
}

#pragma mark - GCDAsyncSocket delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    _reconnectTimeInterval = 1.0f;
    NSLog(@"tcp 链接%@:%d成功",host, port);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self.dataSourceCast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj && [obj respondsToSelector:@selector(tcpReciveData:)]){
            [obj tcpReciveData:data];
        }
    }];
    [_tcpSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (_isBackGround) {
        return;
    }
    [self.dataSourceCast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        if (obj && [obj respondsToSelector:@selector(tcpError:)]) {
            [obj tcpError:D5SocketErrorCodeTypeTcpDisconnect];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reconnectTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initialTcpConnect];
        _reconnectTimeInterval = _reconnectTimeInterval * 2;
    });
}
@end
