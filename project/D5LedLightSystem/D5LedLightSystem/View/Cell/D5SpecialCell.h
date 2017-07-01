//
//  D5SpecialCell.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/3.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5MusicSpecialData.h"

#define SPECIAL_CELL_ID @"SPECIAL_CELL"

@interface D5SpecialCell : UITableViewCell

- (void)setData:(D5MusicSpecialData *)data;

/** 预览block */
@property (nonatomic, copy) void(^lookBlock)();

@end
