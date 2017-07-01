//
//  D5AlarmData.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5AlarmData.h"

@implementation D5AlarmData

- (D5AlarmData *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _action = [dict[LED_STR_ACTION] intValue];
        _alarmId = [dict[LED_STR_ID] intValue];
        _lookType = [dict[LED_STR_LOOKTYPE] intValue];
        _week = [dict[LED_STR_WEEK] intValue];
        _execTime = [dict[LED_STR_EXECTIME] integerValue];
        _operate = [dict[LED_STR_OPERATE] intValue];
    }
    return self;
}

+ (D5AlarmData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)dictWithData:(D5AlarmData *)data {
    @autoreleasepool {
        NSDictionary *dict = @{LED_STR_ACTION : @(data.action),
                               LED_STR_ID : @(data.alarmId),
                               LED_STR_LOOKTYPE : @(data.lookType),
                               LED_STR_WEEK : @(data.week),
                               LED_STR_EXECTIME : @(data.execTime),
                               LED_STR_OPERATE : @(data.operate)};
        return dict;
    }
}

@end
