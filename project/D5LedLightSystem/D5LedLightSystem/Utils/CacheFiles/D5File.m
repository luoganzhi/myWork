//
//  D5File.m
//  D5Home_new
//
//  Created by 黄斌 on 15/12/16.
//  Copyright © 2015年 com.pangdou.d5home. All rights reserved.
//

#import "D5File.h"
#import "D5PhoneMessage.h"

@implementation D5File

/**
 * 改变后缀名
 */
+ (NSString *)changeExtensionName:(NSString *)extensionName withOriginalName:(NSString *)fileName {
    @autoreleasepool {
        NSString *name = [fileName stringByDeletingPathExtension];
        NSString *newName = [name stringByAppendingPathExtension:extensionName];
        return newName;
    }
}

+ (NSString *)audioFileName {
    @autoreleasepool {
        NSString *phoneNumber = [D5PhoneMessage identifierUUID];
        NSInteger randomNumber = [D5File getRandomNumberFrom:0 to:1000000];
        NSString *time = [D5File getFileNameTime];
        return [NSString stringWithFormat:@"audio_%@_%@_%lu.wav", phoneNumber,time, (long)randomNumber];
    }
}

+ (NSInteger)getRandomNumberFrom:(NSInteger)from to:(NSInteger)to {
    return (NSInteger)(from + (arc4random()%(to - from + 1)));
}

+ (NSString *)getFileNameTime {
    @autoreleasepool {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMDDHHmmss"];
        return [formatter stringFromDate:[NSDate date]];
    }
    
}
@end
