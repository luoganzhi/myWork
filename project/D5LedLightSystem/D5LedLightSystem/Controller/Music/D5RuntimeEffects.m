//
//  D5RuntimeEffects.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5RuntimeEffects.h"

@implementation D5RuntimeEffects
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"effectId": @"id",
             @"effectType" : @"type"
             };
}

@end
