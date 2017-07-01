//
//  D5LedAdd.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedAddDelegate <NSObject>

- (void)ledAddReturn:(int64_t)status;

@end

@interface D5LedAdd : D5LedCmd

- (void)ledAdd:(LedAddType)type;

@end
