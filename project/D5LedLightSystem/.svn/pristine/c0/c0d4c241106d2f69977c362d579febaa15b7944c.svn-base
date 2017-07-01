//
//  D5CmdMuticast.h
//  Network
//
//  Created by anthonyxoing on 15/9/8.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CastBlock)(id obj);

@interface D5CmdMuticast : NSObject

@property(strong, nonatomic) NSMutableArray *delegateList;

/**
 *  将delegate加入到delegateList中
 *
 *  @param delegate
 */
- (void)addCmdMuticastDelegate:(id)delegate;

/**
 *  delegateList从muticast中加obj
 *
 *  @param muticast
 */
- (void)addCmdMuticastDelegateFrom:(D5CmdMuticast *)muticast;

/**
 *  从delegateList移除delegate
 *
 *  @param delegate
 */
- (void)removeCmdMuticastDelegate:(id)delegate;

/**
 *  判断delegate是否存在于delegateList中
 *
 *  @param delegate
 *
 *  @return 是否存在
 */
- (BOOL)isExistCmdMuticastDelegate:(id)delegate;

/**
 *  delegateList中obj的个数
 *
 *  @return count
 */
- (NSInteger)count;
@end
