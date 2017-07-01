//
//  D5LedBaseCmd.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5BigLittleEndianExchange.h"
#import "D5SocketBaseTool.h"
#import "NSJSONSerialization+Helper.h"
#import "D5LedZKTList.h"
#import "D5LedCmds.h"
#import "D5UdpPingManager.h"

#define SRC_MAC_STR @"15828059276"
#define BROADCAST_DEST_MAC_STR @"FF:FF:FF:FF:FF:FF"

#define REMOTE_TIMEOUT_INTERVAL 10
#define LOCAL_TIMEOUT_INTERVAL  5

typedef struct _led_mac {
    char srcMac[6];
    char destMac[6];
}LedMac;

#define LED_BOX_RECEIVE_PORT 9004 //中控端UDP收数据端口
#define LED_BOX_SEND_PORT 9005 //手机端监听收数据端口（中控发数据，添加中控时）
#define LED_TCP_LONG_CONN_PORT 9006 //长连接端口

@interface D5LedBaseCmd : NSObject

@property (assign, nonatomic)   DeviceTag remoteLocalTag;

@property (assign, nonatomic)   LedMac mac;
@property (copy, nonatomic)     NSString *strSrcMac, *strDestMac;

@property (copy, nonatomic)     NSString *localIp;//目的设备的局域网IP
@property (assign, nonatomic)   uint16_t localPort;//目的设备的局域网端口
@property (assign, nonatomic)   uint16_t remotePort;//设备服务器端口
@property (assign, nonatomic)   NSString *remoteIp;//设备服务器IP

@property (assign, nonatomic)   LedHeader header;
@property (assign, nonatomic)   uint8_t headerCmd;
@property (assign, nonatomic)   uint8_t headerSubCmd;
@property (assign, nonatomic)   uint8_t sn;
@property (assign, nonatomic)   uint16_t checkCode;

@property (assign, nonatomic)   CPUModel remoteModel;
@property (strong, nonatomic)   NSMutableData *receiveData;

#pragma mark - 发送数据前的准备

/**
 根据发送的数据获取校验码
 
 @param data 发送的数据
 @return 校验码
 */
- (int8_t)getCheckSum:(NSData *)data;

/**
 设置sn -- 需子类实现
 */
- (void)setHeaderSn;

/**
 设置header中的值

 @param cmd
 @param subCmd
 @return header
 */
- (LedHeader *)headerForCmd:(int8_t)cmd withSubCmd:(uint8_t)subCmd;

/**
 根据remoteModel是否改变header的大小端
 
 @param header
 @param remoteModel
 */
+ (void)changeHeader:(LedHeader *)header remoteCpuModel:(CPUModel) remoteModel;

/**
 添加需要处理数据的cmd到列表中，开始超时定时器
 */
- (void)startCmd;

/**
 移除cmd，如果UDP发送数据则关闭UDP,关闭定时器
 */
- (void)endCmd;

/**
 将手机IP的最后一段改成255
 
 @return @return 手机IP的前三段+255
 */
- (NSString *)convertIp;

@end
