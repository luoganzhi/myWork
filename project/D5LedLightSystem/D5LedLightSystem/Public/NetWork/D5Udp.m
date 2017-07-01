//
//  D5Udp.m
//  Network
//
//  Created by anthonyxoing on 15/9/7.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5Udp.h"

@interface D5Udp()
@property (assign,nonatomic) uint16_t tempPort;

@end

@implementation D5Udp

- (instancetype)init {
    if (self == [super init]) {
        //        [self initialUdpConnect];
    }
    return self;
}

- (void)initialUdpConnect {
    @autoreleasepool {
        NSError *error = nil;
        if (_udpSocket) {
            if (_isEnableBroadcast) {
                [_udpSocket leaveMulticastGroup:@"239.0.0.0" error:&error];
            }
            [_udpSocket close];
        }
        _udpSocket = nil;
        if (_udpSocket == nil) {
            _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("udp", 0)];
        }
        //        [self beginRecive];
    }
}

- (GCDAsyncUdpSocket *)udpSocket {
    if (_udpSocket == nil) {
        @autoreleasepool{
            NSError * error = nil;
            if (_udpSocket) {
                if (_isEnableBroadcast) {
                    [_udpSocket leaveMulticastGroup:@"239.0.0.0" error:&error];
                }
                [_udpSocket close];
            }
            _udpSocket = nil;
            if (_udpSocket == nil) {
                _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("udp", 0)];
                [_udpSocket setIPv6Enabled:NO];
            }
            //        [self beginRecive];
        }
    }
    return _udpSocket;
}

- (void)close {
    if (_port != 0) {
        _isManualClosed = YES;
    }
    [self.udpSocket close];
}

- (void)setPort:(uint16_t)port {
    _port = port;
}

- (void)connect {
    _isManualClosed = NO;
    [self bindPort];
    [self openBroadcast];
    [self beginRecive];
}

- (D5NetRecvieDataArray *)reciveData {
    if (_reciveData == nil) {
        _reciveData = [[D5NetRecvieDataArray alloc] init];
    }
    return _reciveData;
}

- (void)bindPort {
    if (self.udpSocket) {
        NSError *error = nil;
        uint16_t port = _port;
        if (port == 0) {
            port = 1024 + (arc4random() % (UINT16_MAX - 1024));
            _tempPort = port;
        }
        if ([self.udpSocket bindToPort:port error:&error]) {
//            NSLog(@"绑定端口%d成功",_port);
        } else {
//            NSLog(@"绑定端口%d失败",_port);
            [self bindPort];
        }
        
    }
    
}

- (D5CmdMuticast *)dataSourceCast{
    if (_dataSourceCast == nil) {
        _dataSourceCast = [[D5CmdMuticast alloc] init];
    }
    return _dataSourceCast;
}

- (void)setIsEnableBroadcast:(BOOL)isEnableBroadcast{
    _isEnableBroadcast = isEnableBroadcast;
    if (_port > 0) {
        [self openBroadcast];
    }
}

- (void)openBroadcast{
    //    if (!_isEnableBroadcast) {
    //        if ([self.udpSocket enableBroadcast:NO error:nil]) {
    //            NSLog(@"禁止广播成功");
    //        }
    //
    //        if ([self.udpSocket leaveMulticastGroup:@"239.0.0.0" error:nil]) {
    //            NSLog(@"成功离开广播组");
    //        }
    //
    //        return;
    //    }
    if (!_isEnableBroadcast) {
        return;
    }
    if (self.udpSocket) {
        NSError * error = nil;
        if ([self.udpSocket enableBroadcast:_isEnableBroadcast error:&error]) {
            NSLog(@"开启广播成功");
            if ([self.udpSocket joinMulticastGroup:@"239.0.0.0" error:&error]) {
                NSLog(@"加入组播组成功");
            } else {
                NSLog(@"加入组播组失败");
            }
        } else {
            NSLog(@"开启广播失败");
        }
    }
    
}

- (void)beginRecive{
    NSError * error = nil;
    if ([self.udpSocket beginReceiving:&error]) {
//        NSLog(@"UDP 开启接受服务成功");
    } else {
//        NSLog(@"UDP 开启接受服务失败");
    }
    
}

- (void)sendData:(NSData *)data toHost:(NSString *)ip toPort:(uint16_t)port withTag:(NSInteger)tag{
    if (ip == nil || [ip isEqualToString:@""] || [ip isEqual:[NSNull null]]) {
        NSLog(@"UDP 目的IP地址为空");
        return;
    }
    if (port == 0) {
        NSLog(@"没有提供 UDP 目的端口");
        return;
    }
    if (_port == 0) {
        _port = 0;//开启随机端口
        [self bindPort];
    }
    [self.udpSocket sendData:data toHost:ip port:port withTimeout:-1 tag:tag];
    [self beginRecive];
}

#pragma mark - GCDAsyncUdpSocket delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    NSLog(@"udp did not connect");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    [self.dataSourceCast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj respondsToSelector:@selector(udpError:otherError:withTag:)]) {
            [obj udpError:D5SocketErrorCodeTypeUDPSendDataFailed otherError:0 withTag:tag];
        }
    }];
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    [self.dataSourceCast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj respondsToSelector:@selector(udpReciveData:from:withTag:fromSocket:)]) {
            [obj udpReciveData:data from:[GCDAsyncUdpSocket hostFromAddress:address] withTag:0 fromSocket:self];
        }
    }];
    
}

- (void)dealloc {
//    NSLog(@"udp release");
}

- (void)recivedData{
    //    self.reciveData.isCasted = YES;
    [self.reciveData.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == nil) {
            return;
        }
        NSDictionary * dic = (NSDictionary *)obj;
        NSData * data = [dic objectForKey:DATA_RECIVE];
        NSString * ip = [dic objectForKey:DATA_FROM_IP];
        [self.dataSourceCast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj && [obj respondsToSelector:@selector(udpReciveData:from:withTag:fromSocket:)]) {
                [obj udpReciveData:data from:ip withTag:0 fromSocket:self];
            }
        }];
        [self.reciveData.dataArray removeObject:obj];
    }];
    //    self.reciveData.isCasted = NO;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    //    NSLog(@"send data %ld success",tag);
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
//    NSLog(@"udp did close :%d",_port == 0?_tempPort:_port);
    if (_isManualClosed) {
        return;
    }
    if (!_isEnableBroadcast) {
        return;
    }
    [self.dataSourceCast.delegateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((obj && [obj respondsToSelector:@selector(udpClosed:)])) {
            [obj udpClosed:_port];
        }
    }];
}
@end
