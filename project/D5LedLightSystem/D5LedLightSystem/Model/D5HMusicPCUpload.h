//
//  D5HMusicPCUpload.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol D5HMusicPCUploadDelegate <NSObject>

-(void)getUPloadStartService:(BOOL) isOpen ip:(NSString*)ip port:(NSString*)port;

@end
typedef void (^D5HMusicPCUploadResult)(NSString*ip,NSString*port,BOOL isOpen,BOOL result);
@interface D5HMusicPCUpload : D5LedCmd

@property(nonatomic,assign)BOOL isOpen;//开启上传音乐
@property(nonatomic,copy)D5HMusicPCUploadResult result;
@property(nonatomic,copy)id <D5HMusicPCUploadDelegate>delegate;

//+(id)shareInstance;
-(void)uploadPcMusic;

@end
