//
//  D5HJMusicDownloadEditCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5HJMusicDownloadEditCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Helper.h"
@implementation D5HJMusicDownloadEditCell
- (IBAction)selectEdit:(UIButton*)sender {
    _selectEdit(!sender.selected,_musicID);
//    [sender setSelected:!sender.selected];
}

-(void)setUIforMusicData:(D5HJMusicDownloadManageModel *)data{

    _musicID = data.musicID;
    self.musicNameLable.text = data.musicName;
    self.musicSingerLable.text  =  [NSString stringWithFormat:@"%@ - %@",data.singer,data.albumTitle];
    [self.abulmImage sd_setImageWithURL:[NSURL URLWithString:data.albumURL] placeholderImage:IMAGE(@"music_cover_default_tiny")];
    //头像圆角
    [self.abulmImage setBtnFillet];
    [_selcteStatus setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    [_selcteStatus setSelected:(data.editSelcteType == Edit_Select) ? YES:NO];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
