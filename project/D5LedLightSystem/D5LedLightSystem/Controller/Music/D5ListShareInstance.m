//
//  D5ListShareInstance.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ListShareInstance.h"

@implementation D5ListShareInstance


static D5ListShareInstance *instance = nil;


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.musicList = [NSMutableArray array];
        instance.effectsList = [NSMutableArray array];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

@end
