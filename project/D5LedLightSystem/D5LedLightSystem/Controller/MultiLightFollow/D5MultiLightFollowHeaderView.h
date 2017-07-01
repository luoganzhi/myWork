//
//  D5MultiLightFollowHeaderView.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5MultiLightFollowBoxData;

#define PRIMARY_BOX_BG_COLOR [UIColor colorWithHex:0xF19149 alpha:0.5f] //主中控背景颜色
#define SUBORDINATE_BOX_BG_COLOR [UIColor colorWithHex:0x4C8124 alpha:0.5f] //从中控背景颜色

#define PRIMARY_BOX_TAG_IMAGE [UIImage imageNamed:@"icon_tip_main"]
#define SUBORDINATE_BOX_TAG_IMAGE [UIImage imageNamed:@"icon_tip_other"]

#define PRIMARY_TAG_STR @"主"
#define SUBORDINATE_TAG_STR @"从"

@interface D5MultiLightFollowHeaderView : UIView

+ (D5MultiLightFollowHeaderView *)sharedHeaderView;
- (void)setData:(D5MultiLightFollowBoxData *)data;

@end
