//
//  D5LedLightSwitchStatus.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/29.
//  Copyright © 2016年 PangDou. All rights reserved.
//


//获取Led灯的开关状态，只有有一盏灯为开则显示为开灯
#import <Foundation/Foundation.h>
#import "D5LedCmd.h"

@protocol D5LedLightSwitchStatusDelegate <NSObject>

- (void)ledLightSwitchStatus:(uint8_t)status;

@end


@interface D5LedLightSwitchStatus : D5LedCmd

- (void)getLedLightSwitchStatus;

@end
