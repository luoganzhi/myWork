//
//  D5ConnectedViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ConnectedViewController.h"
#import "D5ConnectZKTCell.h"

#define PLEASE_CONNECT_WIFI @"请连接Wi-Fi"

#define FILTER_STR @""

@interface D5ConnectedViewController()<UITableViewDelegate, UITableViewDataSource> //, UITextFieldDelegate

/** 包含WIFIview和搜索结果view的scrollview */
//@property (weak, nonatomic) IBOutlet UIScrollView *connectScrollView;

/** scrollview的contentView */
//@property (weak, nonatomic) IBOutlet UIView *contentView;

/** contentView的宽高度 */
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (assign, nonatomic) CGFloat tableViewHeight;

/** 查看明文按钮 */
//@property (weak, nonatomic) IBOutlet UIButton *btnSmallEye;
//- (IBAction)btnSmallEyeClicked:(UIButton *)sender;

/** 加载中view */
@property (weak, nonatomic) IBOutlet UIView *loadingView;

/** 搜索失败view */
@property (weak, nonatomic) IBOutlet UIView *failedView;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;

@end

@implementation D5ConnectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedIdentify = nil;
    [self initView];
//    [self addNotification];
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)changeConstraint {
//    _contentHeight.constant = _height;
//    _connectScrollView.contentSize = CGSizeMake(_connectScrollView.contentSize.width, _contentHeight.constant);
//    
//    [self.view layoutIfNeeded];
//}

#pragma mark - init view
- (void)initView {
    [self.view layoutIfNeeded];
    
    [self initTextField];
    
//        [self setWIFIView];
    [self initBottomView];
    [self initBtnTitle];
    
    [self initConnectScrollView];
    _countDownView.totalInterval = SEARCH_BOX_TIME_INTERVAL;
}

- (void)initConnectScrollView {
//    @autoreleasepool {
//        [self.view layoutIfNeeded];
//        
//        _tableViewHeight = CGRectGetHeight(_tableView.frame);
//        
//        CGSize scrollSize = CGSizeMake(CGRectGetWidth(self.view.frame), _height);
//        _contentWidth.constant = scrollSize.width;
//        _contentHeight.constant = scrollSize.height;
//        
//        _connectScrollView.contentSize = scrollSize;
//    }
}

/**
 *  给 “连接帮助" 按钮添加字体颜色和下划线
 */
- (void)initBtnTitle {
    @autoreleasepool {
        NSString *title = _btnHelp.currentTitle;
        if ([NSString isValidateString:title]) {
            [_btnHelp setAttributedTitle:[D5String attrStringWithString:title fontColor:_btnHelp.currentTitleColor] forState:UIControlStateNormal];
            
            [_btnHelp addTarget:self action:@selector(btnHelpClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)initBottomView {
    _failedView.hidden = YES;
    _loadingView.hidden = NO;
    _tableView.hidden = NO;
}

- (void)initTextField {
//    @autoreleasepool {
//        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,15,1)];
//        leftView.backgroundColor = [UIColor clearColor];
//        _wifiPwdTF.leftView = leftView;
//        _wifiPwdTF.leftViewMode = UITextFieldViewModeAlways;
//        _wifiPwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        
//        UIButton *rightView = _btnSmallEye;
//        _wifiPwdTF.rightView = rightView;
//        _wifiPwdTF.rightViewMode = UITextFieldViewModeAlways;
//    }
}

//- (void)setWIFIView {
//    @autoreleasepool {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *title = PLEASE_CONNECT_WIFI;
//            
//            NSString *currentWifiName = [D5NetWork getCurrentWifiName];
//            if (![WIFI_NOT_FOUND isEqualToString:currentWifiName]) { //连上wifi
//                title = currentWifiName;
//            } else {
//                _wifiPwdTF.text = @"";
//            }
//
//            [self setBtnTitle:title forBtn:_wifiLabel];
//        });
//    }
//}

//- (void)addNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:NETWORK_STATUS_CHANGED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWIFIView) name:UIApplicationDidBecomeActiveNotification object:nil];
//}

- (NSMutableArray *)zktBoxArr {
    if (!_zktBoxArr) {
        _zktBoxArr = [NSMutableArray array];
    }
    return _zktBoxArr;
}

#pragma mark - 开始搜索和搜索结果
- (void)searchBoxIng {
    @autoreleasepool {
        _loadingView.hidden = NO;
        [self startRotateForImg:_loadingImgView];
        
        _failedView.hidden = YES;
        _tableView.hidden = YES;
        _countDownView.hidden = NO;
    }
}

- (void)searchBoxFailed {
    @autoreleasepool {
        _loadingView.hidden = YES;
        [self stopRotateForImg:_loadingImgView];
        _failedView.hidden = NO;
        _tableView.hidden = YES;
        _countDownView.hidden = YES;
    }
}

//用在reloaddata后(搜索成功一个以上，但还在搜索)
- (void)searchBoxSearched {
    @autoreleasepool {
        _loadingView.hidden = NO;
        _failedView.hidden = YES;
        _tableView.hidden = NO;
        _countDownView.hidden = YES;
        
//        NSInteger count = [_tableView numberOfRowsInSection:0];
//        CGFloat row = _tableView.rowHeight;
//        
//        CGFloat value = row * count - _tableViewHeight;
//        if (value > 0) { //超出了
//            _contentHeight.constant = value + _height;
//            _connectScrollView.contentSize = CGSizeMake(_connectScrollView.contentSize.width, _contentHeight.constant);
//            [self.view layoutIfNeeded];
//        }
    }
}

- (void)searchBoxSuccess {
    @autoreleasepool {
        _loadingView.hidden = NO;
        [self stopRotateForImg:_loadingImgView];
        _failedView.hidden = YES;
        _tableView.hidden = NO;
        _countDownView.hidden = YES;
    }
}

#pragma mark - 网络状态变化
//- (void)networkChanged:(NSNotification *)notification {
//    @autoreleasepool {
//        NSDictionary *userInfo = notification.userInfo;
//        if (userInfo) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self setWIFIView];
//            });
//        }
//    }
//}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zktBoxArr.count;
//    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5ConnectZKTCell *cell = [tableView dequeueReusableCellWithIdentifier:CONNECT_ZKT_CELL_ID];
        if (!cell) {
            cell = [[D5ConnectZKTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CONNECT_ZKT_CELL_ID];
        }
        
        NSInteger row = indexPath.row;
        if (row < self.zktBoxArr.count) {   // 数组中的dict包括：name,type,id,ip,mac
            NSDictionary *dict = self.zktBoxArr[row];
            [cell setData:[D5LedZKTBoxData dataWithDict:dict] selectedIdentifier:_selectedIdentify];
            
            if (row == 0) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                BOOL isHasSearched = [userDefaults boolForKey:HAS_SEARCHED_BOX];
                if (!isHasSearched) {
                    [userDefaults setBool:YES forKey:HAS_SEARCHED_BOX];
                    [userDefaults synchronize];
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(addGuideTipWithFrame:)]) {
                        [_delegate addGuideTipWithFrame:cell.boxMacLabel.frame];
                    }
                }
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        NSInteger row = indexPath.row;
        if (row < self.zktBoxArr.count) {
            NSDictionary *dict = self.zktBoxArr[row];
            NSString *boxId = dict[ZKT_BOX_ID]; //选中的中控记录下唯一标示
            
            if (![boxId isEqualToString:_selectedIdentify]) { //改变了
                //DLog(@"改变了");
                _selectedIdentify = boxId;
            } else {
                //DLog(@"还是原来的");
                _selectedIdentify = nil;
                
            }
            [tableView reloadData];
            if (_delegate && [_delegate respondsToSelector:@selector(selectedBoxChanged:)]) {
                [_delegate selectedBoxChanged:_selectedIdentify];
            }
        }
    }
}

#pragma mark - textfiled delegate
////str中是否包含中文
//- (BOOL)isIncludeChineseInString:(NSString *)str {
//    for (int i = 0; i < str.length; i ++) {
//        unichar ch = [str characterAtIndex:i];
//        if (0x4e00 < ch  && ch < 0x9fff) {
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    return _canEditPwdTF;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return ![self isIncludeChineseInString:string];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    @autoreleasepool {
//        NSString *text = _wifiPwdTF.text;
//        NSInteger length = 0;
//        if ([NSString isValidateString:text]) {
//            length = text.length;
//        }
//        
//        [self responseDelegateSelector:length >= 8];
//    }
//}
//
////调用代理方法
//- (void)responseDelegateSelector:(BOOL)param {
//    if (_delegate && [_delegate respondsToSelector:@selector(enterPwdFinish:)]) {
//        [_delegate enterPwdFinish:param];
//    }
//}

#pragma mark - 点击事件
//- (IBAction)btnSmallEyeClicked:(UIButton *)sender {
//    @autoreleasepool {
//        _wifiPwdTF.secureTextEntry = !_wifiPwdTF.secureTextEntry;
//        
//        NSString *text = _wifiPwdTF.text;
//        _wifiPwdTF.text = @" ";
//        _wifiPwdTF.text = text;
//    }
//}

- (void)btnHelpClick {
    if (_delegate && [_delegate respondsToSelector:@selector(helpClick)]) {
        [_delegate helpClick];
    }
}

- (void)hiddenLodaingView {
    self.loadingView.hidden = YES;
    self.loadingImgView.hidden = YES;
}
@end
