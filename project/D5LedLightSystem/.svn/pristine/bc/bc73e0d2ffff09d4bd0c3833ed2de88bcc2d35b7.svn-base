//
//  D5ConfigCell.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ConfigCell.h"
#import "D5EffectsModel.h"
#import "D5MusicModel.h"
#import "D5BaseListModel.h"

@interface D5ConfigCell()

@property (weak, nonatomic) IBOutlet UILabel *configLabel;
@end



@implementation D5ConfigCell

//- (void)setConfig:(D5MusicModel *)mus
//{
//    _config = config;
//    self.configLabel.text = [NSString stringWithFormat:@"%@-%@", config.name, config.user];
//}

//- (void)setMusicModel:(D5MusicModel *)musicModel
//{
//    _musicModel = musicModel;
//}

- (void)setCellWithMusicModel:(D5BaseListModel *)musicModel Index:(NSIndexPath *)index
{
    D5EffectsModel *model = musicModel.effectsList[index.row];
    
    
    if (model.type == LedEffectTypeCommon) {
        self.configLabel.text = [NSString stringWithFormat:@"%@-%@", musicModel.music.name, model.name];
    } else {
        self.configLabel.text = [NSString stringWithFormat:@"%@-%@", musicModel.music.name, model.author];
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
//    NSIndexPath *index = [self indexOfAccessibilityElement:<#(nonnull id)#>]
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
