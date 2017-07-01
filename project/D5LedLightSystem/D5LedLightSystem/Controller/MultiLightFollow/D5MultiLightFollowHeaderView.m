//
//  D5MultiLightFollowHeaderView.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MultiLightFollowHeaderView.h"
#import "D5MultiLightFollowBoxData.h"

#define HEADER_VIEW_XIB @"MultiLightFollowHeader"

static D5MultiLightFollowHeaderView *instance = nil;

@interface D5MultiLightFollowHeaderView()

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation D5MultiLightFollowHeaderView

+ (instancetype)sharedHeaderView {
    @autoreleasepool {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[[NSBundle mainBundle] loadNibNamed:HEADER_VIEW_XIB owner:self options:nil] firstObject];
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            instance.frame = CGRectMake(0, 0, screenSize.width, 130.0f);
        });
        return instance;
    }
}

- (void)setData:(D5MultiLightFollowBoxData *)data {
    @autoreleasepool {
        BOOL isPrimaryBox = (data.boxTag == LedBoxTagPrimary);
        _centerView.backgroundColor = isPrimaryBox ? PRIMARY_BOX_BG_COLOR : SUBORDINATE_BOX_BG_COLOR;
        _tagLabel.text = isPrimaryBox ? PRIMARY_TAG_STR : SUBORDINATE_TAG_STR; //主/从
        _tagImgView.image = isPrimaryBox ? PRIMARY_BOX_TAG_IMAGE : SUBORDINATE_BOX_TAG_IMAGE;
        
        _macLabel.text = data.mac;
        _nameLabel.text = data.name;
    }
}
@end
