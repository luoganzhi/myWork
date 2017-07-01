//
//  D5LedCmd.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5BigLittleEndianExchange.h"
#import "D5CmdMuticast.h"
#import "D5LedModule.h"
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

@protocol D5LedCmdDelegate <NSObject>

@optional

/**
 接收数据 -- 有body,有IP (在有body返回的情况下，如果VC实现了该方法，则优先调用该方法)

 @param header
 @param dict
 @param ip
 */
- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict withIP:(NSString *)ip;

/**
 接收数据 -- 有body，没有IP (在有body返回的情况下，如果VC没有实现了👆的方法，则调用此方法)

 @param dict body
 */
- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict;

/**
 接收数据 -- 没有body，没有IP
 */
- (void)ledCmdReceivedData:(LedHeader *)header;


@end

@interface D5LedCmd : NSObject<D5LedReceiveDataDelegate>

@property (assign, nonatomic)   id<D5LedNetWorkErrorDelegate> errorDelegate;
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
@property (assign, nonatomic)   uint8_t serailNumber;
@property (assign, nonatomic)   uint16_t checkCode;

@property (assign, nonatomic)   CPUModel remoteModel;
@property (strong, nonatomic)   NSMutableData *receiveData;
@property (assign, nonatomic)   uint8_t sn;

/** 收到数据后是否调用endCmd -- 如果广播的命令或者推送的命令则传NO， 默认YES */
@property (nonatomic, assign)   BOOL isNeedEndCmd;

@property (nonatomic, assign)   id<D5LedCmdDelegate> receivedDelegate;

#pragma mark - 发送数据前的准备

/**
 根据发送的数据获取校验码
 
 @param data 发送的数据
 @return 校验码
 */
- (int8_t)getCheckSum:(NSData *)data;

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
 将手机IP的最后一段改成255
 
 @return @return 手机IP的前三段+255
 */
- (NSString *)convertIp;

#pragma mark - 发送数据
/**
 发送数据 -- 广播形式接收
 
 @param data
 */
- (void)sendBroadCastData:(NSData *)data;

/**
 发送数据 -- 非广播形式接收
 
 @param data
 */
- (void)sendData:(NSData *)data;

/**
 发送命令 -- 带body，收到数据后需要调用endCmd
 @param cmd
 @param subCmd
 @param dict body
 */
- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict;

/**
 发送命令 -- 不带body，收到数据后需要调用endCmd

 @param cmd
 @param subCmd
 */
- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd;

/**
 发送命令,收到数据后是否调用endcmd -- 不带body
 isNeedEndCmd -- 如果广播的命令或者推送的命令则传NO

 @param cmd
 @param subCmd
 @param isNeedEndCmd 收到数据后是否需要调用endCmd
 */
- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd isNeedEndCmd:(BOOL)isNeedEndCmd;

/**
 发送命令,收到数据后是否调用endcmd -- 带body
 isNeedEndCmd -- 如果广播的命令或者推送的命令则传NO
 
 @param cmd
 @param subCmd
 @param dict body
 @param isNeedEndCmd 收到数据后是否需要调用endCmd
 */
- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict isNeedEndCmd:(BOOL)isNeedEndCmd;

#pragma mark - 接收到数据的处理
/**
 移除cmd，如果UDP发送数据则关闭UDP
 */
- (void)endCmd;

/**
 关闭定时器
 */
- (void)stopTimer;

/**
 移除CMD,关闭定时器
 */
- (void)cmdReceivedResult;

/**
 接收数据出现错误
 
 @param errorCode 错误码
 @param msg 错误信息
 @param header
 @param ip
 */
- (void)cmdError:(int)errorCode withMsg:(NSString *)msg withHeader:(LedHeader *)header withData:(NSDictionary *)data from:(NSString *)ip;

@end
