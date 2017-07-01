//
//  D5DeviceCmd.h
//  D5Home
//
//  Created by anthonyxoing on 4/2/15.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5DeviceProtocol.h"

@class D5DeviceCmdSend;

@protocol D5DeviceReceiveDataDelegate <NSObject>

@optional
-(void)cmdSend:(D5DeviceCmdSend *)sender udpReceived:(NSData *)data fromHost:(NSString *)ipAddress;
-(void)cmdSend:(D5DeviceCmdSend *)sender tcpReceived:(NSData *)data;

@end

@class D5DeviceMutiCast;

@interface D5DeviceCmdSend : NSObject

@property (strong, nonatomic) D5DeviceMutiCast * mutiCast,* resultCast;
@property (weak,nonatomic) id<D5DeviceReceiveDataDelegate> receiveDelegate;
@property (strong, nonatomic) D5DeviceNetWork * netWorking;

-(void)addDelegate:(id)delegate;
-(void)removeDelegate:(id)delegate;

-(void)addResultDelegate:(id)delegate;
-(void)removeResultDelegate:(id)delegate;

-(void)addLocalCmd:(NSData*)data withAddress:(NSString *)address withSequence:(NSUInteger)sequence;
-(void)addRemoteCmd:(NSData *)data withSequence:(NSUInteger)sequence;

-(void)setNetWorkType:(NetWorkType)nettype;
-(void)udpData:(NSData *)data from:(NSString *)ipAddress ;
-(void)tcpData:(NSData *)data ;
-(void)networkError:(int)errorCode errorMessage:(NSString *)message withTag:(long)tag;

-(void)deleteLocalCmd:(NSUInteger)sequence;
-(void)deleteRemoteCmd:(NSUInteger)sequence;

-(void)clearLocalCmd;
-(void)clearRemoteCmd;
-(void)sendTcpData:(NSData*)data withTag:(long)tag;
-(void)sendUdpData:(NSData *)data toAddress:(NSString *)address toPort:(int)port withSequence:(NSUInteger)sequence;
@end
