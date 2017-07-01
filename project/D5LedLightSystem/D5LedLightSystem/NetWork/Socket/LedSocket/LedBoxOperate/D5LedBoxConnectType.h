//
//  D5LedBoxConnectType.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/2.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBoxConnectTypeCodeDelegate <NSObject>

- (void)ledBoxConnectTypeReturn:(uint8_t)type;

@end


@interface D5LedBoxConnectType : D5LedCmd

- (void)ledBoxConnectType;

@end
