//
//  D5SocketManager.m
//  Network
//
//  Created by anthonyxoing on 15/9/7.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5TcpManager.h"
#import "Reachability.h"
#import "D5Udp.h"
#import "D5Tcp.h"

static D5TcpManager *tcpManager = nil;

@interface D5TcpManager()
@property (retain,nonatomic) NSMutableDictionary *tcpSocketList;
@end

@implementation D5TcpManager

+ (D5TcpManager *)defaultSocketManager {
    if (tcpManager == nil) {
        tcpManager = [[D5TcpManager alloc] init];
    }
    return tcpManager;
}

- (instancetype)init {
    if (self == [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChange:) name:NETWORK_CHANGED object:nil];
    }
    return self;
}
- (void)appBecomeActive {
    [[_tcpSocketList allValues] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        D5Tcp * tcp = (D5Tcp *)obj;
        if (![tcp isConnect]) {
            NSString * remoteIp = tcp.remoteIP;
            uint16_t port = tcp.remotePort;
            [tcp connectTo:remoteIp port:port];
        }
    }];
}

- (NSMutableDictionary *)tcpSocketList {
    if (_tcpSocketList == nil) {
        _tcpSocketList = [[NSMutableDictionary alloc] init];
    }
    return _tcpSocketList;
}

- (void)netWorkChange:(NSNotification *)notification {
    @autoreleasepool {
        NSDictionary *networkInfo = [notification userInfo];
        NetworkStatus status = [[networkInfo objectForKey:@"netType"] integerValue];
        [self netWork:status];
    }
}

- (float)SystemVersion {
    @autoreleasepool {
        NSString *strSystemVersion = [[UIDevice currentDevice] systemVersion];
        return [strSystemVersion floatValue];
    }
}

- (void)netWork:(NetworkStatus)status {
    [[_tcpSocketList allValues] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        D5Tcp *tcp = (D5Tcp *)obj;
        [tcp disconnect];
    }];
}

#pragma mark - manager tcp socket
- (void)deleteConnect:(NSString *)tcpRemoteIp port:(uint16_t)tcpRemotePort deviceModule:(id)delegate {
    @autoreleasepool {
        if (delegate == nil) {
            NSLog(@"delegate = nil");
            return;
        }
        NSString *socketKey = [self socketKey:tcpRemoteIp port:tcpRemotePort];
        D5Tcp *tcp = [self.tcpSocketList objectForKey:socketKey];
        if (tcp != nil && ![tcp isEqual:[NSNull null]]) {
            [tcp.dataSourceCast removeCmdMuticastDelegate:delegate];
            if ([tcp.dataSourceCast count] <= 0) {
                [self.tcpSocketList removeObjectForKey:socketKey];
            }
        }
    }
}

- (void)addConnect:(NSString *)tcpRemoteIp port:(uint16_t)tcpRemotePort deviceModule:(id)delegate {
    @autoreleasepool {
        if ([tcpRemoteIp isEqualToString:@""] || [tcpRemoteIp isEqual:[NSNull null]] || tcpRemoteIp == nil) {
            NSLog(@"tcp 远程IP地址为空");
            return;
        }
        if (tcpRemotePort == 0) {
            NSLog(@"tcp 远程端口为空");
            return;
        }
        if (delegate == nil) {
            NSLog(@"delegate = nil");
            return;
        }
        NSString *socketKey = [self socketKey:tcpRemoteIp port:tcpRemotePort];
        D5Tcp *tcp = [self.tcpSocketList objectForKey:socketKey];
        if (tcp == nil || [tcp isEqual:[NSNull null]]) {
            D5Tcp * tcp = [[D5Tcp alloc] init];
            [tcp.dataSourceCast addCmdMuticastDelegate:delegate];
            [tcp connectTo:tcpRemoteIp port:tcpRemotePort];
            [self.tcpSocketList setObject:tcp forKey:socketKey];
        } else {
            if (![tcp isConnect]) {
                NSString * remoteIp = tcp.remoteIP;
                uint16_t port = tcp.remotePort;
                [tcp connectTo:remoteIp port:port];
            }
            [tcp.dataSourceCast addCmdMuticastDelegate:delegate];
        }
    }
}

- (NSString *)socketKey:(NSString *)tcpRemoteIP port:(uint16_t)tcpRmotePort {
    return [NSString stringWithFormat:@"%@+%d",tcpRemoteIP,tcpRmotePort];
}

- (D5Tcp *)getConenct:(NSString *)tcpRemoteIp port:(uint16_t)tcpRemotePort deviceModule:(id)delegate {
    @autoreleasepool {
        NSString *socketKey = [self socketKey:tcpRemoteIp port:tcpRemotePort];
        D5Tcp *tcp = [self.tcpSocketList objectForKey:socketKey];
        
        if (tcp == nil || [tcp isEqual:[NSNull null]]) {
            return nil;
        } else {
            [tcp.dataSourceCast addCmdMuticastDelegate:delegate];
        }
        
        return tcp;
    }
}

@end
