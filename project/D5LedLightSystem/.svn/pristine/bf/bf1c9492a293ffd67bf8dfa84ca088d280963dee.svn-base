//
//  D5Date.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5Date : NSObject

/**
 获取当前时间的时间戳

 @return 当前时间的时间戳
 */
+ (NSTimeInterval)currentTimeStamp;
+ (int64_t)currentLongTimeStamp;

/**
 将秒数转为yyyy-MM-dd HH:mm

 @param seconds 秒数
 @return
 */
+ (NSDate *)dateFromSeconds:(NSInteger)seconds;


/**
 将秒数转为时间字符串

 @param seconds 秒数
 @return 转成格式为HH:mm:ss的字符串
 */
+ (NSString *)timeFromSeconds:(NSInteger)seconds;


/**
 将秒数转为字符串
 
 @param seconds 秒数
 @return 转成格式为HH:mm的字符串
 */
+ (NSString *)hourMinuteStrFromSeconds:(NSInteger)seconds;

/**
 将date转为秒数

 @param date
 @return 秒数
 */
+ (NSInteger)secondsFromDate:(NSDate *)date;

@end
