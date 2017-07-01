//
//  D5UpdateModel.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/12/20.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHECK_UPDATE_TYPE       @"type"
#define CHECK_UPDATE_ISNEED     @"isneedupdate"

@interface D5UpdateModel : NSObject

@property (nonatomic, assign) CheckUpdateType updatType;
@property (nonatomic, assign) BOOL  isNeedUpdate;
@property (nonatomic, assign) int freshVerCode;

@property (nonatomic, copy) NSString *updateTip;
@property (nonatomic, copy) NSString *updateUrl;
@property (nonatomic, copy) NSString *freshverText;

- (D5UpdateModel *)initWithDict:(NSDictionary *)dict;
+ (D5UpdateModel *)dataWithDict:(NSDictionary *)dict;

@end
