//
//  NSMutableArray+Helper.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Helper)

/**
 * 给arr按照attributeName排序
 * ascending 升/降序
 */
+ (NSMutableArray *)arraySortedFrom:(NSArray *)arr by:(NSString *)attributeName ascending:(BOOL)ascending;
+ (NSMutableArray *)arraySortedByLightIDFrom:(NSArray *)arr ascending:(BOOL)ascending;
+ (NSMutableArray *)arraySortedNumber:(NSArray *)arr ascending:(BOOL)ascending;

/**
 * 根据灯的id排序--升级蓝牙灯
 */
+ (NSMutableArray *)arraySortedByLightIDFromUpdate:(NSArray *)arr ascending:(BOOL)ascending;
@end
