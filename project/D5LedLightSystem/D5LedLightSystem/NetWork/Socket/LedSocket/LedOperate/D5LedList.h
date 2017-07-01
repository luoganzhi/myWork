//
//  D5LedList.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedCmd.h"

#define LED_LIST_TYPE @"type"
#define LED_LIST_DATA @"data"

@protocol D5LedListDelegate <NSObject>

- (void)ledListReturn:(NSDictionary *)listInfos;

@end

@interface D5LedList : D5LedCmd

- (void)ledList:(LedListType)type;

@end
