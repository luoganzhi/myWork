//
//  D5LedBoxAdd.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/15.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"
#import "D5UdpPingManager.h"

@protocol D5LedBoxAddDelegate <NSObject>

- (void)ledBoxAddReturn:(NSDictionary *)dict;

@end

@interface D5LedBoxAdd : D5LedCmd

- (void)ledBoxAddBSSID:(NSString *)bssid withSSID:(NSString *)ssid withPwd:(NSString *)pwd isBroadCast:(BOOL)broadCast;

@end
