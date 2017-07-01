//
//  D5LedZKTList.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/30.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedZKTList.h"
#import "D5TcpManager.h"
#import "D5UdpPingManager.h"
#import "D5DisconnectTipView.h"

#define HEART_TIMER_INTERVAL 60.0f
#define SEARCH_TIMER_INTERVAL 30.0f
#define SEND_INTERVAL 1.0f

static D5LedZKTList *defaultZKTList = nil;

@interface D5LedZKTList()<D5LedNetWorkErrorDelegate, D5LedCmdDelegate, D5TcpDelegate>

@property (nonatomic, strong) NSMutableArray *needConnectArr; //需要链接的Arr
@property (nonatomic, strong) NSMutableArray *connectNewipIDArr; //连接的是最新的IP的中控ID数组 -- 失败了则不再连接
@property (nonatomic, assign) BOOL isGetedFromServer; //监听是否发送过广播
@property (nonatomic, assign) BOOL isNeedConnect; //是否需要链接

@property (nonatomic, strong) NSTimer *heartTimer;

/** 搜索中控 */
@property (nonatomic, strong) D5LedSpecialCmd *boxScan;


@property (nonatomic, strong) D5LedSpecialCmd *boxHeart;

@property (nonatomic, strong) NSTimer *searchTimer;
@property (nonatomic, assign) NSTimeInterval interval;

@property (nonatomic, assign) NSTimeInterval lastReceivedHeartTimeStamp;

@end

@implementation D5LedZKTList

#pragma mark - 初始化
- (instancetype)init {
    if (self = [super init]) {
        _list = [NSMutableArray array];
        _loginStatus = LedLoginStatusNotLogin;
        
        _isNeedConnect = NO;
        
        _lastReceivedHeartTimeStamp = 0;
        
    }
    return self;
}

+ (D5LedZKTList *)defaultList {
    @autoreleasepool {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            defaultZKTList = [[D5LedZKTList alloc] init];
        });
        return defaultZKTList;
    }
}

- (void)setDelegate:(id<D5LedZKTListDelegate>)delegate {
    _delegate = delegate;
    if (delegate == nil) {
        [self stopSearchBox];
    }
}

#pragma mark - 获取中控列表
- (NSMutableArray *)getList {
    return _list;
}

- (NSInteger)ledZKTListCount {
    if (!_list || _list.count <= 0) {
        return 0;
    }
    
    return _list.count;
}

- (NSDictionary *)zktDictById:(NSString *)boxId {
    @autoreleasepool {
        if (!_list || _list.count <= 0) {
            return nil;
        }
        
        for (NSDictionary *dict in _list) {
            @autoreleasepool {
                if ([boxId isEqualToString:dict[ZKT_BOX_ID]]) {
                    return dict;
                }
                break;
            }
        }
        
        return nil;
    }
}

- (NSDictionary *)zktDictByIp:(NSString *)ip {
    @autoreleasepool {
        if (!_list || _list.count <= 0) {
            return nil;
        }
        
        for (NSDictionary *dict in _list) {
            @autoreleasepool {
                if ([ip isEqualToString:dict[ZKT_BOX_IP]]) {
                    return dict;
                }
                break;
            }
        }
        
        return nil;
    }
}

#pragma mark - 获取中控列表（本地/服务器)
- (D5LedZKTList *)getZKTListFromLocal {
    @autoreleasepool {
        @autoreleasepool {
            [_list removeAllObjects];
            
            NSDictionary *box = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_ZKT_KEY];
            [_list addObject:box];
            
            return self;
        }
    }
}

/**
 发送广播搜索中控列表
 */
- (void)getZKTListFromServer {
    @autoreleasepool {
        [_list removeAllObjects];
        _interval = 0;
        _searchTimer = [NSTimer scheduledTimerWithTimeInterval:SEND_INTERVAL target:self selector:@selector(sendScanBox) userInfo:nil repeats:YES];
        [_searchTimer fire];
    }
}

- (D5LedSpecialCmd *)boxScan {
    if (!_boxScan) {
        _boxScan = [[D5LedSpecialCmd alloc] init];
        
        _boxScan.strDestMac = BROADCAST_DEST_MAC_STR;
        _boxScan.remotePort = LED_BOX_RECEIVE_PORT;
        _boxScan.errorDelegate = self;
        _boxScan.receiveDelegate = self;
        
        _boxScan.cmdType = SpecialCmdTypeBroadCast;
    }
    
    return _boxScan;
}

- (void)sendScanBox {
    @autoreleasepool {
        DLog(@"发送搜索中控 _inter = %f", _interval);
        NSDictionary *sendDict = @{LED_STR_BSSID : [D5NetWork getCurrentBssid],
                                   LED_STR_WIFINAME : [D5NetWork getCurrentWifiName],
                                   LED_STR_WIFIPWD : @""};
        
        [self.boxScan ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Scan withData:sendDict];
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(ledZKTList:countDownInterval:)]) {
            [_delegate ledZKTList:self countDownInterval:_interval];
        }
        
        _interval += SEND_INTERVAL;
        if (_interval > SEARCH_TIMER_INTERVAL) {
            [self searchTimeOut];
        }
    }
}

#pragma mark - 接收到数据
- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict withIP:(NSString *)ip {
    @autoreleasepool {
        if (header->cmd == Cmd_Box_Operate && (header->subCmd == SubCmd_Box_Scan || header->subCmd == SubCmd_Box_App_Login)) {
            if (!dict) {
                return;
            }
            
            NSDictionary *data = dict[LED_STR_DATA];
            if (!data) {
                return;
            }
            
            switch (header->subCmd) {
                case SubCmd_Box_Scan: {  // 搜索中控
                    NSDictionary *newDict = @{ZKT_BOX_ID : data[LED_STR_ID],
                                              ZKT_BOX_NAME : data[LED_STR_NAME],
                                              ZKT_BOX_TYPE : data[LED_STR_TYPE],
                                              ZKT_BOX_TCP_PORT : @([data[LED_STR_TCPPORT] intValue]),
                                              ZKT_BOX_IP : ip,
                                              ZKT_BOX_MAC : [D5SocketBaseTool macFormatStrFromMacCharArr:header->srcMac]
                                              };
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *localBox = [D5CurrentBox currentBox];
                        if (!localBox) {
                            [_list addObject:newDict];
                        } else {
                            NSString *boxID = newDict[ZKT_BOX_ID];
                            if (![boxID isEqualToString:localBox[ZKT_BOX_ID]]) {    // 不是本地中控
                                [_list addObject:newDict];
                            } else {    // 本地中控，判断IP是否改变
                                
                            }
                        }
                        
                        if (_delegate && [_delegate respondsToSelector:@selector(ledZKTList:searchedZKT:)]) {
                            [_delegate ledZKTList:self searchedZKT:newDict];
                        }
                        
                        if (_isNeedConnect) {
                            [self handleSearchResult:newDict];
                        }
                    });
                    
                }
                    break;
                case SubCmd_Box_App_Login : {
                    _loginStatus = LedLoginStatusLoginSuccess;
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:CURRENT_LOGIN_BOX];    // 保存所有信息
                    [D5CurrentBox setRunTimeInfo];
                    [self sendHeartToZKT];
                    [[D5LedList sharedInstance] getLedListByType:LedListTypeHasAdded];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                    });
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
}

/**
 心跳返回数据
 
 @param header
 */
- (void)ledCmdReceivedData:(LedHeader *)header {
    @autoreleasepool {
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Heart) {
            _lastReceivedHeartTimeStamp = [D5Date currentTimeStamp];
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {    
    if (header->cmd == Cmd_Box_Operate) {
        switch (header->subCmd) {
            case SubCmd_Box_Scan: {
                if (errorType == D5SocketErrorCodeTypeTimeOut) {
                    return;
                }
                
                if (_delegate && [_delegate respondsToSelector:@selector(ledZKTList:getFinished:)]) {
                    [_delegate ledZKTList:self getFinished:NO];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopSearchBox];
                });
            }
                break;
            case SubCmd_Box_App_Login: {    // 登录
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"登录返回失败了 --- 重新登录");
                    
                    _loginStatus = LedLoginStatusLoginFailed;
                    [self sendLoginToBox:[D5CurrentBox currentBoxIP] withMac:[D5CurrentBox currentBoxMac]];
                });
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 处理搜索到的结果

/**
 根据ID替换_list中的dict
 
 @param imeiCode
 @param dict
 */
- (void)replaceDictById:(NSString *)boxID withNewDict:(NSDictionary *)dict {
    @autoreleasepool {
        if (!_list || _list.count <= 0) {
            return;
        }
        
        [_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if ([obj[ZKT_BOX_ID] isEqualToString:boxID]) {
                    [_list replaceObjectAtIndex:idx withObject:dict];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSDictionary *selectedZKT = [userDefaults objectForKey:SELECTED_ZKT_KEY];
                    if (selectedZKT) {
                        if ([boxID isEqualToString:selectedZKT[ZKT_BOX_ID]]) { //如果刚好有更新的dict 是本地已选择的中控
                            [userDefaults setObject:dict forKey:SELECTED_ZKT_KEY];
                            [userDefaults synchronize];
                        }
                        *stop = YES;
                    }
                }
            }
        }];
    }
}

/**
 处理搜索结果 -- 是否是本地中控，如果是，则看是否需要替换
 
 @param dict 搜索到的中控
 */
- (void)handleSearchResult:(NSDictionary *)dict {
    @autoreleasepool {
        @autoreleasepool {
            NSString *boxID = dict[ZKT_BOX_ID];
            
            NSDictionary *localBox = [D5CurrentBox currentBox];
            
            if (![localBox isEqualToDictionary:dict]) {             // 是本地中控，但有变动 -- 替换
                [self searchTimeOut]; // 不再搜索
                [self replaceDictById:localBox[ZKT_BOX_ID] withNewDict:dict];
            }
            
            // 是否需要连接 -- 需要则去连接
            if ([self.needConnectArr containsObject:boxID]) { //在需要链接的arr中
                [[D5LedCommunication sharedLedModule] tcpConnect:dict[ZKT_BOX_IP] port:[D5CurrentBox currentBoxTCPPort]];
                [self.needConnectArr removeObject:boxID];
            }
        }
    }
}

//搜索30s完成 -- 关闭广播、定时器、缓存新的列表到本地
- (void)searchTimeOut {
    @autoreleasepool {
        if (_delegate && [_delegate respondsToSelector:@selector(ledZKTList:getFinished:)]) {
            [_delegate ledZKTList:self getFinished:YES];
        }
        
        _interval = 0;
        
        [self stopSearchBox];
    }
}

/**
 关闭定时器
 */
- (void)stopSearchTimer {
    if (_searchTimer) {
        [_searchTimer invalidate];
        _searchTimer = nil;
    }
}


#pragma mark - 初始化数组
- (NSMutableArray *)needConnectArr {
    @autoreleasepool {
        if (!_needConnectArr) {
            _needConnectArr = [NSMutableArray array];
        }
        return _needConnectArr;
    }
}

- (NSMutableArray *)connectNewipIDArr {
    @autoreleasepool {
        if (!_connectNewipIDArr) {
            _connectNewipIDArr = [NSMutableArray array];
        }
        return _connectNewipIDArr;
    }
}

#pragma mark - 给本地中控建立TCP链接

/**
 连接本地中控
 */
- (void)connectLocalZKT {
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess:) name:TCP_CONNECT_SUCCESS object:nil];
        NSDictionary *box = [D5CurrentBox currentBox];
        if (!box) {
            return;
        }
        
        NSString *ip = [D5CurrentBox currentBoxIP];
        if (![NSString isValidateString:ip]) {
            return;
        }
        
        [[D5LedCommunication sharedLedModule] tcpConnect:ip port:[D5CurrentBox currentBoxTCPPort]];
    }
}

- (void)stopSearchBox {
    @autoreleasepool {
        [self.boxScan finishReceive];
        [self stopSearchTimer];
    }
}

#pragma mark - tcp delegate -- 链接结果
- (void)connectSuccess:(NSNotification *)notification {
    @autoreleasepool {
        DLog(@"connectSuccess   %d", ![D5CurrentBox currentBox]);
        if (![D5CurrentBox currentBox]) {
            return;
        }
        
        D5Tcp *tcp = (D5Tcp *)notification.object;
        DLog(@"connectSuccess   %@",tcp);
        
        if ([D5TcpManager isCurrentBoxTcp:tcp]) {
            DLog(@"connectSuccess 当前tcp");
            [self sendLoginToBox:[D5CurrentBox currentBoxIP] withMac:[D5CurrentBox currentBoxMac]];
        }
    }
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - 发送登录命令
- (void)sendLoginToBox:(NSString *)ip withMac:(NSString *)mac {
    @autoreleasepool {
        if (_loginStatus == LedLoginStatusLoginSuccess) {   // 登录成功
            return;
        }
        
        D5LedNormalCmd *ledBoxLogin = [[D5LedNormalCmd alloc] init];
        
        ledBoxLogin.strDestMac = mac;
        ledBoxLogin.remoteLocalTag = tag_remote;
        ledBoxLogin.remotePort = [D5CurrentBox currentBoxTCPPort];
        ledBoxLogin.remoteIp = ip;
        ledBoxLogin.errorDelegate = self;
        ledBoxLogin.receiveDelegate = self;
        
        [ledBoxLogin ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_App_Login];
    }
}

#pragma mark - 发送心跳获取中控开关
- (void)sendHeartToZKT {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self heartTimerNil];
            
            _heartTimer = [NSTimer scheduledTimerWithTimeInterval:HEART_TIMER_INTERVAL target:self selector:@selector(sendGetOnOffToBox) userInfo:nil repeats:YES];
            [_heartTimer fire];
        });
    }
}

- (void)heartTimerNil {
    if (_heartTimer) {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
}

- (void)finishHeart {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self heartTimerNil];
    });
    [self.boxHeart finishReceive];
    
    _lastReceivedHeartTimeStamp = 0;
}

#pragma mark - 获取中控的开关状态
- (D5LedSpecialCmd *)boxHeart {
    if (!_boxHeart) {
        _boxHeart = [[D5LedSpecialCmd alloc] init];
        
        _boxHeart.remoteLocalTag = tag_remote;
        _boxHeart.errorDelegate = self;
        _boxHeart.receiveDelegate = self;
        
        _boxHeart.cmdType = SpecialCmdTypeHeart;
    }
    _boxHeart.strDestMac = [D5CurrentBox currentBoxMac];
    _boxHeart.remoteIp = [D5CurrentBox currentBoxIP];
    _boxHeart.remotePort = [D5CurrentBox currentBoxTCPPort];
    
    return _boxHeart;
}

- (void)sendGetOnOffToBox {
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
            [self.boxHeart ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Heart];
            
            if (_lastReceivedHeartTimeStamp == 0) {  //第一次获取心跳
                return;
            }
            
            NSTimeInterval sendTimeStamp = [D5Date currentTimeStamp];
            if ((sendTimeStamp - _lastReceivedHeartTimeStamp) >= 2 * HEART_TIMER_INTERVAL) {   //+ 断开连接了  手动断开的，但需要显示出来
                DLog(@"断开连接了 %f", (sendTimeStamp - _lastReceivedHeartTimeStamp));
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:HEART_TIMEOUT_DISCONNECT object:[[D5TcpManager defaultTcpManager] tcpOfServer:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]]];
                });
            }
        });
    }
}

@end
