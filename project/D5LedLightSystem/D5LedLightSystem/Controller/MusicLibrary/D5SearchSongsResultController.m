//
//  D5SearchSongsResultController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//  Modify by zy on 16/11/19 -- downloadMusicToCentreBox:
//
//

#import "D5SearchSongsResultController.h"
#import "D5RearchMusicResultCell.h"
#import "D5SearchMusicModel.h"
#import "D5MusicLibraryData.h"
#import "D5DownLoadMusic.h"
#import "D5HJMusicDownloadList.h"
#import "D5DownLoadMusic.h"
#import "D5HJMusicDownloadListManageController.h"
#import "NSArray+Helper.h"
@interface D5SearchSongsResultController()<UITableViewDataSource,UITableViewDelegate, D5LedCmdDelegate, D5LedNetWorkErrorDelegate, D5DownLoadMusicDelegate>

{
    NSInteger _totalPage;//当前页
    NSInteger _totalPageNum;//分页总数
    dispatch_queue_t quenue;
    
 
}
@property (weak, nonatomic) IBOutlet UITableView * tableview;

@property(nonatomic,strong)UIView*searchFailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipOriginY;
@property (weak, nonatomic) IBOutlet UIView *downLoadTipView;
@property (weak, nonatomic) IBOutlet UILabel *downloadMusicTipLable;
@property (nonatomic, strong)D5HJMusicDownloadListManageController *downLoadMusicVC;



@end
static NSInteger  SearchMUsicPageNum = 80;

@implementation D5SearchSongsResultController

-(void)viewDidLoad
{
    [super viewDidLoad];
    quenue = dispatch_queue_create("DownLoadSearch", DISPATCH_QUEUE_SERIAL);
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMusicList:) name:@"checkMusicData" object:nil];
    [self initView];//初始化view
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    
    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchKeyWorlds = nil;
    [_searchList removeAllObjects];
    [_tableview reloadData];
    [_searchNullDataView setHidden:YES];
}

-(void)updateMusicList:(NSNotification*)notification{
    NSDictionary *dict = notification.object;
    if (!dict) {
        return;
    }
    NSNumber *music = dict[@"musicID"];
    [self alertMusicDownloadStatus:music.integerValue status:NO];
    [self upDateDownloadView];
    

}
-(void)upDateDownloadView
{
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BOOL isHiden = ([D5HJMusicDownloadList shareInstance].list.count > 0) ? NO : YES;
            [_downLoadTipView setHidden:isHiden];
            [_downloadMusicTipLable setText:[NSString stringWithFormat:@"%lu首歌曲正在下载",(unsigned long)[D5HJMusicDownloadList shareInstance].list.count]];
            
        });
    }
}

#pragma mark --私有方法

-(void)initView {
    
    _tableview.tableFooterView = [UIView new];
//    _tableview.contentInset = UIEdgeInsetsMake(0, 0, 74, 0);
    [_tableview setBackgroundColor:MUSIC_CELL_BLACk];
    [self.view setBackgroundColor:MUSIC_CELL_BLACk];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)showToast:(NSString*)message{
 
    [iToast showButtomTitile:message];
    
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
-(void)removeFailView{
    
    if([self failViewExist]){
        
        [self.searchFailView removeFromSuperview];
    }

}
-(D5HJMusicDownloadListManageController*)downLoadMusicVC
{
    if (!_downLoadMusicVC) {
        
        _downLoadMusicVC = [[UIStoryboard storyboardWithName:MUSICLIBRARY_STORYBOARD_ID bundle:nil]instantiateViewControllerWithIdentifier:@"D5HJMusicDownloadListManageController"];
    }
    return _downLoadMusicVC;
}

- (IBAction)downloadMusicManage:(id)sender {
    
    [self.navigationController pushViewController:self.downLoadMusicVC animated:YES];
    
}

#pragma  amrk --下载管理

//是否存在失败View
-(BOOL)failViewExist
{
  return  [self.view.subviews containsObject:self.searchFailView];

}
#pragma  mark --公开方法


//开始搜索歌曲
-(void)startsearch:(NSString*)keyWorlds{
    
      _totalPage = 0;
      _searchKeyWorlds = keyWorlds;
//      [_searchList removeAllObjects];
     _searchList = [NSMutableArray array];
     [self getkeyworldsSearcList:keyWorlds type:0];
}

//根据关键字获取到搜索的结果
-(void)getkeyworldsSearcList:(NSString*)key type:(NSInteger)type
{
    //以前老版本
    NSString*parentURLString = [NSString stringWithFormat:@"/%@/%ld/%ld/%ld",key,(long)type,(long)SearchMUsicPageNum,_totalPage];
   
    //拼接URL
    parentURLString = [NSString stringWithFormat:@"{\"cmd\":10,\"nowPage\":%ld,\"pageNum\":%ld,\"key\":\"%@\"}",(long)_totalPage,(long)SearchMUsicPageNum,key];

    NSLog(@"当前关键字:%@,当前页数:%ld",key,(long)_totalPage);
    [D5SearchMusicModel getSearchKeyworldsAllSongs:parentURLString cmd:10 TotalPage:^(NSInteger totalPage) {
        
        _totalPageNum = totalPage;//当前页
        
    } success:^(id response) {
        
        NSArray* tempData = response[@"data"];
        NSString*keyworlds = response[@"keyWorlds"];
        if ((![keyworlds isEqualToString:_searchKeyWorlds]) || [NSArray isNullArray:tempData]) {
             [self updateMusicResultUI];
            return ;
        }
//        [_searchList removeAllObjects];
        //检测搜索出来的商品本地是否有下载记录
        [self checkLocalMusicDownload:tempData];
       
        [_searchList addObjectsFromArray:tempData];
        [self updateMusicResultUI];
        
    } fail:^(NSError *error) {
        
        [self updateMusicResultUI];
      
    }];
    

}

-(void)updateMusicResultUI{

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_searchList.count == 0) {
            [_searchNullDataView setHidden:NO];
        }else{
            [_searchNullDataView setHidden:YES];
        }
        [_tableview reloadData];
    });

}


-(void)checkLocalMusicDownload:(NSArray*)array{
    if ([NSArray isNullArray:array]) {
        return;
    }
    for (D5MusicLibraryData* data in array) {
    
    data.isNOPermitDownload = NO;
    [ [D5HJMusicDownloadList shareInstance].list enumerateObjectsUsingBlock:^(D5HJMusicDownloadManageModel *obj, NSUInteger idx, BOOL *stop) {
            
    if (obj.musicID.integerValue == data.musicId) {
        data.isNOPermitDownload = YES;
            
        *stop = YES;
    }

    }];
        
    }
    
}


#pragma mark -- Tableview-Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(0 == _searchList.count){
//        [self showSearchFailView];
//    }else
//    {
//        [self removeFailView];
//        
//    }
    
    return _searchList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    D5RearchMusicResultCell* cell = [tableView dequeueReusableCellWithIdentifier:RearchMusicResult];
    
    // 换行改变cell的不同颜色
    [cell setBackgroundColor:(indexPath.row % 2 == 0) ? MUSIC_CELL_LOWBLACk : MUSIC_CELL_BLACk];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    NSInteger row = indexPath.row;
    if (row == _searchList.count -1 && _totalPage <= _totalPageNum) {
       _totalPage++;
        [self getkeyworldsSearcList:_searchKeyWorlds type:0];
    }
    if (_searchList && row < _searchList.count) {
        //设置数据
        D5MusicLibraryData *model = _searchList[row];
        
        NSString *musicName = model.musicName;
        if ([NSString isValidateString:musicName]) {
            NSString *noSuffixName = [musicName stringByDeletingPathExtension];
            NSMutableAttributedString *songName = [self attrSongNameBySongName:noSuffixName searchName:_searchKeyWorlds];
            //添加歌手和专辑
            NSMutableAttributedString *singerName;
            NSString*singerAblumText;
            if([NSString isValidateString:model.album]){
                //添加歌手和专辑
                singerName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@", model.musicSinger,model.album]];
                //获取要调整颜色的文字位置,调整颜色
                singerAblumText = [NSString stringWithFormat:@"%@ - %@",model.musicSinger,model.album];
            }else{
                //添加歌手和专辑
                singerName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", model.musicSinger]];
                //获取要调整颜色的文字位置,调整颜色
                singerAblumText = [NSString stringWithFormat:@"%@",model.musicSinger];
                
            }
            NSRange singerNameRange = [[singerAblumText lowercaseString]rangeOfString:_searchKeyWorlds.lowercaseString ];
            if (singerNameRange.location != NSNotFound){
                [singerName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffd400 alpha:1.0] range:singerNameRange];
            }
            
            cell.songsName.attributedText = songName;
            cell.singerName.attributedText = singerName;
            cell.selectData = model;
           UIImage*downloadImage = (!model.isNOPermitDownload) ? IMAGE(@"music_icon_download1") : IMAGE(@"music_icon_download2");
            [cell.downloadMusicBtn setImage:downloadImage forState:UIControlStateNormal];
            //开始下载搜索的歌曲到中控盒子
            cell.downLoadMusic = ^(D5MusicLibraryData* selecteData) {
                [MobClick event:UM_ADD_MUSIC_TYPE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", UMAddMusicTypeDownload]}];
                
                 [self addNewDownloadRecorder:selecteData];
                //修改歌曲当前的下载状态
                [self alertMusicDownloadStatus:selecteData.musicId status:YES];
                [self upDateDownloadView];

                dispatch_async(quenue, ^{
                [[D5DownLoadMusic shareInstance] downloadMusicByID:selecteData.musicId];
                });
                
            };

        }
    }
    
    
    return cell;

}
-(void)updateView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_tableview reloadData];
        
    });
}
//修改当前歌曲列表的下载状态
-(void)alertMusicDownloadStatus:(NSInteger)musicID status:(BOOL)isNoPermitDownload{
    
  
    if (!_searchList) {
        return;
    }
    for ( D5MusicLibraryData*obj  in _searchList) {
        
        if (obj.musicId == musicID) {
            
            obj.isNOPermitDownload = isNoPermitDownload;
            break;
        }
    }
    [self updateView];
    
}
//下载所有的歌曲
-(void)downLoadAllSongs{
    
    D5HJMusicDownloadManageModel*obj = [[D5HJMusicDownloadList shareInstance] getNeedDownloadModel];
    if (obj == nil) {
        NSLog(@"暂时没有需要下载的歌曲");
        return;
    }
    
    [self startDownloadSingelMusic:obj.musicID.integerValue];
}

-(void)startDownloadSingelMusic:(NSInteger)musicID
{
    [D5DownLoadMusic shareInstance].delegate = self;
    //开始下载
    [[D5DownLoadMusic shareInstance] downloadMusicByID:musicID];
    NSLog(@"开始下载的音乐ID:%ld",musicID);
    
}


-(void)addNewDownloadRecorder:(D5MusicLibraryData*)data
{
    D5HJMusicDownloadManageModel* obj = [[D5HJMusicDownloadManageModel alloc]init];
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

#pragma mark - 生成有颜色的关键字
- (NSMutableAttributedString *)attrSongNameBySongName:(NSString *)songName searchName:(NSString *)searchName {
    @autoreleasepool {
        // 生成 NSMutableAttributedString 搜索关键字加突出颜色
        NSMutableAttributedString *songsName = [[NSMutableAttributedString alloc] initWithString:songName];
        
        //获取要调整颜色的文字位置,调整颜色
        NSRange songsNameRange = [[songName lowercaseString] rangeOfString:[searchName lowercaseString]];
        [songsName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffd400 alpha:1.0] range:songsNameRange];
        
        return songsName;
    }
}

#pragma mark - 下载结果
- (void)downLoadFinish:(BOOL)isFinish {
    if (isFinish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[D5DownLoadMusic shareInstance] pushToMusicVCAndRefresh];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"歌曲下载失败，请重新下载" toView:self.view];
        });
    }
}


@end