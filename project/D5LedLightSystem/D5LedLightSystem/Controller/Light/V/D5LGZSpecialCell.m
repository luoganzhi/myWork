//
//  D5LGZSpecialCell.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/9/26.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LGZSpecialCell.h"
#import "D5EffectsModel.h"
#import "D5RuntimeShareInstance.h"
@interface D5LGZSpecialCell()


@property (weak, nonatomic) IBOutlet UILabel *configNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *configUserLabel;

@end


@implementation D5LGZSpecialCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (IBAction)configBtnClick:(UIButton *)sender {
    D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
    
    if (![D5LedList sharedInstance].addedLedList || [D5LedList sharedInstance].addedLedList.count <= 0) {
        [MBProgressHUD showMessage:@"请在 “设置-灯组管理”中添加新灯"];
        return;
    }

    if (instance.lampStatus != LedOnOffStatusOn) { // 如果灯关闭
        [MBProgressHUD showMessage:@"请开灯或检查灯是否正确安装"];
        return;
    }

    self.configPlayBtn.selected = !self.configPlayBtn.selected;
    
    
    if (self.configPlayBtn.selected) {
        self.configNameLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:0 alpha:1];
        self.configUserLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:0 alpha:1];
        self.playSpecialBlock();
        
        [self setSelected:YES animated:NO];
    } else {
        self.configNameLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        self.configUserLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
        self.pauseSpecialBlock();
        
         [self setSelected:NO animated:NO];
    
    }

    
}

- (void)setSpecialConfig:(D5EffectsModel *)specialConfig
{
    _specialConfig = specialConfig;
    self.configNameLabel.text = specialConfig.name;
    self.configUserLabel.text = specialConfig.author;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.configPlayBtn.selected) {
        self.configNameLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:0 alpha:1];
        self.configUserLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:0 alpha:1];
    } else {
        self.configNameLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        self.configUserLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];

    }

}


@end
