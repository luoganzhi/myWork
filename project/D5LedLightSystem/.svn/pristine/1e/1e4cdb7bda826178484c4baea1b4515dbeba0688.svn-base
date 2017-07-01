//
//  D5Udp.m
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/16.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import "D5Udp.h"
#import "GCDAsyncUdpSocket.h"
#import "NSObject+runtime.h"

@interface D5Udp()<GCDAsyncUdpSocketDelegate>{
    Class oldClass;
}

@property (strong,nonatomic) GCDAsyncUdpSocket * udpSocket;
@property (assign,nonatomic) BOOL isbinded;

@end


@implementation D5Udp

-(instancetype)init{
    if(self = [super init]){
        _localPort = 0;
        _isbinded = NO;
    }
    return self;
}
-(GCDAsyncUdpSocket *)udpSocket{
    if(NULL == _udpSocket){
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("D5UDP_DELEGATE_QUEUE", 0) socketQueue:dispatch_queue_create("D5UDP_QUEUE",0)];
    }
    return _udpSocket;
}
- (void)setDelegate:(id<D5UdpDelegate>)delegate{
    _delegate = delegate;
    oldClass = [self objectGetClass:_delegate];
}

- (BOOL)openBroadCast{
    if(_isBroadCast){
        NSError * error = NULL;
        [self.udpSocket enableBroadcast:YES error:&error];
        if(error){
            if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpError:errorCode:message:)]){
                [_delegate udpError:self errorCode:D5Udp_BroadCast_Open_Error message:error.localizedDescription];
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)bindPort{
    NSError * error = NULL;
    if(_isbinded){
        return YES;
    }
    if(![self.udpSocket bindToPort:_localPort error:&error]){
        DLog(@"----UDP---绑定端口失败");
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpError:errorCode:message:)]){
            [_delegate udpError:self errorCode:D5Udp_LocalPort_Error message:error.localizedDescription];
        }
        return NO;
    }
    _isbinded = YES;
    return YES;
}

- (BOOL )initialUdp{
    if(_localPort > 0){
        if(![self bindPort]){
            return NO;
        }
    }
    if(![self openBroadCast]){
        return NO;
    }
    return YES;
}
- (void)close{
    [self.udpSocket close];
    [self setUdpSocket:NULL];
}

- (void)beginReceive{
    NSError * error = NULL;
    [self.udpSocket beginReceiving:&error];
    if(error){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpError:errorCode:message:)]){
            [_delegate udpError:self errorCode:D5Udp_Receive_Error message:error.localizedDescription];
        }
       
    }
}
- (void)sendData:(NSData *)data toRemote:(NSString *)remoteIp toPort:(uint16_t)remotePort{
    [self sendData:data toRemote:remoteIp toPort:remotePort withTimeOut:-1];
}

-(void)sendData:(NSData *)data toRemote:(NSString *)remoteIp toPort:(uint16_t)remotePort withTimeOut:(NSTimeInterval)timeOut{
    _remoteIP = remoteIp;
    _remotePort = remotePort;
    if(![self checkRemoteIP]){
        return;
    }
    if(![self checkRemotePort]){
        return;
    }
    if([self initialUdp]){
        [self.udpSocket sendData:data toHost:_remoteIP port:_remotePort withTimeout:timeOut tag:0];
        [self beginReceive];
    }
}


- (BOOL)checkDelegate{
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == oldClass);
}

- (BOOL)checkRemotePort{
    if(_remotePort == 0){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpError:errorCode:message:)]){
            [_delegate udpError:self errorCode:D5Udp_Remote_Port_Zero message:@"远程端口号为空"];
        }
        return NO;
    }
    return YES;
}

- (BOOL)checkRemoteIP{
    if(_remoteIP == NULL || [_remoteIP isEqual:[NSNull null]] || [_remoteIP isEqualToString:@""]){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpError:errorCode:message:)]){
            [_delegate udpError:self errorCode:D5Udp_Remote_IP_Empty message:@"远程ip地址为空"];
        }
        return NO;
    }
    NSArray * ipArray = [_remoteIP componentsSeparatedByString:@"."];
    if(ipArray.count != 4 && ipArray.count != 6){
        if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpError:errorCode:message:)]){
            [_delegate udpError:self errorCode:D5Udp_Remote_IP_Error message:@"远程ip地址长度错误"];
        }
        return NO;
    }
    if(ipArray.count == 6){
        
        self.udpSocket.IPv4Enabled = NO;
        self.udpSocket.IPv6Enabled = YES;
    }else{
        self.udpSocket.IPv4Enabled = YES;
        self.udpSocket.IPv6Enabled = NO;
    }
    
    return true;
}
#pragma mark - 处理GCDAsyncUdpSocket代理
-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    D5UdpError code = D5Udp_NO_Error;
    NSString * message = NULL;
    if(error){
        code = D5Udp_Close_Error;
        message = error.description;
    }
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpClose:errorCode:message:)]){
        [_delegate udpClose:self errorCode:code message:message];
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpSendSuccess:)]){
        [_delegate udpSendSuccess:self];
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    D5UdpError code = D5Udp_Send_error;
    NSString * message = NULL;
    if(error){
        message = error.description;
    }
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(udpError:errorCode:message:)]){
        [_delegate udpError:self errorCode:code message:message];
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSString * ip = NULL;
    ip = [GCDAsyncUdpSocket hostFromAddress:address];
    if([self checkDelegate] && [_delegate respondsToSelector:@selector(udp:receivedData:from:)]){
        [_delegate udp:self receivedData:data from:ip];
    }
    [self beginReceive];
}
@end
