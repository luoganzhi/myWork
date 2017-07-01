//
//  D5LedZKTList.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/30.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5LedZKTBoxData.h"
#import "D5LedList.h"

typedef enum _zkt_add_status {
    ZKTAddStatusIng = 1,
    ZKTAddStatusSuccess,
    ZKTAddStatusFailed,
    ZKTAddStatusSearched
}ZKTAddStatus;

typedef enum _login_status {
    LedLoginStatusNotLogin = 0, // 未登录
    LedLoginStatusLoginSuccess, // 登录成功
    LedLoginStatusLoginFailed   // 登录失败
}LedLoginStatus;

@class D5LedZKTList;

@protocol D5LedZKTListDelegate <NSObject>

- (void)ledZKTList:(D5LedZKTList *)zktList getFinished:(BOOL)flag;
@optional
- (void)ledZKTList:(D5LedZKTList *)zktList countDownInterval:(NSTimeInterval)interval;

- (void)ledZKTList:(D5LedZKTList *)zktList searchedZKT:(NSDictionary *)dict;

@end

@interface D5LedZKTList : NSObject

@property (nonatomic, weak) id<D5LedZKTListDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *list;

@property (nonatomic, assign) LedLoginStatus loginStatus;

#pragma mark - 初始化
+ (D5LedZKTList *)defaultList;

- (NSMutableArray *)getList;

#pragma mark - 根据条件查找中控dict
- (NSDictionary *)zktDictById:(NSString *)boxId;
- (NSDictionary *)zktDictByIp:(NSString *)ip;

#pragma mark - 中控列表数
- (NSInteger)ledZKTListCount;

/**
 登录中控

 @param ip
 @param mac
 */
- (void)sendLoginToBox:(NSString *)ip withMac:(NSString *)mac;

#pragma mark - 给本地中控建立TCP链接
- (void)connectLocalZKT;

/**
 结束心跳
 */
- (void)finishHeart;

#pragma mark - 获取列表 -- 本地/服务器
- (D5LedZKTList *)getZKTListFromLocal;
- (void)getZKTListFromServer;

- (void)stopSearchBox;

@end
