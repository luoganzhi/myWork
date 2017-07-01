//
//  D5TcpManager.m
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import "D5TcpManager.h"
#import "D5Tcp.h"

#define CONENCT_TIMEOUT_INTERVAL 8.0f

static D5TcpManager *tcpManager = nil;

@interface D5TcpManager()
/*
 *存放tcp链接的列表
 *里面的存放的数据是NSDictionary（key -- value）
 *
 */
@property (strong,nonatomic) NSMutableArray * tcpList;
@property (retain,nonatomic) dispatch_semaphore_t sem;

@end

@implementation D5TcpManager

+ (D5TcpManager *)defaultTcpManager {
    @autoreleasepool {
        static dispatch_once_t onceQueue;
        dispatch_once(&onceQueue, ^{
            tcpManager = [[D5TcpManager alloc] init];
        });
        return tcpManager;
    }
}

- (dispatch_semaphore_t)sem{
    if(NULL == _sem){
        _sem = dispatch_semaphore_create(1);
    }
    return _sem;
}

- (NSMutableArray *)tcpList{
    if(NULL == _tcpList){
        _tcpList = [[NSMutableArray alloc] init];
    }
    return _tcpList;
}
- (D5Tcp *)tcpOfServer:(NSString *)serverIP port:(uint16_t)serverPort{
    D5Tcp * targetTcp = NULL;
    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
    for(D5Tcp * tcp in self.tcpList){
        if(tcp && [tcp.serverIP isEqualToString:serverIP] && tcp.serverPort == serverPort){
            targetTcp = tcp;
            break;
        }
    }
    dispatch_semaphore_signal(self.sem);
    return targetTcp;
}

- (void)addTcp:(D5Tcp *)tcp{
    D5Tcp * findTcp = [self tcpOfServer:tcp.serverIP port:tcp.serverPort];
    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
    if(NULL == findTcp){
        [self.tcpList addObject:tcp];
    }
    dispatch_semaphore_signal(self.sem);
}

- (void)addTcp:(NSString *)serverIP port:(uint16_t)serverPort delegate:(id)delegate{
    D5Tcp * findTcp = [self tcpOfServer:serverIP port:serverPort];
    DLog(@"去连接TCP---- %@--%d---%@", serverIP, serverPort, findTcp);
    if(NULL == findTcp){
        D5Tcp * tcp = [[D5Tcp alloc] init];
        [tcp setDelegate:delegate];
        [tcp connectToHost:serverIP port:serverPort withTimeout:CONENCT_TIMEOUT_INTERVAL];
        dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);

        [self.tcpList addObject:tcp];
        dispatch_semaphore_signal(self.sem);
    }
}

- (void)deleteTcp:(NSString *)serverIP port:(uint16_t)serverPort{
    D5Tcp * findTcp = [self tcpOfServer:serverIP port:serverPort];
    DLog(@"删除TCP:  %@--%d ++++ %@", serverIP, serverPort, findTcp);
    if(NULL != findTcp){
        if([findTcp isConnected]){
            [findTcp disconnect];
        }
        dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);

        [self.tcpList removeObject:findTcp];
        dispatch_semaphore_signal(self.sem);

    }
}

+ (BOOL)isCurrentBoxTcp:(D5Tcp *)tcp {
    @autoreleasepool {
        if (!tcp) {
            return NO;
        }
        
        if (tcp && [tcp.serverIP isEqualToString:[D5CurrentBox currentBoxIP]] && tcp.serverPort == [D5CurrentBox currentBoxTCPPort]) {
            return YES;
        }
        
        return NO;
    }
}
@end
