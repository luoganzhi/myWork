//
//  D5UpdateModel.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/12/20.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5UpdateModel.h"

@implementation D5UpdateModel

- (D5UpdateModel *)initWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        if (self = [super init]) {
            _updatType = [dict[CHECK_UPDATE_TYPE] intValue];
            _isNeedUpdate = [dict[CHECK_UPDATE_ISNEED] boolValue];
            _freshVerCode = [dict[ACTION_VERCODE] intValue];
            
            
            NSString *tipStr = [NSString stringWithFormat:@"%@", dict[ACTION_TIPS]];
            NSString *str = [tipStr stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            
            _updateTip = str;
            _updateUrl = dict[ACTION_URL];
            _freshverText = dict[ACTION_VERTEXT];
        }
        return self;
    }
}

+ (D5UpdateModel *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end