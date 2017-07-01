//
//  D5AddMusicListController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5AddMusicListController.h"
#import "D5TanslateMusic.h"
#import "D5BarItem.h"
#import "D5AddMusicListCell.h"

#import "D5MusicCategoryPopView.h"
#import "D5SearchMusicModel.h"
#import "D5MusicLibraryData.h"
#import "MKJFirstViewController.h"
#import "MJRefresh.h"
#import "D5SheetController.h"
#import "D5PCTanslateSongs.h"
#import "D5MoubileTanslateSongsController.h"
#import "UIImageView+Helper.h"
#import "D5TFOrUsbViewController.h"
#import "D5MainViewController.h"
#import "D5DownLoadMusic.h"
#import "D5HJMusicDownloadList.h"
#import "D5HJMusicDownloadListManageController.h"
#import "D5CheckService.h"
#import "NSArray+Helper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "D5DownloadList.h"
#import "AppDelegate.h"

//网络分页
struct NetworkingPage {
    NSInteger nowPage;//当前页
    NSInteger totalPage;//总页数
   };
#define PAGENUM 20 //每页的元素
#define music_popup_down_yellow [UIImage imageNamed:@"music_popup_down_yellow"]
#define music_popup_down [UIImage imageNamed:@"music_popup_down"]
#define music_popup_up [UIImage imageNamed:@"music_popup_up"]

@interface D5AddMusicListController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, D5DownLoadMusicDelegate,D5LedCmdDelegate,D5LedNetWorkErrorDelegate> {
   
//    ADD_MUSIC_LIST_CATEGORY _preSelectCategory;//当前选择的类别
    __weak IBOutlet UIView * buttomView;
    __weak IBOutlet UITextField * textfiledSearch;
    NSString*   _currentCategoryID;//当前选择的分类ID
    NSString*    _currentCategoryName;//当前选择的分类名
    __weak IBOutlet UIView *  searchView;
    __weak IBOutlet UITableView *  _tableview;
    float _slideViewY;
    BOOL _isShowPop;
    BOOL isFirst;//是否第一次进来
    dispatch_queue_t quenue;//下载队列
   
}

@property(nonatomic,strong)D5MusicCategoryPopView* popview;//分类view
@property(nonatomic,strong)NSArray*  classifyArray; //风格分类下类别数组
@property(nonatomic,strong)NSArray*  languageArray;//语言分类下类别数组
@property(nonatomic,strong)NSMutableArray* musicList;//音乐列表
@property(nonatomic,assign)NSInteger nowpage;
@property (weak, nonatomic) IBOutlet UIButton * languageBtn;
@property (weak, nonatomic) IBOutlet UIButton * styleBtn;
@property (weak, nonatomic) IBOutlet UIButton * recmmondBtn;
@property (weak, nonatomic) IBOutlet UIView *downLoadTipView;
@property (weak, nonatomic) IBOutlet UIView *nullDataView;
@property (strong, nonatomic) UIView * slideView;
@property (weak, nonatomic) IBOutlet UIButton * languagePop;
@property (weak, nonatomic) IBOutlet UIButton * stylePop;
@property (weak, nonatomic) IBOutlet UIView * mildView;
@property (weak, nonatomic) IBOutlet UILabel *downloadMusicTipLable;
@property(strong,nonatomic) D5SheetController* sheetVC;
@property (nonatomic, strong) D5LedSpecialCmd *downloadStatus;
@property (nonatomic, strong)D5HJMusicDownloadListManageController *downLoadMusicVC;
@property(nonatomic,strong)NSArray*categoryBtnArray;
@property(nonatomic,assign) ADD_MUSIC_LIST_CATEGORY nowSelectCategory;//当前选择的类别
@end
@implementation D5AddMusicListController
#pragma mark - 懒加载
- (D5LedSpecialCmd *)downloadStatus {
    if (!_downloadStatus) {
        _downloadStatus = [[D5LedSpecialCmd alloc] init];
        _downloadStatus.remoteLocalTag = tag_remote;
        _downloadStatus.errorDelegate = self;
        _downloadStatus.receiveDelegate = self;
        _downloadStatus.cmdType = SpecialCmdTypePush;
    }
    _downloadStatus.remotePort = [D5CurrentBox currentBoxTCPPort];
    _downloadStatus.strDestMac =  [D5CurrentBox currentBoxMac];
    _downloadStatus.remoteIp = [D5CurrentBox currentBoxIP];
   
    return _downloadStatus;
}

-(D5HJMusicDownloadListManageController*)downLoadMusicVC
{
    if (!_downLoadMusicVC) {
        _downLoadMusicVC = [[UIStoryboard storyboardWithName:MUSICLIBRARY_STORYBOARD_ID bundle:nil]instantiateViewControllerWithIdentifier:@"D5HJMusicDownloadListManageController"];
    }
    return _downLoadMusicVC;

}
-(UIButton*)getPreSelcteBtn:(NSInteger)tag{
    for (UIButton* btn in _categoryBtnArray) {
        if (btn.tag == tag) {
            return btn;
        }
    }
    
    return nil;

}
#pragma mark --属性方法

-(D5MusicCategoryPopView*)popview
{
    if (_popview == nil) {
        
        _popview = [[D5MusicCategoryPopView alloc]initWithFrame:self.navigationController.view.bounds];
    }
   
    __weak __typeof(self)weakSelf = self;
    //点击空白处回调
    _popview.popViewHiden = ^(BOOL isHiden){
  
        NSInteger tag = weakSelf.nowSelectCategory ;
        UIButton*btn = [weakSelf getPreSelcteBtn:tag];
        //设置当前的选项状态
        [weakSelf setMildeSlideView:tag];
        if (btn != nil) {
             [weakSelf setCategorySlecteBtnUI:btn];
        }
       
    };
    return _popview;
}

-(D5SheetController*)sheetVC
{
    UIStoryboard*boad=[UIStoryboard storyboardWithName:MUSICLIBRARY_STORYBOARD_ID bundle:nil];
    if (_sheetVC == nil) {
        
        _sheetVC = [boad instantiateViewControllerWithIdentifier:SheetControllerVC];
    }
    _sheetVC.view.frame=CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    
    __weak __typeof(self)weakSelf = self;
    //选择手机上传
    _sheetVC.mobileTranslate = ^(void)
    {
        D5MoubileTanslateSongsController*mobile = [boad instantiateViewControllerWithIdentifier:MoubileTanslateSongsVC];
        [weakSelf.navigationController pushViewController:mobile animated:YES];
        
    };
    //选择PC上传
    _sheetVC.pcTranslate=^(void)
    {
        D5PCTanslateSongs*pc = [boad instantiateViewControllerWithIdentifier:PCTanslateSongsVC];
        [weakSelf.navigationController pushViewController:pc animated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.isNeedRefresh = YES;
        
    };
    // USB上传
    _sheetVC.usbTfTranslate = ^(void) {
        D5TFOrUsbViewController *usb = [boad instantiateViewControllerWithIdentifier:TF_OR_USB_VC];
        [weakSelf.navigationController pushViewController:usb animated:YES];
    };
    
    [_sheetVC.view setUserInteractionEnabled:YES];
    _sheetVC.topview.backgroundColor = [UIColor blackColor];
    [_sheetVC.topview setAlpha:0.5];
    
    
    return _sheetVC;
    
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotification];
    [self initData];
    [self initView];
    [self judgeUploadMusicGuide];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [D5DownLoadMusic shareInstance].delegate = self;
    //显示下载的歌曲
    [self upDateDownloadView];
    //开始刷新
    [self setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [D5DownLoadMusic shareInstance].delegate = nil;
    [self resignGuideTip];
    //影藏掉底部的sheet
    if ([self isContainButtomSheet]) {
        [_sheetVC hideAnimation:YES];
    }
}

- (void)dealloc
{
    NSLog(@"%@", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//APP引导页
- (void)judgeUploadMusicGuide {
    
    NSString *key = @"has_upload_music_guide";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasAddedLightGuide = [userDefaults boolForKey:key];
    if (!hasAddedLightGuide) {
        [self addGuideViewWithPoint:CGPointMake(10, 50) tipStr:@"可以上传手机、电脑、\n移动设备里的歌曲" direction:GuideBgDirectionRight];
        [userDefaults setBool:YES forKey:key];
        [userDefaults synchronize];
    }
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkMusicData:) name:@"checkMusicData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelSucess:) name:@"cancelDownloading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCentreBoxDownloadingMusicList) name:REFRESH_DOWNLOAD_MUSIC_LIST object:nil];
}

#pragma  mark -- 通知

- (void)checkMusicData:(NSNotification *)notification {
    NSDictionary *dict = notification.object;
    if (!dict) {
        return;
    }
    NSNumber *musicID = dict[@"musicID"];
      [self updateUI:musicID];
}
-(void)cancelSucess:(NSNotification*)noti{
    
    NSDictionary* dict = (NSDictionary*)noti.object;
    NSDictionary* data = dict[@"data"];
    if (!data) {
        return;
    }
    NSNumber * musicID = data[@"serverId"];
    [[D5HJMusicDownloadList shareInstance]removeDownloadMusicData:musicID];
    [ self alertMusicDownloadStatus:musicID.integerValue isCanDownload:NO];
    
}

//更新UI视图（下载提示View和音乐列表数据）
- (void)updateUI:(NSNumber *)musicID {
    [self alertMusicDownloadStatus:[musicID integerValue] isCanDownload:NO];
}


-(void)initView {
     self.navigationItem.title = @"添加歌曲";
    //navgation
    [D5BarItem setLeftBarItemWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(back)];
    [D5BarItem addRightBarItemWithText:@"上传" color: WHITE_COLOR target:self action:@selector(uploadMusicAction)];
     _slideView = [[UIView alloc]init];
    [_slideView setFrame:[self getSlildFrame:ADD_MUSIC_LIST_RECOMMOND]];
    [_slideView setBackgroundColor:[UIColor colorWithHex:0xFFD400 alpha:1.0]];
    [self.view addSubview:_slideView];
    [_recmmondBtn setSelected:YES];
    [_languageBtn setEnlargeEdgeWithTop:5 right:20 bottom:5 left:10];
    [_styleBtn setEnlargeEdgeWithTop:5 right:20 bottom:5 left:10];
    //设置搜素框的圆角
    [searchView setViewFillet:5.0 color:self.view.backgroundColor borderWidth:1.0];
    [textfiledSearch setDelegate:self];
    //添加下拉刷新
    [self addTableviewHeader];
}

-(void)addTableviewHeader
{
    //Tableview Header下拉刷新
     MJRefreshAutoStateFooter*footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableview.tableFooterView = [UIView new];
    [footer setTitle:@"松开加载" forState: MJRefreshStatePulling];
    [footer setTitle:@"正在加载" forState: MJRefreshStateRefreshing];
    [footer setTitle:@"所有数据加载完毕，没有更多的数据了" forState: MJRefreshStateNoMoreData];
    _tableview.mj_footer = footer;
}

-(void)initData {
    _nowSelectCategory = ADD_MUSIC_LIST_RECOMMOND;
    _nowpage = 0;
    _musicList = [NSMutableArray array];
    _categoryBtnArray = @[_recmmondBtn,_languageBtn,_styleBtn];
    [self getClassifyList];//获取分类列表
    isFirst = YES;
    [self getRecommendAllMusic:YES];//获取推荐歌曲列表
    quenue = dispatch_queue_create("DownLoad", DISPATCH_QUEUE_SERIAL);
    //获取下载列表
    [self getCentreBoxDownloadingMusicList];
}
#pragma  mark -- 音乐数据
//获取分类列表
-(void)getClassifyList
{
    __weak typeof(self) weakSelf = self;
    [D5SearchMusicModel getClassifyMusic:^(id response) {
        @autoreleasepool {
            NSArray*class=[response valueForKey:@"风格"];
            weakSelf.classifyArray = class;
            NSArray*language = [response valueForKey:@"语种"];
            weakSelf.languageArray = language;
        }
       
    } fail:^(NSError *error) {
    }];

}

//下拉刷新
-(void)refresh
{
    [self endRefresh];
}
//加载更多
-(void)loadMore
{
    //如果当前选择的项为推荐加载推荐下所有的歌曲
    if (_nowSelectCategory == ADD_MUSIC_LIST_RECOMMOND) {
        [self getRecommendAllMusic:NO];
    }else {
    
        [self getClassifyAllSongs:NO];
    }
}

/**
 * 更新视图.
 */
-(void)updateView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL hiden = ([NSArray isNullArray:_musicList] == 0 ) ? NO : YES;
        [_nullDataView setHidden:!hiden];
        [_tableview reloadData];
    });
}

/**
 *  停止刷新
 */
-(void)endRefresh{
    
    [_tableview.mj_header endRefreshing];
    [_tableview.mj_footer endRefreshing];
}

//获取分类歌曲列表
-(void)getClassifyAllSongs:(BOOL)isRefresh
{
    NSInteger pageNum = PAGENUM;
    [self showLoading];
    //参数
    NSString*parament=[NSString stringWithFormat:@"{\"cmd\":8,\"cid\":%ld,\"nowPage\":%ld,\"pageNum\":%ld}",(long)_currentCategoryID.integerValue,(long)_nowpage,(long)pageNum];
    
    __weak typeof(self) weakSelf = self;

    [D5SearchMusicModel getClassifyAllSongs:parament cmd:8 TotalPage:^(NSInteger totalPage) {
       
    } success:^(id response) {
       
        [self hidenLoading];
        if ([response count] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endRefresh];
            });
        }
        [self checkLocalMusicDownload:response];
        _nowpage ++;
        [_musicList addObjectsFromArray:response];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
            [weakSelf endRefresh];
        });
    } fail:^(NSError *error) {
        [self hidenLoading];
        [weakSelf endRefresh];
    }];
}

-(void)showLoading {
  [MBProgressHUD showLoading:@"" toView:self.view];
}
-(void)hidenLoading {
  [MBProgressHUD hideHUDForView:self.view];
}
//获取推荐歌曲
-(void)getRecommendAllMusic:(BOOL)isRefresh
{
    NSInteger pageNum = PAGENUM;//每页20个元素
    NSString*parament=[NSString stringWithFormat:@"{\"cmd\":7,\"pageNum\":%ld,\"nowPage\":%ld}",(long)pageNum,_nowpage];
    __weak typeof(self) weakSelf = self;
    [self showLoading];
    [D5SearchMusicModel getRecomondAllSongs:parament cmd:7 TotalPage:^(NSInteger totalPage) {
    } success:^(id response) {
        [self hidenLoading];
        [weakSelf endRefresh];
         NSArray* array = (NSArray*)response;
        if (array.count == 0) {
            return ;
        }
        [self checkLocalMusicDownload:response];
        _nowpage ++;
       // 叠加数据
        [weakSelf.musicList addObjectsFromArray:response];
        [weakSelf updateView];
        
    } fail:^(NSError *error) {
        [self hidenLoading];
        [weakSelf endRefresh];
    }];
}



#pragma  mark -- 下载

//开始下载
- (void)startDownloadSingelMusic:(NSInteger)musicID {
    
    dispatch_async(quenue, ^{
        
        [[D5DownLoadMusic shareInstance] downloadMusicByID:musicID];
    });
}
-(NSInteger)getDownloadingCout{
    
    return [D5HJMusicDownloadList shareInstance].list.count;
}
//添加一条新纪录到临时的全局数组(当从中控上拉取到最新的数据时替换）
-(void)addNewDownloadRecorder:(D5MusicLibraryData*)data {
    @autoreleasepool {
        D5HJMusicDownloadManageModel* obj = [[D5HJMusicDownloadManageModel alloc] init];
        obj.progress = 0.0f;
        obj.downloadStatus = UpdateDownloadStatusReady;
        obj.albumURL = data.albumURL;
        obj.albumTitle = data.album;
        obj.musicName = data.musicName;
        obj.singer = data.musicSinger;
        obj.musicID =  @(data.musicId);
        obj.musicURL = [data.musicURL absoluteString];
        
        [[D5HJMusicDownloadList shareInstance] addDownloadMusicList:obj];
    }
}

//检查本地正在下载的音乐和网络获取的音乐列表的音乐比较（）
-(void)checkLocalMusicDownload:(NSArray*)array{
    if ([NSArray isNullArray:array]) {
        return;
    }
    for (D5MusicLibraryData * data in array) {
        if ([data isKindOfClass:[D5MusicLibraryData class]]) {
            data.isNOPermitDownload = NO;
            [ [D5HJMusicDownloadList shareInstance].list enumerateObjectsUsingBlock:^(D5HJMusicDownloadManageModel *obj, NSUInteger idx, BOOL *stop) {
                //如果网络上获取的音乐已经在中控的下载列表里面，不能再重复下载
                if (obj.musicID.integerValue == data.musicId) {
                    data.isNOPermitDownload = YES;
                    *stop = YES;
                }
            }];
        }
    }
}
//获取中控正在下载的音乐列表
- (void)getCentreBoxDownloadingMusicList {
    dispatch_async(quenue, ^{
        //获取正在下载的音乐列表
        [[D5DownLoadMusic shareInstance] getDownloadingMusicList];
        
    });
}


-(void)upDateDownloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isHiden = ([self getDownloadingCout] > 0) ? NO : YES;
        if (_downLoadTipView.hidden != isHiden) {
            float navOffset = 44;
            float yOffset = 126.0f;
            float viewHeight = 54.0f;
            if (isHiden == NO) {
                [_downLoadTipView setFrame:CGRectMake(0, MainScreenHeight-yOffset-navOffset, MainScreenWidth, 0)];
                [UIView animateWithDuration:0.8 animations:^{
                [_downLoadTipView setFrame:CGRectMake(0, MainScreenHeight - yOffset-viewHeight-navOffset, MainScreenWidth, viewHeight)];
                    
                } completion:^(BOOL finished) {
                }];
                [_downLoadTipView setHidden:isHiden];
            }else{
                
                [_downLoadTipView setFrame:CGRectMake(0, MainScreenHeight - yOffset-viewHeight-navOffset, MainScreenWidth, viewHeight)];
                [UIView animateWithDuration:0.8 animations:^{
                    [_downLoadTipView setFrame:CGRectMake(0, MainScreenHeight - yOffset-navOffset, MainScreenWidth, 0)];
                } completion:^(BOOL finished) {
                   [_downLoadTipView setHidden:isHiden];
                }];
            }
        }
        [_downloadMusicTipLable setText:[NSString stringWithFormat:@"%lu首歌曲正在下载",(unsigned long)[self getDownloadingCout]]];
    });
}

#pragma  mark -- 下载音乐委托方法

- (void)downloadFinished:(NSNumber *)musicID {
    DLog(@"下载完成-----");
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.isNeedRefresh = YES;
    });
    
}
// 获取正在下载下载的音乐列表的代理方法
-(void)getDownloadingMusicListFish:(BOOL)isFish response:(NSDictionary *)response {
    if (isFish) {
        //更新下载列表
        [self upDateDownloadView];
    }
}

#pragma  mark --用户交互
//音乐下载管理
- (IBAction)downloadMusicListAction:(id)sender {
    
       [self.navigationController pushViewController:self.downLoadMusicVC animated:YES];
}
//选择推荐
- (IBAction)slectRecommond:(UIButton*)sender {
    
    _nowSelectCategory = ADD_MUSIC_LIST_RECOMMOND;
    [self setMildeSlideView:ADD_MUSIC_LIST_RECOMMOND];
    [self setCategorySlecteBtnUI:sender];
    //获取数据
    [_musicList removeAllObjects];
    _nowpage = 0;
    [self getRecommendAllMusic:YES];
    //将风格和语言重置成初始标题
    [self.styleBtn setTitle:@"风格" forState:UIControlStateNormal];
    [self.languageBtn setTitle:@"语种" forState:UIControlStateNormal];
}
//显示popviewUI
-(void)showPopViewUI:(NSInteger)category{
   
      //设置PopView数据
     [self.popview setDataList:(category == ADD_MUSIC_LIST_LAGUAGE) ?  self.languageArray:self.classifyArray selctedCategory:_currentCategoryName];
    [self.popview setCategoryID:category];
    __weak __typeof(self)weakSelf = self;
    self.popview.selectedMusicCategoryList = ^(NSString*musicClassfyName,NSString*musicClassfyID,NSInteger categoryID)
        {
            _currentCategoryID = musicClassfyID;//当前选择的歌曲分类ID
            _currentCategoryName = musicClassfyName;//当前选择的歌曲分类名称
            _nowpage = 0;
            _nowSelectCategory = (int)categoryID;
            [weakSelf.musicList removeAllObjects];
            //选择分类歌曲后分类标题显示
            if (categoryID == ADD_MUSIC_LIST_LAGUAGE) {
    
                [weakSelf.languageBtn setTitle:musicClassfyName forState:UIControlStateNormal];
                [weakSelf.styleBtn setTitle:@"风格" forState:UIControlStateNormal];

             }else {
                [weakSelf.languageBtn setTitle:@"语种" forState:UIControlStateNormal];
                [weakSelf.styleBtn setTitle:musicClassfyName forState:UIControlStateNormal];
            }
            //获取分类歌曲列表
             [weakSelf getClassifyAllSongs:NO];
        };
    
    if (![self isContainPopView]) {
        [self.view addSubview:_popview];
    }

}
//选择语言
- (IBAction)selectLanguage:(UIButton*)sender {

    [self setMildeSlideView:ADD_MUSIC_LIST_LAGUAGE];
    [self setCategorySlecteBtnUI:sender];
    [self showPopViewUI:ADD_MUSIC_LIST_LAGUAGE];
    
   }
//选择风格
- (IBAction)selcteStyle:(UIButton*)sender {
    [self setMildeSlideView:ADD_MUSIC_LIST_STYLE];
    [self setCategorySlecteBtnUI:sender];
    [self showPopViewUI:ADD_MUSIC_LIST_STYLE];
}

//选项按钮UI更新
-(void)setCategorySlecteBtnUI:(UIButton*)sender{
    for (UIButton*btn in _categoryBtnArray) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            if (btn == _recmmondBtn) {
                [self.styleBtn setTitle:@"风格" forState:UIControlStateNormal];
                [self.languageBtn setTitle:@"语种" forState:UIControlStateNormal];
            }else if (btn == _languageBtn) {
                BOOL isDown = !self.popview.hidden;
                [self.popview hidenView:!self.popview.hidden];
                [_languagePop setImage:isDown ? music_popup_down_yellow : music_popup_up forState:UIControlStateNormal];
                
            }else if(btn == _styleBtn){
                BOOL isDown = !self.popview.hidden;
                 [self.popview hidenView:!self.popview.hidden];
                [_stylePop setImage:isDown ? music_popup_down_yellow : music_popup_up forState:UIControlStateNormal];
            }
        }else{
            btn.selected = NO;
            if (btn == _languageBtn) {
                [_languagePop setImage:music_popup_down forState:UIControlStateNormal];
            }else if(btn == _styleBtn){
                [_stylePop setImage:music_popup_down forState:UIControlStateNormal];
            }
        }
    }


}
//切换分类UI滑动条动画
-(void)setMildeSlideView:(NSInteger)page
{
         __weak typeof(self) weakSelf = self;
   
    dispatch_async(dispatch_get_main_queue(), ^{
         //黄色滑动条的坐标动画
        [UIView animateWithDuration:0.4f animations:^{
            
            [weakSelf.slideView setFrame:[self getSlildFrame:page]];
        }];
    });

}
//根据当前选择项确定滑动条的frame
-(CGRect)getSlildFrame:(NSInteger)page{

    float x = 0.0f;
    static float y = 166.0f;//Y坐标固定
    float width = 0.0f;
    static float height = 2.0f;
    static float mildleOffset = 14.0f;//滑动条在中间的便宜量
    static float rightDistance= 94.0f;//滑动条距离右边的距离
    switch (page) {
        case ADD_MUSIC_LIST_RECOMMOND:
        {
            x = 46;
            width = 50.0f;
        }
            break;
        case ADD_MUSIC_LIST_LAGUAGE:
        {
            x = (MainScreenWidth/2.0)- mildleOffset;
            width = 50;
        }
            break;
            
        default:
        {
            x = MainScreenWidth - rightDistance;
            width = 50;
        }
            break;
    }

    return CGRectMake(x, y, width, height);
}
//上传按钮
-(void)uploadMusicAction
{
    [self resignGuideTip];
    if (![self isHidenPopView]) {
        [self.popview hidenView:YES];
        return;
    }
  
    if ([self isContainButtomSheet]) {
        
        [_sheetVC hideAnimation:YES];
        return;
    }
  
    [self.navigationController addChildViewController:self.sheetVC];
    
    [self.sheetVC setAnimation:self animation:YES];
  

}

//底部sheet是否包含在界面上面
-(BOOL)isContainButtomSheet{

    return [self.view.subviews containsObject:_sheetVC.view];
    
}
//弹出toast
-(void)showToast:(NSString*)message
{
    //只显示文字
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.margin = 10.f;
    hud.location = MBProgressHUDLocationBottom;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3.0f];

}

//
-(void)back {
    if (![self isHidenPopView]) {
        [self.popview hidenView:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:NO];
    
   
}
-(void)shoPopView{

    dispatch_async(dispatch_get_main_queue(), ^{
        if(_nowSelectCategory == ADD_MUSIC_LIST_LAGUAGE){
            [_languagePop setImage:music_popup_up forState:UIControlStateNormal];
            [_stylePop setSelected:NO];
        }else if (_nowSelectCategory == ADD_MUSIC_LIST_STYLE){
            [_languagePop setSelected:NO];
            [_stylePop setImage:music_popup_up forState:UIControlStateNormal];
            
        }
        [self.popview hidenView:NO];
 
    });
}

//是否包含了popview
-(BOOL)isContainPopView
{
    return [self.view.subviews containsObject:self.popview];
}
//是否已经隐藏了popview
-(BOOL)isHidenPopView
{
   return  [self.popview isHidden];

}
//修改当前歌曲列表的下载状态
/*
 msuicID为当前下载的音乐ID
 isdownload 为是否可以下载
 */
-(void)alertMusicDownloadStatus:(NSInteger)musicID isCanDownload:(BOOL)isDownload{
    [_musicList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        D5MusicLibraryData *data = (D5MusicLibraryData *)obj;
        if (data.musicId == musicID) {
            data.isNOPermitDownload  = isDownload;
            *stop = YES;
        }
    }];
    [self upDateDownloadView];
    [self updateView];
}
//获取当前显示的数据列表
-(NSMutableArray*)getCuurentShowDatalist{
    return _musicList;
}
//获取每一行的数据进行显示（根据当前选择分类ID到不同的分类数组列表获取数据）
-(D5MusicLibraryData*)getmusicLibraryData:(NSInteger)row
{
    D5MusicLibraryData*data = _musicList [row];
     return data;

}

#pragma mark --tableview Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return _musicList.count;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 54.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    D5AddMusicListCell*cell = [tableView dequeueReusableCellWithIdentifier:AddMusicListIndentifer];
    
    if (!cell) {
        cell = [[D5AddMusicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddMusicListIndentifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = indexPath.row;
    if (row < _musicList.count) {
        [cell setBackgroundColor:(row % 2 == 0) ? MUSIC_CELL_LOWBLACk : MUSIC_CELL_BLACk];
        
        D5MusicLibraryData *data = _musicList[row];
        if (data) {
            [cell setData:data];
        }
        
        __weak D5AddMusicListController *weakSelf = self;
        cell.downloadMusic = ^(D5MusicLibraryData *downloadData) {
            [MobClick event:UM_ADD_MUSIC_TYPE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", UMAddMusicTypeDownload]}];
            
            //修改歌曲下载状态
            [weakSelf alertMusicDownloadStatus:downloadData.musicId isCanDownload:YES];
            
            //添加新的歌曲下载记录
            [weakSelf addNewDownloadRecorder:downloadData];
            
            //显示正在下载View
            [weakSelf upDateDownloadView];
            
            //开始下载
            [weakSelf startDownloadSingelMusic:downloadData.musicId];
        };
    }
    return cell;
}
 - (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict{
    if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Trans_Progress ) {
        
            NSLog(@"%@",dict);
    }


}

#pragma  mark --UI监听事件

//点击其他view收回事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self hidenPopView];
}

//影藏键盘弹出搜索歌曲
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     [textField resignFirstResponder];
    
//    [self hidenPopView];
    MKJFirstViewController * first = [[MKJFirstViewController alloc]init];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:first];
    first.view.frame = self.view.bounds;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        nvc.popoverPresentationController.sourceView = textField;
        nvc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    }
    
    [self.navigationController presentViewController:nvc animated:NO completion:^{
    }];
    return NO;
}
//键盘返回键收回键盘

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    
    return YES;

}
@end
