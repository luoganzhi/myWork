//
//  D5SearchKeyworldsCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/2.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SearchKeyworldsCell.h"

#import "D5MusicSpecialCell.h"
@implementation D5SearchKeyworldsCell

-(void)awakeFromNib
{
    [super awakeFromNib];

}

//选择单首歌曲
- (IBAction)selecteSong:(UIButton*)sender {
    [sender setSelected:!sender.selected];

}

//上传音乐到中控
- (IBAction)uploadMusicToCentereBox:(id)sender {
}


//设置数据
- (void)setData:(D5MusicLibraryData *)data editStatus:(MusicStatus)status
{
    if (status==MusicStatusSelected) {
        
        
    }
    [self.selectSong setHidden:(status==MusicStatusSelected) ? NO:YES];
    [self.selectSong setSelected:(status==MusicStatusSelected) ? YES:NO];
  
    

}
@end
