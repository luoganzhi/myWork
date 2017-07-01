//
//  D5SearchKeyworldsCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/2.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5MusicLibraryData.h"
typedef enum _music_library_status {
    MusicStatusUnSelected=1,
    MusicStatusSelected,
}MusicStatus;


#define SearchKeyworldIndentifer @"D5SearchKeyworldsCell"
@interface D5SearchKeyworldsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UIButton *upload;
@property (weak, nonatomic) IBOutlet UIButton *selectSong;

@property (strong, nonatomic)D5MusicLibraryData *musicLibraryData;
- (void)setData:(D5MusicLibraryData *)data editStatus:(MusicStatus)status;
@end
