//
//  D5LocalMusicListCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LocalMusicListCell.h"

@implementation D5LocalMusicListCell
-(void)awakeFromNib
{
    [super awakeFromNib];
//    [_aibumImageBt setSelected:YES];

}

- (IBAction)selectMusic:(UIButton*)sender {

//    [sender setSelected:!sender.selected];
//    _selectMusic(sender.selected,self.data);
    
}

- (void)setData:(D5MusicLibraryData *)data {
    @autoreleasepool {
        _data = data;
        
        _musicName.text = data.musicName;
        _musicSinger.text = [NSString stringWithFormat:@"%@-%@", data.musicSinger, data.album];
        
        if (data.albumImage.size.width > 0) {
            [_albumImage setImage:data.albumImage];
        } else {
            [_albumImage setImage:IMAGE(@"music_cover_default_tiny")];
        }
        
        [_albumImage setBtnFillet];
        _aibumImageBt.selected = data.isSelected;
    }
}

@end
