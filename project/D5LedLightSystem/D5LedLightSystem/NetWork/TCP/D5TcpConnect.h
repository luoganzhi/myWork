//
//  D5TcpConnect.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/29.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5TcpConnect : NSObject

@property (nonatomic, copy) NSString *remoteIP;//中控ip地址
@property (nonatomic, assign) int remotePort;//中控固定端口
@property (strong, nonatomic) GCDAsyncSocket * tcpSocket;//套接字
@property (assign,nonatomic) NSTimeInterval reconnectTimeInterval;//超时时间
@property(assign,nonatomic) BOOL isReconnection;//重新连接yes 为正在重连 NO为正常情况;
@property (nonatomic, assign) NSInteger failedCount;//失败次数
@property (assign,nonatomic) BOOL isBackGround;//是否是在后台
+ (D5TcpConnect *)sharedTcpConnect;//单利
- (void)connectTo:(NSString *)ip port:(uint16_t)port;
- (BOOL)isConnect;
- (void)disconnect;
@end
