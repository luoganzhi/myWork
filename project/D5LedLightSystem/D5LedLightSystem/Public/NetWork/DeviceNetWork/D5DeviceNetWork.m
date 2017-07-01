//
//  D5DeviceNetWork.m
//  D5Home
//
//  Created by anthonyxoing on 31/1/15.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5DeviceNetWork.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "D5Socket.h"
#define DEVICE_SERVER @"www.ipangdou.com"
//#define DEVICE_SERVER @"api.ipangdou.com"

@interface D5DeviceNetWork()<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>

@property (retain,nonatomic) GCDAsyncSocket * tcpSockt;
@property (retain,nonatomic) GCDAsyncUdpSocket * udpSockt;

@property (assign,nonatomic) int tcpConnectedTimes;
@end

@implementation D5DeviceNetWork

-(void)initialUdpConnect{
    NSError * error;
    if(_udpSockt){
        if(_isEnableBroadCast){
            [_udpSockt leaveMulticastGroup:@"239.0.0.0" error:nil];
        }
        [_udpSockt close];
    }
    _udpSockt = nil;
    if(_udpSockt == nil){
        _udpSockt = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("udp", 0)];
    }
    if(![_udpSockt bindToPort:_udpPort error:&error]){
        NSLog(@"%@",error);
        return;
    }
    if(_isEnableBroadCast){
        if(![_udpSockt enableBroadcast:YES error:&error]){
            NSLog(@"%@",error);
            return;
        }
        
        if(![_udpSockt joinMulticastGroup:@"239.0.0.0" error:&error]){ //224.0.0.0
            NSLog(@"%@",error);
            return;
        }
    }
    if([_udpSockt beginReceiving:&error]){
        NSLog(@"udp 准备好接收数据");
    }else{
        NSLog(@"udp 准备接收数据失败:%@",error);
    }
}
-(void)initialTcpConnect{
    if(_tcpSockt == nil){
        _tcpSockt = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("Ogemray_tcp", 0)];
    }
    
    if([_tcpSockt connectToHost:DEVICE_SERVER onPort:_tcpPort error:nil]){
        [_tcpSockt readDataWithTimeout:-1 tag:0];

    }else{
        
    }
    
}
-(void)sendUdpData:(NSData *)data withIpAddress:(NSString *)address withTag:(long)tag{
//    if(_udpSockt.isConnected){
        [_udpSockt sendData:data toHost:address port:_udpPort withTimeout:-1 tag:tag];
//    }else{
//        [self initialUdpConnect];
//    }
}
-(void)sendTcpData:(NSData *)data withTag:(long)tag{
    if(!_tcpSockt.isConnected){
        [self initialTcpConnect];
    }
    if(_tcpSockt.isConnected){
        [_tcpSockt writeData:data withTimeout:10 tag:tag];
    }
}
-(void)setNetworktype:(NetWorkType)networktype{
    _networktype = networktype;
    
    if((networktype & D5Network_type_udp) > 0){
        [self initialUdpConnect];
    }
    if((networktype & D5Network_type_tcp) > 0){
        [self initialTcpConnect];
    }
}
#pragma mark - udp delegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    if(_delegate && [_delegate respondsToSelector:@selector(d5network:udpRecevied:withAddress:)]){
        [_delegate d5network:self udpRecevied:data withAddress:[GCDAsyncUdpSocket hostFromAddress:address]];
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"send udp data success:%ld",tag);
}
-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    NSLog(@"udp closed :%@",error.localizedDescription);
    [self initialUdpConnect];
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"udp send error:%@",error.localizedDescription);
    if(_delegate && [_delegate respondsToSelector:@selector(d5network:errorCode:withMessage:withTag:)]){
        [_delegate d5network:self errorCode:networking_udp_send_error withMessage:error.localizedDescription withTag:tag];
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error{
    NSLog(@"udp connect error:%@",error.localizedDescription);
    [self initialUdpConnect];
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    NSLog(@"udp connected");
}

#pragma mark - tcp delegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"tcp connected to %@ successfull",host);
    _tcpConnectedTimes = 0;
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    if(_delegate && [_delegate respondsToSelector:@selector(d5network:tcpRecevied:)]){
        [_delegate d5network:self tcpRecevied:data];
    }
    [sock readDataWithTimeout:-1 tag:0];
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"tcp send data successfull");
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if(_tcpConnectedTimes < 10){
        [self initialTcpConnect];
    }
}
@end
