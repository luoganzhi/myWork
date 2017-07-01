//
//  D5MusicLibraryCell.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/11.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5MusicLibraryData;
@class D5MusicSpecialData;

typedef enum _music_library_status {
    MusicLibraryStatusUnEdit,
    MusicLibraryStatusEdit,
}MusicLibraryStatus;

typedef enum _music_library_type {
    MusicLibraryTypeServer,
    MusicLibraryTypeLocal
}MusicLibraryType;


#define MUSIC_LIBRARY_CELL_ID @"MUSIC_LIBRARY_CELL"

#define BTN_CONFIG_START_TAG 1000
#define BTN_CHECK_START_TAG 10000

typedef void(^SpecialCellSelectedBlock)(D5MusicSpecialData *specialData, D5MusicLibraryData *libraryData);

typedef void(^UploadMusic)(NSInteger type,NSInteger row);

@interface D5MusicLibraryCell : UITableViewCell

@property (nonatomic, strong) SpecialCellSelectedBlock selectedBlock;
@property(nonatomic,copy)UploadMusic uploadMusic;

@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnConfigList;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicNameSinger;
@property (weak, nonatomic) IBOutlet UILabel *musicConfigDJ;
@property (weak, nonatomic) IBOutlet UITableView *musicSpecialTableView;
@property (nonatomic, strong) D5MusicLibraryData *musicData;
/**
 *  设置self中的控件的值
 *
 *  @param data
 *  @param status 编辑状态/非编辑状态
 *  @param type 本地歌曲/音乐馆
 */
- (void)setData:(D5MusicLibraryData *)data editStatus:(MusicLibraryStatus)status type:(MusicLibraryType)type isAllSelect:(BOOL)isAllSelect;
@end
