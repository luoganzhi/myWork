//
//  D5AddMusicListCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5AddMusicListCell.h"
#import "UIImageView+WebCache.h"

@interface D5AddMusicListCell() {
    NSTimeInterval interval;
}

@end

@implementation D5AddMusicListCell

- (IBAction)downLoadMusic:(UIButton *)sender {

//    if ([self showTips]) {
//        
//        return;
//    }
    if(_musicData.isNOPermitDownload){
        [iToast showButtomTitile:@"正在下载到中控"];
        return;
    }
   
    _downloadMusic(_musicData);

}

- (void)setData:(D5MusicLibraryData *)data {
    @autoreleasepool {
        _musicData = data;
        
        self.musicNameLabel.text = data.musicName;
        if ([NSString isValidateString:data.album]) {
            self.singerLabel.text  =  [NSString stringWithFormat:@"%@ - %@",data.musicSinger,data.album];
        }else{
            self.singerLabel.text  =  [NSString stringWithFormat:@"%@",data.musicSinger];
        }
       
        [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:data.albumURL] placeholderImage:IMAGE(@"music_cover_default_tiny")];
        //头像圆角
        [self.albumImageView setBtnFillet];
        //下载状态设置
        UIImage* downloadImage = (!data.isNOPermitDownload) ? IMAGE(@"music_icon_download1") : IMAGE(@"music_icon_download2");
        [self.downLoad setImage:downloadImage forState:UIControlStateNormal];
    }
}

-(BOOL)showTips
{
    if ([[NSDate date]timeIntervalSince1970]-interval<=1) {
        return YES;
    }
    else
    {
        interval=[[NSDate date]timeIntervalSince1970];
       
        return NO;
    }
}

@end