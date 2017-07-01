//
//  D5EditMusicViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5EditMusicViewController.h"
#import "D5EditTableViewCell.h"
#import "D5MusicListModel.h"
#import "D5MusicModel.h"
#import "MBProgressHUD.h"
#import "D5BaseListModel.h"
#import "D5MusicListInstance.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "D5RuntimeShareInstance.h"
#import "D5RuntimeMusic.h"


#define listInstance [D5MusicListInstance sharedInstance]


#define CANCEL_ALL_SELECT @"全不选"
#define ALL_SELECT @"全选"


@interface D5EditMusicViewController () <UITableViewDataSource, UITableViewDelegate, D5LedCmdDelegate, D5LedNetWorkErrorDelegate>
@property (weak, nonatomic) IBOutlet UITableView *editMusicTabelView;
@property (weak, nonatomic) IBOutlet UIButton *selectedAllBtn;

/** musicIDs */
@property (nonatomic, strong) NSMutableArray *musicIds;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
/** musicListModel */
@property (nonatomic, strong) D5MusicListModel *musicListModel;

/** runLedCmd */
@property (nonatomic, strong) D5LedSpecialCmd *runLedCmd;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation D5EditMusicViewController

- (NSMutableArray *)musicIds
{
    if (!_musicIds) {
        _musicIds = [NSMutableArray array];
    }
    return _musicIds;
}

- (D5LedSpecialCmd *)runLedCmd {
    if (!_runLedCmd) {
        _runLedCmd = [[D5LedSpecialCmd alloc] init];
        _runLedCmd.remoteLocalTag = tag_remote;
        _runLedCmd.errorDelegate = self;
        _runLedCmd.receiveDelegate = self;
        
        _runLedCmd.cmdType = SpecialCmdTypePush;
    }
    
    _runLedCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    _runLedCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    _runLedCmd.remoteIp = [D5CurrentBox currentBoxIP];
    return _runLedCmd;
}



#pragma mark - 删除歌曲回调
- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    @autoreleasepool {
        __weak D5EditMusicViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.editMusicTabelView.mj_footer endRefreshing];
        });
        if (errorType == D5SocketErrorCodeTypeTimeOut) {
            //DLog(@"删除歌曲超时");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }
        
    }
}

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict
{
    if (header->cmd == Cmd_Media_Operate && header->subCmd == SubCmd_Music_List) {
        __weak D5EditMusicViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.editMusicTabelView.mj_header endRefreshing];
            
            
            NSDictionary *data = dict[LED_STR_DATA];
            weakSelf.musicListModel = [D5MusicListModel mj_objectWithKeyValues:data];
            
            listInstance.pageNum = weakSelf.musicListModel.pageNum;
            listInstance.totalNum = weakSelf.musicListModel.totalNum;
            
            
            
            if (![listInstance.allMusicList containsObject:weakSelf.musicListModel.musicList]) {
                [listInstance.allMusicList addObjectsFromArray:weakSelf.musicListModel.musicList];
                
            }
            
            if (listInstance.pageNum + 1 < listInstance.totalNum) { //如果还有数据就只是停止刷新
                [weakSelf.editMusicTabelView.mj_footer endRefreshing];
            } else {  // 如果没有数据就提示没有数据了
                [weakSelf.editMusicTabelView.mj_footer endRefreshingWithNoMoreData];
            }
            
         
            
            
            if ([self.selectedAllBtn.currentTitle isEqualToString:CANCEL_ALL_SELECT]) {
                for (D5BaseListModel *model in listInstance.allMusicList) {
                    model.music.selected = YES;
                }
            }
            
            [weakSelf.editMusicTabelView reloadData];
            [weakSelf runtimeInfoChang];

            
        });

    }
    __weak D5EditMusicViewController *weakSelf = self;
    if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Delete_Music) { // 删除命令
        dispatch_async(dispatch_get_main_queue(), ^{
            int code = [dict[LED_STR_CODE] intValue];
            if (code == LedCodeSuccess) { // 删除成功
                [[D5RuntimeShareInstance sharedInstance] clear];
                [MBProgressHUD showSuccess:@"删除成功"];
                
                if (weakSelf.deleteBlock) {
                    weakSelf.deleteBlock();
                }

                
               
            } else {
                [MBProgressHUD showError:@"删除失败"];
            }
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 导航栏设置
    [self setNavigationBarHidden:YES];
    [self setNavigationBarTranslucent];
    [self setStatusBarStyle:UIBarStyleDefault];
    [self setHeader];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runtimeInfoChang) name:Runtime_Info_Update object:nil];
    self.selectedAllBtn.adjustsImageWhenHighlighted = NO;
    
    if (listInstance.pageNum + 1 < listInstance.totalNum) { //如果还有数据就只是停止刷新
        [self.editMusicTabelView.mj_footer endRefreshing];
    } else {  // 如果没有数据就提示没有数据了
        [self.editMusicTabelView.mj_footer endRefreshingWithNoMoreData];
    }

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    // 获取运行时状态
    [self.runLedCmd ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Runtime_Info];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.editMusicTabelView scrollToRowAtIndexPath:self.index atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    NSInteger selectedNumber = 0;
    
    for (D5BaseListModel *model in listInstance.allMusicList) {
        if (model.music.selected == YES) {
            selectedNumber = selectedNumber + 1;
        }
        
        if (listInstance.allMusicList.count == selectedNumber) {
            [self.selectedAllBtn setTitle:CANCEL_ALL_SELECT forState:UIControlStateNormal];
        } else {
            [self.selectedAllBtn setTitle:ALL_SELECT forState:UIControlStateNormal];
        }
    }

}

// 设置header
- (void)setHeader
{
    
    // 设置上拉
    [self addTableviewFooter];
    

    
}



- (void)footerUpdateMusic
{
    if (listInstance.totalNum > listInstance.pageNum) {
        listInstance.currentIndex++;
    } else {
        [self.editMusicTabelView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    [self getMusic:(listInstance.currentIndex)];
    
    
}

- (void)getMusic:(int32_t)index
{
    
    NSDictionary *dict = @{LED_STR_PAGENUM: @(index),
                           LED_STR_PAGESIZE: @(20)
                           };
    
    D5LedNormalCmd *ledCmd = [[D5LedNormalCmd alloc] init];
    ledCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    ledCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    ledCmd.remoteLocalTag = tag_remote;
    ledCmd.remoteIp = [D5CurrentBox currentBoxIP];
    ledCmd.errorDelegate = self;
    ledCmd.receiveDelegate = self;
    
    
    [ledCmd ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Music_List withData:dict];
}



- (IBAction)cancleClick:(id)sender {
    self.deleteView.hidden = YES;
}

// 取消按钮
- (IBAction)cancleBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (IBAction)selectAllBtnClick:(UIButton *)sender {
    
    // 按钮全选与全不选设置
    if ([sender.currentTitle isEqualToString:ALL_SELECT]) {
        for (D5BaseListModel *model in listInstance.allMusicList) {
            model.music.selected = YES;
        }
        [self setBtnTitle:CANCEL_ALL_SELECT forBtn:sender];
        self.totalLabel.text = [NSString stringWithFormat:@"已选择%d首歌", listInstance.totalSize];

    } else if ([sender.currentTitle isEqualToString:CANCEL_ALL_SELECT]) {
        for (D5BaseListModel *model in listInstance.allMusicList) {
            model.music.selected = NO;
        }
        [self setBtnTitle:ALL_SELECT forBtn:sender];
        
        self.totalLabel.text = [NSString stringWithFormat:@"已选择0首歌"];
    }
    
    [self setBtnEnable:self.deleteBtn enable:[sender.currentTitle isEqualToString:CANCEL_ALL_SELECT]];
    
    [self.editMusicTabelView reloadData];
//    [self runtimeInfoChang];
    
}

- (IBAction)deleteMusicBtnClick:(id)sender {
    
    self.deleteView.hidden = NO;
    


}
- (IBAction)deleteBtnClick:(id)sender {
    
    
    
    self.musicIds = nil;
    
    // 将所有选中的歌曲添加到要删除的数组中
    for (D5BaseListModel *model in listInstance.allMusicList) {
        if (model.music.selected == YES) {
            
            int32_t musicid =(int32_t)model.music.musicID ;
                        
            
            [self.musicIds addObject:@(musicid)];
        }
    }
    
    
    if ([self.selectedAllBtn.titleLabel.text isEqualToString:ALL_SELECT]) {
        NSDictionary *deleteDict = @{LED_STR_DELIDS : self.musicIds,
                                     LED_STR_TYPE : @(Del_Custom)
                                     };

    D5LedNormalCmd *musicDelete = [[D5LedNormalCmd alloc] init];
    
    musicDelete.remotePort = [D5CurrentBox currentBoxTCPPort];
    musicDelete.strDestMac =  [D5CurrentBox currentBoxMac];
    musicDelete.remoteLocalTag = tag_remote;
    musicDelete.remoteIp = [D5CurrentBox currentBoxIP];
    musicDelete.errorDelegate = self;
    musicDelete.receiveDelegate = self;
    
    // 发送删除命令
        [musicDelete ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Delete_Music withData:deleteDict];
    } else if ([self.selectedAllBtn.titleLabel.text isEqualToString:CANCEL_ALL_SELECT]) {
        NSDictionary *deleteDict = @{
                                     LED_STR_TYPE : @(Del_All)
                                     };

        D5LedNormalCmd *musicDelete = [[D5LedNormalCmd alloc] init];
        
        musicDelete.remotePort = [D5CurrentBox currentBoxTCPPort];
        musicDelete.strDestMac =  [D5CurrentBox currentBoxMac];
        musicDelete.remoteLocalTag = tag_remote;
        musicDelete.remoteIp = [D5CurrentBox currentBoxIP];
        musicDelete.errorDelegate = self;
        musicDelete.receiveDelegate = self;
        
        // 发送删除命令
        [musicDelete ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Delete_Music withData:deleteDict];

    }
    
    self.deleteView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
    
    [self.navigationController popViewControllerAnimated:NO];

    
}


#pragma mark - <tableviewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (listInstance.allMusicList) {
        return listInstance.allMusicList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    D5EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LGZEditCell"];
    
    if (!cell) {
        cell = [[D5EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LGZEditCell"];
    }

    // 设置cell的背景色
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:37/225.f green:39/255.f blue:40/255.f alpha:1];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    }

    
    if (listInstance.allMusicList.count > 0) {
        
        cell.musicModel = listInstance.allMusicList[indexPath.row];
//        DLog(@"allMusicList = %u   indexPath = %d   musicName = %@   musicId = %d", cell.musicModel.music.playStatus, indexPath.row, cell.musicModel.music.name, cell.musicModel.music.musicID);

    }
    
    cell.indexRow = indexPath.row;
    __weak D5EditMusicViewController *weakSelf = self;
    // 选择回调
    [cell setCheckBlock:^{
        
        NSInteger selectedNumber = 0;
        
        for (D5BaseListModel *model in listInstance.allMusicList) {
            if (model.music.selected == YES) {
                selectedNumber = selectedNumber + 1;
            }
            
            if (listInstance.allMusicList.count == selectedNumber) {
                weakSelf.selectedAllBtn.titleLabel.text = CANCEL_ALL_SELECT;
                [weakSelf.selectedAllBtn setTitle:CANCEL_ALL_SELECT forState:UIControlStateNormal];
                
                weakSelf.totalLabel.text = [NSString stringWithFormat:@"已选择%ld首歌", (long)listInstance.totalSize];

            } else {
                weakSelf.selectedAllBtn.titleLabel.text = ALL_SELECT;
                [weakSelf.selectedAllBtn setTitle:ALL_SELECT forState:UIControlStateNormal];
                weakSelf.totalLabel.text = [NSString stringWithFormat:@"已选择%d首歌", selectedNumber];

            }
            [weakSelf setBtnEnable:weakSelf.deleteBtn enable:(selectedNumber>0)];
        }
    }];
        
    return cell;
}

- (void)setBtnEnable:(UIButton *)btn enable:(BOOL)isEnable {
    
    btn.enabled = isEnable;
    btn.backgroundColor = isEnable ? BTN_YELLOW_COLOR : BTN_DISABLED_COLOR;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)runtimeInfoChang
{
    D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
    
    if (instance.music.playStatus == Stop) return;
    __weak D5EditMusicViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.editMusicTabelView reloadData];

    });
    return;
    
    for (D5BaseListModel *musicList in listInstance.allMusicList) {
        if (musicList.music.musicID  == instance.music.musicId) {
            NSUInteger currentIndex = [listInstance.allMusicList indexOfObject:musicList];
            
            NSIndexPath *current = [NSIndexPath indexPathForRow:currentIndex inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 选中当前播放的歌曲
                [weakSelf.editMusicTabelView selectRowAtIndexPath:current animated:NO scrollPosition:UITableViewScrollPositionNone];
            });
            
            
            
        }
    }
    
    
}

- (void)addTableviewFooter
{
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerUpdateMusic)];
    
    // 设置普通状态的动画图片
    NSMutableArray *freshImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_0%zd", i]];
        [freshImages addObject:image];
    }
    
    
    
    [gifFooter setImages:freshImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    
    _editMusicTabelView.mj_footer = gifFooter;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
