//
//  D5RuntimeEffects.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5RuntimeEffects : NSObject


typedef enum _effect_type {
    Effects_Short = 1,  // 简短特效
    Effects_Common,   // 通用配置
    Effects_Self       // 独有配置
}EffectsType;


/** 配置类型 */
@property (nonatomic, assign) EffectsType effectType;

/** 配置id */
@property (nonatomic, assign) int effectId;

/** 配置服务端id */
@property (nonatomic, assign) int serverId;

/** 配置名 */
@property (nonatomic, copy) NSString *name;

/** 配置作者 */
@property (nonatomic, copy) NSString *author;

/** 播放状态 */
@property (nonatomic, assign) PlayStatusType playStatus;

@end
