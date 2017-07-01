//
//  D5LedMusicSetModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

@protocol D5LedMusicSetModelDelegate <NSObject>

- (void)ledMusicSetModelReturn:(int64_t)result;

@end


@interface D5LedMusicSetModel : D5LedCmd

- (void)ledMusicSetModel:(LedMusicSetModelType)type;


@end
