//
//  D5LedBrightnessSingle.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedBrightnessSingleDelegate <NSObject>

- (void)ledBrightnessSingleReturn:(int64_t)status;

@end

@interface D5LedBrightnessSingle : D5LedCmd

- (void)ledBrightnessSingle:(NSArray *)brightnesses;

@end
