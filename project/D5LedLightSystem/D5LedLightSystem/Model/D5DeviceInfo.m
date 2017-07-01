//
//  D5DeviceInfo.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//  登录中控后，返回的中控deviceInfo信息
//

#import "D5DeviceInfo.h"

@implementation D5DeviceInfo

- (D5DeviceInfo *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _boxAppId       =   [dict[LED_STR_APPID] intValue];
        _boxId          =   dict[LED_STR_ID];
        _boxName        =   dict[LED_STR_NAME];
        _versionCode    =   [dict[LED_STR_VERSIONCODE] intValue];
        _versionText    =   dict[LED_STR_VERSIONTEXT];
        _connectType    =   [dict[LED_STR_NETCONNECTTYPE] intValue];
        _modelName      =   dict[LED_STR_MODELNAME];
        
        _btVerCode      =   [dict[LED_STR_BTVERCODE] intValue];
        _btVerText      =   dict[LED_STR_BTVERTEXT];
        
        _btType         =   [dict[LED_STR_BT_TYPE] intValue];
    }
    return self;
}

+ (D5DeviceInfo *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
