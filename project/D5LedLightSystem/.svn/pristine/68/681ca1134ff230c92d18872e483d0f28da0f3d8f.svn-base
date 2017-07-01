//
//  D5UdpPingManager.h
//  Network
//
//  Created by anthonyxoing on 15/9/8.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5Udp.h"
/***********************************************************************
 数据结构为数据字典
 key:remote tcp port
 value:socket
 ***********************************************************************/
@interface D5UdpPingManager : NSObject
+ (D5UdpPingManager *)defaultUdpPingManager;
- (void)deletePing:(uint16_t)port deviceModule:(id)delegate;
- (void)addPing:(uint16_t)port deviceModule:(id)delegate;
- (D5Udp *)getPing:(uint16_t)port deviceModule:(id)delegate;
- (void)reCreatePing:(uint16_t)port;
@end
