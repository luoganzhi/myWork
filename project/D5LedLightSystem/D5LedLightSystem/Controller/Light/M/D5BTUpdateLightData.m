//
//  D5BTUpdateLightData.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/12/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BTUpdateLightData.h"

@implementation D5BTUpdateLightData

- (instancetype)init {
    if (self = [super init]) {
        _updateStatus = BtUpdateStatusNotUpdate;
        _progress = 0;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"lightID": @"id",
             @"updateStatus" : @"status"
             };
}

@end
