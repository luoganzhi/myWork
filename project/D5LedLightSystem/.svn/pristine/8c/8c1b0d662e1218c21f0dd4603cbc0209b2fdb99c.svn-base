//
//  D5AlarmSettingViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5AlarmSettingViewController.h"
#import "D5AlarmTableCell.h"
#import "D5AddAlarmViewController.h"
#import "D5AlarmData.h"

#define BOTTOM_MARGIN 30

#define ALL_SELECT @"全选"
#define ALL_DISSELECT @"全不选"

#define DELETE @"删除"
#define ADD @"添加"

@interface D5AlarmSettingViewController () <UITableViewDelegate, UITableViewDataSource, D5LedCmdDelegate,  D5LedNetWorkErrorDelegate>

/** table view */
@property (weak, nonatomic) IBOutlet UITableView *alarmTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (nonatomic, strong) NSMutableArray *alarmsArr;
@property (nonatomic, strong) NSMutableDictionary *selectedAlarmDict;
@property (nonatomic, assign) BOOL isEdit, isLoading;

/*tip view*/
@property (weak, nonatomic) IBOutlet UIView *tipView;

/*添加*/
@property (weak, nonatomic) IBOutlet UIButton *btnAddAlarm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnAddLeftMargin;
- (IBAction)btnAddAlarmClicked:(UIButton *)sender;

/*删除view*/
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *containDeleteView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containDeleteBottomMargin;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
- (IBAction)btnSureClicked:(UIButton *)sender;
- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnDeleteClicked:(UIButton *)sender;

@end

@implementation D5AlarmSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sendGetTask];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 获取定时任务
 */
- (void)sendGetTask {
    @autoreleasepool {
        D5LedNormalCmd *getTask = [[D5LedNormalCmd alloc] init];
        
        getTask.remoteLocalTag = tag_remote;
        getTask.remotePort = [D5CurrentBox currentBoxTCPPort];
        getTask.strDestMac = [D5CurrentBox currentBoxMac];
        getTask.remoteIp = [D5CurrentBox currentBoxIP];
        getTask.errorDelegate = self;
        getTask.receiveDelegate = self;
        
        [getTask ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Get_TimeTask];
    }
}

#pragma mark - init
- (void)initView {
    @autoreleasepool {
        self.title = @"定时设置";
        [self addLeftBarItem];
        
        _deleteView.hidden = YES;
        _containDeleteView.hidden = YES;
        _alarmTableView.allowsMultipleSelection = YES; //允许多选
        [self showLoading:YES];
    }
}

- (void)containDeleteViewIsShow:(BOOL)isShow {
    @autoreleasepool {
        [self.view layoutIfNeeded];
        
        CGFloat height = CGRectGetHeight(_containDeleteView.frame);
        
        if (isShow) {
            _containDeleteView.hidden = NO;
        }
        
        __weak D5AlarmSettingViewController *weakSelf = self;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.containDeleteBottomMargin.constant = isShow ? 0 : -height;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (!isShow) {
                weakSelf.containDeleteView.hidden = YES;
            }
        }];
    }
}

- (void)showLoading:(BOOL)isLoading {
    @autoreleasepool {
        _isLoading = isLoading;
        if (isLoading) {
            [MBProgressHUD showLoading:@"加载中..." toView:self.view];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
        }
        
        _tipView.hidden = isLoading;
        _btnAddAlarm.hidden = isLoading;
    }
}

- (void)addLeftBarItem {
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
}

- (NSMutableArray *)alarmsArr {
    if (!_alarmsArr) {
        _alarmsArr = [NSMutableArray array];
    }
    return _alarmsArr;
}

- (NSMutableDictionary *)selectedAlarmDict {
    if (!_selectedAlarmDict) {
        _selectedAlarmDict = [NSMutableDictionary dictionary];
    }
    return _selectedAlarmDict;
}

//根据是否有定时任务来显示view
- (void)showViewByHasAlarm:(BOOL)hasAlarm {
    @autoreleasepool {
        [self showLoading:NO];
        
        [self.view layoutIfNeeded];
        
        _alarmTableView.hidden = !hasAlarm;
        
        CGFloat noEditHasAlarmTableHeight = CGRectGetHeight(self.view.frame) - CGRectGetHeight(_btnAddAlarm.frame) - BOTTOM_MARGIN * 2 - 64;
        CGFloat editTableHeight = CGRectGetHeight(self.view.frame) - CGRectGetHeight(_containDeleteView.frame) - 64;
        CGFloat noEditHasSixAlarmTableHeight = CGRectGetHeight(self.view.frame) - 64;
        
        _tableHeight.constant = hasAlarm ? (_isEdit ? editTableHeight : (self.alarmsArr.count >= 6 ? noEditHasSixAlarmTableHeight : noEditHasAlarmTableHeight)) : 0;
        _tipView.hidden = hasAlarm;
        
        _btnAddAlarm.hidden = _isLoading ? YES : self.alarmsArr.count >= 6;
    }
}

#pragma mark - 获取定时任务返回数据
- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    @autoreleasepool {
        if (!dict) {
            return;
        }
        
        if (header->cmd == Cmd_Box_Operate) {
            switch (header->subCmd) {
                case SubCmd_Box_Get_TimeTask: {     // 获取定时任务
                    NSDictionary *data = dict[LED_STR_DATA];
                    if (!data) {
                        return;
                    }
                    
                    NSArray *tasks = data[LED_STR_TASK];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.alarmsArr = tasks ?  [NSMutableArray arrayWithArray:tasks] : nil;
                        [self showViewByHasAlarm:(tasks && tasks.count > 0)];
                        [self.alarmTableView reloadData];
                    });
                }
                    
                    break;
                case SubCmd_Box_Set_TimeTask: {     // 设置定时任务
                    LedCode code = [dict[LED_STR_CODE] intValue];
                    if (code == LedCodeFailed) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.alarmTableView reloadData];
                        });
                        return;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_isEdit) {
                        } else { //修改禁用属性
                            
                        }
                    });
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
//    //DLog(@"定时设置里面errorType = %d", (int)errorType);
    if (header->cmd == Cmd_Box_Operate) {
        switch (header->subCmd) {
            case SubCmd_Box_Get_TimeTask: {     // 获取定时任务
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_isLoading) {
                        [self showViewByHasAlarm:NO];
                    }
                });
            }
                
                break;
            case SubCmd_Box_Set_TimeTask: {     // 设置定时任务
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.alarmTableView reloadData];
                });
            }
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 删除定时任务
- (void)deleteAlarms {
    @autoreleasepool {
        NSMutableArray *arr = [self selectedToDeleteArr];
        if (!arr || arr.count == 0) {
            [MBProgressHUD showMessage:@"请选择要删除的定时任务"];
            return;
        }
        
        D5LedNormalCmd *setTime = [[D5LedNormalCmd alloc] init];
        
        setTime.remoteLocalTag = tag_remote;
        setTime.remotePort = [D5CurrentBox currentBoxTCPPort];
        setTime.strDestMac = [D5CurrentBox currentBoxMac];
        setTime.remoteIp = [D5CurrentBox currentBoxIP];
        setTime.errorDelegate = self;
        setTime.receiveDelegate = self;
        

        NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT] * 1000;
        
        
        NSDictionary *sendDict = @{LED_STR_TASK : arr, LED_STR_APPCURRENTTIME : @([D5Date currentLongTimeStamp]), LED_STR_ZONE : @(timeZoneOffset)};
        [setTime ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Set_TimeTask withData:sendDict];
        
        dispatch_after(1, dispatch_get_main_queue(), ^{
            [self deleteAlarmFromTableView];
        });
    }
}

- (void)deleteAlarmFromTableView {
    @autoreleasepool {
        [MBProgressHUD showMessage:@"删除成功"];
        
        NSArray *keys = [self.selectedAlarmDict allKeysForObject:@(YES)];
        if (keys && keys.count > 0) { //选中删除的indexpaths
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            for (NSIndexPath *key in keys) {
                @autoreleasepool {
                    [indexSet addIndex:key.section];
                }
            }
            
            [self.alarmsArr removeObjectsAtIndexes:indexSet];
        }
        
        [self isEditMode:NO];
        [self showViewByHasAlarm:self.alarmsArr.count > 0];
    }
}

//选中删除的数组
- (NSMutableArray *)selectedToDeleteArr {
    @autoreleasepool {
        LedOperateTaskType type = LedOperateTaskTypeDelete;
        NSArray *keys = [self.selectedAlarmDict allKeysForObject:@(YES)];
        if (keys && keys.count > 0) {
            NSMutableArray *selectedArr = [NSMutableArray array];
            
            for (NSIndexPath *indexPath in keys) {
                @autoreleasepool {
                    NSDictionary *dict = self.alarmsArr[indexPath.section];
                    
                    // 修改操作类型
                    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    mutableDict[LED_STR_ACTION] = @(type);
                    
                    [selectedArr addObject:mutableDict];
                }
            }
            
            return selectedArr;
        }
        
        return nil;
    }
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @autoreleasepool {
        NSInteger count = self.alarmsArr.count;
        _btnAddLeftMargin.constant = (self.alarmsArr.count > 0) ? 30 : 64;
        return count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @autoreleasepool {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5AlarmTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ALARM_CELL_ID];
        if (!cell) {
            cell = [[D5AlarmTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ALARM_CELL_ID];
        }
     
        NSInteger section = indexPath.section;
        if (section < self.alarmsArr.count) {
            BOOL isChecked = ((NSNumber *)self.selectedAlarmDict[indexPath]).boolValue;
            cell.btnSelected.selected = isChecked;
            NSDictionary *dict = self.alarmsArr[section];
            
            [cell setData:[D5AlarmData dataWithDict:dict] isEdit:_isEdit delegate:self];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    @autoreleasepool {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 12)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        NSInteger section = indexPath.section;
        if (section < self.alarmsArr.count) {
            if (!_isEdit) {
                NSDictionary *taskDict = self.alarmsArr[section];
                [self pushToAddAlarmVC:taskDict];
                return;
            }
            
            [self checkStatusForIndexPath:indexPath];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        if (!_isEdit) {
            return;
        }
        
        [self checkStatusForIndexPath:indexPath];
    }
}

//滑动显示删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        [self.selectedAlarmDict setObject:@(YES) forKey:indexPath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self isEditMode:YES];
        });
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEdit) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - 保存选中状态
- (void)checkStatusForIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        BOOL isChecked = !((NSNumber *)self.selectedAlarmDict[indexPath]).boolValue;
        self.selectedAlarmDict[indexPath] = @(isChecked);
        
        D5AlarmTableCell *cell = [_alarmTableView cellForRowAtIndexPath:indexPath];
        cell.btnSelected.selected = isChecked;
        
        [self changeBySelectedCount];
    }
}

//根据选中个数改变title为全选/全不选 删除按钮的enable属性
- (void)changeBySelectedCount {
    @autoreleasepool {
        NSArray *values = [self.selectedAlarmDict allValues];
        NSUInteger count = 0;
        if (values && values.count > 0) {
            for (NSNumber *number in values) {
                @autoreleasepool {
                    if (!number.boolValue) continue;
                    count ++;
                }
            }
        }
        
        [self changeRightBarItemTitle:(count == self.alarmsArr.count) ? ALL_DISSELECT : ALL_SELECT];
        [self setBtnEnable:_btnDelete enable:count > 0];
    }
}

#pragma mark - 点击事件
- (void)isEditMode:(BOOL)isEdit {
    @autoreleasepool {
        _isEdit = isEdit;
        
        CGFloat noEditHasAlarmTableHeight = CGRectGetHeight(self.view.frame) - CGRectGetHeight(_btnAddAlarm.frame) - BOTTOM_MARGIN * 2 - 64;
        CGFloat editTableHeight = CGRectGetHeight(self.view.frame) - CGRectGetHeight(_containDeleteView.frame) - 64;
        CGFloat noEditHasSixAlarmTableHeight = CGRectGetHeight(self.view.frame) - 64;
        
        _tableHeight.constant = isEdit ? editTableHeight : (self.alarmsArr.count >= 6 ? noEditHasSixAlarmTableHeight : noEditHasAlarmTableHeight);
        
        [self containDeleteViewIsShow:isEdit];
        _btnAddAlarm.hidden = !isEdit ? self.alarmsArr.count >= 6 : YES;
        
        if (isEdit) {
            NSString *rightBarItemTitle = (self.alarmsArr.count == 1) ? ALL_DISSELECT : ALL_SELECT;
            if (!self.navigationItem.rightBarButtonItem) {
                [D5BarItem addRightBarItemWithText:rightBarItemTitle color:WHITE_COLOR target:self action:@selector(allSelectedClicked:)];
            } else {
                [self changeRightBarItemTitle:rightBarItemTitle];
            }
            [D5BarItem setLeftBarItemWithTitle:@"取消" color:WHITE_COLOR target:self action:@selector(cancelDeleteClicked:)];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
            [self addLeftBarItem];
            
            [self.selectedAlarmDict removeAllObjects];
            [self setBtnEnable:_btnDelete enable:YES];
        }
        
        DLog(@"selected = %@", self.selectedAlarmDict);
        [self.alarmTableView reloadData];
    }
}

- (void)cancelDeleteClicked:(UIBarButtonItem *)item {
    @autoreleasepool {
        [self isEditMode:NO];
    }
}

- (void)allSelectedClicked:(UIButton *)item {
    @autoreleasepool {
        BOOL isAllSelect = [item.currentTitle isEqualToString:ALL_SELECT];
        for (int i = 0; i < self.alarmsArr.count; i ++) {
            @autoreleasepool {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                [self.selectedAlarmDict setObject:@(isAllSelect) forKey:indexPath];
            }
        }
        
        [item setTitle:(isAllSelect ? ALL_DISSELECT : ALL_SELECT) forState:UIControlStateNormal];
        [self setBtnEnable:_btnDelete enable:isAllSelect];
        [self.alarmTableView reloadData];
    }
}

- (IBAction)btnAddAlarmClicked:(UIButton *)sender {
    @autoreleasepool {
        [self pushToAddAlarmVC:nil];
    }
}

- (IBAction)btnSureClicked:(UIButton *)sender {
    _deleteView.hidden = YES;
    
    [self deleteAlarms];
}

- (IBAction)btnCancelClicked:(UIButton *)sender {
    _deleteView.hidden = YES;
}

- (IBAction)btnDeleteClicked:(UIButton *)sender {
    _deleteView.hidden = NO;
}

#pragma mark - 跳转事件
- (void)pushToAddAlarmVC:(NSDictionary *)taskDict {
    @autoreleasepool {
        D5AddAlarmViewController *addAlarmVC = [self.storyboard instantiateViewControllerWithIdentifier:ADDALARM_VC_ID];
        if (addAlarmVC) {
            addAlarmVC.modifyTaskData = taskDict ? [D5AlarmData dataWithDict:taskDict] : nil;
            [self.navigationController pushViewController:addAlarmVC animated:YES];
        }
    }
}

@end
