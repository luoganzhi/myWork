//
//  D5UdpPingManager.h
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/16.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class D5Udp;
/**
 *该类管理需要接收的广播端口，别的设备发，本机收,所有的方法里的参数localPort都是本地接收端口
 *
 */

@interface D5UdpPingManager : NSObject

+ (D5UdpPingManager *)defaultUdpManager;

- (D5Udp *)addPing:(uint16_t)localPort delegate:(id)delegate;


- (void)removePing:(uint16_t)localPort;


- (D5Udp *)udpOfPing:(uint16_t)localPort;

@end
