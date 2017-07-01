//
//  D5LedRGBSingle.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedRGBSingleDelegate <NSObject>

- (void)ledRGBSingleReturn:(int64_t)status index:(int8_t)sn;

@end

@interface D5LedRGBSingle : D5LedCmd

- (void)ledRGBSingle:(NSArray *)rgbs;

@end
