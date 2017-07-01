//
//  D5LedLinkDeviceAddFromApp.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedLinkDeviceAddFromAppDelegate <NSObject>

- (void)ledLinkDeviceAddFromAppReturn:(int64_t)status;

@end

@interface D5LedLinkDeviceAddFromApp : D5LedCmd

- (void)ledLinkDeviceAddFromApp:(NSArray *)addInfos;

@end
