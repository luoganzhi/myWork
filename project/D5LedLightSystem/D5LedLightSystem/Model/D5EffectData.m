//
//  D5EffectData.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5EffectData.h"

@implementation D5EffectData

- (D5EffectData *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _effectType = [dict[LED_STR_TYPE] intValue];
        _effectId = [dict[LED_STR_ID] intValue];
        _serverId = [dict[LED_STR_SERVERID] intValue];
        _effectName = dict[LED_STR_NAME];
        _author = dict[LED_STR_AUTHOR];
        _playStatus = [dict[LED_STR_PLAYSTATUS] intValue];
    }
    return self;
}

+ (D5EffectData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
