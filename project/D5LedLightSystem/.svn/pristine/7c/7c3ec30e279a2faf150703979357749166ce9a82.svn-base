//
//  D5MoubileTanslateSongsController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MoubileTanslateSongsController.h"
#import "D5MusicLibraryData.h"
#import "D5HLocalMusicList.h"
#import "D5HUploadLocalMusic.h"
#import "D5UploadFileViewController.h"
#import "D5LocalMusicListCell.h"
#import "D5MainViewController.h"
#import "D5MainViewController.h"
#import "D5LocalDataModel.h"
#import "D5TransferMusic.h"
#import "D5UploadingView.h"
#import "D5UploadSuccessView.h"
#import "D5UploadFailedView.h"
#import "AppDelegate.h"

#define ALL_SELECT @"全选"
#define ALL_DESELECT @"全不选"
#define HAS_SELECTED_COUNT(count) [NSString stringWithFormat:@"已选择%d首歌", count]
#define TOTAL_COUNT(count) [NSString stringWithFormat:@"共%d首歌", count]

#define SCANING_TEXT    @"正在扫描手机内的音乐"
#define NO_LIGHT_TEXT   @"手机里没有新的歌曲哦"

#define SCANING_IMG [UIImage imageNamed:@"loading"]
#define NO_LIGHT_IMG [UIImage imageNamed:@"no_light_info"]

typedef enum _scan_status {
    ScanStatusIng,
    ScanStatusNoMusic,
    ScanStatusHasMusic
}ScanStatus;

@interface D5MoubileTanslateSongsController()<UITableViewDelegate,UITableViewDataSource, D5TransferMusicDelegate, D5UploadFailedViewDelegate, D5UploadingViewDelegate>
{
    NSMutableArray* selectedAddr;//选择的歌曲列表
    __weak int uploadIndex;//上传index
    __weak IBOutlet UIButton* upload;//上传
    __weak IBOutlet UITableView* tableview;
}


@property (weak, nonatomic) IBOutlet UIView *sureCancelView;
- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnSureClicked:(UIButton *)sender;


//@property (nonatomic, strong) D5UploadFileViewController *loadVC;     //显示正在上传VC
@property (nonatomic, strong) NSMutableArray *localMusicList;       //本地歌曲数组列表
@property (nonatomic, strong) NSMutableDictionary *selectedIndexPathDict; //选中的indexpath字典  键值对：（indexpath---是否选中）
@property(copy, nonatomic) NSString *operateMusicURL;//操作的音乐上传地址URL
@property(nonatomic,strong)NSMutableArray *names;//上传的名字
@property(nonatomic,strong) UIBarButtonItem *rigntBtn;//全选按钮
@property(nonatomic,strong)UIView*searchFailView;
@property (weak, nonatomic) IBOutlet UIView *noMusicAndScaningView;
@property (weak, nonatomic) IBOutlet UIImageView *scaningImgView;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@property (weak, nonatomic) IBOutlet UILabel *hasSelectedLabel;

/** 是否取消上传 */
@property (nonatomic, assign) BOOL isCancelUpload;

@property (weak, nonatomic) IBOutlet UIButton *btnReScan;
- (IBAction)btnReScanClicked:(UIButton *)sender;

@end

@implementation D5MoubileTanslateSongsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _localMusicList = [NSMutableArray array];
    [self setViewByLocalMusic];
}


- (void)setViewByLocalMusic {
    [self initView];
    [self setNoMusicAndScaningViewByStatus:ScanStatusIng];
    [self getLoaclMusicList];
}

- (void)setNoMusicAndScaningViewByStatus:(ScanStatus)status {
    @autoreleasepool {
        switch (status) {
            case ScanStatusIng:
                _btnReScan.hidden = YES;
                _noMusicAndScaningView.hidden = NO;
                _scaningImgView.image = SCANING_IMG;
                [self startRotateForImg:_scaningImgView];
                _scanLabel.text = SCANING_TEXT;
                break;
                
            case ScanStatusNoMusic:
                _btnReScan.hidden = NO;
                _noMusicAndScaningView.hidden = NO;
                [self stopRotateForImg:_scaningImgView];
                
                _scaningImgView.hidden = NO;
                _scaningImgView.image = NO_LIGHT_IMG;
                _scanLabel.text = NO_LIGHT_TEXT;
                break;
                
            default:
                _noMusicAndScaningView.hidden = YES;
                [self stopRotateForImg:_scaningImgView];
                break;
        }
    }
}

- (void)setHasSelectedTextByCount:(int)count {
    _hasSelectedLabel.text = HAS_SELECTED_COUNT(count);
    [self setBtnEnable:upload enable:count > 0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [D5TransferMusic sharedInstance].delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self removeFailView];
    [self hideTipView];
}

- (void)hideTipView {
    _isCancelUpload = NO;
    
    [[D5UploadingView sharedUploadingView] hideTipView];
    [[D5UploadFailedView sharedUploadFailedView] hideTipView];
    [[D5UploadSuccessView sharedUploadSuccessView] hideTipView];
}

#pragma mark - 初始化view and data
- (void)initView {
    [self.navigationItem setTitle:@"手机传歌"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [D5BarItem setLeftBarItemWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(back)];
    
    
    //设置tableview属性
    tableview.tableFooterView = [[UIView alloc] init];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    tableview.sectionIndexColor = [UIColor whiteColor];
    //上传音乐属性
    [upload.layer setCornerRadius:18];
    upload.layer.masksToBounds = YES;
//    [upload setBackgroundColor:BTN_BACK_COLOR forState:UIControlStateDisabled];
//    [upload setTitleColor:BTN_BACK_TITLE_COLOR forState:UIControlStateDisabled];
//    [upload setBackgroundColor:BTN_YELLOW_COLOR forState:UIControlStateNormal];
//    [upload setEnabled:self.selectedIndexPathDict.count > 0];//b禁用button
    _sureCancelView.hidden = YES;
    
}

//默认全选
- (void)allSelect {
    if (self.localMusicList.count > 0) {
        for (int i = 0; i < self.localMusicList.count; i ++) {
            @autoreleasepool {
                NSDictionary *dict = self.localMusicList[i];
                NSArray *subArr = [dict allValues];
                if (subArr && subArr.count > 0) {
                    NSArray *datas = subArr[0];
                    if (datas && datas.count > 0) {
                        int count = (int)datas.count;
                        for (int j = 0; j < count; j ++) {
                            @autoreleasepool {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                self.selectedIndexPathDict[indexPath] = @(YES);
                            }
                        }
                    }
                }
            }
        }
        
        [self setHasSelectedTextByCount:[D5HLocalMusicList shareInstance].totalCount];
    }
}

#pragma mark - 右上角的baritem 全选/全不选
- (void)addRightBar {
    @autoreleasepool {
        if (!self.navigationItem.rightBarButtonItem) {
            [D5BarItem addRightBarItemWithText:ALL_DESELECT color:WHITE_COLOR target:self action:@selector(rightBarClicked:)];
        } else { //如果已有全选按钮，则只需改变其标题
            NSInteger selectedCount = [self.selectedIndexPathDict allKeysForObject:@(YES)].count;
            NSInteger totalCount = [D5HLocalMusicList shareInstance].totalCount;
            [self changeRightBarItemTitle:(selectedCount == totalCount) ? ALL_DESELECT : ALL_SELECT];
        }
    }
}

- (void)rightBarClicked:(UIButton *)sender {
    @autoreleasepool {
        NSString *title = sender.currentTitle;
        BOOL isAllSelect = [ALL_SELECT isEqualToString:title];
        if (isAllSelect) { //全选
            [self allSelect];
        } else { //全不选
            if (_selectedIndexPathDict) {
                [self.selectedIndexPathDict removeAllObjects];
            }
            [self setHasSelectedTextByCount:0];
        }
        [tableview reloadData];
        [self addRightBar];
    }
}

- (NSMutableDictionary *)selectedIndexPathDict {
    if (!_selectedIndexPathDict) {
        _selectedIndexPathDict = [NSMutableDictionary dictionary];
    }
    return _selectedIndexPathDict;
}

#pragma  mark --搜索不到view属性
-(UIView*)searchFailView
{
    if (_searchFailView==nil) {
        _searchFailView=[[[NSBundle mainBundle]loadNibNamed:@"NoContent" owner:nil options:nil]firstObject];
    }
    [_searchFailView setFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    UILabel*content=[_searchFailView viewWithTag:2];
    [content setText:@"搜索不到，请换个名字试试"];
    
    return _searchFailView;
    
}
//显示搜素不到view
-(void)showSearchFailView
{
    if (![self failViewExist]) {
        
        [self.view insertSubview:self.searchFailView atIndex:self.view.subviews.count];
    }
}
//是否存在失败View
-(BOOL)failViewExist
{
    return  [self.view.subviews containsObject:self.searchFailView];
    
}

-(void)removeFailView{
    
    if([self failViewExist]){
        
        [self.searchFailView removeFromSuperview];
    }
    
}

#pragma mark - 获取本地所有的歌曲
- (void)getLoaclMusicList {
    D5HLocalMusicList *list = [D5HLocalMusicList shareInstance];
    
    __weak D5MoubileTanslateSongsController *weakSelf = self;
    [list setArrBlock:^(NSMutableArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.localMusicList = arr;
            [weakSelf allSelect];
            
            // 如果有本地歌曲，才添加全选按钮
            if (weakSelf.localMusicList.count > 0) {
                [weakSelf addRightBar];
            }
            
            [tableview reloadData];
            if (!weakSelf.localMusicList || 0 == weakSelf.localMusicList.count) {
                [weakSelf setNoMusicAndScaningViewByStatus:ScanStatusNoMusic];
            } else {
                [weakSelf setNoMusicAndScaningViewByStatus:ScanStatusHasMusic];
            }
        });
    }];
    
    [list localMusicSortedArr];
    
//    _localMusicList = [[D5HLocalMusicList shareInstance] localMusicSortedArr];
   
}

#pragma mark - 传歌服务开关结果
- (void)openTransferServiceFinish:(BOOL)isFinish ipv4:(NSString *)ipv4 port:(int)port url:(NSString *)url {
    @autoreleasepool {
        if (!isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBtnEnable:upload enable:YES];
                [[D5UploadingView sharedUploadingView] hideTipView];
            });
            return;
        }
        
        if (_isCancelUpload) {
            return ;
        }
        
        _operateMusicURL = url;
        [self btnUpLoadMusic];
    }
}

#pragma mark - 上传音乐
//点击上传音乐
- (IBAction)uploadMusic:(id)sender {
    NSArray *selectedKeys = [self.selectedIndexPathDict allKeysForObject:@(YES)];
    if (selectedKeys && 0 == selectedKeys.count) {
        //DLog(@"没选择上传的歌曲");
        return;
    }
    
    if (!selectedAddr) {
        selectedAddr = [NSMutableArray array];
    } else {
        [selectedAddr removeAllObjects];
    }
    [MobClick event:UM_ADD_MUSIC_TYPE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", UMAddMusicTypePhone]}];
    
    for (NSIndexPath * indexPath in selectedKeys) {
        @autoreleasepool {
            NSInteger row = indexPath.row;
            NSInteger section = indexPath.section;
            
            D5MusicLibraryData *data = [D5HLocalMusicList dataFromArr:self.localMusicList atSection:section atRow:row];
            
            [selectedAddr addObject:data];
        }
    }
   
    [D5UploadingView sharedUploadingView].delegate = self;
    [D5UploadFailedView sharedUploadFailedView].delegate = self;
    
    D5MusicLibraryData *data = selectedAddr[0];
    
    _isCancelUpload = NO;
    [[D5UploadingView sharedUploadingView] showUploadIngViewByIndex:1 totalCount:(int)selectedAddr.count musicName:data.musicName progress:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //打开本地开关
        [[D5TransferMusic sharedInstance] transferServiceOpen:YES];
    });
}

//上传音乐
- (void)btnUpLoadMusic {
    @autoreleasepool {
        _names = [NSMutableArray array];
        //异步组
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步函数
        __weak D5MoubileTanslateSongsController *weakSelf = self;
        dispatch_group_async(group, queue, ^{
//            遍历选择的数组z
            [selectedAddr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    if (obj != nil) {
                        D5LocalDataModel* model = [[D5LocalDataModel alloc]init];
                        model.musicId = ((D5MusicLibraryData *)obj).musicId;
                        model.musicName = ((D5MusicLibraryData *)obj).musicName;
                        model.centreBoxId = [D5CurrentBox currentBoxId];
                        [weakSelf.names addObject:model];
                    }
                }
            }];
        });
        
        dispatch_group_notify(group, queue, ^{
            uploadIndex = 1;//开始上传歌曲索引
            [weakSelf uploadMusicToSevice];
        });
    }
}

//获取本地歌曲
- (NSDictionary *)getLocalMusicCache:(D5MusicLibraryData *)data {
    @autoreleasepool {
        NSDictionary *musicData = [[D5HLocalMusicList shareInstance] mediaItemToData:data.curItem];
        return musicData;
    }
}
//获取音乐库数据通过本地标记音乐模型
-(D5MusicLibraryData*)getSelcteMusicLibray:(D5LocalDataModel*) model {
    
    for (D5MusicLibraryData *obj in selectedAddr) {
        @autoreleasepool {
            if (obj.musicId == model.musicId) {
                return obj;
            }
        }
    }
    
    return nil;
    
}


- (void)uploadMusicToSevice {
    @autoreleasepool {
        if (_names.count == 0) {
            return;//结束上传音乐
        }
        
        D5LocalDataModel *model = _names[0];
        D5MusicLibraryData* objData = [self getSelcteMusicLibray:model];
        if (objData == nil) {
            return;
        }
        NSDictionary *dataDict = nil;
        @synchronized (self) {
             dataDict = [self getLocalMusicCache:objData];
        }
        if (dataDict == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[D5UploadingView sharedUploadingView] updateProgress:0 currentIndex:uploadIndex musicName:model.musicName];
        });
        
        DLog(@"uploadMusicToSevice   %d", _isCancelUpload);
        if (_isCancelUpload) {
            return;
        }
        
        //DLog(@"索引:%ld", (long)uploadIndex);
        [D5HUploadLocalMusic uploadNewMusicFile:dataDict
            name:model.musicName
                url:_operateMusicURL
                    progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[D5UploadingView sharedUploadingView] updateProgress:(int)(((double)bytesWritten / (double)totalBytesWritten) * 100) currentIndex:uploadIndex musicName:model.musicName];
                        });
                    } success:^(id response) {
                            @autoreleasepool {
                                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                delegate.isNeedRefresh = YES;
                                
                                if (_names.count > 0) {
                                    [_names removeObjectAtIndex:0];
                                }
                                
                                [self setLocalMusicUploadTag:model];//将选择的歌曲存放在本地
                                
                                if (_isCancelUpload) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self hidenLoadView];
                                    });
                                    return ;
                                }
                                
                                if (_names.count == 0) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self handleUploadResult:YES];
                                    });
                                    return ;
                                }
                                
                                uploadIndex ++;
                                
                                [self uploadMusicToSevice];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[D5UploadingView sharedUploadingView] updateProgress:0 currentIndex:uploadIndex musicName:model.musicName];
                                });
                            }
                        } fail:^(NSError *error) {
                            DLog(@"上传error = %@", error);
                            if ( error.code == -999)
                                return ;
//                            if (_names.count == 0) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self handleUploadResult:NO];
                                });
                                return ;
//                            }
                            
                            
//                            uploadIndex ++;
//                            [self uploadMusicToSevice:array names:names url:urlString];
                        }];
    }
}

/**
 上传结果的处理

 @param isSuceess 是否上传成功
 */
- (void)handleUploadResult:(BOOL)isSuceess {
    @autoreleasepool {
        _isCancelUpload = NO;
        DLog(@"handleUploadResult -----  %d", _isCancelUpload);
        [[D5TransferMusic sharedInstance] transferServiceOpen:NO];
        
        if (isSuceess) {
            [[D5UploadSuccessView sharedUploadSuccessView] showView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hidenLoadView];
            });
        } else {
            [[D5UploadFailedView sharedUploadFailedView] showView];
        }
    }
}

#pragma mark - tipview delegate
- (void)uploadViewReUpload:(D5UploadFailedView *)tipView {
    [self reUpload];
}

- (void)reUpload {
    @autoreleasepool {
        _isCancelUpload = NO;
        if (!selectedAddr || selectedAddr.count == 0) {
            return;
        }
        
        D5MusicLibraryData *data = selectedAddr[0];
        [[D5UploadingView sharedUploadingView] showUploadIngViewByIndex:1 totalCount:(int)selectedAddr.count musicName:data.musicName progress:0];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //打开本地开关
            [[D5TransferMusic sharedInstance] transferServiceOpen:YES];
        });
    }
}

- (void)uploadIngCancelUpload:(D5UploadingView *)uploadView {    
    _sureCancelView.hidden = NO;
    
    [self cancelUpload];
}

- (void)cancelUpload {
    @autoreleasepool {
        _isCancelUpload = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [D5HUploadLocalMusic cancelPost];
        });
        
        [self changeRightBarItemEnabled:YES];
        
        [[D5TransferMusic sharedInstance] transferServiceOpen:NO];
    }
}

- (IBAction)btnCancelClicked:(UIButton *)sender {
    _sureCancelView.hidden = YES;
    
    [self reUpload];
}

- (IBAction)btnSureClicked:(UIButton *)sender {
    _sureCancelView.hidden = YES;
}

-(void)setLocalMusicUploadTag:(D5LocalDataModel*)data {
   NSMutableArray*array = [D5HLocalMusicList getLocalUploadTagArray];
    
    //如果是第一次存取则把data存入即可
    if (array == nil) {
        array = [NSMutableArray array];
    }
    
    [array addObject:data];
        //序列化到本地
    [NSKeyedArchiver archiveRootObject:array toFile:[D5HLocalMusicList getfileDir]];
}

#pragma mark - loadingView的显示和隐藏

//隐藏loadView
- (void)hidenLoadView {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideTipView];
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
            if ([vc isKindOfClass:[D5MainViewController class]]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
                });
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        
    });
}

#pragma mark - 保存选中状态
- (void)checkStatusForIndexPath:(NSIndexPath *)indexPath{
    @autoreleasepool {
        BOOL isChecked = ![(self.selectedIndexPathDict[indexPath]) boolValue];
        self.selectedIndexPathDict[indexPath] = @(isChecked);
        
        D5MusicLibraryData *data = [D5HLocalMusicList dataFromArr:self.localMusicList atSection:indexPath.section atRow:indexPath.row];
        data.isSelected = !data.isSelected;
        
        D5LocalMusicListCell *cell = (D5LocalMusicListCell *)[tableview cellForRowAtIndexPath:indexPath];
        cell.aibumImageBt.selected = !cell.aibumImageBt.isSelected;
        
        NSArray *values = [self.selectedIndexPathDict allValues];
        BOOL hasChecked = NO;
        if (values && values.count > 0) {
            for (NSNumber *number in values) {
                @autoreleasepool {
                    if (number.boolValue) {
                        hasChecked = YES;
                        break;
                    }
                }
            }
        }
        
        NSArray *keys = [self.selectedIndexPathDict allKeysForObject:@(YES)];
        int selectedCount = 0;
        if (keys && keys.count > 0) {
            selectedCount = (int)(keys.count);
        }
        
        [self setHasSelectedTextByCount:selectedCount];
        
        [self addRightBar];
    }
}

#pragma mark - tableview的delegate和datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.localMusicList && section < self.localMusicList.count) {
        NSDictionary *dict = self.localMusicList[section];
        if (dict) {
            NSArray *values = [dict allValues];
            if (values && values.count > 0) {
                NSArray *datas = values[0];
                return datas ? datas.count : 0;
            }
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.localMusicList ? self.localMusicList.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5LocalMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:LocalMusicListCell];
        if (!cell) {
            cell = [[D5LocalMusicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LocalMusicListCell];
        }
        //设置cell的背景色
        NSInteger row = indexPath.row;
        if ( 0 == row % 2) {
            [cell setBackgroundColor:MUSIC_CELL_LOWBLACk];
        } else {
            [cell setBackgroundColor:MUSIC_CELL_BLACk];
        }
        
        NSInteger section = indexPath.section;
        //如果当前row小于本地音乐列表
        D5MusicLibraryData *data = [D5HLocalMusicList dataFromArr:self.localMusicList atSection:section atRow:row];
        if (data) {
            BOOL isChecked = [(self.selectedIndexPathDict[indexPath]) boolValue];
            data.isSelected = isChecked;
            
            [cell setData:data];
        }
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [D5HLocalMusicList titleFromArr:self.localMusicList atSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self checkStatusForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self checkStatusForIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   if (self.localMusicList && self.localMusicList.count > 0 && section == self.localMusicList.count - 1) {
       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 60)];
       label.textAlignment = NSTextAlignmentCenter;
       label.textColor = WHITE_COLOR;
       label.font = [UIFont systemFontOfSize:12];
       label.text = TOTAL_COUNT([D5HLocalMusicList shareInstance].totalCount);
        return label;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.localMusicList && self.localMusicList.count > 0 && section == self.localMusicList.count - 1) {
        return 60;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    @autoreleasepool {
        NSInteger resultSection = [D5HLocalMusicList indexForTitle:title fromArr:self.localMusicList];
        if (resultSection == -1) {
            return index;
        }
        
        //点击索引，列表跳转到对应索引的行
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:resultSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        return resultSection;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    @autoreleasepool {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.textColor = [UIColor whiteColor];
        
        header.contentView.backgroundColor = [UIColor blackColor];
    }
}

- (IBAction)btnReScanClicked:(UIButton *)sender {
    [self setViewByLocalMusic];
}

@end
