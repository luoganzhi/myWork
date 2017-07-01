//
//  D5D5LedMusicDelete.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/24.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedMusicDeleteDelegate <NSObject>

- (void)ledMusicDeleteReturn:(int64_t)result;

@end


@interface D5LedMusicDelete : D5LedCmd

- (void)ledMusicDelete:(NSArray *)musicIds;

@end
