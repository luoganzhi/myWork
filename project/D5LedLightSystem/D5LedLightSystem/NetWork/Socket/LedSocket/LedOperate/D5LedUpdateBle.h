//
//  D5LedUpdateBle.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedUpdateBleDelegate <NSObject>

- (void)ledUpdateBleReturn:(int64_t)status;

@end

@interface D5LedUpdateBle : D5LedCmd

- (void)ledUpdateBle;

@end
