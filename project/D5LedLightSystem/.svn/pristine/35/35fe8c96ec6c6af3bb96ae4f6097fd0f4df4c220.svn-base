//
//  D5Date.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5Date.h"

@implementation D5Date

+ (NSTimeInterval)currentTimeStamp {
    return [[NSDate date] timeIntervalSince1970];
}

+ (int64_t)currentLongTimeStamp {
    return (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
}

+ (NSDate *)dateFromSeconds:(NSInteger)seconds {
    @autoreleasepool {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        
        NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
        todayStr = [todayStr stringByAppendingFormat:@" %@", [self timeFromSeconds:seconds]]; //2016-09-23 14:12:30
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:todayStr];
        return date;
    }
}


+ (NSString *)timeFromSeconds:(NSInteger)seconds {
    @autoreleasepool {
        int hour = (int)seconds / 3600;
        int remainMinutes = (int)seconds % 3600;
        
        int minute = 0;
        int second = 0;
        if (remainMinutes < 60) {   // 不满一分钟
            second = remainMinutes;
        } else {
            minute = remainMinutes / 60;
            second = remainMinutes % 60;
        }
        
        NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
        return time;
    }
}

+ (NSString *)hourMinuteStrFromSeconds:(NSInteger)seconds {
    @autoreleasepool {
        int hour = (int)seconds / 3600;
        int remainMinutes = (int)seconds % 3600;
        
        int minute = 0;
        if (remainMinutes >= 60) {
            minute = remainMinutes / 60;
        }
        
        NSString *time = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
        return time;
    }
}

+ (NSInteger)secondsFromDate:(NSDate *)date {
    @autoreleasepool {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        NSInteger minute = dateComponent.minute;
        NSInteger hour = dateComponent.hour;
        NSInteger second = dateComponent.second;
        
        return hour * 60 * 60 + minute * 60 + second;
    }
}

@end
