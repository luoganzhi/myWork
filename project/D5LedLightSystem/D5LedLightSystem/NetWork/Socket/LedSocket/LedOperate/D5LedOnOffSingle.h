//
//  D5LedOnOffSingle.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedOnOffSingleDelegate <NSObject>

- (void)ledOnOffSingleReturn:(int64_t)status;

@end

@interface D5LedOnOffSingle : D5LedCmd

- (void)ledOnOffSingle:(NSArray *)datas forLedMac:(int32_t)macInt;

@end
