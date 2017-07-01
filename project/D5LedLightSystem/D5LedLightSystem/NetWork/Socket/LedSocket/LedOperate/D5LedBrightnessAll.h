//
//  D5LedBrightnessAll.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBrightnessAllDelegate <NSObject>

- (void)ledBrightnessAllReturn:(int64_t)status;

@end

@interface D5LedBrightnessAll : D5LedCmd

- (void)ledBrightnessAll:(uint8_t)brightness;

@end
