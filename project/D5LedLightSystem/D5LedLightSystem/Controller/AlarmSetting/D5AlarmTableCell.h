//
//  D5AlarmTableCell.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5AlarmData;

#define ALARM_CELL_ID @"ALARM_CELL"

#define WEEK_DAYS_REPEAT 62
#define EVERY_DAY_REPEAT 0xfe

@interface D5AlarmTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnSelected;

- (void)setData:(D5AlarmData *)data isEdit:(BOOL)isEdit delegate:(id<D5LedCmdDelegate, D5LedNetWorkErrorDelegate>)delegate;

@end
