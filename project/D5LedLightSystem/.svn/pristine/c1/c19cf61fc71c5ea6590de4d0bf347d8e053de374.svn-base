//
//  D5RearchMusicResultCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5MusicLibraryData.h"
#define RearchMusicResult @"RearchMusicResult"

typedef void(^DownLoadMusicToCentreBox)(D5MusicLibraryData*data);


@interface D5RearchMusicResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songsName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property(strong,nonatomic)D5MusicLibraryData*selectData;
@property(copy,nonatomic)DownLoadMusicToCentreBox downLoadMusic;
@property (weak, nonatomic) IBOutlet UIButton *downloadMusicBtn;

@end
