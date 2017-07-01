//
//  D5MusicCell.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicCell.h"
#import "D5MusicModel.h"
#import "UIImageView+WebCache.h"
@interface D5MusicCell()
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playTagImageView;

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;


@end


@implementation D5MusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.albumImageView.layer.cornerRadius = 19;
    self.albumImageView.layer.masksToBounds = YES;
}

- (void)setIndex:(NSIndexPath *)index
{
    _index = index;
    // 设置cell的背景色
    if (index.row % 2 == 0) {
        self.backgroundColor = [UIColor colorWithRed:37/225.f green:39/255.f blue:40/255.f alpha:1];
    } else {
        self.backgroundColor = [UIColor colorWithRed:25/255.0 green:26/255.0 blue:27/255.0 alpha:1];
    }

}

- (void)setMusicModel:(D5MusicModel *)musicModel
{
    _musicModel = musicModel;
    
    self.songLabel.text = musicModel.name;
    
    if (([musicModel.singerName isEqualToString:@""] || !musicModel.singerName)&& ([musicModel.albumName isEqualToString:@""] || !musicModel.albumName)) {
        self.singerLabel.text = @"未知";
    } else if (([musicModel.singerName isEqualToString:@""] || !musicModel.singerName)&& (![musicModel.albumName isEqualToString:@""] || musicModel.albumName)) {
        self.singerLabel.text = musicModel.albumName;
    } else if ((![musicModel.singerName isEqualToString:@""] || musicModel.singerName)&& ([musicModel.albumName isEqualToString:@""] || !musicModel.albumName)) {
        self.singerLabel.text = musicModel.singerName;
    } else if ((![musicModel.singerName isEqualToString:@""] || musicModel.singerName)&& (![musicModel.albumName isEqualToString:@""] || musicModel.albumName)){
        self.singerLabel.text =  [NSString stringWithFormat:@"%@ - %@", musicModel.singerName, musicModel.albumName];
    }
    DLog(@"%@   url = %@", musicModel.name , musicModel.albumImgUrl);
    
    if ([musicModel.albumImgUrl isEqualToString:@""]) {
        self.albumImageView.image = [UIImage imageNamed:@"music_cover_default_tiny"];
    } else {
        
        
        [self.albumImageView sd_setImageWithURL:[NSURL D5UrlWithString:musicModel.albumImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.albumImageView.image = image;
        }];
        

        
    }
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    if (selected) {
    self.songLabel.textColor  = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:0 alpha:1];
    self.singerLabel.textColor  = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:0 alpha:1];
        self.playTagImageView.hidden = NO;
    } else {
        self.songLabel.textColor  = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
        self.singerLabel.textColor  = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        self.playTagImageView.hidden = YES;
    }


    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor blackColor];
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    
}

- (IBAction)configBtnClick:(id)sender {
    if (self.configBlock) {
        self.configBlock();
    }
}

@end
