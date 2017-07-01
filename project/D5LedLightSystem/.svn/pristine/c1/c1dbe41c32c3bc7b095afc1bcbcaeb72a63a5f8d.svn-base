//
//  D5LedList.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/10.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5LedCmds.h"

#define SEARCH_LIGHT_TIME_INTERVAL 60.0f

@class D5LedList;
@class D5LedData;

@protocol D5LedListDelegate <NSObject>

@optional
- (void)ledList:(D5LedList *)list getFinished:(BOOL)isFinished;

- (void)ledListAddOK:(D5LedList *)list isFinished:(BOOL)isFinished;
- (void)ledListAddOKError:(D5LedList *)list errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage;

- (void)ledListOperateNewLed:(D5LedList *)list operateType:(LedOperateNewType)operateType isFinished:(BOOL)isFinished;
- (void)ledListErrorOperateNewLed:(D5LedList *)list operateType:(LedOperateNewType)operateType errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage;

- (void)ledListOperateAddedLed:(D5LedList *)list operateType:(LedOperateType)operateType isFinished:(BOOL)isFinished;
- (void)ledListErrorOperateAddedLed:(D5LedList *)list operateType:(LedOperateType)operateType errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage;

- (void)ledListOperateAllLed:(D5LedList *)list operateType:(LedOperateType)operateType isFinished:(BOOL)isFinished;
- (void)ledListErrorOperateAllLed:(D5LedList *)list operateType:(LedOperateType)operateTyp errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage;

- (void)ledListOperateMode:(D5LedList *)list sceneType:(LedSceneType)sceneType isFinished:(BOOL)isFinished;
- (void)ledListErrorOperateMode:(D5LedList *)list sceneType:(LedSceneType)sceneType errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage;

@end

@interface D5LedList : NSObject

@property (nonatomic, weak) id<D5LedListDelegate> delegate;

/** 未添加的灯的列表 */
@property (nonatomic, strong) NSArray *notAddLedList;

/** 已添加的灯的列表 */
@property (nonatomic, strong) NSArray *addedLedList;

/** 列表类型 */
@property (nonatomic, assign) LedListType listType;

@property (nonatomic, assign) BOOL allOffline;

+ (D5LedList *)sharedInstance;

/**
 根据type获取灯的列表

 @param type 已添加的灯/未添加的灯
 */
- (void)getLedListByType:(LedListType)type;

/**
 已添加的灯列表中 设置过编号的灯

 @return  已经设置过编号的灯列表
 */
- (NSArray *)arrWithSetNoLedList;

/**
 开始心跳
 */
- (void)startHeartTimer;

/**
 停止心跳
 */
- (void)stopHeartTimer;

/**
 操作单个新灯
 
 @param operateType 操作类型(编号/取消编号/开关)
 @param ledData 操作的灯data
 @param index 操作的灯所在的index
 @param status 开灯/关灯 -- 只有在操作类型为开关时才传，其它类型LedOnOffStatusOn
 */
- (void)operateSingleNewLight:(LedOperateNewType)operateType withLedData:(D5LedData *)ledData atIndex:(NSInteger)index onoffStatus:(LedOnOffStatus)status;

/**
 操作单个已添加的灯
 
 @param operateType 操作类型(编号/开关/颜色/亮度/模式/删除)
 @param ledData 操作的灯data
 @param index 操作的灯所在的index
 @param status 开灯/关灯 -- 只有在操作类型为开关时才传，其它类型传LedOnOffStatusOn
 */
- (void)operateSingleAddedLight:(LedOperateType)operateType withLedData:(D5LedData *)ledData atIndex:(NSInteger)index onoffStatus:(LedOnOffStatus)status ;

/**
 场景设置

 @param sceneType 场景类型
 @param bSame 是否同色
 @param arr 颜色值数组
 */
- (void)operateModeSetting:(LedSceneType)sceneType bSame:(BOOL)bSame colorArr:(NSArray *)arr;

/**
 操作所有已添加的灯

 @param operateType 操作类型(颜色/亮度/模式/所有灯的开关)
 @param dict    操作参数（颜色值，亮度，开关状态）,该dict中不用传操作类型
 */
- (void)operateAllAddedLight:(LedOperateType)operateType parameterDict:(NSDictionary *)dict;

/**
 添加新搜到的灯组
 */
- (void)addLightGroup;

/**
 删除选择的灯组
 
 @param lights 选中的灯的数组
 */
- (void)deleteLightGroup:(NSArray *)lights;

@end
