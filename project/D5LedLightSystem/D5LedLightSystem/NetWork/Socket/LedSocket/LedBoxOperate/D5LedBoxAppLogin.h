//
//  D5LedBoxAppLogin.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBoxAppLoginDelegate <NSObject>

- (void)ledBoxAppLoginReturn:(int64_t)status withMac:(NSString *)mac;

@end

@interface D5LedBoxAppLogin : D5LedCmd

- (void)ledBoxAppLogin;

@end
