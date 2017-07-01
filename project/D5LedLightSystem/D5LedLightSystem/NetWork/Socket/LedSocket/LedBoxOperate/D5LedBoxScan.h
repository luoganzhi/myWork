//
//  D5LedBoxScan.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"
#import "D5UdpPingManager.h"
#import "D5LedZKTBoxData.h"

@protocol D5LedBoxScanDelegate <NSObject>

- (void)ledBoxScanReturn:(NSDictionary *)dict;

@end

@interface D5LedBoxScan : D5LedCmd

+ (D5LedBoxScan *)defaultBoxScan;
- (void)ledBoxScanBroadCast:(BOOL)isBroadCast;

@end
