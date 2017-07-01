//
//  D5LedBoxHeart.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/29.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBoxHeartDelegate <NSObject>

- (void)ledBoxHeartReturn:(uint8_t)onoffStatus withMac:(NSString *)mac;

@end

@interface D5LedBoxHeart : D5LedCmd

- (void)ledBoxHeart;

@end
