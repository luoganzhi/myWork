//
//  D5HUploadLocalMusic.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSURLSessionTask;

//请求格式
typedef NS_ENUM(NSUInteger, D5HRequestType) {
    D5HRequestTypeJSON = 1, // 默认
   D5HRequestTypePlainText  = 2 // 普通text/html
};

//上传文件任务
typedef NSURLSessionTask D5HURLSessionTask;

/**  上传进度
*  @param bytesWritten              已上传的大小
*  @param totalBytesWritten         总上传大小
*/
typedef void (^D5HUploadProgress)(int64_t bytesWritten,
                                  int64_t totalBytesWritten);
/*
*  请求成功的回调
*
*  @param response 服务端返回的数据类型，通常是字典
*/

typedef void(^D5HResponseSuccess)(id response);
/* 
*  网络响应失败时的回调
*
*  @param error 错误信息
*/
typedef void(^D5HResponseFail)(NSError *error);

typedef void (^D5HTotalPage)(NSInteger totalPage);

@interface D5HUploadLocalMusic : NSObject
+ (void)cancelPost;

@property(nonatomic,strong)NSURLSessionDataTask*requst;
  +(D5HUploadLocalMusic*)shareInstance;

+(void)uploadNewMusicFile:(NSDictionary *)dataDict name:(NSString*)names url:(NSString*)urlString progress:(D5HUploadProgress)progress success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;

//取消音乐上传
+(void)cancelUploadMusic;
//老版本服务器请求
+(void)afNetworkingServer:(NSString*)urlStrting success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;

//修改后的带参数
+(void)afNetworkingAddParametersServer:(NSString *)urlStrting parameters:(NSDictionary*)paraments success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;

//
+(void)afNewNetworkingServer:(NSString *)urlStrting cmd:(NSInteger)cmd success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;

@end
