//
//  D5UdpPingManager.m
//  Network
//
//  Created by anthonyxoing on 15/9/8.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5UdpPingManager.h"
#import "Reachability.h"
static D5UdpPingManager * defaultPingManager = nil;

@interface D5UdpPingManager()

@property (retain,nonatomic) NSMutableDictionary * pingList;
@property (assign,nonatomic) BOOL isBackground;
@property (assign,nonatomic) BOOL isRecreating;
@property (assign,nonatomic) UIBackgroundTaskIdentifier bgTask;
@end

@implementation D5UdpPingManager

+ (D5UdpPingManager *)defaultUdpPingManager {
    
    if (defaultPingManager == nil) {
        defaultPingManager = [[D5UdpPingManager alloc] init];
    }
    
    return defaultPingManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChange:) name:NETWORK_CHANGED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reCreatePing) name:UIApplicationWillEnterForegroundNotification object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterbackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterbackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (NSMutableDictionary *)pingList {
    
    if (_pingList == nil) {
        _pingList = [[NSMutableDictionary alloc] init];
    }
    return _pingList;
    
}

- (void)netWorkChange:(NSNotification *)notification {
    @autoreleasepool {
        NSDictionary * networkInfo = [notification userInfo];
        NetworkStatus status = [[networkInfo objectForKey:@"netType"] integerValue];
        [self netWork:status];
    }
}
- (void)enterbackground {
    @autoreleasepool {
        UIApplication* app = [UIApplication sharedApplication];
        _isBackground = YES;
        _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:_bgTask];
            _bgTask = UIBackgroundTaskInvalid;
        }];
        // Start the long-running task and return immediately.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 0), ^{
            // Do the work associated with the task.
            [self.pingList.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                D5Udp * udp = [self.pingList objectForKey:obj];
                [udp close];
            }];
            [app endBackgroundTask:_bgTask];
            _bgTask = UIBackgroundTaskInvalid;
        });
    }
}

- (void)reCreatePing:(uint16_t)port {
    if (_isBackground) {
        return;
    }
    if (_isRecreating == YES) {
        return;
    }
    _isRecreating = YES;
    D5Udp * lastUdp = [self.pingList objectForKey:[self pingKey:port]];
    if (lastUdp) {
        [lastUdp close];
        D5Udp * udp = [[D5Udp alloc] init];
        udp.isEnableBroadcast = YES;
        [udp.dataSourceCast addCmdMuticastDelegateFrom:lastUdp.dataSourceCast];
        udp.port = port;
        [udp connect];
        [self.pingList removeObjectForKey:[self pingKey:port]];
        [self.pingList setObject:udp forKey:[self pingKey:port]];
        _isRecreating = NO;
    }
}

- (void)reCreatePing {
    _isBackground = NO;
    if (_isRecreating == YES) {
        return;
    }
    _isRecreating = YES;
    [self.pingList.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        uint16_t port = [obj intValue];
        D5Udp * lastUdp = [self.pingList objectForKey:obj];
        [lastUdp close];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            D5Udp *udp = [[D5Udp alloc] init];
            udp.isEnableBroadcast = YES;
            [udp.dataSourceCast addCmdMuticastDelegateFrom:lastUdp.dataSourceCast];
            udp.port = port;
            [udp connect];
            
            [self.pingList removeObjectForKey:[self pingKey:port]];
            [self.pingList setObject:udp forKey:[self pingKey:port]];
        });
    }];
    _isRecreating = NO;
}

- (void)netWorkForWWAN {
    
}

- (void)netWorkForWiFi {
    [self reCreatePing];
}

- (void)netWorkForNone {
 
}
- (void)netWork:(NetworkStatus)status {
    switch (status) {
        case ReachableViaWWAN:
        {
            NSLog(@"WWAN");
            [self netWorkForWWAN];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"Wifi");
            [self netWorkForWiFi];
            break;
        }
        case NotReachable:
        {
            NSLog(@"no network");
            [self netWorkForNone];
            break;
        }
    }
}

- (NSString *)pingKey:(uint16_t)port {
    return [NSString stringWithFormat:@"%d",port];
}

- (void)addPing:(uint16_t)port deviceModule:(id)delegate {
    @autoreleasepool {
        NSString *pingKey = [self pingKey:port];
        D5Udp *udp = [self.pingList objectForKey:pingKey];
        if (udp == nil || [udp isEqual:[NSNull null]]) {
            udp = [[D5Udp alloc] init];
            udp.isEnableBroadcast = YES;
            [udp.dataSourceCast addCmdMuticastDelegate:delegate];
            udp.port = port;
            [udp connect];
            [self.pingList setObject:udp forKey:pingKey];
        }else{
            //        udp.isEnableBroadcast = YES;
            [udp.dataSourceCast addCmdMuticastDelegate:delegate];
        }
    }
}

- (void)deletePing:(uint16_t)port deviceModule:(id)delegate {
    @autoreleasepool {
        NSString *pingKey = [self pingKey:port];
        D5Udp *udp = [self.pingList objectForKey:pingKey];
        [udp close];
        if (udp != nil && ![udp isEqual:[NSNull null]]) {
            [udp.dataSourceCast removeCmdMuticastDelegate:delegate];
            if ([udp.dataSourceCast count] <= 0) {
                [self.pingList removeObjectForKey:pingKey];
            }
        }
    }
}

- (D5Udp *)getPing:(uint16_t)port deviceModule:(id)delegate {
    @autoreleasepool {
        NSString * pingKey = [self pingKey:port];
        D5Udp * udp = [self.pingList objectForKey:pingKey];
        if (udp == nil || [udp isEqual:[NSNull null]]) {
            return nil;
        }
        [udp.dataSourceCast addCmdMuticastDelegate:delegate];
        return udp;
    }
}
@end
