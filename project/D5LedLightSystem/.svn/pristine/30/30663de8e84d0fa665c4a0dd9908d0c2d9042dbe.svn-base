//
//  D5LocalMusicListCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//


//本地音乐列表cell
#import <UIKit/UIKit.h>
#import "D5MusicLibraryData.h"
#define LocalMusicListCell  @"LocalMusicListCell"
typedef void (^SelectMusic)(BOOL selected,D5MusicLibraryData *data);
@interface D5LocalMusicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UIButton *aibumImageBt;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *musicSinger;
@property(strong,nonatomic)D5MusicLibraryData *data;
@property(nonatomic,copy)SelectMusic selectMusic;

- (void)setData:(D5MusicLibraryData *)data;

@end
