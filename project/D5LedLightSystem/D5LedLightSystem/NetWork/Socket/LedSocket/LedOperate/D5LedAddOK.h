//
//  D5LedAddOK.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedAddOKDelegate <NSObject>

- (void)ledAddOKReturn:(int64_t)status;

@end

@interface D5LedAddOK : D5LedCmd

- (void)ledAddOK;

@end
