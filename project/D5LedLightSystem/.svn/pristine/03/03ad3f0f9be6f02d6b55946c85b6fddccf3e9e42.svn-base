//
//  D5CmdMuticast.m
//  Network
//
//  Created by anthonyxoing on 15/9/8.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5CmdMuticast.h"

@interface D5CmdMuticast()

@property (nonatomic, strong) dispatch_semaphore_t sem;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation D5CmdMuticast
- (instancetype)init {
    if (self == [super init]) {
        _sem = dispatch_semaphore_create(1L);
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (NSMutableArray *)delegateList {
    if (_delegateList == nil) {
        _delegateList = [[NSMutableArray alloc] init];
    }
    return _delegateList;
}

#pragma mark - manager ping socket
- (BOOL)isExistCmdMuticastDelegate:(id)delegate {
    __block BOOL result;
    dispatch_async(_queue, ^{
        dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
        if ([self.delegateList containsObject:delegate]) {
            result = YES;
        } else {
            result = NO;
        }
        dispatch_semaphore_signal(_sem);
    });
    
    return result;
}

- (void)addCmdMuticastDelegate:(id)delegate {
    dispatch_async(_queue, ^{
        dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
        if (![self.delegateList containsObject:delegate]) {
            [self.delegateList addObject:delegate];
        }
        dispatch_semaphore_signal(_sem);
    });
}

- (void)removeCmdMuticastDelegate:(id)delegate {
    dispatch_async(_queue, ^{
        dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
        [self.delegateList removeObject:delegate];
        
        //DLog(@"removeCmdMuticastDelegate代理 %@", [delegate class]);
        dispatch_semaphore_signal(_sem);
    });
}

- (void)addCmdMuticastDelegateFrom:(D5CmdMuticast *)muticast {
    dispatch_async(_queue, ^{
        dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
        [self.delegateList addObjectsFromArray:muticast.delegateList];
        dispatch_semaphore_signal(_sem);
    });
}

#pragma mark - cast data
- (void)castData:(CastBlock)block {
    [self.delegateList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
        block(obj);
        dispatch_semaphore_signal(_sem);
    }];
}

- (NSInteger)count {
    return self.delegateList.count;
}
@end
