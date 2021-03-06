//
//  D5HJMusicDownloadEditController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5HJMusicDownloadEditController.h"
#import "D5HJMusicDownloadEditCell.h"
#import "D5HJMusicDownloadList.h"
#import "D5DownLoadMusic.h"
#import "D5AddMusicListController.h"
@interface D5HJMusicDownloadEditController ()<D5DownLoadMusicDelegate>
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(nonatomic,strong)NSArray*musicDataArray;
@property(strong,nonatomic)D5HJMusicDownloadList*downloadListManage;
@property(assign,nonatomic)BOOL isAllSelcte;//是否全选

@property(strong,nonatomic)UIButton*barButton;
@property (weak, nonatomic) IBOutlet UIView *nullSongsView;
@property(strong,nonatomic)UIBarButtonItem* barItem;
@property (weak, nonatomic) IBOutlet UIView *deleteTipView;
@end

@implementation D5HJMusicDownloadEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认全不选择
    _isAllSelcte = NO;
    _downloadListManage = [D5HJMusicDownloadList shareInstance];
    [self initView];
    [self getDownloadMusicList];
    [self checkMusicEdit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelSucess:) name:@"cancelDownloading" object:nil];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [D5DownLoadMusic shareInstance].delegate = self;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [D5DownLoadMusic shareInstance].delegate = nil;

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma  mark -- 通知
-(void)cancelSucess:(NSNotification*)noti{
    
    NSDictionary* dict = (NSDictionary*)noti.object;
    NSDictionary* data = dict[@"data"];
    if (!data) {
        return;
    }
    NSNumber * musicID = data[@"serverId"];
    [[D5HJMusicDownloadList shareInstance]removeDownloadMusicData:musicID];
    [[self getMusicListVC] alertMusicDownloadStatus:musicID.integerValue isCanDownload:NO];
}

#pragma  mark --私有方法

//当前下载的下载个数
-(NSInteger)getDownloadMusicCount{
    return _downloadListManage.list.count;
}
#pragma  mark -- 删除view显示
//显示和隐藏删除提示View
-(void)showDelteTipView:(BOOL)isHiden{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_deleteTipView setHidden:isHiden];
    });
}
-(BOOL)deleteTipViewisHiden{
    
    return _deleteTipView.hidden;

}

#pragma mark -- 音乐取消下载
 //开始取消下载
- (void)canecelDownloadSingelMusic:(NSArray*)musicIDArray {
   
    [[D5DownLoadMusic shareInstance] cancelDownloadMusics:musicIDArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deletemusicfinish" object:nil];
//     [MBProgressHUD showLoading:@"" toView:self.navigationController.view];
     NSLog(@"取消下载的音乐:%@",musicIDArray);
      [self back];
//    [NSTimer scheduledTimerWithTimeInterval:4.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
    
//            [MBProgressHUD hideHUDForView:self.navigationController.view];
    
//    }];
}



//获取取消下载的音乐ID
- (NSMutableArray*)getCancelMusicIDArray{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray* sort = [NSArray arrayWithArray:_downloadListManage.list];
    for (D5HJMusicDownloadManageModel *obj in sort) {
        if (obj.editSelcteType == Edit_Select) {
            [tempArray addObject:obj.musicID];
        }
    }
    return tempArray;
    
}
//获取正在下载的音乐列表
- (void)getDownloadMusicList {
    
    [[D5DownLoadMusic shareInstance] getDownloadingMusicList];
}


#pragma  mark -- 音乐列表编辑

//设置音乐列表编辑状态
-(void)setListSelect:(NSNumber *)musicID seclect:(BOOL)isSelcet
{
    for (D5HJMusicDownloadManageModel* obj in _downloadListManage.list) {
        
        if (musicID.integerValue == obj.musicID.integerValue) {
            
            obj.editSelcteType = (isSelcet == YES) ? Edit_Select:Edit_NOSelect;
            break;
            
        }
    }
    
}
//是否选择了歌曲
-(BOOL)isSeclectMusic{
    BOOL isSelect = NO;
    for (D5HJMusicDownloadManageModel* obj in _downloadListManage.list) {
        if (obj.editSelcteType == Edit_Select) {
            isSelect = YES;
            break;
        }
    }
    return isSelect;
}
//设置音乐选择编辑全选状态
-(void)setListAllSelect:(BOOL)isSeclect{
    
    for (D5HJMusicDownloadManageModel* obj in _downloadListManage.list) {
        obj.editSelcteType = (isSeclect == YES) ? Edit_Select:Edit_NOSelect;
    }
}
//选择的歌曲数量
-(NSInteger)selectMusicCount{
    NSInteger count = 0;
    for (D5HJMusicDownloadManageModel* obj in _downloadListManage.list) {
        if (obj.editSelcteType == Edit_Select) {
            count = count + 1;
        }
    }
    return count;
    
}
//检测选择的歌曲
-(void)checkMusicEdit{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBtnEnable:_deleteBtn enable:[self isSeclectMusic]];
        self.navigationItem.title = [NSString stringWithFormat:@"已选择%d首歌",(int)[self selectMusicCount]];
        [_tableview reloadData];
    });
}
//全选/全不选所有音乐
-(void)selectAllMusic{
    
    if (![self deleteTipViewisHiden]) {
        return;
    }
    _isAllSelcte = ! _isAllSelcte;
    NSString* rightBtnTitle = (!_isAllSelcte ) ? @"全选":@"全不选";
    [self setListAllSelect:_isAllSelcte];
    [self checkMusicEdit];
    [self addRightBarItemWithText:rightBtnTitle color:WHITE_COLOR];
    
}



#pragma  mark -- 初始化View

//设置右边全选/全部选按钮
- (void)addRightBarItemWithText:(NSString *)text color:(UIColor *)color {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!_barButton) {
            _barButton = [[ UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
            [_barButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
            [_barButton addTarget:self action:@selector(selectAllMusic) forControlEvents:UIControlEventTouchUpInside];
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

//初始化View
-(void)initView{
    
    self.navigationItem.title = @"已选择0首歌";
    //navgation
    [D5BarItem setLeftBarItemWithTitle:@"取消" color:WHITE_COLOR target:self action:@selector(cancelEdit)];
    [self addRightBarItemWithText:@"全选" color:WHITE_COLOR];
    [self setBtnEnable:_deleteBtn enable:NO];

    [_tableview setTableFooterView:[UIView new]];
    
}
-(void)updateView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
             [_tableview reloadData];
    });
}


#pragma  mark -- 用户交互
//取消删除
- (IBAction)cancelDeleteMusic:(id)sender {
    
    [self showDelteTipView:YES];
}

//确定删除音乐
- (IBAction)sureDeleteMusic:(id)sender {
    [self showDelteTipView:YES];
    //取消音乐下载
    [self canecelDownloadSingelMusic:[self getCancelMusicIDArray]];
}

//删除歌曲
- (IBAction)deleteAction:(id)sender {
    [self showDelteTipView:NO];
}

//取消音乐编辑
-(void)cancelEdit{
    
    if (![self deleteTipViewisHiden]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma  mark --下载完成一首歌曲
- (void)downloadFinished:(NSNumber *)musicID {
    DLog(@"editing中下载完成 --- ");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self checkMusicEdit];
    });
}
#pragma  mark -- 取消音乐下载
-(void)cancelMusicDownloadFish:(BOOL)isFish musicID:(NSNumber *)musicID {
    //    [MBProgressHUD hideHUDForView:self.view];
    if (isFish) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deletemusicfinish" object:nil];
        
    }
}

-(D5AddMusicListController*)getMusicListVC{

    for (UIViewController*vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[D5AddMusicListController class]]) {
            
            return (D5AddMusicListController*)vc;
        }
    }
    
    return nil;
}

#pragma mark -- tableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    BOOL isHiden = ([self getDownloadMusicCount] == 0) ? NO : YES;
    if (!isHiden) {
        [self back];
    }
//    [_nullSongsView setHidden:isHiden];
//    [_barButton setHidden:!isHiden];
    
    return [self getDownloadMusicCount];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 54.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    D5HJMusicDownloadEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"D5HJMusicDownloadEditCell"];
    if (!cell) {
        cell = [[D5HJMusicDownloadEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"D5HJMusicDownloadEditCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = indexPath.row;
    [cell setBackgroundColor:(row % 2 == 0) ? MUSIC_CELL_LOWBLACk : MUSIC_CELL_BLACk];
    
    if (row < [self getDownloadMusicCount]) {
        D5HJMusicDownloadManageModel * temp = _downloadListManage.list[row];
        [cell setUIforMusicData:temp];
        
        __weak D5HJMusicDownloadEditController *weakSelf = self;
        cell.selectEdit = ^(BOOL isSelect,NSNumber *musicID){
            //设置单选
            [weakSelf setListSelect:musicID seclect:isSelect];
            [weakSelf checkMusicEdit];
        };
    }
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
