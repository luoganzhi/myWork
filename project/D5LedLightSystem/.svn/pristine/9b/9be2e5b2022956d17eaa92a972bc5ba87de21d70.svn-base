//
//  D5MusicListInstance.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/12/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicListInstance.h"

@implementation D5MusicListInstance

static D5MusicListInstance *instance = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.allMusicList = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (void)clear
{
    onceToken = 0;
    instance.currentIndex = 0;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


@end
