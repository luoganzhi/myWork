//
//  D5LedSendReceiveCmd.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBaseCmd.h"
#import "D5LedCommunication.h"

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

@interface D5LedSendReceiveCmd : D5LedBaseCmd <D5LedReceiveDataDelegate>

@property (weak, nonatomic)   id<D5LedNetWorkErrorDelegate> errorDelegate;
@property (weak, nonatomic)   id<D5LedCmdDelegate> receiveDelegate;

/** 是否需要先加入临时列表 */
@property (nonatomic, assign) BOOL isNeedAddToList;

- (BOOL)checkReceiveDelegate;
- (BOOL)checkErrorDelegate;

#pragma mark - 发送数据
/**
 发送数据 -- 广播形式接收(udp, 子类实现，不需开启关闭超时定时器，sn=0，要处理接收数据)
 
 @param data
 */
- (void)sendBroadCastData:(NSData *)data;

/**
 发送心跳类型数据 -- 子类实现(不需开启关闭超时定时器，sn=0，要处理接收数据)

 @param data
 */
- (void)sendHeartData:(NSData *)data;


/**
 发送推送类数据 -- 子类实现(不需开启关闭超时定时器，sn=0，不处理接收数据)

 @param data
 */
- (void)sendPushData:(NSData *)data;

/**
 发送数据 -- 非广播形式接收
 
 @param data
 @param isNeed 是否需要先加入队列中
 */
- (void)sendData:(NSData *)data needAddToTempList:(BOOL)isNeed;

/**
 发送命令 -- 带body (需子类实现发送方式-- 广播/心跳/推送)
 
 @param cmd
 @param subCmd
 @param dict body
 
 @return 发送的数据
 */
- (NSMutableData *)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict;

/**
 发送命令 -- 不带body
 
 @param cmd
 @param subCmd
 */
- (void)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd;

#pragma mark - 接收到数据的处理

/**
 接收数据出现错误
 
 @param errorCode 错误码
 @param msg 错误信息
 @param header
 @param ip
 */
- (void)cmdError:(int)errorCode withMsg:(NSString *)msg withHeader:(LedHeader *)header withData:(NSDictionary *)data from:(NSString *)ip;

- (void)closeUdp ;
@end
