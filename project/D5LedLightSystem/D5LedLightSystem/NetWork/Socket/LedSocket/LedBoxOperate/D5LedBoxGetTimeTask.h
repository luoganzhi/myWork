//
//  D5LedBoxGetTimeTask.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBoxGetTimeTaskDelegate <NSObject>

- (void)ledBoxGetTimeTaskReturn:(NSArray *)tasks;

@end

@interface D5LedBoxGetTimeTask : D5LedCmd

- (void)ledBoxGetTimeTask;

@end
