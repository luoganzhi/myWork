//
//  D5TFTableViewCell.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/17.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5TFTableViewCell.h"
#import "D5TFMusicModel.h"

@interface D5TFTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end

@implementation D5TFTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTFMusic:(D5TFMusicModel *)TFMusic
{
    _TFMusic = TFMusic;
    self.nameLabel.text = TFMusic.name;
    self.selectedBtn.selected = TFMusic.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.TFMusic.selected = sender.selected;
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.checkBlock) {
        weakSelf.checkBlock();
    }
}

@end
