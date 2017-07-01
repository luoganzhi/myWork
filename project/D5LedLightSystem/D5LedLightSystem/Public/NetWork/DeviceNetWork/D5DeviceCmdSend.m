//
//  D5DeviceCmd.m
//  D5Home
//
//  Created by anthonyxoing on 4/2/15.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import "D5DeviceCmdSend.h"
@interface D5DeviceCmdSend()<D5DeviceNetWorkDelegate>


@property (retain,nonatomic) NSMutableArray * localCmdArray,* remoteCmdArray;
@property (retain,nonatomic) dispatch_semaphore_t remoteSem,localSem;
@property (assign,nonatomic) BOOL localSending,remoteSending;
@property (retain,nonatomic) dispatch_group_t goup;
@property (retain,nonatomic) dispatch_queue_t queue;
@end

@implementation D5DeviceCmdSend

-(instancetype)init{
    self = [super init];
    if(self){
        _localCmdArray = [[NSMutableArray alloc] init];
        _remoteCmdArray = [[NSMutableArray alloc] init];
        
        _mutiCast = [[D5DeviceMutiCast alloc] init];
        _resultCast = [[D5DeviceMutiCast alloc] init];
        _netWorking = [[D5DeviceNetWork alloc] init];
        
        _netWorking.delegate = self;
        
        _remoteSending = NO;
        _localSending = NO;
        
        _remoteSem = dispatch_semaphore_create(1);
        _localSem = dispatch_semaphore_create(1);
        
        _goup = dispatch_group_create();
        _queue = dispatch_queue_create("ogemray recevie", 0);
    }
    return self;
}
-(void)dealloc{
    _netWorking.delegate = nil;
}
-(void)setNetWorkType:(NetWorkType)nettype{
    [_netWorking setIsEnableBroadCast:YES];
    [_netWorking setNetworktype:nettype];
}
-(void)addDelegate:(id)delegate{
    if(![_mutiCast.mutiDelegate containsObject:delegate]){
        [_mutiCast.mutiDelegate addObject:delegate];
    }
}
-(void)removeDelegate:(id)delegate{
    [self cmdListDelete:delegate];
    [_mutiCast.mutiDelegate removeObject:delegate];
}

-(void)addResultDelegate:(id)delegate{
    if(![_resultCast.mutiDelegate containsObject:delegate]){
        [_resultCast.mutiDelegate addObject:delegate];
    }
}
-(void)removeResultDelegate:(id)delegate{
    [_resultCast.mutiDelegate removeObject:delegate];
}
-(void)cmdListDelete:(id)viewController{
    dispatch_semaphore_wait(_localSem, DISPATCH_TIME_FOREVER);
    //    NSLog(@"delete cmd");
    [_localCmdArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        if([obj objectForKey:CMD_VIEWCONTROLLER] == viewController){
            [_localCmdArray removeObject:obj];
        }
    }];
    dispatch_semaphore_signal(_localSem);
    dispatch_semaphore_wait(_remoteSem, DISPATCH_TIME_FOREVER);
    [_remoteCmdArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL * stop){
        if([obj objectForKey:CMD_VIEWCONTROLLER] == viewController){
            [_remoteCmdArray removeObject:obj];
        }
    }];
    dispatch_semaphore_signal(_remoteSem);
    _localSending = NO;
    _remoteSending = NO;
}

-(void)addLocalCmd:(NSData *)data withAddress:(NSString *)address withSequence:(NSUInteger)sequence{
    @autoreleasepool {
        dispatch_semaphore_wait(_localSem, DISPATCH_TIME_FOREVER);
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc] init];
        [dic setObject:data forKey:CMD_DATA];
        [dic setObject:address forKey:CMD_IP];
        [dic setObject:[NSNumber numberWithInteger:sequence] forKey:CMD_SEQUENCE];
        [_localCmdArray addObject:data];
        dispatch_semaphore_signal(_localSem);
        [self sendLocalData];
    }
}
-(void)addRemoteCmd:(NSData *)data withSequence:(NSUInteger)sequence{
    @autoreleasepool {
        dispatch_semaphore_wait(_remoteSem, DISPATCH_TIME_FOREVER);
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc] init];
        [dic setObject:data forKey:CMD_DATA];
        [dic setObject:[NSNumber numberWithInteger:sequence] forKey:CMD_SEQUENCE];
        [_remoteCmdArray addObject:data];
        dispatch_semaphore_signal(_remoteSem);
        [self sendRemoteData];
    }
}
-(void)sendLocalData{
    if(_localSending){
        return;
    }
    if(_localCmdArray.count <= 0){
        return;
    }
    dispatch_semaphore_wait(_localSem, DISPATCH_TIME_FOREVER);
    NSDictionary * dic = [_localCmdArray objectAtIndex:0];
    [_netWorking sendUdpData:[dic objectForKey:CMD_DATA] withIpAddress:[dic objectForKey:CMD_IP] withTag:[[dic objectForKey:CMD_DATA] longValue]];
    dispatch_semaphore_signal(_localSem);
}
-(void)sendRemoteData{
    if(_remoteSending){
        return;
    }
    if(_remoteCmdArray.count <= 0){
        return;
    }
    dispatch_semaphore_wait(_remoteSem, DISPATCH_TIME_FOREVER);
    NSDictionary * dic = [_remoteCmdArray objectAtIndex:0];
    [_netWorking sendTcpData:[dic objectForKey:CMD_DATA] withTag:[[dic objectForKey:CMD_DATA] longValue]];
    dispatch_semaphore_signal(_remoteSem);
}
-(void)sendTcpData:(NSData *)data withTag:(long)tag{
    [_netWorking sendTcpData:data withTag:tag];
}
-(void)sendUdpData:(NSData *)data toAddress:(NSString *)address toPort:(int)port withSequence:(NSUInteger)sequence{
    [_netWorking sendUdpData:data withIpAddress:address withTag:sequence];
}
-(void)deleteOneLocalCmd{
    dispatch_semaphore_wait(_localSem, DISPATCH_TIME_FOREVER);
    if(_localCmdArray.count > 0){
        [_localCmdArray removeObjectAtIndex:0];
    }
    dispatch_semaphore_signal(_localSem);
    [self sendLocalData];
}
-(void)deleteLocalCmd:(NSUInteger)sequence{
    dispatch_semaphore_wait(_localSem, DISPATCH_TIME_FOREVER);
    [_localCmdArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL * stop){
        if([obj objectForKey:CMD_SEQUENCE]){
            [_localCmdArray removeObject:obj];
            if(_localSending){
                _localSending = NO;
            }
        }
    }];
    dispatch_semaphore_signal(_localSem);
}
-(void)deleteRemoteCmd:(NSUInteger)sequence{
    dispatch_semaphore_wait(_remoteSem, DISPATCH_TIME_FOREVER);
    [_remoteCmdArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL * stop){
        if([obj objectForKey:CMD_SEQUENCE]){
            [_remoteCmdArray removeObject:obj];
            if(_remoteSending){
                _remoteSending = NO;
            }
        }
    }];
    dispatch_semaphore_signal(_remoteSem);
}
-(void)clearLocalCmd{
    dispatch_semaphore_wait(_localSem, DISPATCH_TIME_FOREVER);
    [_localCmdArray removeAllObjects];
    if(_localSending){
        _localSending = NO;
    }
    dispatch_semaphore_signal(_localSem);
}
-(void)clearRemoteCmd{
    dispatch_semaphore_wait(_remoteSem, DISPATCH_TIME_FOREVER);
    [_remoteCmdArray removeAllObjects];
    if(_remoteSending){
        _remoteSending = NO;
    }
    dispatch_semaphore_signal(_remoteSem);
}
//-(void)tcpData:(NSData *)data{
//    
//}
//-(void)udpData:(NSData *)data from:(NSString *)ipAddress{
//    
//}
#pragma mark - delegate
-(void)d5network:(D5DeviceNetWork *)networking errorCode:(NetError)errorCode withMessage:(NSString *)message withTag:(long)tag{
    if(errorCode == networking_udp_send_error){
        _localSending = NO;
        [self deleteOneLocalCmd];
    }
    if([self respondsToSelector:@selector(networkError:errorMessage:withTag:)]){
        [self networkError:errorCode errorMessage:message withTag:tag];
    }
}
-(void)d5network:(D5DeviceNetWork *)networking udpRecevied:(NSData *)data withAddress:(NSString *)ipAddress{
    dispatch_async(_queue, ^{
        if([self respondsToSelector:@selector(udpData:from:)]){
            [self udpData:data from:ipAddress];
        }
    });
}
-(void)d5network:(D5DeviceNetWork *)networking tcpRecevied:(NSData *)data{
    dispatch_async(_queue, ^{
        @autoreleasepool {
            if([self respondsToSelector:@selector(tcpData:)]){
                [self tcpData:data];
            }
        }
    });
}


#pragma mark --暂未实现的功能
-(void)udpData:(NSData *)data from:(NSString *)ipAddress ;
{
}
-(void)tcpData:(NSData *)data ;
{
}

-(void)networkError:(int)errorCode errorMessage:(NSString *)message withTag:(long)tag;
{

}
@end
