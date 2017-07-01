//
//  D5TFOrUsbViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/17.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5TFOrUsbViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "D5TFDataModel.h"
#import "D5TFMusicModel.h"
#import "D5EditTableViewCell.h"
#import "D5TFTableViewCell.h"
#import "D5MoubileTanslateSongsController.h"
#import "D5ProgressModel.h"
#import "D5CurrentMusicModel.h"
#import "D5UploadFailedView.h"
#import "D5UploadSuccessView.h"
#import "D5UploadingView.h"
#import "D5MainViewController.h"
#import "D5HLocalMusicList.h"
#import "D5RuntimeShareInstance.h"
#import "AppDelegate.h"

#define D5_TF_CELL @"D5TFCell"
#define CANCEL_ALL_SELECT @"全不选"
#define ALL_SELECT @"全选"


@interface D5TFOrUsbViewController () <D5LedCmdDelegate, D5LedNetWorkErrorDelegate, UITableViewDelegate, UITableViewDataSource, D5UploadingViewDelegate, D5UploadFailedViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tfTableView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *tfOrUsbView;

@property (nonatomic, strong) NSArray *resultArr;

/** currentIndex */
@property (nonatomic, assign) int currentIndex;

/** TF中的歌曲存在着 */
@property (nonatomic, strong) NSMutableArray *TFArray;
// 没有歌曲的界面
@property (weak, nonatomic) IBOutlet UIView *noSongView;

/** D5TFDataModel */
@property (nonatomic, strong) D5TFDataModel *data;
@property (weak, nonatomic) IBOutlet UIButton *selectedAllBtn;

/** _progressCmd */
@property (nonatomic, strong) D5LedSpecialCmd *progressCmd;

/** deviceTypeCmd */
@property (nonatomic, strong) D5LedSpecialCmd *deviceTypeCmd;

@property (weak, nonatomic) IBOutlet UIButton *transtButton;
@property (weak, nonatomic) IBOutlet UIView *sureCancelView;

/** footer */
@property (nonatomic, strong) MJRefreshAutoGifFooter *footer;
@property (weak, nonatomic) IBOutlet UILabel *noSongLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

/** 是否点击取消 */
@property (nonatomic, assign) BOOL clickCancel;


/** 是否记录UUID */
@property (nonatomic, assign) BOOL needSaveUUID;

/** isSelfUpdate */
@property (nonatomic, assign) BOOL isSelfUpdate;

/** needHidden */
@property (nonatomic, assign) BOOL progressHidden;

@end

@implementation D5TFOrUsbViewController

#pragma mark - 懒加载
- (NSMutableArray *)TFArray
{
    if (!_TFArray) {
        _TFArray = [NSMutableArray array];
    }
    return _TFArray;
}




-(D5LedSpecialCmd *)progressCmd
{
    if (!_progressCmd) {
        _progressCmd = [[D5LedSpecialCmd alloc] init];
        _progressCmd.remoteLocalTag = tag_remote;
        _progressCmd.errorDelegate = self;
        _progressCmd.receiveDelegate = self;
        
        _progressCmd.cmdType = SpecialCmdTypePush;
    }
    _progressCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    _progressCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    _progressCmd.remoteIp = [D5CurrentBox currentBoxIP];
    return _progressCmd;
}

-(D5LedSpecialCmd *)deviceTypeCmd
{
    if (!_deviceTypeCmd) {
        _deviceTypeCmd = [[D5LedSpecialCmd alloc] init];
        _deviceTypeCmd.remoteLocalTag = tag_remote;
        _deviceTypeCmd.errorDelegate = self;
        _deviceTypeCmd.receiveDelegate = self;
        
        _deviceTypeCmd.cmdType = SpecialCmdTypePush;
    }
    _deviceTypeCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    _deviceTypeCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    _deviceTypeCmd.remoteIp = [D5CurrentBox currentBoxIP];
    return _deviceTypeCmd;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化界面
    [self initView];
    
    self.currentIndex = 0;
    [self getMusicInTfWithPageNum:self.currentIndex];
    
    [self setHeaderAndFooter];
    
    [D5UploadingView sharedUploadingView].delegate = self;
    [D5UploadFailedView sharedUploadFailedView].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMusic) name:SD_USB_Refresh object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toastError) name:Runtime_Info_Update object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureCancelClick:) name:@"cancelUpdate" object:nil];
    
    self.clickCancel = NO;
    self.needSaveUUID = YES;
    self.progressHidden = NO;
    
    [self.progressCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_ExtDeviceType];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self hideTipView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)hideTipView {
    [[D5UploadingView sharedUploadingView] hideTipView];
    [[D5UploadSuccessView sharedUploadSuccessView] hideTipView];
    [[D5UploadFailedView sharedUploadFailedView] hideTipView];
}

- (void)toastError
{
    BOOL isStorageNeedWarn = [D5RuntimeShareInstance sharedInstance].isStorageNeedWarn;
    
    __weak typeof(self) weakSelf = self;
    if (isStorageNeedWarn) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[D5UploadingView sharedUploadingView] hideTipView];
            [[D5WarningViewController warningView] showView];
            
            [[D5WarningViewController warningView] setBtnClickBlock:^{
                [weakSelf.tfTableView.mj_header beginRefreshing];

            }];
          //            [MBProgressHUD showMessage:@"内存小于200M"];
        });

    }
}

- (void)active {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf startRotateForImg:weakSelf.loadingImageView];
    });
}

// 下拉刷新上拉加载   stateLabel
- (void)setHeaderAndFooter{
//    self.tfTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateMusic)];
    [self addTableviewFooter];
    

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addTableviewFooter
{
     self.footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerUpdateMusic)];
    
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
    
    [self.footer setImages:upArray forState:MJRefreshStatePulling];
    [self.footer setImages:downArray forState:MJRefreshStateIdle];
    [self.footer setImages:freshImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    
    _tfTableView.mj_footer = self.footer;
    
}


- (void)updateMusic
{
    self.TFArray = nil;
    self.currentIndex = 0;
    [self getMusicInTfWithPageNum:self.currentIndex];
}

- (void)footerUpdateMusic
{
    self.currentIndex++;
    if (self.currentIndex >= self.data.totalNum) {
        [self.footer endRefreshingWithNoMoreData];
        self.footer.stateLabel.text = [NSString stringWithFormat:@"共%d首", (int)self.TFArray.count];
        return;
    }
    
    [self getMusicInTfWithPageNum:self.currentIndex];
    DLog(@"正在请求第%d页数据", self.currentIndex);
}

- (void)getMusicInTfWithPageNum:(int)pageNum{
    D5LedNormalCmd *ledCmd = [[D5LedNormalCmd alloc] init];
    ledCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    ledCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    ledCmd.remoteLocalTag = tag_remote;
    ledCmd.remoteIp = [D5CurrentBox currentBoxIP];
    ledCmd.errorDelegate = self;
    ledCmd.receiveDelegate = self;
    NSDictionary *dict = @{
                           LED_STR_PAGENUM : @(pageNum),
                           LED_STR_PAGESIZE : @(20)
                           };
    [ledCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Get_Music_TF withData:dict];

}

- (void)initView{
    [self startRotateForImg:self.loadingImageView];
    self.title = @"中控SD卡/USB传歌";
    
    [self setNavigationBarHidden:YES];
    self.loadingImageView.hidden = NO;
    self.tfOrUsbView.hidden = YES;
    self.noSongView.hidden = YES;
    self.selectedAllBtn.hidden = YES;
    
    self.sureCancelView.hidden = YES;
    _tfTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tfTableView.sectionIndexColor = [UIColor whiteColor];
}

- (void)checkSelected
{
    
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header{
    
    __weak typeof(self) weakSelf = self;
    
    if (errorType == D5SocketErrorCodeTypeExtDevicesNotMounted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            weakSelf.selectedAllBtn.hidden = YES;
            
        
            weakSelf.noSongView.hidden = NO;
            weakSelf.noSongLabel.text = @"中控盒子没有插入SD卡或USB设备";

        });

    } else if (errorType == D5SocketErrorCodeTypeFileCopyCutComplete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[D5UploadSuccessView sharedUploadSuccessView] showView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[D5UploadSuccessView sharedUploadSuccessView] hideTipView];
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[D5MainViewController class]]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
                        });
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
                
            });

        });

    } else if (errorType == D5SocketErrorCodeTypeExtUsbDeviceUnmount) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tfTableView.mj_header beginRefreshing];
            [weakSelf updateMusic];
            [[D5UploadingView sharedUploadingView] hideTipView];

        });

    } else if (errorType == D5SocketErrorCodeTypeStorageWarn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[D5UploadingView sharedUploadingView] hideTipView];
//            [MBProgressHUD showMessage:@"内存小于200M"];
            [[D5WarningViewController warningView] showView];
            [[D5WarningViewController warningView] setBtnClickBlock:^{
//                [weakSelf.tfTableView.mj_header beginRefreshing];
                [weakSelf updateMusic];
            }];
        });

    } else if (errorType == -110) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isSelfUpdate = NO;
            [MBProgressHUD showMessage:@"有人正在上传歌曲，请等候"];
        });

    } else if (errorType == -108) {
        [weakSelf reScanMusic:nil];
    }
    
    
}

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict
{
    
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{

        [weakSelf.tfTableView.mj_footer endRefreshing];
    
        
    });

    if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Get_Music_TF) {
        int code = [dict[LED_STR_CODE] intValue];

            if (code == LedCodeSuccess) {  // 读取音乐成功并且返回了列表
                
               
                
                if (self.needSaveUUID) {
                    weakSelf.data = [D5TFDataModel mj_objectWithKeyValues:dict[LED_STR_DATA]];
                }
                
                self.currentIndex = self.data.pageNum;
                
                if ([self.selectedAllBtn.currentTitle isEqualToString:ALL_SELECT]) {
                
                } else {
                    for (D5TFMusicModel *model in weakSelf.data.list) {
                        model.selected = YES;
                    }
                }
            
                if (weakSelf.data.pageNum + 1 >= weakSelf.data.totalNum) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tfTableView.mj_footer endRefreshingWithNoMoreData];
                        
                        weakSelf.footer.stateLabel.text = [NSString stringWithFormat:@"共%d首歌", (int)weakSelf.TFArray.count];
                    });
                }

                
                // 操作太耗时了， 后面修改
                [weakSelf.TFArray addObjectsFromArray:weakSelf.data.list];
                D5HLocalMusicList *list = [D5HLocalMusicList shareInstance];
                [list setTfMusicBlock:^(NSArray *result) {
                    weakSelf.resultArr = [NSArray arrayWithArray:result];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSInteger selectedNum = 0;
                        
                        for (D5TFMusicModel *model in weakSelf.TFArray) {
                            if (model.selected == YES) {
                                selectedNum += 1;
                            }
                        }

                        weakSelf.totalLabel.text = [NSString stringWithFormat:@"已选择%d首歌",selectedNum];

                        [weakSelf.tfTableView reloadData];
                        weakSelf.loadingImageView.hidden = YES;
                        weakSelf.tfOrUsbView.hidden = NO;
                        weakSelf.noSongView.hidden = YES;
                        weakSelf.selectedAllBtn.hidden = NO;
                        
                        if (!weakSelf.resultArr || weakSelf.resultArr.count == 0) {
                            weakSelf.noSongView.hidden = NO;
                            weakSelf.selectedAllBtn.hidden = YES;
                            if (weakSelf.data.extDeviceType == Usb_Only) {
                                weakSelf.noSongLabel.text = @"USB存储设备中没有新的歌曲哦";
                            } else if (weakSelf.data.extDeviceType == Sdcard_Only) {
                                weakSelf.noSongLabel.text = @"SD卡中没有新的歌曲哦";
                            } else {
                                weakSelf.noSongLabel.text = @"SD卡/USB存储设备中没有新的歌曲哦";
                            }
                        } else {
                            weakSelf.noSongView.hidden = YES;
                            weakSelf.selectedAllBtn.hidden = NO;
                        }
                    });
                    
                }];
                [list sortedTFMusicArr:weakSelf.TFArray];
                
//
                
                NSDictionary *dict = @{
                                       LED_STR_UUID : weakSelf.data.uuid
                                       };
                
                [weakSelf.progressCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Trans_Progress withData:dict];

        }
    } else if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Trans_TFMusic){
        int code = [dict[LED_STR_CODE] intValue];
        
        
        if (code == LedCodeSuccess) {
            DLog(@"开始上传成功");
        } else {
            DLog(@"开始上传失败");
        }
        
        
    } else if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_ExtDeviceType) {
        DLog(@"----- 4- 10  %@", dict);
        NSDictionary *data = dict[LED_STR_DATA];
        NSInteger type = [data[LED_STR_EXT_DEVICE_TYPE] intValue];
        

        if (type == Usb_Only) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

            [MBProgressHUD showMessage:@"USB存储设备已插入"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf reScanMusic:nil];

                });
                

                
            });
        } else if (type == Sdcard_Only) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

            [MBProgressHUD showMessage:@"SD卡已插入"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf reScanMusic:nil];

                });
                

        });
            

        }
    
        
    } else if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Trans_Progress) {
        
        NSDictionary *progressDict = dict[LED_STR_DATA];
        DLog(@"%@", dict);
        D5ProgressModel *model = [D5ProgressModel mj_objectWithKeyValues:progressDict];
        int code = [dict[LED_STR_CODE] intValue];
                if ([weakSelf.data.uuid isEqualToString: model.uuid]) {
                    if (weakSelf.sureCancelView.hidden == NO) return;
                    if (!self.progressHidden) {
                        if (self.TFArray.count > 0) {
                            D5TFMusicModel *musicModel = self.TFArray[0];
                            dispatch_async(dispatch_get_main_queue(), ^{

                            [[D5UploadingView sharedUploadingView] showUploadIngViewByIndex:0 totalCount:(int)model.totalSize musicName:musicModel.name progress:0];
                            });
                        }

                    }
                    self.progressHidden = YES;

                    if (code == LedCodeSuccess && model.completeSize != model.totalSize) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                     if (weakSelf.clickCancel) return ;
                         
                         [[D5UploadingView sharedUploadingView] updateProgress:model.file.progress currentIndex:model.completeSize musicName:model.file.name];
                         if (model.completeSize >= 1) {
                             AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                             delegate.isNeedRefresh = YES;
                         }

                     });
                

                    } else if ((model.completeSize == model.totalSize)
                       || code == 2) {
                
                     dispatch_async(dispatch_get_main_queue(), ^{
                        [[D5UploadSuccessView sharedUploadSuccessView] showView];
                         self.needSaveUUID  =YES;

                     });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[D5UploadSuccessView sharedUploadSuccessView] hideTipView];
                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[D5MainViewController class]]) {
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
                                });
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }

                    });
                } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                        [[D5UploadFailedView sharedUploadFailedView] showView];
                         self.needSaveUUID  =YES;
                     });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[D5UploadFailedView sharedUploadFailedView] hideTipView];
                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[D5MainViewController class]]) {
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
                                });
                                    [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }
                    });

                }
                }
    }


}

- (void)scanNoSongView
{
    
}



#pragma mark - <TableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_resultArr) {
        return 0;
    }
    
    return _resultArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_resultArr && section < _resultArr.count) {
        NSDictionary *dict = _resultArr[section];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    D5TFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:D5_TF_CELL];
    // 设置cell的背景色
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:37/225.0 green:37/255.0 blue:37/255.0 alpha:1];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    }
    
    //如果当前row小于本地音乐列表
    D5TFMusicModel *data = [D5HLocalMusicList tfModelFromArr:_resultArr atSection:section atRow:row];
    if (data) {
        cell.TFMusic = data;
    }
    __weak typeof(self) weakSelf = self;
    [cell setCheckBlock:^{
        NSInteger selectedNumber = 0;
        
        for (D5TFMusicModel *model in weakSelf.TFArray) {
            if (model.selected == YES) {
                selectedNumber = selectedNumber + 1;
            }
            
            if (selectedNumber > 0) {
                [weakSelf setBtnEnable:weakSelf.transtButton enable:YES];
            }
            
                [weakSelf.selectedAllBtn setTitle:@"全选" forState:UIControlStateNormal];
                  weakSelf.totalLabel.text = [NSString stringWithFormat:@"已选择%d首歌", selectedNumber];

        }
    }];
 
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [D5HLocalMusicList titleFromArr:_resultArr atSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    @autoreleasepool {
        NSInteger resultSection = [D5HLocalMusicList indexForTitle:title fromArr:_resultArr];
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

- (IBAction)transTFMusicClick:(UIButton *)sender {
    
    [MobClick event:UM_ADD_MUSIC_TYPE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", UMAddMusicTypeUSB]}];
    self.clickCancel = NO;
    self.needSaveUUID = NO;
    NSMutableArray *array = [NSMutableArray array];
    for (D5TFMusicModel *model in self.TFArray) {
        if (model.selected) {
            NSDictionary *dict = @{
                                   LED_STR_KEY : model.key,
                                   LED_STR_ID : @(model.TFMusicId)
                                   };

            [array addObject:dict];
        }
    }
    
    NSDictionary *sendDict = @{
                               LED_STR_TYPE : @(TF_Copy_Files),
                               LED_STR_UUID : self.data.uuid,
                               LED_STR_LIST : array
                               };
    
    D5LedNormalCmd *ledCmd = [[D5LedNormalCmd alloc] init];
    ledCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    ledCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    ledCmd.remoteLocalTag = tag_remote;
    ledCmd.remoteIp = [D5CurrentBox currentBoxIP];
    ledCmd.errorDelegate = self;
    ledCmd.receiveDelegate = self;
    [ledCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Trans_TFMusic withData:sendDict];
    
    

}



- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectedAllBtnClick:(id)sender {
    if ([self.selectedAllBtn.titleLabel.text isEqualToString:CANCEL_ALL_SELECT]) {
        [self.selectedAllBtn setTitle:ALL_SELECT forState:UIControlStateNormal];
        for (D5TFMusicModel *model in self.TFArray) {
            model.selected = NO;
        }
        [self setBtnEnable:self.transtButton enable:NO];
        self.totalLabel.text = [NSString stringWithFormat:@"已选择0首歌"];

        

    } else {
        [self.selectedAllBtn setTitle:CANCEL_ALL_SELECT forState:UIControlStateNormal];
        for (D5TFMusicModel *model in self.TFArray) {
            model.selected = YES;
        }
        [self setBtnEnable:self.transtButton enable:YES];
        self.totalLabel.text = [NSString stringWithFormat:@"已选择%d首歌", self.TFArray.count];

    }
    [self.tfTableView reloadData];
}

- (IBAction)reScanMusic:(id)sender {
    self.tfOrUsbView.hidden = YES;
    self.loadingView.hidden = NO;
    self.noSongView.hidden = YES;
    self.selectedAllBtn.hidden = YES;
    self.loadingImageView.hidden = NO;
    self.TFArray = nil;
    [self getMusicInTfWithPageNum:0];
}

#pragma mark - <tipviewDelegate>


- (void)uploadIngCancelUpload:(D5UploadingView *)uploadView {
        self.clickCancel = YES;

        self.sureCancelView.hidden = NO;
        [uploadView hideTipView];
        NSDictionary *sendDict = @{
                                   LED_STR_TYPE : @(TF_Pause),
                                   LED_STR_UUID : self.data.uuid,
                                   };
        
        D5LedNormalCmd *ledCmd = [[D5LedNormalCmd alloc] init];
        ledCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
        ledCmd.strDestMac =  [D5CurrentBox currentBoxMac];
        ledCmd.remoteLocalTag = tag_remote;
        ledCmd.remoteIp = [D5CurrentBox currentBoxIP];
        ledCmd.errorDelegate = self;
        ledCmd.receiveDelegate = self;
        [ledCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Trans_TFMusic withData:sendDict];
        

    
}

- (IBAction)sureCancelClick:(id)sender {

    self.sureCancelView.hidden = YES;
    NSDictionary *sendDict = @{
                               LED_STR_TYPE : @(TF_Cancle),
                               LED_STR_UUID : self.data.uuid,
                               };
    
    D5LedNormalCmd *ledCmd = [[D5LedNormalCmd alloc] init];
    ledCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    ledCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    ledCmd.remoteLocalTag = tag_remote;
    ledCmd.remoteIp = [D5CurrentBox currentBoxIP];
    ledCmd.errorDelegate = self;
    ledCmd.receiveDelegate = self;
    [ledCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Trans_TFMusic withData:sendDict];
    [[D5UploadingView sharedUploadingView] hideTipView];
    [self updateMusic];
    self.needSaveUUID = YES;
    self.progressHidden = NO;
    


}

- (IBAction)notCancelClick:(id)sender {
    self.clickCancel = NO;

    self.sureCancelView.hidden = YES;
    NSDictionary *sendDict = @{
                               LED_STR_TYPE : @(TF_Continue),
                               LED_STR_UUID : self.data.uuid,
                               };
    
    D5LedNormalCmd *ledCmd = [[D5LedNormalCmd alloc] init];
    ledCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    ledCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    ledCmd.remoteLocalTag = tag_remote;
    ledCmd.remoteIp = [D5CurrentBox currentBoxIP];
    ledCmd.errorDelegate = self;
    ledCmd.receiveDelegate = self;
    [ledCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Trans_TFMusic withData:sendDict];
    [[D5UploadingView sharedUploadingView] showView];

}

@end
