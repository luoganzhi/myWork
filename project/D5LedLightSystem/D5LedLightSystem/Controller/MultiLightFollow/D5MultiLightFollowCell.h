//
//  D5MultiLightFollowCell.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/24.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5MultiLightFollowBoxData;

#define MULTILIGHT_FOLLOW_CELL_ID @"MULTILIGHT_FOLLOW_CELL"

@interface D5MultiLightFollowCell : UITableViewCell

- (void)setData:(D5MultiLightFollowBoxData *)boxData;

@end
