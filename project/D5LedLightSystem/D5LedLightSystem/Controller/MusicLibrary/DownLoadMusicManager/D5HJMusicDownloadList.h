//
//  D5HJMusicDownloadList.h
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5HJMusicDownloadManageModel.h";
@interface D5HJMusicDownloadList : NSObject

@property(nonatomic,strong)NSMutableArray* list;
+(D5HJMusicDownloadList*)shareInstance;
//获取需要下载的歌曲记录(按先添加先下载)
-(D5HJMusicDownloadManageModel*)getNeedDownloadModel;
//获取所有的下载记录
//- (NSMutableArray*)getDownloadListArray;
//移除所有的下载记录
-(BOOL)removeAllDownloadMusicList;
//添加一条下载记录
-(BOOL)addDownloadMusicList:(D5HJMusicDownloadManageModel*)model;
//移除下载记录
-(BOOL)removeDownloadMusicData:(NSNumber*)musicID;
//-(void)removeDownloadMusicDataByMusicURL:(NSString*)musicURL;

//是否包含记录
-(BOOL)isContainCurrentMusicRecoder:(NSNumber*)musicID;
//更新下载记录
-(BOOL)updateDownloadMusicList:(NSNumber*)musicID;
//更新下载的进度
-(BOOL)updateDownloadMusicProgress:(NSNumber *)musicID progress:(float)progress status:(UpdateDownloadStatus)status url:(NSString*)url;
//-(BOOL)saveData;
//-(void)setListAllSelect:(BOOL)isSeclect;
//-(void)setListSelect:(NSString*)musicID seclect:(BOOL)isSelcet;
//
@end
