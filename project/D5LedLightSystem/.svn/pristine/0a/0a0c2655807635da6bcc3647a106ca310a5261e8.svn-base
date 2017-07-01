//
//  D5HLocalMusicList.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "D5MusicLibraryData.h"
#import "D5TFMusicModel.h"

typedef void(^LocalMusicArrBlock)(NSMutableArray *arr);

@interface D5HLocalMusicList : NSObject

@property (nonatomic, assign) __block int totalCount;
@property (nonatomic, assign) __block int tfTotalCount;

@property (nonatomic, copy) LocalMusicArrBlock arrBlock;
@property (nonatomic, copy) LocalMusicArrBlock tfMusicBlock;

+(D5HLocalMusicList *)shareInstance;
-(NSMutableArray*)getlocalMusicList;//获取本地音乐列表
- (NSDictionary *)mediaItemToData :(MPMediaItem*)curItem;//音乐二进制文件存入本地
-(NSString*)getfileDir:(NSInteger)songId;//获取音乐文件目录
//-(NSData*)mediaNewItemToData :(MPMediaItem*)curItem;

/**
 将中文str转为拼音

 @param chinese 中文
 @return 拼音
 */
- (NSString *)transformStr:(NSString *)chinese;

+ (NSString *)getfileDir;

//获取本地已经上传的歌曲记
+ (NSMutableArray *)getLocalUploadTagArray;

/**
 获取arr中index处的dictionary

 @param arr arr
 @param index index
 @return dict
 */
- (NSMutableDictionary *)getDictFromArr:(NSMutableArray *)arr atIndex:(int)index;

/**
 将arr中index处的对象中加入obj
 
 @param arr arr
 @param index index
 @param obj obj
 */
- (void)addObjFromArr:(NSMutableArray *)arr atIndex:(int)index obj:(id)obj;

/**
 给arr排序

 @param arr arr
 @return 排序后的arr
 */
- (NSArray *)arrSortedByArr:(NSArray *)arr;

/**
 给本地列表排序后返回

 @return 排序后的本地音乐列表
 */
- (void)localMusicSortedArr;

+ (NSString *)titleFromArr:(NSArray *)arr atSection:(NSInteger)section;

+ (D5MusicLibraryData *)dataFromArr:(NSArray *)arr atSection:(NSInteger)section atRow:(NSInteger)row;

+ (NSInteger)rowCountFromArr:(NSArray *)arr atSection:(NSInteger)section;

/**
 根据title获取该对象在arr中的index
 
 @param title 首字符串
 @param arr arr
 @return index
 */
+ (NSInteger)indexForTitle:(NSString *)firstStr fromArr:(NSArray *)arr;

/**
 tf音乐列表排序

 @param tfMusicArr tf音乐列表
 */
- (void)sortedTFMusicArr:(NSArray *)tfMusicArr;

/**
 获取arr中section处的row处的data数据(tf卡）
 
 @param arr arr
 @param section section
 @param row row
 @return data
 */
+ (D5TFMusicModel *)tfModelFromArr:(NSArray *)arr atSection:(NSInteger)section atRow:(NSInteger)row;
@end
