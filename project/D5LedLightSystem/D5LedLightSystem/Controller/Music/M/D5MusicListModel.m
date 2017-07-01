//
//  D5MusicListModel.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicListModel.h"
#import "D5MusicModel.h"
#import "D5BaseListModel.h"

@implementation D5MusicListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"musicList" : [D5BaseListModel class]
             };
}



@end
