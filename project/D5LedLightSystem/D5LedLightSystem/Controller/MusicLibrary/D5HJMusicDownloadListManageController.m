//
//  D5HJMusicDownloadListManageController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5HJMusicDownloadListManageController.h"
#import "D5HJMusicDownloadListCell.h"
#import "D5HJMusicDownloadEditController.h"
#import "MJRefresh.h"
#import "D5HJMusicDownloadManageModel.h"
#import "D5DownloadList.h"
#import "D5HJMusicDownloadList.h"
#import "NSArray+Helper.h"
#import "D5DownLoadMusic.h"
#import "D5AddMusicListController.h"
#import "D5SearchSongsResultController.h"
#import "MKJFirstViewController.h"

@interface D5HJMusicDownloadListManageController ()<UITableViewDataSource,UITableViewDelegate, D5DownLoadMusicDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *dataTipView;//没有下载歌曲View提示
@property(strong,nonatomic)UIButton*barButton;
@property(strong,nonatomic)UIBarButtonItem* barItem;
@property(strong,nonatomic)D5HJMusicDownloadList*downloadListManage;

@end

@implementation D5HJMusicDownloadListManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _downloadListManage = [D5HJMusicDownloadList shareInstance];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteDownloadMusicNoti) name:@"deletemusicfinish" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelSucess:) name:@"cancelDownloading" object:nil];
    [self initView];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [D5DownLoadMusic shareInstance].delegate = self;
     [self getDownloadMusicList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [D5DownLoadMusic shareInstance].delegate = nil;

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark --私有方法
// 获取正在下载的音乐列表（每一次进这个页面拉取更新一次）
- (void)getDownloadMusicList {
    [[D5DownLoadMusic shareInstance] getDownloadingMusicList];
}
//当前下载的下载个数
-(NSInteger)getDownloadMusicCount{
    return _downloadListManage.list.count;
}
//是否隐藏缺省页面
-(BOOL)isHidenNullTipView{

    return ([self getDownloadMusicCount] == 0) ? NO: YES;
    
}
#pragma  mark --通知
//删除下载的歌曲
-(void)cancelSucess:(NSNotification*)noti{
    
    NSDictionary* dict = (NSDictionary*)noti.object;
    NSDictionary* data = dict[@"data"];
    if (!data) {
        return;
    }
    NSNumber * musicID = data[@"serverId"];
    [[D5HJMusicDownloadList shareInstance]removeDownloadMusicData:musicID];
    [self upDataView];
}


//删除完歌曲通知
-(void)deleteDownloadMusicNoti{

    [self upDataView];
}
-(void)upDataView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
}

#pragma mark - 网络代理
//获取正在下载的音乐列表
- (void)getDownloadingMusicListFish:(BOOL)isFish response:(NSDictionary *)response {
    if (isFish) {
        [self upDataView];
    }
}
//更新下载进度
- (void)progressUpdated {
    DLog(@"manager中进度更新了 --- ");
    [self upDataView];
}
//下载歌曲完成一首回调
- (void)downloadFinished:(NSNumber *)musicID {
    DLog(@"manager中下载完成 --- ");
    [self upDataView];
}

-(void)back{

    for (UIViewController*vc in self.navigationController.viewControllers) {
        
        //返回到歌曲推荐页面
        if([vc isKindOfClass:[D5AddMusicListController class]]){
        
            D5AddMusicListController* obj = (D5AddMusicListController*)vc;
            [obj upDateDownloadView];
            
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
        
        if ([vc isKindOfClass:[MKJFirstViewController class]]) {
            
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
         }
    
}


#pragma  mark -- 用户交互

-(void)editMusic{

    if (![self getDownloadMusicCount]) {
        return;
    }
    D5HJMusicDownloadEditController *vc = [[UIStoryboard storyboardWithName:MUSICLIBRARY_STORYBOARD_ID bundle:nil]instantiateViewControllerWithIdentifier:@"D5HJMusicDownloadEditController"];
    [self.navigationController pushViewController:vc animated:NO];

}
#pragma  mark -- 初始化View

-(void)initView{

    self.navigationItem.title = @"歌曲下载";
    //navgation
    [D5BarItem setLeftBarItemWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(back)];
    [self addRightBarItemWithText:@"编辑" color:WHITE_COLOR];
    [_tableview setTableFooterView:[UIView new]];

}

//设置右边编辑按钮
- (void)addRightBarItemWithText:(NSString *)text color:(UIColor *)color {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (!_barButton) {
                _barButton = [[ UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
                [_barButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                [_barButton addTarget:self action:@selector(editMusic) forControlEvents:UIControlEventTouchUpInside];
                [_barButton setTitleColor:color forState:UIControlStateNormal];
                [_barButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateDisabled];
                button.titleLabel.font = [UIFont systemFontOfSize:VC_TITLE_FONT_SIZE];
            }
            [_barButton setTitle:text forState:UIControlStateNormal];
            
            if (!_barItem) {
                _barItem = [[UIBarButtonItem alloc] initWithCustomView:_barButton];
                self.navigationItem.rightBarButtonItem = _barItem;
            }
        });
    }
    
}

#pragma mark -- tableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tempArray = _downloadListManage.list;

    BOOL hiden = [self isHidenNullTipView];
    [self.dataTipView setHidden: hiden];
    [self.barButton setHidden:!hiden];
    DLog(@"个数 %ld", (long)[self getDownloadMusicCount]);
    return [NSArray isNullArray:tempArray] ? 0 : [self getDownloadMusicCount];
    
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
    D5HJMusicDownloadListCell*cell = [tableView dequeueReusableCellWithIdentifier:@"D5HJMusicDownloadListCell"];
    
    if (!cell) {
        cell = [[D5HJMusicDownloadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"D5HJMusicDownloadListCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    NSInteger tempRow = indexPath.row;
  
    if (![NSArray isNullArray:_downloadListManage.list] && tempRow < [self getDownloadMusicCount] )
    {
        D5HJMusicDownloadManageModel* temp = _downloadListManage.list[tempRow];
        cell.data = temp;
        [cell setDownLoadMusicCellUI:temp];
    }
  
    [cell setBackgroundColor:(tempRow % 2 == 0) ? MUSIC_CELL_LOWBLACk : MUSIC_CELL_BLACk];

        return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end