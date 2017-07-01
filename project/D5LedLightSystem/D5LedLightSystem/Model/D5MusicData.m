//
//  D5MusicData.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicData.h"

@implementation D5MusicData

- (D5MusicData *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _musicId = [dict[LED_STR_ID] intValue];
        _serverId = [dict[LED_STR_SERVERID] intValue];
        _musicName = dict[LED_STR_NAME];
        _singerName = dict[LED_STR_SINGERNAME];
        _albumName = dict[LED_STR_ALBUMNAME];
        _albumImgUrl = dict[LED_STR_ALBUMIMGURL];
        _duration = [dict[LED_STR_DURATION] intValue];
        _currentPos = [dict[LED_STR_CURRENTPOS] intValue];
        _playStatus = [dict[LED_STR_PLAYSTATUS] intValue];
    }
    return self;
}

+ (D5MusicData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
