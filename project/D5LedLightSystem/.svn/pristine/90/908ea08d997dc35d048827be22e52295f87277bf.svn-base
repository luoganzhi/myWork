//
//  D5TcpManager.h
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class D5Tcp;

@interface D5TcpManager : NSObject

/**
 *  创建单例
 *
 *  @return 单例
 */
+ (D5TcpManager *)defaultTcpManager;

//采用默认方式添加---无超时链接模式添加一个tcp链接
- (void)addTcp:(NSString *)serverIP port:(uint16_t)serverPort delegate:(id) delegate;

//添加一个设定好的tcp链接
- (void)addTcp:(D5Tcp *)tcp;

//根据提供的ip地址和端口号删除相关的tcp链接
- (void)deleteTcp:(NSString *)serverIP port:(uint16_t)serverPort;

//根据提供的服务器ip地址和端口号获取tcp链接
- (D5Tcp *)tcpOfServer:(NSString *)serverIP port:(uint16_t)serverPort;

/**
 判断TCP是否是当前中控连接的TCP

 @param tcp
 @return 
 */
+ (BOOL)isCurrentBoxTcp:(D5Tcp *)tcp;
@end
