//
//  D5ZKTAddCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/2.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ZKTAddCell.h"
#import "D5LedZKTBoxData.h"

@interface D5ZKTAddCell()

@property (weak, nonatomic) IBOutlet UILabel *zktNameLabel;

@end

@implementation D5ZKTAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(D5LedZKTBoxData *)data {
    @autoreleasepool {
        _zktNameLabel.text = data.boxName;
    }
}

@end
