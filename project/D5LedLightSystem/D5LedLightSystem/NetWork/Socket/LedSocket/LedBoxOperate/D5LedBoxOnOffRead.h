//
//  D5LedBoxOnOffRead.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/9/1.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBoxOnOffReadDelegate <NSObject>

- (void)ledBoxOnOffReadReturn:(uint8_t)onoff;

@end

@interface D5LedBoxOnOffRead : D5LedCmd

- (void)ledBoxOnOffRead;

@end
