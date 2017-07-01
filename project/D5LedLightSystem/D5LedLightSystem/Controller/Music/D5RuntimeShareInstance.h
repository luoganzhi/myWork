//
//  D5RuntimeShareInstance.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class D5RuntimeMusic;
@class D5RuntimeEffects;

typedef enum _device_status {
    DeviceStatusNormal = 0,     // 未升级 未处于联动
    DeviceStatusUpdating,       // 在升级 未处于联动
    DeviceStatusLink,           // 未升级 处于联动
    DeviceStatusUpdatingAndLink // 升级 且 处于联动
}DeviceStatus;

@interface D5RuntimeShareInstance : NSObject

/** 设备唯一标示 */
@property (nonatomic, copy) NSString *deviceId;

/** 灯状态 */
@property (nonatomic, assign) LedOnOffStatus lampStatus;

/** 返回灯类型 */
@property (nonatomic, assign) LedDeviceType deviceType;

/** 亮度 */
@property (nonatomic, assign) int brightness;

/** 音乐播放模式 */
@property (nonatomic, assign) int playMode;

/** 音量 */
@property (nonatomic, assign) int volume;

/** 场景模式 */
@property (nonatomic, assign) LedSceneType sceneType;

/** 音乐 */
@property (nonatomic, strong) D5RuntimeMusic *music;

/** 配置 */
@property (nonatomic, strong) D5RuntimeEffects *effects;

/** 颜色模式 */
@property (nonatomic, assign) LedColorModel colorMode;

/** 设备标识符 */
@property (nonatomic, assign) DeviceStatus deviceStatus;

/** 内存警告 */
@property (nonatomic, assign) BOOL isStorageNeedWarn;

+ (instancetype)sharedInstance;

/**
 是否处于蓝牙升级中

 @return 
 */
- (BOOL)isBtUpdating;

/**
 是否在联动模式

 @return
 */
- (BOOL)isDeviceLink;

- (void)clear;

@end
