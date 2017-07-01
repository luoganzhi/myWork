//
//  D5SpecialLibraryViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/7/20.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SpecialLibraryViewController.h"
#import "D5SpecialCell.h"
#import "D5LedMusicConfigEffectList.h"
#import "D5MusicConfigPlayEffect.h"
#import "D5MusicSpecialData.h"

@interface D5SpecialLibraryViewController () <UITableViewDelegate, UITableViewDataSource, D5LedNetWorkErrorDelegate, D5LedMusicConfigEffectListDelegate, D5LedMusicConfigPlayEffectDelegate>

@property (weak, nonatomic) IBOutlet UITableView *specialTableView;
@property (strong, nonatomic)  NSMutableArray *specialArr, *specialDatas;


/** 获取特效库 */
@property (nonatomic, strong) D5LedMusicConfigEffectList *musicConfigEffectList;
/** D5MusicConfigPlayEffect */
@property (nonatomic, strong) D5MusicConfigPlayEffect *configPlay;

@end

@implementation D5SpecialLibraryViewController

// 获取特效列表
- (D5LedMusicConfigEffectList *)musicConfigEffectList
{
    if (!_musicConfigEffectList) {
        _musicConfigEffectList = [[D5LedMusicConfigEffectList alloc] init];
        NSString  *boxIP = [[NSUserDefaults standardUserDefaults] objectForKey:@"selected_box_ip"];
        
        
        NSDictionary *dict = [[D5LedZKTList defaultList] zktDictByIP:boxIP];
        
        NSString *mac = dict[ZKT_BOX_MAC];
        
        _musicConfigEffectList.strSrcMac = SRC_MAC_STR;
        _musicConfigEffectList.localIp = nil;
        _musicConfigEffectList.localPort = 0;
        _musicConfigEffectList.strDestMac = mac;
        _musicConfigEffectList.remoteLocalTag = tag_remote;
        _musicConfigEffectList.remotePort = LED_TCP_LONG_CONN_PORT;
        _musicConfigEffectList.remoteIp = boxIP;
        _musicConfigEffectList.errorDelegate = self;

    }
    return _musicConfigEffectList;
}

// 播放特效
- (D5MusicConfigPlayEffect *)configPlay
{
    if (!_configPlay) {
        _configPlay = [[D5MusicConfigPlayEffect alloc] init];
        NSString  *boxIP = [[NSUserDefaults standardUserDefaults] objectForKey:@"selected_box_ip"];
        NSDictionary *dict = [[D5LedZKTList defaultList] zktDictByIP:boxIP];
        
        NSString *mac = dict[ZKT_BOX_MAC];
        
        _configPlay.strSrcMac = SRC_MAC_STR;
        _configPlay.localIp = nil;
        _configPlay.localPort = 0;
        _configPlay.strDestMac = mac;
        _configPlay.remoteLocalTag = tag_remote;
        _configPlay.remotePort = LED_TCP_LONG_CONN_PORT;
        _configPlay.remoteIp = boxIP;
        _configPlay.errorDelegate = self;
        
    }
    return _configPlay;
    
}



#pragma mark - <MyDelegate>
- (void)d5NetWorkError:(int64_t)errorType errorMessage:(NSString *)errorMesssage forHeader:(LedHeader *)header
{
    @autoreleasepool {
        if (errorType == D5SocketErrorCodeTypeTimeOut) {
            NSLog(@"获取特效库超时:%d->%d",header->cmd,header->subCmd);
        } else if (errorType == D5SocketErrorCodeTypeTCPSendDataFailed) {
        }
        
    }
}

- (void)ledMusicConfigPlayEffectReturn:(int64_t)result
{
    if (result < 0) {
        NSLog(@"预览特效失败");
    } else {
        NSLog(@"预览特效成功");
    }
}


// 获取特效库列表
- (void)ledMusicConfigEffectListReturn:(NSArray *)configDatas
{
    self.specialArr = [NSMutableArray arrayWithArray:configDatas];
    
    if (self.specialArr.count > 0) {
        for (NSDictionary *dict in self.specialArr) {
            @autoreleasepool {
                D5MusicSpecialData *data = [D5MusicSpecialData dataWithDict:dict];
                if (data) {
                    [self.specialDatas addObject:data];
                }
            }
        }
    }

    
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        [self.specialTableView reloadData];
    });

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    [[D5LedModule sharedLedModule].resultMuticast addCmdMuticastDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.musicConfigEffectList ledMusicConfigEffectList];
}

- (void)dealloc
{
    [[D5LedModule sharedLedModule].resultMuticast removeCmdMuticastDelegate:self];

}

- (void)initView {
    self.title = @"特效库";
    
}
//
//- (NSMutableArray *)specialArr {
//    @autoreleasepool {
//        if (!_specialArr) {
//            _specialArr = [NSMutableArray arrayWithObjects:
//                           @{SPECIAL_NAME : @"KTV炫彩快闪",
//                             SPECIAL_DJ : @"DJ.BigBoss"},
//                           @{SPECIAL_NAME : @"欢天喜地（节日通用）",
//                             SPECIAL_DJ : @"DJ.BigBoss"},
//                           @{SPECIAL_NAME : @"童话世界",
//                             SPECIAL_DJ : @"DJ.BigBoss"}, nil];
//        }
//        
//        return _specialArr;
//    }
//}

- (NSMutableArray *)specialDatas {
    if (!_specialDatas) {
        _specialDatas = [NSMutableArray array];
        if (self.specialArr.count > 0) {
            for (NSDictionary *dict in self.specialArr) {
                @autoreleasepool {
                    D5MusicSpecialData *data = [D5MusicSpecialData dataWithDict:dict];
                    if (data) {
                        [self.specialDatas addObject:data];
                    }
                }
            }
        }
    }
    return _specialDatas;
}


#pragma mark - 点击事件
- (IBAction)btnCloseClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.specialDatas.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //选择
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5SpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:SPECIAL_CELL_ID];
        if (!cell) {
            cell = [[D5SpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SPECIAL_CELL_ID];
        }
        
        NSInteger row = indexPath.row;
        if (row < self.specialDatas.count) {
            
            D5MusicSpecialData *data = self.specialDatas[row];
            
            [cell setData:data];
            
            [cell setLookBlock:^{
                LedConfigPlayEffect configEffect;
                configEffect.type = 3;
                configEffect.effectId = data.specialId;
                
                [self.configPlay ledMusicConfigPlayEffect:configEffect];
            }];
        }
       
        return cell;
    }
}
@end
