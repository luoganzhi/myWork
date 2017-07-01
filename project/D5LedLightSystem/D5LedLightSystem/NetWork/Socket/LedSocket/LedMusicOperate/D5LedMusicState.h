//
//  D5LedMusicState.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/24.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedMusicStateDelegate <NSObject>

- (void)ledMusicStateReturn:(NSDictionary *)musicStates;

@end


@interface D5LedMusicState : D5LedCmd

- (void)ledMusicState;

@end
