//
//  D5LedInitialInfoData.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedInitialInfoData.h"
#import "D5FileModules.h"
#import "NSJSONSerialization+Helper.h"

static D5LedInitialInfoData *instance = nil;

#define ISFIRST_NO_BOX @"isFirstNoBox"
#define ISFIRST_NO_LIGHTS @"isFirstNoLights"
#define DEVICE_TOKEN   @"deviceToken"

@interface D5LedInitialInfoData()

@end

@implementation D5LedInitialInfoData

+ (NSString *)filePath {
    return  [D5FileModules configurePath:INITITAL_INFO_FILE_NAME];
}

- (D5LedInitialInfoData *)initWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        if (self = [super init]) {
            _isFirstNoBox = [[dict objectForKey:ISFIRST_NO_BOX] boolValue];
            _isFirstNoLights = [[dict objectForKey:ISFIRST_NO_LIGHTS] boolValue];
            _deviceToken = [dict objectForKey:DEVICE_TOKEN];
        }
        return self;
    }
}

+ (D5LedInitialInfoData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+ (D5LedInitialInfoData *)sharedLedInitialInfoData {
    @autoreleasepool {
        if ([self filePath]) {
            NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
            if (data) {
                NSDictionary *dict = [NSJSONSerialization dictFromJsonData:data];
                if (dict) {
                    instance = [self dataWithDict:dict];
                    return instance;
                }
            }
        }
        
        return [[self alloc] init];
    }
}

//保存数据
- (BOOL)saveInfo {
    @autoreleasepool {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithBool:_isFirstNoLights] forKey:ISFIRST_NO_LIGHTS];
        [dict setObject:[NSNumber numberWithBool:_isFirstNoBox] forKey:ISFIRST_NO_BOX];
        
        NSData *data = [NSJSONSerialization jsonDataFromDict:dict];
        if (data) {
            BOOL result = [data writeToFile:[D5LedInitialInfoData filePath] atomically:YES];
            return result;
        }
        
        return NO;
    }
}

@end
