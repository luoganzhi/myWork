//
//  D5MusicModel.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicModel.h"

@implementation D5MusicModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"musicID": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"effects" : @"D5EffectsModel"
             };
}



@end
