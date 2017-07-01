//
//  D5LedBoxUpdateApp.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBoxUpdateAppDelegate <NSObject>

- (void)ledBoxUpdateAppReturn:(int64_t)status;

@end

@interface D5LedBoxUpdateApp : D5LedCmd

- (void)ledBoxUpdateApp:(NSString *)url;

@end
