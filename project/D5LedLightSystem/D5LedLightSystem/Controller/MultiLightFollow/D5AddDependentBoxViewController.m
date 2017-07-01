//
//  D5AddDependentBoxViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/24.
//  Copyright © 2016年 PangDou. All rights reserved.
//


#import "D5AddDependentBoxViewController.h"
#import "D5ConnectZKTCell.h"
#import "D5LedLinkDevice.h"

#define SEARCH_TIMEOUT_INTERVAL 30.0f //搜索时长

#define SEARCH_AGAIN @"重新搜索"
#define DONE_STR @"完成"

@interface D5AddDependentBoxViewController () <UITableViewDelegate, UITableViewDataSource, D5LedZKTListDelegate, D5LedLinkDeviceDelegate>

/*正在加载的图片*/
@property (weak, nonatomic) IBOutlet UIImageView *loadingImgView;

/*从属中控的tableview*/
@property (weak, nonatomic) IBOutlet UITableView *boxTableView;

/*搜索失败的view*/
@property (weak, nonatomic) IBOutlet UIView *failedView;

/*下面的按钮--完成/重新搜索*/
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
- (IBAction)btnBottomClicked:(UIButton *)sender;

/*搜索到的从属中控数组*/
@property (nonatomic, strong) NSMutableArray *boxsArr;

/*当前选择的中控imeicode*/
@property (nonatomic, copy) NSString *selectedIdentify;

/*搜索状态 -- 搜索中，搜索到一个继续搜，搜索成功，搜索失败*/
@property (nonatomic, assign) ZKTAddStatus addStatus;

@end

@implementation D5AddDependentBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTop];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)active {
    if (_addStatus == ZKTAddStatusIng) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startRotateForImg:_loadingImgView];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [D5LedZKTList defaultList].delegate = nil;
    [D5LedLinkDevice sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
/**
 * 初始化navigation上的view
 */
- (void)initTop {
    self.title = @"添加从属中控";
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
}

/**
 * 初始化view
 */
- (void)initView {
    [self showViewForStatus:ZKTAddStatusIng];
    
    [self startSearchBox];
}

/**
 * 开始搜索从属中控
 */
- (void)startSearchBox {
    @autoreleasepool {
        [D5LedZKTList defaultList].delegate = self;
        [[D5LedZKTList defaultList] getZKTListFromServer];
    }
}

- (NSMutableArray *)boxsArr {
    if (!_boxsArr) {
        _boxsArr = [NSMutableArray new];
    }
    return _boxsArr;
}

#pragma mark - 设置view的显示状态
- (void)showViewForStatus:(ZKTAddStatus)status {
    @autoreleasepool {
        _addStatus = status;
        switch (status) {
            case ZKTAddStatusSuccess: //成功
                [self stopRotateForImg:_loadingImgView];
                _failedView.hidden = YES;
                [self setBtnTitle:DONE_STR forBtn:_btnBottom];
                [self setBtnEnable:_btnBottom enable:[NSString isValidateString:_selectedIdentify]];
                break;
                
            case ZKTAddStatusFailed: //失败
                [self stopRotateForImg:_loadingImgView];
                _failedView.hidden = NO;
                [self setBtnEnable:_btnBottom enable:YES];
                [self setBtnTitle:SEARCH_AGAIN forBtn:_btnBottom];
                break;
                
            case ZKTAddStatusSearched: //搜索成功一个以上，但还在搜索
                _failedView.hidden = YES;
                [self setBtnTitle:DONE_STR forBtn:_btnBottom];
                [self setBtnEnable:_btnBottom enable:[NSString isValidateString:_selectedIdentify]];
                break;
                
            default: //ZKTAddStatusIng
                [self startRotateForImg:_loadingImgView];
                _failedView.hidden = YES;
                [self setBtnTitle:DONE_STR forBtn:_btnBottom];
                [self setBtnEnable:_btnBottom enable:NO];
                break;
        }
    }
}

#pragma mark - 搜索中控
- (void)ledZKTList:(D5LedZKTList *)zktList getFinished:(BOOL)flag {
    if (flag) {
        [self showViewForStatus:(self.boxsArr.count == 0) ? ZKTAddStatusFailed : ZKTAddStatusSuccess];
    }
}

- (void)ledZKTList:(D5LedZKTList *)zktList searchedZKT:(NSDictionary *)dict {
    @autoreleasepool {
        if (!dict) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断是否已存在并显示
            NSString *identify = [dict objectForKey:ZKT_BOX_ID];
            //本身imeiCode
            NSString *currentBoxId = [D5CurrentBox currentBoxId];
            if ([identify isEqualToString:currentBoxId]) { //是本身则不显示进去
//                DLog(@"本身");
                return ;
            }
            
            __block BOOL isExist = NO;
            
            __weak D5AddDependentBoxViewController *weakSelf = self;
            if (self.boxsArr.count > 0) {
                [self.boxsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @autoreleasepool {
                        NSString *existIdentify = [obj objectForKey:ZKT_BOX_ID];
                        // 数组中已有该identify的dict -- 判断是否有变动
                        if ([NSString isValidateString:identify] && [identify isEqualToString:existIdentify]) {
                            isExist = YES;
                            if (![obj isEqualToDictionary:dict]) { //内容有改动
                                [weakSelf.boxsArr replaceObjectAtIndex:idx withObject:dict]; //替换已存在的
                                *stop = YES;
                            }
                        }
                    }
                }];
                
            }
            
            if (!isExist) { //不存在
                [self.boxsArr addObject:dict];
            }
            
            [_boxTableView reloadData]; //界面显示
            [self showViewForStatus:ZKTAddStatusSearched];
        });
    }
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boxsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5ConnectZKTCell *cell = [tableView dequeueReusableCellWithIdentifier:CONNECT_ZKT_CELL_ID];
        if (!cell) {
            cell = [[D5ConnectZKTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CONNECT_ZKT_CELL_ID];
        }
        
        NSInteger row = indexPath.row;
        if (row < self.boxsArr.count) {
            NSDictionary *dict = [self.boxsArr objectAtIndex:row];
            [cell setData:[D5LedZKTBoxData dataWithDict:dict] selectedIdentifier:_selectedIdentify];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        NSInteger row = indexPath.row;
        if (row < self.boxsArr.count) {
            NSDictionary *dict = self.boxsArr[row];
            NSString *imeiCode = dict[ZKT_BOX_ID]; //选中的中控记录下唯一标示
            
            if (![imeiCode isEqualToString:_selectedIdentify]) { //改变了
                _selectedIdentify = imeiCode;
            } else {
                _selectedIdentify = nil;
                
            }
            [tableView reloadData];
            
            if (_addStatus == ZKTAddStatusSearched || _addStatus == ZKTAddStatusSuccess) { //搜索出来
                [self setBtnEnable:_btnBottom enable:[NSString isValidateString:_selectedIdentify]];
            }
        }
    }
}

#pragma mark - 点击事件
/**
 * 保存/重新搜索的点击事件
 */
- (IBAction)btnBottomClicked:(UIButton *)sender {
    @autoreleasepool {
        BOOL isSearchAgain = (_addStatus == ZKTAddStatusFailed);
        if (isSearchAgain) {
            [self startSearchBox];
            [self showViewForStatus:ZKTAddStatusIng];
        } else { //完成
            [MBProgressHUD showLoading:@"" toView:self.view];
            
            [[D5LedZKTList defaultList] stopSearchBox];
            
            [self addSubordinateBox];
        }
    }
}

#pragma mark - 添加从属中控
- (void)addSubordinateBox {
    @autoreleasepool {
        BOOL isValidate = [NSString isValidateString:_selectedIdentify];
        if (!isValidate) {
            return;
        }
        
        NSString *ip = nil;
        int port = 0;
        for (NSDictionary *dict in self.boxsArr) {
            @autoreleasepool {
                if ([_selectedIdentify isEqualToString:[dict objectForKey:ZKT_BOX_ID]]) {
                    ip = [dict objectForKey:ZKT_BOX_IP];
                    port = [dict[ZKT_BOX_TCP_PORT] intValue];
                    break;
                }
            }
        }
        
        [D5LedLinkDevice sharedInstance].delegate = self;
        [[D5LedLinkDevice sharedInstance] addLinkDevice:ip port:port];
    }
}

- (void)ledLinkDeviceAddFinish:(BOOL)isFinish {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
    });
    
    if (!isFinish) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"已成功连接到中控"];
        
        [MobClick event:UM_DEVICE_FOLLOW];
        
        dispatch_after(1, dispatch_get_main_queue(), ^{
            [self back];
        });
    });
}

@end
