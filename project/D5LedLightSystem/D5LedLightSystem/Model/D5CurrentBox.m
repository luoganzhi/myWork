//
//  D5CurrentBox.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5CurrentBox.h"
#import "D5RuntimeShareInstance.h"
#import "NSObject+MJKeyValue.h"

static NSDictionary *instance = nil;

@implementation D5CurrentBox

+ (NSDictionary *)currentBox {
    if (instance == nil) {
        instance = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_ZKT_KEY];
    }
    return instance;
}

+ (NSString *)currentBoxIP {
    if (![D5CurrentBox currentBox]) {
        return nil;
    }
    return [instance objectForKey:ZKT_BOX_IP];
}

+ (NSString *)currentBoxMac {
    if (![D5CurrentBox currentBox]) {
        return nil;
    }
    return [instance objectForKey:ZKT_BOX_MAC];
}

+ (NSString *)currentBoxId {
    if (![D5CurrentBox currentBox]) {
        return nil;
    }
    return [instance objectForKey:ZKT_BOX_ID];
}

+ (int)currentBoxTCPPort {
    if (![D5CurrentBox currentBox]) {
        return 0;
    }
    
    return [[instance objectForKey:ZKT_BOX_TCP_PORT] intValue];
}

+ (NSString *)currentBoxName {
    if (![D5CurrentBox currentBox]) {
        return nil;
    }
    return [instance objectForKey:ZKT_BOX_NAME];
}

+ (D5DeviceInfo *)currentBoxDeviceInfo {
    @autoreleasepool {
        NSDictionary *dict =  [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_LOGIN_BOX];
        if (dict) {
           NSDictionary *deviceInfoDict =  dict[LED_STR_DEVICEINFO];
           return [D5DeviceInfo dataWithDict:deviceInfoDict];
        }
        
        return nil;
    }
}

+ (void)setCurrentBoxDeviceInfo:(NSDictionary *)deviceInfo {
    @autoreleasepool {
        if (!deviceInfo) {
            return;
        }
        
        NSDictionary *dict =  [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_LOGIN_BOX];
        if (dict) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            mutableDict[LED_STR_DEVICEINFO] = deviceInfo[LED_STR_DEVICEINFO];
            
            [[NSUserDefaults standardUserDefaults] setObject:mutableDict forKey:CURRENT_LOGIN_BOX];
        }
        
    }
}

+ (void)setRunTimeInfo {
    @autoreleasepool {
        NSDictionary *dict =  [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_LOGIN_BOX];
        if (dict) {
            NSDictionary *runtimeIfno = (NSDictionary *)dict[LED_STR_RUNTIMEINFO];
            
            D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
            instance = [D5RuntimeShareInstance mj_objectWithKeyValues:runtimeIfno];
        }
    }
}

+ (void)setInstanceNil {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SELECTED_ZKT_KEY];
    
    instance = nil;
}


@end
