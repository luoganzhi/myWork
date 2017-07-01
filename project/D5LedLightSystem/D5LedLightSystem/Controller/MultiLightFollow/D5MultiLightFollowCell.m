//
//  D5MultiLightFollowCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/24.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MultiLightFollowCell.h"
#import "D5MultiLightFollowHeaderView.h"
#import "D5MultiLightFollowBoxData.h"

#define OFFLINE_BOX_BG_COLOR [UIColor colorWithHex:0x333333 alpha:1] //离线中控背景颜色
#define OFFLINE_BOX_TEXT_COLOR [UIColor colorWithHex:0xB3B3B3 alpha:1] //离线中控字体颜色

#define ONLINE_BOX_ICON_IMAGE [UIImage imageNamed:@"box_white"]
#define OFFLINE_BOX_ICON_IMAGE [UIImage imageNamed:@"box_gray"]

@interface D5MultiLightFollowCell ()

/*中间view -- 根据状态改变背景颜色*/
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewLeftMargin;

/*主从中控的标示*/
@property (weak, nonatomic) IBOutlet UIImageView *boxTagImgView;
@property (weak, nonatomic) IBOutlet UILabel *boxTagLabel;

/*中控图标*/
@property (weak, nonatomic) IBOutlet UIImageView *boxImgView;

/*中控名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/*mac地址*/
@property (weak, nonatomic) IBOutlet UILabel *macTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;

/*离线label*/
@property (weak, nonatomic) IBOutlet UILabel *offlineLabel;

@end

@implementation D5MultiLightFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setData:(D5MultiLightFollowBoxData *)boxData {
    @autoreleasepool {
        BOOL isPrimaryBox = (boxData.boxTag == LedBoxTagPrimary);//是否主中控
        
        BOOL isOnline = (boxData.onoffStatus != LedBoxOnOffStatusOffline); //是否在线
        _centerView.backgroundColor = isOnline ? (isPrimaryBox ? PRIMARY_BOX_BG_COLOR : SUBORDINATE_BOX_BG_COLOR) : OFFLINE_BOX_BG_COLOR;
        _boxImgView.image = isOnline ? ONLINE_BOX_ICON_IMAGE : OFFLINE_BOX_ICON_IMAGE;
        
        _macTitleLabel.textColor = isOnline ? WHITE_COLOR : OFFLINE_BOX_TEXT_COLOR;
        _nameLabel.textColor = isOnline ? WHITE_COLOR : OFFLINE_BOX_TEXT_COLOR;
        _macLabel.textColor = isOnline ? WHITE_COLOR : OFFLINE_BOX_TEXT_COLOR;
        
        _macLabel.text = boxData.mac;
        _nameLabel.text = boxData.name;
        
        _offlineLabel.hidden = isOnline;
        
        _boxTagLabel.text = isPrimaryBox ? PRIMARY_TAG_STR : SUBORDINATE_TAG_STR;
        _boxTagImgView.image = isPrimaryBox ? PRIMARY_BOX_TAG_IMAGE : SUBORDINATE_BOX_TAG_IMAGE;
    }
}

@end
