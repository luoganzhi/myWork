//
//  D5MusicLibraryCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/11.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicLibraryCell.h"
#import "D5MusicLibraryData.h"
#import "D5MusicSpecialCell.h"
#import "UIImage+GIF.h"

#define BTN_CHECK_WIDHT 17
#define BTN_CHECK_TRAIL_MARGIN 8
#define BTN_CONFIGLIST_LEFT_MARGIN 8
#define BTN_CONFIGLIST_WIDHT 18

@interface D5MusicLibraryCell() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCheckTrailMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCheckWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConfigListLeftMargin;

@property (weak, nonatomic) IBOutlet UIImageView *specialImgView;


@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@end

@implementation D5MusicLibraryCell

#pragma mark --交互
-(void)uploadLoaclMusic
{
    self.uploadMusic(MusicLibraryTypeLocal,self.btnConfigList.tag);

}


#pragma mark - 设置data
- (void)setData:(D5MusicLibraryData *)data editStatus:(MusicLibraryStatus)status type:(MusicLibraryType)type isAllSelect:(BOOL)isAllSelect {
    @autoreleasepool {
        BOOL isEditing = (status == MusicLibraryStatusEdit);
        if (isEditing) {
            data.isShow = NO;
        }
        
        if (type==MusicLibraryTypeLocal) {
            
            [_btnConfigList addTarget:self action:@selector(uploadLoaclMusic) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        _musicData = data;
        [_musicData setData:data];
        
        
        _gifImageView.hidden = YES;
        _specialImgView.hidden = isEditing;
        
        if (!isEditing) {
            NSArray *arr = self.musicData.musicSpecialDatas;
            if (arr && arr.count > 0) {
                _specialImgView.image = [UIImage imageNamed:@"music_library_special"];
            } else {
                _specialImgView.image = [UIImage imageNamed:@"music_default_special"];
            }
            
            //将图片转为NSData数据
            NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"play_special_gif" ofType:@"gif"]];
            _gifImageView.image = [UIImage sd_animatedGIFWithData:localData];
        }
        
        _btnCheck.hidden = !isEditing;
        _btnCheckWidth.constant = isEditing ? BTN_CHECK_WIDHT : 0;
        _btnCheckTrailMargin.constant = isEditing ? BTN_CHECK_TRAIL_MARGIN : 0;
        _btnConfigList.hidden = isEditing;
        _btnConfigListLeftMargin.constant = isEditing ? 0 : BTN_CONFIGLIST_LEFT_MARGIN;
        
        if (isEditing && isAllSelect) { //编辑状态下全选
            _btnCheck.selected = YES;
        }
        
        _musicNameLabel.text = data.musicName;
        _musicNameSinger.text =[NSString stringWithFormat:@"%@.%@",data.musicSinger,data.album];
        _musicConfigDJ.text = data.musicConfigDJ;
    }
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.musicData && self.musicData.musicSpecialDatas) {
        return self.musicData.musicSpecialDatas.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5MusicSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:MUSIC_SPECIAL_CELL_ID];
        if (!cell) {
            cell = [[D5MusicSpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MUSIC_SPECIAL_CELL_ID];
        }
        
        NSInteger row = indexPath.row;
        NSArray *datas = self.musicData.musicSpecialDatas;
        if (datas && row < datas.count) {
            D5MusicSpecialData *data = [datas objectAtIndex:row];
            [cell setData:data];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.selectedBlock) {
        return;
    }
    
    NSInteger row = indexPath.row;
    NSArray *datas = self.musicData.musicSpecialDatas;
    if (datas && row < datas.count) {
        D5MusicSpecialData *data = [datas objectAtIndex:row];
        self.selectedBlock(data, self.musicData);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.gifImageView.hidden = NO;
    } else {
        self.gifImageView.hidden = YES;
        
    }
    
    
}

@end
