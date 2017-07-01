//
//  NSMutableArray+Helper.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "NSMutableArray+Helper.h"
#import "D5LedData.h"
#import "D5BTUpdateLightData.h"

@implementation NSMutableArray (Helper)

+ (NSMutableArray *)arraySortedFrom:(NSArray *)arr by:(NSString *)attributeName ascending:(BOOL)ascending {
    @autoreleasepool {
        NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:attributeName ascending:ascending];
        NSArray *resultArr = [arr sortedArrayUsingDescriptors:@[desc]];
        return [NSMutableArray arrayWithArray:resultArr];
    }
}

/**
 * 根据灯的id排序
 */
+ (NSMutableArray *)arraySortedByLightIDFrom:(NSArray *)arr ascending:(BOOL)ascending {
    @autoreleasepool {
        NSMutableArray *resultArr = nil;
        if (arr && arr.count > 0) {
            NSMutableArray *noNumberArr = [NSMutableArray array];
            NSMutableArray *numberedArr = [NSMutableArray array];
            for (D5LedData *ledData in arr) {
                @autoreleasepool {
                    if (ledData.lightId <= 0) {
                        [noNumberArr addObject:ledData];
                    } else {
                        [numberedArr addObject:ledData];
                    }
                }
            }
            
            resultArr = [self arraySortedFrom:numberedArr by:@"lightId" ascending:ascending];
            [resultArr addObjectsFromArray:noNumberArr];
        }
        
        return resultArr;
    }
}

/**
 * 根据灯的id排序--升级蓝牙灯
 */
+ (NSMutableArray *)arraySortedByLightIDFromUpdate:(NSArray *)arr ascending:(BOOL)ascending {
    @autoreleasepool {
        NSMutableArray *resultArr = nil;
        if (arr && arr.count > 0) {
            NSMutableArray *noNumberArr = [NSMutableArray array];
            NSMutableArray *numberedArr = [NSMutableArray array];
            for (D5BTUpdateLightData *ledData in arr) {
                @autoreleasepool {
                    if (ledData.lightID <= 0) {
                        [noNumberArr addObject:ledData];
                    } else {
                        [numberedArr addObject:ledData];
                    }
                }
            }
            
            resultArr = [self arraySortedFrom:numberedArr by:@"lightID" ascending:ascending];
            [resultArr addObjectsFromArray:noNumberArr];
        }
        
        return resultArr;
    }
}

/**
 * 给nsnumber的数组排序（按照数字大小排序）
 */
+ (NSMutableArray *)arraySortedNumber:(NSArray *)arr ascending:(BOOL)ascending {
    @autoreleasepool {
        //block比较方法，数组中可以是NSInteger，NSString（需要转换）
        NSComparator finderSort = ^(NSNumber *num1, NSNumber *num2) {
            if ([num1 integerValue] > [num2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if ([num1 integerValue] < [num2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else
                return (NSComparisonResult)NSOrderedSame;
        };
        
        //数组排序：
        NSArray *resultArray = [arr sortedArrayUsingComparator:finderSort];
        //DLog(@"第一种排序结果：%@", resultArray);
        return [NSMutableArray arrayWithArray:resultArray];
    }
}
@end
