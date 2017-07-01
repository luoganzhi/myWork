//
//  D5SocketTool.m
//  D5Home_new
//
//  Created by PangDou on 16/1/25.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import "D5SocketTool.h"

@implementation D5SocketTool

+ (NSString *)macNumberToString:(long long)mac {
    @autoreleasepool {
        NSMutableArray *macArray = [[NSMutableArray alloc] init];
        int count = sizeof(long long);
        char *p = (char *)&mac;
        for (int i = 0; i < count; i ++) {
            @autoreleasepool {
                char byteMac = *p++;
                NSString *str = [NSString stringWithFormat:@"%02x",(unsigned char)byteMac];
                [macArray addObject:str];
            }
        }
        return [macArray componentsJoinedByString:@":"];
    }
}

+ (NSString *)macStringToDeleteZeroStr:(NSString *)mac {
    @autoreleasepool {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray: [mac componentsSeparatedByString:@":"]];
        if ([array.firstObject isEqualToString:@"00"]) {
            [array removeObjectAtIndex:0];
        }
        if ([array.firstObject isEqualToString:@"00"]) {
            [array removeObjectAtIndex:0];
        }
        return [array componentsJoinedByString:@":"];
    }
}


+ (NSString *)macStringToPlusZeroStr:(NSString *)mac {
    @autoreleasepool {
        NSArray *arr = [mac componentsSeparatedByString:@":"];
        NSString *newMac = @"";
        if (arr.count < 8) {
            int value = 8 - (int)arr.count;
            for (int i = 1;  i <= value; i ++) {
                newMac = [newMac stringByAppendingString:@"00:"];
            }
            
            newMac = [NSString stringWithFormat:@"%@%@", newMac, mac];
        }
        return newMac;
    }
}

+ (long long)macStringToNumber:(NSString *)number {
    @autoreleasepool {
        NSArray *macArray = [number componentsSeparatedByString:@":"];
        long long mac = 0;
        for (int i = 0; i < macArray.count; i ++) {
            NSString *tempMac = [macArray objectAtIndex:i];
            long long macTemp = strtoll([tempMac UTF8String], 0, 16);
            mac = (macTemp << (8 * i)) + mac;
        }
        return mac;
    }
}
@end
