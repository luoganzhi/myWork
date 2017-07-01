//
//  D5SocketManager.h
//  Network
//
//  Created by anthonyxoing on 15/9/7.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5Tcp.h"
/***********************************************************************
 数据结构为数据字典
 key:remote tcp ip + remote tcp port
 value:socket
 ***********************************************************************/

@interface D5TcpManager : NSObject
+ (D5TcpManager *)defaultSocketManager;
- (void)deleteConnect: (NSString *)tcpRemoteIp port:(uint16_t)tcpRemotePort deviceModule:(id)delegate;
- (void)addConnect:(NSString *)tcpRemoteIp port:(uint16_t)tcpRemotePort deviceModule:(id)delegate;
- (D5Tcp *)getConenct:(NSString *)tcpRemoteIp port:(uint16_t)tcpRemotePort deviceModule:(id)delegate;
@end
