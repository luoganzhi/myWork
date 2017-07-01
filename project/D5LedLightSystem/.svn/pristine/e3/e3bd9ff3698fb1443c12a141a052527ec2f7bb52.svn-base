//
//  D5DownLoadMusic.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol D5DownLoadMusicDelegate <NSObject>

@optional
- (void)downloadFinished:(NSNumber *)musicID;
- (void)progressUpdated;
-(void)cancelMusicDownloadFish:(BOOL)isFish musicID:(NSNumber *)musicID;
// 获取正在下载下载的音乐列表的代理方法
-(void)getDownloadingMusicListFish:(BOOL)isFish response:(NSDictionary*)response;

@end

@interface D5DownLoadMusic : NSObject

@property (nonatomic, weak) id<D5DownLoadMusicDelegate> delegate;

/**
 单例

 @return 实例
 */
+ (D5DownLoadMusic *)shareInstance;

/**
 下载多首音乐到中控

 @param musics 要下载的音乐数组：元素是音乐ID
 */
- (void)downloadMusics:(NSArray *)musicIDs;

/**
 下载单首音乐到中控
 
 @param musicID 要下载的音乐ID
 */
- (void)downloadMusicByID:(NSInteger)musicID;

/**
 跳转到音乐列表界面并发送通知刷新列表
 */
- (void)pushToMusicVCAndRefresh;

/**
 取消下载
 */
//音乐下载的url
- (void)cancelDownloadMusics:(NSArray *)musicURLs;

/**
 正在下载的音乐列表
 */
-(void)getDownloadingMusicList;

@end
