//
//  D5HJMusicDownloadListCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5HJMusicDownloadListCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Helper.h"
@implementation D5HJMusicDownloadListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDownLoadMusicCellUI:(D5HJMusicDownloadManageModel *)data {
    
    self.musicNameLable.text = data.musicName;
    self.musicSingerLable.text  =  [NSString stringWithFormat:@"%@ - %@",data.singer,data.albumTitle];
    [self.abulmImage sd_setImageWithURL:[NSURL URLWithString:data.albumURL] placeholderImage:IMAGE(@"music_cover_default_tiny")];
    //头像圆角
    [self.abulmImage setBtnFillet];
    UpdateDownloadStatus status = data.downloadStatus;

    if (status == UpdateDownloadStatusReady) {
        
      [self.downStatusImage setImage:IMAGE(@"music_icon_wait") forState:UIControlStateNormal];
      [self.downStatusImage setHidden:NO];
      [self.progressLable setHidden:YES];
        
    }else //if (status == UpdateDownloadStatusIng)
    {
        [self.progressLable setText:[NSString stringWithFormat:@"%d%%",(int)data.progress]];
        [self.downStatusImage setHidden:YES];
        [self.progressLable setHidden:NO];
        
    }
  
    
}

@end
