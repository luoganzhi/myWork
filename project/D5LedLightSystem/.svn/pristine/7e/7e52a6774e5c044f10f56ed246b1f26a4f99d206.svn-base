//
//  D5HJMusicDownloadList.m
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5HJMusicDownloadList.h"
#import "D5HJMusicDownloadManageModel.h"
#import "NSArray+Helper.h"

@interface D5HJMusicDownloadList()

@property (nonatomic,retain) dispatch_semaphore_t sem;
@property (nonatomic,retain) dispatch_queue_t queue;

@end
@implementation D5HJMusicDownloadList

 static D5HJMusicDownloadList*obj = nil;
+(D5HJMusicDownloadList *)shareInstance{
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        obj = [[D5HJMusicDownloadList alloc]init];
      
    });
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

-(NSMutableArray*)list{
    
    if (_list == nil) {
        _list = [NSMutableArray array];
    
    }
       return _list;
}

- (void)addMusicDataTolist:(D5HJMusicDownloadManageModel*)Obj {
    if (![self isContainCurrentMusicRecoder:Obj.musicID]) {
        DLog(@"下载--加入id %ld",(long)[Obj.musicID integerValue]);
        [self.list addObject:Obj];
    }
}

- (void)removeMusicDataFromMusicList:(D5HJMusicDownloadManageModel*)obj {
   if ([self isContainCurrentMusicRecoder:obj.musicID]) {
       DLog(@"下载--移除id %ld",(long)[obj.musicID integerValue]);
       //检查
       [self.list removeObject:obj];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMusicData" object:@{@"musicID" : obj.musicID}];
       
    }
}

//移除所有的下载记录
- (BOOL)removeAllDownloadMusicList {
    [_list removeAllObjects];
    return YES;
}
//添加一条下载记录
- (BOOL)addDownloadMusicList:(D5HJMusicDownloadManageModel*)model {
    if (!model) {
        return NO;
    }
    if (_list == nil) {
        _list = [NSMutableArray array];
    }
    
    [self addMusicDataTolist:model];
    return  YES;

}

//移除下载记录
-(BOOL)removeDownloadMusicData:(NSNumber *)musicID{

    BOOL isContain = [self isContainCurrentMusicRecoder:musicID];
    if ([NSArray isNullArray:_list] || !isContain) {
        NSLog(@"移除记录：数据为空,或者移除本地没有的记录");
        return NO;
    }
    NSArray* sortArray = [NSArray arrayWithArray:_list];
    for (D5HJMusicDownloadManageModel* obj in sortArray) {
        
        if (obj.musicID.integerValue == musicID.integerValue) {
            NSLog(@"移除本地数据库的音乐ID:%@",obj.musicID);
            [self removeMusicDataFromMusicList:obj];
            break;
        }
    }
    return YES;
}

-(BOOL)updateDownloadMusicProgress:(NSNumber *)musicID progress:(float)progress status:(UpdateDownloadStatus)status url:(NSString*)url
{
    if ([NSArray isNullArray:_list] || !musicID) {
        return NO;
    }
    [_list enumerateObjectsUsingBlock:^(D5HJMusicDownloadManageModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.musicID.integerValue == musicID.integerValue) {
            
            obj.progress = progress;
            obj.downloadStatus = status;
            
            *stop = YES;
        }
    }];
    return  YES;
}
//当前
-(BOOL)isContainCurrentMusicRecoder:(NSNumber *)musicID{

   __block BOOL result = NO;

    if ([NSArray isNullArray:_list] || musicID == nil) {
        
        return result;
    }
    [_list enumerateObjectsUsingBlock:^(D5HJMusicDownloadManageModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (musicID.integerValue == obj.musicID.integerValue) {
            
            result = YES;
            *stop = YES;
        }
 
    }];
       return  result;
}

@end
