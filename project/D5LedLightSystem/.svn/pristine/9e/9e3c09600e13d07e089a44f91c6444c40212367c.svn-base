//
//  D5AlarmData.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5AlarmData : NSObject

@property (nonatomic, assign) LedOperateTaskType action;
@property (nonatomic, assign) int alarmId;
@property (nonatomic, assign) LedTimeTaskCycleType lookType;
@property (nonatomic, assign) int week;
@property (nonatomic, assign) NSInteger execTime;
@property (nonatomic, assign) LedTimeTaskLedOperate operate;

- (D5AlarmData *)initWithDict:(NSDictionary *)dict;
+ (D5AlarmData *)dataWithDict:(NSDictionary *)dict;

+ (NSDictionary *)dictWithData:(D5AlarmData *)data;

@end
