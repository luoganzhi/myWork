//
//  D5MusicSpecialCell.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5MusicSpecialData;

#define MUSIC_SPECIAL_CELL_ID @"MUSIC_SPECIAL_CELL"

@interface D5MusicSpecialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialDJLabel;

/**
 *  设置控件中的值
 *
 *  @param specialData 
 */
- (void)setData:(D5MusicSpecialData *)specialData;

@end
