//
//  D5LedLinkDeviceDeleteFromApp.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedLinkDeviceDeleteFromAppDelegate <NSObject>

- (void)ledLinkDeviceDeleteFromAppReturn:(int64_t)status;

@end

@interface D5LedLinkDeviceDeleteFromApp : D5LedCmd

- (void)ledLinkDeviceDeleteFromApp:(NSArray *)deleteInfos;

@end
