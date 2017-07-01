//
//  D5MusicSpecialData.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicSpecialData.h"

@implementation D5MusicSpecialData


#pragma mark - 创建实例
- (D5MusicSpecialData *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.specialName = [dict objectForKey:SPECIAL_NAME];
        self.specialDJ = [dict objectForKey:SPECIAL_DJ];
        self.specialId = [[dict objectForKey:SPECIAL_ID] integerValue];
    }
    
    return self;
}

+ (D5MusicSpecialData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
