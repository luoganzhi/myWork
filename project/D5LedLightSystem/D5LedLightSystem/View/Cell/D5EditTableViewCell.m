//
//  D5EditTableViewCell.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5EditTableViewCell.h"
#import "D5MusicModel.h"
#import "UIImageView+WebCache.h"
#import "D5BaseListModel.h"
#import "D5BaseListModel.h"
#import "D5MusicListInstance.h"
#import "D5RuntimeShareInstance.h"
#import "D5RuntimeMusic.h"

@interface D5EditTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *playStatusImageView;
@end


@implementation D5EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.albumImageView.layer.cornerRadius = 20;
    self.albumImageView.layer.masksToBounds = YES;
    self.playStatusImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    D5MusicListInstance *listInstance = [D5MusicListInstance sharedInstance];
    
    if (listInstance.allMusicList && self.indexRow < listInstance.allMusicList.count) {
        D5BaseListModel *model = listInstance.allMusicList[self.indexRow];
//        DLog(@"allMusicList ==== %d",model.music.playStatus);
        
        
        if (model.music.musicID == [D5RuntimeShareInstance sharedInstance].music.musicId) {
            self.songLabel.textColor  = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:0 alpha:1];
            self.singerLabel.textColor  = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:0 alpha:1];
            self.playStatusImageView.hidden = NO;
        } else {
            self.songLabel.textColor  = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
            self.singerLabel.textColor  = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
            self.playStatusImageView.hidden = YES;
            
        }
    }

}

- (void)setMusicModel:(D5BaseListModel *)musicModel
{
    _musicModel = musicModel;
    self.songLabel.text = musicModel.music.name;
    self.checkButton.selected = musicModel.music.selected;
    
    if (![NSString isValidateString:musicModel.music.singerName] && ![NSString isValidateString:musicModel.music.albumName]) {
        self.singerLabel.text = @"未知";
    } else if (![NSString isValidateString:musicModel.music.singerName] && [NSString isValidateString:musicModel.music.albumName]) {
        self.singerLabel.text = musicModel.music.albumName;
    } else if ([NSString isValidateString:musicModel.music.singerName] && ![NSString isValidateString:musicModel.music.albumName]) {
        self.singerLabel.text = musicModel.music.singerName;
    } else if ([NSString isValidateString:musicModel.music.singerName] && [NSString isValidateString:musicModel.music.albumName]){
        self.singerLabel.text =  [NSString stringWithFormat:@"%@ - %@", musicModel.music.singerName, musicModel.music.albumName];
    }
    
    if (![NSString isValidateString:musicModel.music.albumName] || !musicModel.music.albumImgUrl) {
        self.albumImageView.image = [UIImage imageNamed:@"music_cover_default_tiny"];
    } else {
        __weak D5EditTableViewCell *weakSelf = self;
        [weakSelf.albumImageView sd_setImageWithURL:[NSURL D5UrlWithString:musicModel.music.albumImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                        weakSelf.albumImageView.image = image;
                } else {
                        weakSelf.albumImageView.image = [UIImage imageNamed:@"music_cover_default_tiny"];
                }
        }];
    }
}

- (IBAction)checkBtnClick:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;
    self.musicModel.music.selected = self.checkButton.selected;
    if (self.checkBlock) {
        self.checkBlock();
    }
}

@end
