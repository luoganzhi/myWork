//
//  D5MultiLightFollowBoxData.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MultiLightFollowBoxData.h"

@implementation D5MultiLightFollowBoxData

- (D5MultiLightFollowBoxData *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _boxID = [dict[LED_STR_ID] integerValue];
        _imei = dict[LED_STR_IMEI];
        _mac = dict[LED_STR_MAC];
        _name = dict[LED_STR_NAME];
        _onoffStatus = [dict[LED_STR_ONOFFSTATUS] intValue];
    }
    return self;
}

+ (D5MultiLightFollowBoxData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
