//
//  D5MultiLightFollowViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/24.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MultiLightFollowViewController.h"
#import "D5MultiLightFollowCell.h"
#import "D5MultiLightFollowHeaderView.h"
#import "D5MultiLightFollowBoxData.h"
#import "D5LedLinkDevice.h"

#define DELETE_TIP @"确定要删除从属的中控吗？"
#define DELETE_TITLE    @"删除从属中控"

#define EXIT_TITLE      @"退出多灯随动"
#define EXIT_TIP   @"确定要退出多灯随动吗？"

typedef enum _current_status {
    CurrentStatusIng = 0, //加载中
    CurrentStatusNoLink, //没有从属中控
    CurrentStatusHasLink //有从属中控
}CurrentStatus;

@interface D5MultiLightFollowViewController () <UITableViewDataSource, UITableViewDelegate, D5LedNetWorkErrorDelegate, D5LedLinkDeviceDelegate>

/*显示没有从属中控的view*/
@property (weak, nonatomic) IBOutlet UIView *noDependentBoxView;

/** 自己的中控tag */
@property (nonatomic, assign) LedBoxTag currentTag;

/*主从中控tableview*/
@property (weak, nonatomic) IBOutlet UITableView *zktTableView;

/*删除从属中控按钮*/
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *deleteTipLabel;
- (IBAction)btnDeleteClicked:(UIButton *)sender;

@property (nonatomic, strong) NSMutableArray *linkBoxs;

@property (nonatomic, assign) CurrentStatus status;

/*确认删除从属中控view*/
@property (weak, nonatomic) IBOutlet UIView *deleteView;
- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnSureClicked:(UIButton *)sender;

@end

@implementation D5MultiLightFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initView];
    
    //获取从属中控
    [D5LedLinkDevice sharedInstance].delegate = self;
    [[D5LedLinkDevice sharedInstance] getLinkDevice];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [D5LedLinkDevice sharedInstance].delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取从属中控结果
- (void)ledLinkDeviceListGetFinish:(BOOL)isFinish primaryDevice:(NSDictionary *)primaryDict withSubordinateDevices:(NSArray *)deivces {
    if (!isFinish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
            [self showViewByStatus:CurrentStatusNoLink];
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        [self.linkBoxs removeAllObjects];
        
        if (!primaryDict) {
            [self showViewByStatus:CurrentStatusNoLink];
            return ;
        }
        [self showViewByStatus:CurrentStatusHasLink];
        
        D5MultiLightFollowBoxData *primaryData = [D5MultiLightFollowBoxData dataWithDict:primaryDict];
        primaryData.boxTag = LedBoxTagPrimary;
        [self ownBoxIsfirstData:primaryData];
        
        if (deivces && deivces.count > 0) { //从中控数组
            NSDictionary *subordinateBox = deivces[0];
            
            D5MultiLightFollowBoxData *subordinateBoxData = [D5MultiLightFollowBoxData dataWithDict:subordinateBox];
            subordinateBoxData.boxTag = LedBoxTagSubordinate;
            [self ownBoxIsfirstData:subordinateBoxData];
            
//            for (NSDictionary *subordinateBox in deivces) {
//                @autoreleasepool {
//                    D5MultiLightFollowBoxData *subordinateBoxData = [D5MultiLightFollowBoxData dataWithDict:subordinateBox];
//                    subordinateBoxData.boxTag = LedBoxTagSubordinate;
//                    [self ownBoxIsfirstData:subordinateBoxData];
//                }
//            }
        }
        
        
        [_btnDelete setTitle:(_currentTag == LedBoxTagPrimary) ? DELETE_TITLE : EXIT_TITLE forState:UIControlStateNormal];
        _deleteTipLabel.text = (_currentTag == LedBoxTagPrimary) ? DELETE_TIP : EXIT_TIP;
        
        [self.zktTableView reloadData];
    });
}

#pragma mark - 初始化
/**
 * 初始化navigation上的view
 */
- (void)initTop {
    self.title = @"多灯随动";
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
}

/**
 * 初始化view
 */
- (void)initView { //先加载
    [self showViewByStatus:CurrentStatusIng];
}

/**
 * 根据状态设置view
 */
- (void)showViewByStatus:(CurrentStatus)status {
    @autoreleasepool {
        _status = status;
        switch (status) {
            case CurrentStatusIng: {
                _noDependentBoxView.hidden = YES;
                _btnDelete.hidden = YES;
                _zktTableView.hidden = YES;
                _deleteView.hidden = YES;
                [MBProgressHUD showLoading:@"" toView:self.view];
            }
                break;
            case CurrentStatusNoLink: { //没有从属中控
                [MBProgressHUD hideHUDForView:self.view];
                _noDependentBoxView.hidden = NO;
                _btnDelete.hidden = YES;
                _zktTableView.hidden = YES;
                _deleteView.hidden = YES;
            }
                break;
                
            default: { //有从属中控
                [MBProgressHUD hideHUDForView:self.view];
                _noDependentBoxView.hidden = YES;
                _btnDelete.hidden = NO;
                _zktTableView.hidden = NO;
                _deleteView.hidden = YES;
            }
                break;
        }
    }
}

#pragma mark - 获取从属中控
- (NSMutableArray *)linkBoxs {
    if (!_linkBoxs) {
        _linkBoxs = [NSMutableArray new];
    }
    return _linkBoxs;
}

/**
 * 将自己中控放在数组第一个
 */
- (void)ownBoxIsfirstData:(D5MultiLightFollowBoxData *)data {
    @autoreleasepool {
        if ([data.imei isEqualToString:[D5CurrentBox currentBoxId]]) { //自己的中控
            _currentTag = data.boxTag;
            [self.linkBoxs insertObject:data atIndex:0]; //将自己的放在第一个
        } else {
            [self.linkBoxs addObject:data]; //添加中控信息
        }
    }
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.linkBoxs.count > 0 ? self.linkBoxs.count - 1 : 0;//目前一主一从
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5MultiLightFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:MULTILIGHT_FOLLOW_CELL_ID];
        if (!cell) {
            cell = [[D5MultiLightFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MULTILIGHT_FOLLOW_CELL_ID];
        }
        
        NSInteger row = indexPath.row;
        if (row + 1 < self.linkBoxs.count) {
            [cell setData:self.linkBoxs[row + 1]];
        }
        return cell;
    }
}

/**
 * 自定义headerview
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    @autoreleasepool {
        D5MultiLightFollowHeaderView *headerView = [D5MultiLightFollowHeaderView sharedHeaderView];
        if (self.linkBoxs.count > 0) {
            [headerView setData:self.linkBoxs[0]];
        }
        return headerView;
    }
}

/**
 * headerview的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 130.0f;
}

#pragma mark - 点击事件
- (IBAction)btnDeleteClicked:(UIButton *)sender {
    _deleteView.hidden = NO;
}

- (IBAction)btnCancelClicked:(UIButton *)sender {
    _deleteView.hidden = YES;
}

- (IBAction)btnSureClicked:(UIButton *)sender {
    _deleteView.hidden = YES;
    [self deleteLinkBox];
}

#pragma mark - 删除联动
- (void)deleteLinkBox {
    @autoreleasepool {
        if (self.linkBoxs.count == 0) {
            return;
        }
        
        
        NSInteger priId = -1;
        NSInteger subId = -1;
        for (int i = 0; i < self.linkBoxs.count; i ++) {
            if (i < 2) {
                D5MultiLightFollowBoxData *boxData = self.linkBoxs[i];
                
                NSInteger boxId = boxData.boxID;
                if (boxData.boxTag == LedBoxTagPrimary) {
                    priId = boxId;
                } else if (boxData.boxTag == LedBoxTagSubordinate) {
                    subId = boxId;
                }
            }
        }
        
        [[D5LedLinkDevice sharedInstance] deleteLinkDevice:priId subordinateBoxID:subId];
        
        [MBProgressHUD showLoading:@"" toView:self.view];
    }
}

- (void)ledLinkDeviceDeleteFinish:(BOOL)isFinish {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
    });
    if (!isFinish) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showViewByStatus:CurrentStatusNoLink];
    });
}

@end
