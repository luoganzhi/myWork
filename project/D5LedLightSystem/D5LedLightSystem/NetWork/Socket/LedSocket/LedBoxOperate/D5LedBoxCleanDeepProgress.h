//
//  D5LedBoxCleanDeepProgress.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBoxCleanDeepProgressDelegate <NSObject>

- (void)ledBoxCleanDeepProgressReturn:(uint8_t)progress;

@end

@interface D5LedBoxCleanDeepProgress : D5LedCmd

- (void)ledBoxCleanDeepProgress;

@end
