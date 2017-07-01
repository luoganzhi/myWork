//
//  D5BaseProtocol.h
//  D5Home_new
//
//  Created by 黄斌 on 15/12/16.
//  Copyright © 2015年 com.pangdou.d5home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5ProtocolAction.h"
#import "AFNetworking.h"

@interface D5BaseProtocol : NSObject

typedef void (^netWorkFinish)(NSDictionary *response);
typedef void (^networkFailed)(NSString *result);

@property (copy, nonatomic) netWorkFinish finishBlock;
@property (copy, nonatomic) networkFailed faildBlock;

- (NSString *)JSONString:(NSDictionary *)dic;
- (NSString *)newParament:(NSString *)sendData withMethod:(int)method;
- (NSDictionary *)urlParament:(NSString *)sendData withMethod:(int)method;
- (void)sendData:(NSString *)data withMethod:(int)method isDevice:(BOOL)isDevice;
- (void)newSendData:(NSString *)data withMethod:(int)method isDevice:(BOOL)isDevice;
//- (void)postSendData:(NSDictionary *)datas withMethod:(int)method;
- (void)showErrorMessage:(NSString *)message;
- (NSString *)getReplacedUrlByUrl:(NSString *)target;

@end
