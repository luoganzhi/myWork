//
//  D5LedUpdateBleProgress.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedUpdateBleProgressDelegate <NSObject>

- (void)ledUpdateBleProgressReturn:(uint8_t)progress;

@end

@interface D5LedUpdateBleProgress : D5LedCmd

- (void)ledUpdateBleProgress;

@end
