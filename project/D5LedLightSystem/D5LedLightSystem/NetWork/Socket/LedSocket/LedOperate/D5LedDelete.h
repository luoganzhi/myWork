//
//  D5LedDelete.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedDeleteDelegate <NSObject>

- (void)ledDeleteReturn:(int64_t)status;

@end

@interface D5LedDelete : D5LedCmd

- (void)ledDelete:(NSArray *)deleteInfos;

@end
