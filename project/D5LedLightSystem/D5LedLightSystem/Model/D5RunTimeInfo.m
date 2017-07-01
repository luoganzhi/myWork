//
//  D5RunTimeInfo.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5RunTimeInfo.h"
#import "D5MusicData.h"
#import "D5EffectData.h"

@implementation D5RunTimeInfo

- (D5RunTimeInfo *)initWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        if (self = [super init]) {
            _boxId = dict[LED_STR_ID];
            _lampStatus = [dict[LED_STR_LAMPSTATUS] intValue];
            _brightness = [dict[LED_STR_BRIGHTNESS] intValue];
            _playMode = [dict[LED_STR_PLAYMODE] intValue];
            _volume = [dict[LED_STR_VOLUME] intValue];
            _colorMode = [dict[LED_STR_COLORMODE] intValue];
            
            int status = [dict[LED_STR_DEVICESTATUS] intValue];
            NSData *data = [NSData dataWithBytes:&status length:sizeof(DeviceStatus)];
            _deviceStatus = *(DeviceStatus *)[data bytes];
            
            NSDictionary *musicDict = dict[LED_STR_MUSIC];
            if (musicDict) {
                _music =  [D5MusicData dataWithDict:musicDict];
            }
            
            _sceneType = [dict[LED_STR_SCENETYPE] intValue];
            
            NSDictionary *effectDict = dict[LED_STR_EFFECTS];
            if (effectDict) {
                _effect = [D5EffectData dataWithDict:effectDict];
            }
        }
        return self;
    }
}

+ (D5RunTimeInfo *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
