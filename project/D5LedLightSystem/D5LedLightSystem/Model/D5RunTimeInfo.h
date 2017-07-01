//
//  D5RunTimeInfo.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//  登录中控后，返回的中控runTimeInfo信息
//

#import <Foundation/Foundation.h>
@class D5MusicData;
@class D5EffectData;

#pragma pack(1)
typedef struct _device_status {
    Byte isUpdateIng:1;
    Byte isLink:1;
}DeviceStatus;

@interface D5RunTimeInfo : NSObject

/** runTimeInfo */
@property (nonatomic, copy)     NSString                *boxId;
@property (nonatomic, assign)   LedOnOffStatus          lampStatus;     // 开关状态
@property (nonatomic, assign)   int                     brightness;     // 亮度
@property (nonatomic, assign)   LedMusicSetModelType    playMode;       // 播放模式
@property (nonatomic, assign)   int                     volume;         // 音量
@property (nonatomic, assign)   LedColorType            colorMode;      // 颜色模式
@property (nonatomic, strong)   D5MusicData             *music;
@property (nonatomic, assign)   int                     sceneType;
@property (nonatomic, strong)   D5EffectData            *effect;
@property (nonatomic, assign)   DeviceStatus            deviceStatus;

- (D5RunTimeInfo *)initWithDict:(NSDictionary *)dict;
+ (D5RunTimeInfo *)dataWithDict:(NSDictionary *)dict;

@end
