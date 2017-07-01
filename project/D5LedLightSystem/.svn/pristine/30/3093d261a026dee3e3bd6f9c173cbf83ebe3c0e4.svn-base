//
//  D5UdpPingManager.m
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/16.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import "D5UdpPingManager.h"
#import "D5Udp.h"

static D5UdpPingManager *udpManager = nil;

@interface D5UdpPingManager()

@property (strong,nonatomic) NSMutableArray * pingList;
@property (retain,nonatomic) dispatch_semaphore_t sem;

@end

@implementation D5UdpPingManager

+ (D5UdpPingManager *)defaultUdpManager {
    @autoreleasepool {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            udpManager = [[D5UdpPingManager alloc] init];
        });
        return udpManager;
    }
}

-(NSMutableArray *)pingList{
    if(NULL == _pingList){
        _pingList = [[NSMutableArray alloc] init];
    }
    return _pingList;
}

-(dispatch_semaphore_t)sem{
    if(NULL == _sem){
        _sem = dispatch_semaphore_create(1);
    }
    return _sem;
}

-(D5Udp *)udpOfPing:(uint16_t)localPort{
    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
    D5Udp * target = NULL;
    for(D5Udp * udp in self.pingList){
        if(localPort == udp.localPort){
            target = udp;
            break;
        }
    }
    dispatch_semaphore_signal(self.sem);
    return target;
}

- (D5Udp *)addPing:(uint16_t)localPort delegate:(id)delegate{
    D5Udp * findUdp = [self udpOfPing:localPort];
    DLog(@"findUdp = %@", findUdp);
    if(NULL == findUdp){
        D5Udp * udp = [[D5Udp alloc] init];
        udp.localPort = localPort;
        [udp setDelegate:delegate];
        
        [udp initialUdp];
        [udp beginReceive];
        
        dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
        [self.pingList addObject:udp];
        dispatch_semaphore_signal(self.sem);
        
        return udp;
    }
    return findUdp;
}

-(void)removePing:(uint16_t)localPort{
    D5Udp * findUdp = [self udpOfPing:localPort];
    if(NULL != findUdp){

        dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
        [findUdp close];
        [self.pingList removeObject:findUdp];
        dispatch_semaphore_signal(self.sem);
        
    }
}

@end
