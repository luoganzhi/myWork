//
//  NSJSONSerialization+Helper.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "NSJSONSerialization+Helper.h"

@implementation NSJSONSerialization (Helper)

+ (id)jsonObjectFromData:(NSData *)jsonData {
    @autoreleasepool {
        if (!jsonData) {
            return nil;
        }
        
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            //DLog(@"json解析失败：%@", error);
            return nil;
        }
        
        return jsonObject;
    }
}

+ (NSDictionary *)dictFromJsonString:(NSString *)jsonStr {
    @autoreleasepool {
        if (![NSString isValidateString:jsonStr]) {
            return nil;
        }
        
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        return [self dictFromJsonData:jsonData];
    }
}

+ (NSDictionary *)dictFromJsonData:(NSData *)jsonData {
    @autoreleasepool {
        id obj = [self jsonObjectFromData:jsonData];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            return obj;
        }
        return nil;
    }
}

+ (NSString *)jsonStringFromDict:(NSDictionary *)dict {
    @autoreleasepool {
        return [[NSString alloc] initWithData:[self jsonDataFromDict:dict] encoding:NSUTF8StringEncoding];
    }
}

+ (NSData *)jsonDataFromDict:(NSDictionary *)dict {
    @autoreleasepool {
        NSError *parseError = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&parseError];
        return data;
    }
}

+ (NSArray *)arrayFromJsonData:(NSData *)jsonData {
    @autoreleasepool {
        id obj = [self jsonObjectFromData:jsonData];
        if ([obj isKindOfClass:[NSArray class]]) {
            return obj;
        }
        return nil;
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
