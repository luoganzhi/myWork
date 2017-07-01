//
//  D5LedSpecialCmd.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedSpecialCmd.h"

@interface D5LedSpecialCmd()

@property (nonatomic, assign) uint16_t port;

@end

@implementation D5LedSpecialCmd
#pragma mark - 将sn改为0
- (void)setHeaderSn {
    self.sn = 0;
}

- (void)addPushCmd:(LedCmd)cmd subcmd:(uint8_t)subcmd delegate:(id<D5LedCmdDelegate, D5LedNetWorkErrorDelegate>)delegate {
    @autoreleasepool {
        D5LedSpecialCmd *pushCmd = [[D5LedSpecialCmd alloc] init];
        [pushCmd headerForCmd:cmd withSubCmd:subcmd];
        
        pushCmd.receiveDelegate = delegate;
        pushCmd.errorDelegate = delegate;
        
        [pushCmd startCmd];
    }
}

- (NSMutableData *)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict {
    @autoreleasepool {
        NSMutableData *data = [super ledSendData:cmd withSubCmd:subCmd withData:dict];
        DLog(@"------发送 %d-%d ---先加入列表%d--- %@", self.headerCmd, self.headerSubCmd, self.isNeedAddToList, data);
        switch (_cmdType) {
            case SpecialCmdTypeBroadCast:
                [self sendBroadCastData:data];
                break;
            case SpecialCmdTypeHeart:
                [self sendHeartData:data];
                break;
            case SpecialCmdTypePush:
                [self sendPushData:data];
                break;
                
            default:
                break;
        }
        return data;
    }
}

#pragma mark - 广播
- (void)sendBroadCastData:(NSData *)data {
    @autoreleasepool {
        [self startCmd];
        
        _port = LED_BOX_SEND_PORT; // 本地端口
        
        D5Udp *udp = [[D5LedCommunication sharedLedModule] udpConnect:_port];
        udp.isBroadCast = YES;
        [udp sendData:data toRemote:[self convertIp] toPort:self.remotePort];
    }
}

- (void)closeBroadCast {
    [[D5UdpPingManager defaultUdpManager] removePing:_port];
}

#pragma mark - 心跳
- (void)sendHeartData:(NSData *)data {
    [self sendData:data needAddToTempList:self.isNeedAddToList];
}

#pragma mark - 推送
- (void)sendPushData:(NSData *)data {
    [self sendData:data needAddToTempList:self.isNeedAddToList];
}

#pragma mark - 结束接收数据
- (void)finishReceive {
    [self endCmd];
    
    if (_cmdType == SpecialCmdTypeBroadCast) {
        [self closeBroadCast];
    }
}


@end
