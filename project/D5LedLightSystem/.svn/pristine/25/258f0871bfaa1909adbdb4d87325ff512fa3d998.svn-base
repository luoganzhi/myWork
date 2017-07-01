//
//  D5AddMusicListCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5MusicLibraryData.h"
//添加音乐主列表cell
#define AddMusicListIndentifer @"AddMusicListIndentifer"

typedef void (^DownloadMusic)(D5MusicLibraryData *downloadData);
@interface D5AddMusicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIButton *downLoad;
@property(weak,nonatomic)IBOutlet UIImageView*albumImageView;
@property(nonatomic,strong)D5MusicLibraryData *musicData;
@property(nonatomic)DownloadMusic downloadMusic;

- (void)setData:(D5MusicLibraryData *)data;

@end
