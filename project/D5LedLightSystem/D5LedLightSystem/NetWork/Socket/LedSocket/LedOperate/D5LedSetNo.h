//
//  D5LedSetNo.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedSetNoDelegate <NSObject>

- (void)ledSetNoReturn:(int64_t)status;

@end

@interface D5LedSetNo : D5LedCmd

- (void)ledSetNo:(NSArray *)noArrs; //+要删
- (void)ledSetNo:(NSArray *)noArrs macInt:(int32_t)macInt;

@end
