//
//  D5LedData.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedData.h"

@implementation D5LedData

- (D5LedData *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _lightId = [[dict objectForKey:LED_STR_ID] intValue];
        _meshAddress = [[dict objectForKey:LED_STR_MESHADDR] integerValue];
        _onoffStatus = [[dict objectForKey:LED_STR_STATUS] intValue];
        _isMaster = [[dict objectForKey:LED_STR_ISMASTER] boolValue];
        _macAddress = [dict objectForKey:LED_STR_MACADDR];
        _currentColor = nil;
    }
    return self;
}


+ (D5LedData *)dataWithDict:(NSDictionary *)dict {
    return [[D5LedData alloc] initWithDict:dict];
}

@end
