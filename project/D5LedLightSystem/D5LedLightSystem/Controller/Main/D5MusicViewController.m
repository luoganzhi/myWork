//
//  D5MusicViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicViewController.h"
#import "D5AddMusicListController.h"
#import "D5MusicLibraryCell.h"
#import "D5EditMusicViewController.h"
#import "D5ConfigViewController.h"
#import "D5MusicCell.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "D5MusicModel.h"
#import "D5MusicListModel.h"
#import "D5MusicStateMusicModel.h"
#import "D5PlayMusicViewController.h"
#import "D5MusicStateModel.h"

#import "D5RuntimeShareInstance.h"
#import "D5RuntimeMusic.h"
#import "D5EffectsModel.h"
#import "D5BaseListModel.h"

#import "D5MusicListInstance.h"
#import "AppDelegate.h"

#define listInstance [D5MusicListInstance sharedInstance]



@interface D5MusicViewController () <UITableViewDelegate, UITableViewDataSource, D5LedNetWorkErrorDelegate, D5LedCmdDelegate>
@property (weak, nonatomic) IBOutlet UIView *hasSongView;
@property (weak, nonatomic) IBOutlet UIScrollView *noSongView;
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
/** D5ConfigViewController */
@property (nonatomic, strong) D5ConfigViewController *configVC;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *addMusicBtn;

/** musicListModel */
@property (nonatomic, strong) D5MusicListModel *musicListModel;

/** 有无歌曲 */
@property (nonatomic, assign) BOOL isHasMusic;



/** D5MusicStateModel */
@property (nonatomic, strong) D5MusicStateModel *stateModel;

/** 是否要主动刷新 */
@property (nonatomic, assign) BOOL isAutoRefresh;

@end

@implementation D5MusicViewController


#pragma mark - 获取音乐

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

#pragma mark - <歌曲返回delegate>
- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.noSongView.mj_header endRefreshing];
            [self.musicTableView.mj_header endRefreshing];
        });
        
        if (errorType == D5SocketErrorCodeTypeTimeOut) {
            //DLog(@"请求播放列表超时");  Mercenaries Saga2
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 回调或者说是通知主线程，当返回错误的时候，停止刷新。
                [MBProgressHUD showMessage:@"获取歌曲列表超时，请重新获取"];
     
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                });
                
                [self.musicTableView.mj_header endRefreshing];
                [self.noSongView.mj_header endRefreshing];
                [self.musicTableView.mj_footer endRefreshing];
                
            });
            
        } else if (errorType == D5SocketErrorCodeTypeMediaFileNotExsit) {
            [MBProgressHUD showMessage:@"歌曲已被删除"];
            [self.musicTableView.mj_header beginRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                
            });

        }        
    }
}


- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict
{
    if (header->cmd == Cmd_Media_Operate && header->subCmd == SubCmd_Music_List) { // 音乐列表返回
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.noSongView.mj_header endRefreshing];
           [self.musicTableView.mj_header endRefreshing];
           [self.musicTableView.mj_footer endRefreshing];
           
           DLog(@"音乐列表 -- %@",dict);

           NSDictionary *data = dict[LED_STR_DATA];
           self.musicListModel = [D5MusicListModel mj_objectWithKeyValues:data];
           
           listInstance.pageNum = self.musicListModel.pageNum;
           listInstance.totalNum = self.musicListModel.totalNum;
           listInstance.totalSize = self.musicListModel.totalSize;
           
           if (listInstance.pageNum == 0 && listInstance.allMusicList.count >0) { // 防止重复返回第一页消息
               [listInstance.allMusicList removeAllObjects];
           }
//           D5MusicListInstance *listInstance = [D5MusicListInstance sharedInstance];
           if ([listInstance.allMusicList containsObject:self.musicListModel.musicList]) return;
           [listInstance.allMusicList addObjectsFromArray:self.musicListModel.musicList];

            if (listInstance.allMusicList.count && listInstance.allMusicList.count > 0 ) { // 如果中控有歌曲
                self.noSongView.hidden  = YES;
                self.hasSongView.hidden = NO;
                self.isHasMusic = YES;
            } else {
                self.noSongView.hidden  = NO;
                self.hasSongView.hidden = YES;
                self.isHasMusic = NO;
            }
           if (self.musicListModel.pageNum + 1 < self.musicListModel.totalNum) { //如果还有数据就只是停止刷新
               [self.musicTableView.mj_footer endRefreshing];
           } else {  // 如果没有数据就提示没有数据了
               [self.musicTableView.mj_footer endRefreshingWithNoMoreData];
               //                self.musicTableView.mj_footer
           }
   
           
           if (listInstance.allMusicList.count <= 0) {
               [[D5RuntimeShareInstance sharedInstance] clear];

               [[NSNotificationCenter defaultCenter] postNotificationName:Runtime_Info_Update object:nil];
           }
   
            [self.musicTableView reloadData];

                
           // 选中单元格
           D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];

            for (D5BaseListModel *musicList in listInstance.allMusicList) {
                if(instance.music.musicId == musicList.music.musicID) {
                    NSUInteger currentIndex = [listInstance.allMusicList indexOfObject:musicList];
                    
                    NSIndexPath *current = [NSIndexPath indexPathForRow:currentIndex inSection:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.musicTableView selectRowAtIndexPath:current animated:NO scrollPosition:UITableViewScrollPositionNone];

                    });

                    
                }

            }
       });
    }
}

- (IBAction)addMusic:(id)sender {
    
    D5AddMusicListController *vc = [[UIStoryboard storyboardWithName:MUSICLIBRARY_STORYBOARD_ID bundle:nil]instantiateViewControllerWithIdentifier:AddMusicListVC];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

    // 其他设置
    [self otherSet];
    
    // 设置header
    [self setHeader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMusicList) name:REFRESH_MUSIC_LIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMusicTable) name:@"reloadData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runtimeInfoChang) name:Runtime_Info_Update object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needEndRefresh) name:@"need_end_refresh" object:nil];
    
    [self appBecomeAvtive];
    
    if (listInstance.allMusicList && listInstance.allMusicList.count>0) {
        [self hasOrNotHasMusic];
        [self.musicTableView reloadData];
        return;
    }
    // 获取歌曲
    [self getMusic:0]; 
    
}

- (void)needEndRefresh {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        typeof(weakSelf) strongSelf = self;
        
        [strongSelf.musicTableView.mj_footer endRefreshingWithNoMoreData];
        
        [strongSelf.musicTableView.mj_header endRefreshing];
        [strongSelf.noSongView.mj_header endRefreshing];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 有无歌曲界面展示
- (void)hasOrNotHasMusic
{
    if (listInstance.allMusicList.count && listInstance.allMusicList.count > 0 ) { // 如果中控有歌曲
        self.noSongView.hidden  = YES;
        self.hasSongView.hidden = NO;
        self.isHasMusic = YES;
    } else {
        self.noSongView.hidden  = NO;
        self.hasSongView.hidden = YES;
        self.isHasMusic = NO;
    }
//    [self.musicTableView reloadData];

    
    
    
    // 选中单元格
    D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
    
    for (D5BaseListModel *musicList in listInstance.allMusicList) {
        if(instance.music.musicId == musicList.music.musicID) {
            NSUInteger currentIndex = [listInstance.allMusicList indexOfObject:musicList];
            
            NSIndexPath *current = [NSIndexPath indexPathForRow:currentIndex inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.musicTableView selectRowAtIndexPath:current animated:NO scrollPosition:UITableViewScrollPositionNone];
                
            });
            
            
        }
        
    }

}

- (void)reloadMusicTable
{
    [self.musicTableView reloadData];
}

- (void)appBecomeAvtive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(runtimeInfoChang)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)runtimeInfoChang {
    D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
    if (listInstance.allMusicList.count <= 0) {
        
    }
    
    if (instance.music.playStatus == Stop) return;

    
    for (D5BaseListModel *musicList in listInstance.allMusicList) {
        if (musicList.music.musicID  == instance.music.musicId) {
            
            NSUInteger currentIndex = [listInstance.allMusicList indexOfObject:musicList];
            
            NSIndexPath *current = [NSIndexPath indexPathForRow:currentIndex inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 选中当前播放的歌曲
                [self.musicTableView selectRowAtIndexPath:current animated:NO scrollPosition:UITableViewScrollPositionNone];
            });
        }
    }
}

// 其他设置
- (void)otherSet
{
    // 状态栏的隐藏与显示
    self.noSongView.hidden  = NO;
    self.hasSongView.hidden = YES;
    // 设置圆角
    self.addMusicBtn.layer.cornerRadius = 16;
    self.addMusicBtn.layer.masksToBounds = YES;

}

// 设置header
- (void)setHeader
{
    

    [self addTableviewFooter];
    
    [self addTableviewHeader];
    
    [self addScrollViewHeader];
    
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
    
    
    
    UIImage *upImage = [UIImage imageNamed:@"up"];
    NSArray *upArray = @[upImage];
    
    UIImage *downImage = [UIImage imageNamed:@"down"];
    NSArray *downArray = @[downImage];
    
    [gifFooter setImages:upArray forState:MJRefreshStatePulling];
    [gifFooter setImages:downArray forState:MJRefreshStateIdle];
    [gifFooter setImages:freshImages duration:0.5 forState:MJRefreshStateRefreshing];
    

    _musicTableView.mj_footer = gifFooter;
    
}




-(void)addTableviewHeader
{
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateMusic)];
    
    // 设置普通状态的动画图片
    NSMutableArray *freshImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_0%zd", i]];
        [freshImages addObject:image];
    }

    
    
    UIImage *upImage = [UIImage imageNamed:@"up"];
    NSArray *upArray = @[upImage];
    
    UIImage *downImage = [UIImage imageNamed:@"down"];
    NSArray *downArray = @[downImage];
    
    [gifHeader setImages:upArray forState:MJRefreshStatePulling];
    [gifHeader setImages:downArray forState:MJRefreshStateIdle];
    [gifHeader setImages:freshImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    [gifHeader setTitle:@"下拉刷新" forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:@"松开更新" forState: MJRefreshStatePulling];
    [gifHeader setTitle:@"刷新中" forState: MJRefreshStateRefreshing];
    _musicTableView.mj_header = gifHeader;
    
}


-(void)addScrollViewHeader
{
    //Tableview Header下拉刷新
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateMusic)];

    NSMutableArray *freshImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_0%zd", i]];
        [freshImages addObject:image];
    }
    
    
    
    UIImage *upImage = [UIImage imageNamed:@"up"];
    NSArray *upArray = @[upImage];
    
    UIImage *downImage = [UIImage imageNamed:@"down"];
    NSArray *downArray = @[downImage];
    
    [gifHeader setImages:upArray forState:MJRefreshStatePulling];
    [gifHeader setImages:downArray forState:MJRefreshStateIdle];
    [gifHeader setImages:freshImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    [gifHeader setTitle:@"下拉刷新" forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:@"松开更新" forState: MJRefreshStatePulling];
    [gifHeader setTitle:@"刷新中" forState: MJRefreshStateRefreshing];
    _noSongView.mj_header = gifHeader;
    
}







// 更新歌曲
- (void)updateMusic
{
    // 下拉加载先将数组清空
//    [listInstance.allMusicList removeAllObjects];
    listInstance.currentIndex = 0;
    [self getMusic:listInstance.currentIndex];
    
    if (self.musicTableView.mj_footer.state == MJRefreshStateRefreshing) {
        [self.musicTableView.mj_footer endRefreshing];
    }
    
}

- (void)footerUpdateMusic
{
    if (listInstance.totalNum > listInstance.pageNum) {
        listInstance.currentIndex++;
    } else {
        [self.musicTableView.mj_footer endRefreshingWithNoMoreData];
        [self.musicTableView reloadData];
        return;
    }
    
    [self getMusic:listInstance.currentIndex];
    
}

- (void)refreshMusicList {
    dispatch_async(dispatch_get_main_queue(), ^{
        _isAutoRefresh = YES;
        [self.musicTableView.mj_header beginRefreshing];
    });
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (listInstance.totalNum > listInstance.pageNum) {
    } else {
        [self.musicTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }

    [self.musicTableView.mj_header endRefreshing];
    [self.noSongView.mj_header endRefreshing];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self runtimeInfoChang];
    
    if (self.musicTableView.mj_footer.state == MJRefreshStateRefreshing) {
//        [self.musicTableView.mj_footer beginRefreshing];
        [self.musicTableView.mj_footer setState:MJRefreshStateIdle];
        [self.musicTableView.mj_footer setState:MJRefreshStateRefreshing];
    } else {
        [self.musicTableView.mj_footer endRefreshing];
    }
    
    if ( listInstance.pageNum + 1 < listInstance.totalNum)  {
    } else {
        if (listInstance.allMusicList && listInstance.allMusicList.count > 0){
            [self.musicTableView reloadData];
            [self.musicTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }

        AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (delegate.isNeedRefresh){
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
            delegate.isNeedRefresh = NO;
        }
    

}

#pragma mark - <tableviewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listInstance.allMusicList ? listInstance.allMusicList.count : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    D5MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LGZMusicCell"];
    
    if (!cell) {
        cell = [[D5MusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LGZMusicCell"];
    }
    
    NSInteger row = indexPath.row;
    if (listInstance.allMusicList && row < listInstance.allMusicList.count) {
        D5BaseListModel *musicList = listInstance.allMusicList[row];
        cell.musicModel = musicList.music;
    }
    
    cell.index = indexPath;
    
    __weak __typeof(self)weakSelf = self;
    // 配置按钮的点击事件
    [cell setConfigBlock:^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([D5ConfigViewController class]) bundle:nil];
        
        weakSelf.configVC = [sb instantiateInitialViewController];
        weakSelf.configVC.view.frame = [UIScreen mainScreen].bounds;
       
        if (listInstance.allMusicList && row < listInstance.allMusicList.count) {
            // 将配置数组传递过去
            weakSelf.configVC.musicModel = listInstance.allMusicList[row];
            
            // 点击配置播放
            [weakSelf.configVC setPlayConfigBlock:^{
                [weakSelf.musicTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([D5PlayMusicViewController class]) bundle:nil];
                D5PlayMusicViewController *vc = [sb instantiateInitialViewController];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.configVC.view];
        }
    }];
    
    
    
    // 给Cell 添加左滑手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
    return cell;
}

- (void)handleSwipes:(UITapGestureRecognizer *)tap
{
    
    // 获取选中点的index
    CGPoint point = [tap locationInView:self.musicTableView];
    
    NSIndexPath *index = [self.musicTableView indexPathForRowAtPoint:point];
    

    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([D5EditMusicViewController class]) bundle:nil];
    D5EditMusicViewController *vc = [sb instantiateInitialViewController];
    
    // 删除回调
    __weak typeof(self) weakSelf = self;
    [vc setDeleteBlock:^{
        [weakSelf.musicTableView.mj_header beginRefreshing];
    }];
    
    vc.index = index;
    
    // 先将所有模型选中属性置为NO
    for (D5BaseListModel *musicList in listInstance.allMusicList) {
       musicList.music.selected = NO;
    }
    
    // 将选中的那一行标记为已经选中
    if (listInstance.allMusicList && index.row < listInstance.allMusicList.count) {
        
        D5BaseListModel *musicList = listInstance.allMusicList[index.row];
        musicList.music.selected = YES;
        
        // 传递数组
        //    vc.allMusicList = listInstance.allMusicList;
        
        [self.navigationController pushViewController:vc animated:NO];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    if (listInstance.allMusicList && row < listInstance.allMusicList.count) {
        
        D5BaseListModel *modelList = listInstance.allMusicList[row];
        
        if (!modelList.effectsList || modelList.effectsList.count <= 0){
            
            NSDictionary *dict = @{LED_STR_MUSICID : @(modelList.music.musicID),
                                   LED_STR_EFFECTID : @(0)};
            
            D5LedNormalCmd *musicPlay = [[D5LedNormalCmd alloc] init];
            musicPlay.remotePort = [D5CurrentBox currentBoxTCPPort];
            musicPlay.strDestMac =  [D5CurrentBox currentBoxMac];
            musicPlay.remoteLocalTag = tag_remote;
            musicPlay.remoteIp = [D5CurrentBox currentBoxIP];
            musicPlay.errorDelegate = self;
            musicPlay.receiveDelegate = self;
            
            [musicPlay ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Music_Play withData:dict];
            
            
        } else {
            D5EffectsModel *effect = modelList.effectsList[0];
            
            NSDictionary *dict = @{LED_STR_MUSICID : @(modelList.music.musicID),
                                   LED_STR_EFFECTID : @(effect.effectID)};
            
            D5LedNormalCmd *musicPlay = [[D5LedNormalCmd alloc] init];
            musicPlay.remotePort = [D5CurrentBox currentBoxTCPPort];
            musicPlay.strDestMac =  [D5CurrentBox currentBoxMac];
            musicPlay.remoteLocalTag = tag_remote;
            musicPlay.remoteIp = [D5CurrentBox currentBoxIP];
            musicPlay.errorDelegate = self;
            musicPlay.receiveDelegate = self;
            
            [musicPlay ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Music_Play withData:dict];
            
        }
        
    }

}




@end
