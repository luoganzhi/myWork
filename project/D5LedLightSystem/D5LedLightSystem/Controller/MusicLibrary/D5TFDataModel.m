//
//  D5TFDataModel.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/17.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5TFDataModel.h"
#import "D5TFMusicModel.h"

@implementation D5TFDataModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"list" : [D5TFMusicModel class]
             };
}

@end
