//
//  D5LedOtherAllStatus.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/10/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedOtherAllStatusDelegate <NSObject>

- (void)ledOtherAllStatusReturn:(LedOtherAllStatus)allStatus;

@end


@interface D5LedOtherAllStatus : D5LedCmd

- (void)ledOtherAllStatus;

@end
