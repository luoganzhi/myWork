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

@property(retain,nonatomic) NSMutableArray *delegateList;

- (void)addCmdMuticastDelegate:(id)delegate;
- (void)addCmdMuticastDelegateFrom:(D5CmdMuticast *)muticast;
- (void)removeCmdMuticastDelegate:(id)delegate;
-(BOOL)isExistCmdMuticastDelegate:(id)delegate;

- (NSInteger)count;
@end
