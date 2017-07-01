//
//  NSJSONSerialization+Helper.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Helper)

+ (id)jsonObjectFromData:(NSData *)jsonData;

/**
 *  将json字符串转为dict
 *
 *  @param jsonStr
 *
 *  @return dict
 */
+ (NSDictionary *)dictFromJsonString:(NSString *)jsonStr;

/**
 *  将jsondata转为dict
 *
 *  @param jsonData
 *
 *  @return dict
 */
+ (NSDictionary *)dictFromJsonData:(NSData *)jsonData;

/**
 *  将dict中的内容转成json字符串
 *
 *  @param dict
 *
 *  @return json字符串
 */
+ (NSString *)jsonStringFromDict:(NSDictionary *)dict;

/**
 *  将dict中的内容转成data
 *
 *  @param dict
 *
 *  @return data
 */
+ (NSData *)jsonDataFromDict:(NSDictionary *)dict;

/**
 *  将jsondata转为array
 *
 *  @param jsonData
 *
 *  @return array
 */
+ (NSArray *)arrayFromJsonData:(NSData *)jsonData;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
