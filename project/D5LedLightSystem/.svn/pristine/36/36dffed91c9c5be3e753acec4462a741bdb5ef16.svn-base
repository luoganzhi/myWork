//
//  D5MutiCmd.h
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//  cmd的管理
//

#import <Foundation/Foundation.h>

@interface D5MutiCmd : NSObject

/**
 添加cmd到list

 @param cmd cmd
 */
- (void)addCmd:(id _Nonnull)cmd;

/**
 从list移除cmd

 @param cmd cmd
 */
- (void)removeCmd:(id _Nonnull)cmd;

/**
 调用list中的cmd

 @param block block
 */
- (void)castCmd:(void (^ _Nonnull )(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)) block;

@end
