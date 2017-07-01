//
//  D5RuntimeShareInstance.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5RuntimeShareInstance.h"
#import "D5RuntimeMusic.h"
#import "D5RuntimeEffects.h"

@implementation D5RuntimeShareInstance

static D5RuntimeShareInstance *instance = nil;
static dispatch_once_t   onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (void)clearAll {
    instance.music.name = nil;
}

- (void)clear
{
    instance.music = nil;
    instance.effects = nil;
    instance.deviceId = nil;
    instance.lampStatus = LedOnOffStatusOff;
    instance.deviceType = Default;
    instance.brightness = 0;
    instance.playMode = 0;
    instance.volume = 0;
    instance.sceneType = LedSceneTypeNo;
    instance.colorMode = Color_Config;
    instance.deviceStatus = DeviceStatusNormal;
    instance.isStorageNeedWarn = NO;
    
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"deviceId": @"id"};
}

- (BOOL)isBtUpdating {
    if (self.deviceStatus == DeviceStatusUpdating || self.deviceStatus == DeviceStatusUpdatingAndLink) {
        return YES;
    }
    return NO;
}

- (BOOL)isDeviceLink {
    if (self.deviceStatus == DeviceStatusLink || self.deviceStatus == DeviceStatusUpdatingAndLink) {
        return YES;
    }
    return NO;
}

@end
