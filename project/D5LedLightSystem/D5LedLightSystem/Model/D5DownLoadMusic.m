//
//  D5DownLoadMusic.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5DownLoadMusic.h"
#import "NSObject+runtime.h"
#import "D5HJMusicDownloadList.h"
#import "D5MainViewController.h"
#import "NSArray+Helper.h"

static D5DownLoadMusic *instance = nil;

@interface D5DownLoadMusic() <D5LedCmdDelegate, D5LedNetWorkErrorDelegate> {
    Class _oldClass;
}

@end

@implementation D5DownLoadMusic

- (void)setDelegate:(id<D5DownLoadMusicDelegate>)delegate {
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

#pragma mark - 检测代理是否存在
- (BOOL)checkDelegate {
    if (!_delegate) {
        return NO;
    }
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == _oldClass);
}


#pragma mark - 初始化实例
+ (D5DownLoadMusic *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[D5DownLoadMusic alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadProgress:) name:@"musicUploadProgress" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma  mark --下载歌曲通知
- (void)uploadProgress:(NSNotification*)noti {
    @autoreleasepool {
        NSDictionary *response = noti.object;
        if (!response) {
            return;
        }
        
        NSDictionary *data = response[@"data"];
        if (!data) {
            return;
        }
        
        NSInteger type = [data[@"type"] integerValue];
        if(type == UpdateFileTypeMusic){
            //下载状态
            UpdateDownloadStatus status = [data[@"status"]intValue];
            NSString *infor = data[@"info"];
            NSDictionary* music  = [NSJSONSerialization dictionaryWithJsonString:infor];
            //下载进度
            NSInteger progress = [data[@"progress"] integerValue];
            NSNumber *musicID = music[@"serverId"];
            NSString* musicURL = music[@"url"];
            
            NSLog(@"音乐ID为%@,下载进度%d,下载状态:%d", musicID, (int)progress, status);
            if (status == UpdateDownloadStatusSuccess || status == UpdateDownloadStatusFailed) {
                [[D5HJMusicDownloadList shareInstance] removeDownloadMusicData:musicID];
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(downloadFinished:)]) {
            
                    [_delegate downloadFinished:musicID];
                }
            } else if(status == UpdateDownloadStatusIng) {
                //更新下载记录
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[D5HJMusicDownloadList shareInstance] updateDownloadMusicProgress:musicID progress:progress status:status url:musicURL];
                     if ([self checkDelegate] && [_delegate respondsToSelector:@selector(progressUpdated)]) {
                         [_delegate progressUpdated];
                    }
                });
            }
        }
    }
    
}

#pragma mark - 下载音乐
- (void)downloadMusicByID:(NSInteger)musicID {
    @autoreleasepool {
        NSArray *arr = @[@(musicID)];
        [self downloadMusics:arr];
    }
}

- (void)downloadMusics:(NSArray *)musicIDs {
    @autoreleasepool {
        if (!musicIDs || musicIDs.count == 0) {
            return;
        }
        
        D5LedNormalCmd *downLoadCmd = [[D5LedNormalCmd alloc] init];
        
        downLoadCmd.remoteLocalTag = tag_remote;
        downLoadCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
        downLoadCmd.strDestMac = [D5CurrentBox currentBoxMac];
        downLoadCmd.remoteIp = [D5CurrentBox currentBoxIP];
        downLoadCmd.errorDelegate = self;
        downLoadCmd.receiveDelegate = self;
        
        [downLoadCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Download_Music withData:@{LED_STR_MUSICLIST : musicIDs}];
    }
}
- (void)cancelDownloadMusics:(NSArray *)musicIDs{

    @autoreleasepool {
        if (!musicIDs || musicIDs.count == 0) {
            return;
        }
        
        D5LedNormalCmd *downLoadCmd = [[D5LedNormalCmd alloc] init];
        
        downLoadCmd.remoteLocalTag = tag_remote;
        downLoadCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
        downLoadCmd.strDestMac = [D5CurrentBox currentBoxMac];
        downLoadCmd.remoteIp = [D5CurrentBox currentBoxIP];
        downLoadCmd.errorDelegate = self;
        downLoadCmd.receiveDelegate = self;
        
        [downLoadCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_CancelDownload_Music withData:@{LED_STR_MUSICLIST : musicIDs}];
    }

}
-(void)getDownloadingMusicList{

    @autoreleasepool {
        D5LedNormalCmd *downLoadCmd = [[D5LedNormalCmd alloc] init];
        downLoadCmd.remoteLocalTag = tag_remote;
        downLoadCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
        downLoadCmd.strDestMac = [D5CurrentBox currentBoxMac];
        downLoadCmd.remoteIp = [D5CurrentBox currentBoxIP];
        downLoadCmd.errorDelegate = self;
        downLoadCmd.receiveDelegate = self;
        
        [downLoadCmd ledSendData:Cmd_IO_Operate withSubCmd:SubCmd_File_Downloading_MusicList withData:nil];
    }

    
}

#pragma mark - 下载结果
- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    @autoreleasepool {
        if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_CancelDownload_Music){
            //取消下载音乐
            NSLog(@"取消下载的歌曲:%@",dict);
            if (!dict) {
                return;
            }
            NSDictionary* data = dict[@"data"];
            if (!data) {
                return;
            }
            
            NSNumber * musicID = data[@"serverId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMusicData" object:@{@"musicID" :musicID}];
            //还为开始下载的歌曲直接从本地移除
            if ([self checkDelegate] && [_delegate respondsToSelector:@selector(cancelMusicDownloadFish:musicID:)]) {
                 [_delegate cancelMusicDownloadFish:YES musicID:musicID];
            }
        }else if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Downloading_MusicList){
          //正在下载的音乐
            NSDictionary *data = dict[@"data"];
            if (!data) {
                return;
            }
            //从中控获取到的音乐列表
            NSArray *tempArray = data[@"downloadList"];
        
//            [[D5HJMusicDownloadList shareInstance] removeAllDownloadMusicList];
           //遍历中控下载音乐列表 如果中控下载列表有数据。本地没有这条数据，则加入本地维护数组
            for (NSDictionary*dict in tempArray) {
              NSNumber *musicId = dict[@"serverId"];
                BOOL iscontain = [[D5HJMusicDownloadList shareInstance] isContainCurrentMusicRecoder:musicId];
                if (!iscontain) {
                     [self addDataModel:dict];
                }
            }
            //本地保存的列表
            NSArray *oldArr = [NSArray arrayWithArray:[D5HJMusicDownloadList shareInstance].list];
             //遍历本地下载音乐列表 如果中控下载列表没有数据，则加入移除本地维护数组的数据（下载成功，中控没有推送结果的情况）
            for (D5HJMusicDownloadManageModel*obj in oldArr) {
                
                BOOL isOldArrayContain = [self isContainMusicDic:tempArray dict:obj.musicID];
                if (!isOldArrayContain) {
                    [[D5HJMusicDownloadList shareInstance] removeDownloadMusicData:obj.musicID];
                    
                }
                //循环筛选记住以前的进度（进度保存连贯）
                for (D5HJMusicDownloadManageModel*temp in oldArr) {
                    if (temp.downloadStatus == UpdateDownloadStatusIng && ([temp.musicID isEqual:obj.musicID]) ) {
                        obj.downloadStatus = UpdateDownloadStatusIng;
                        obj.progress = temp.progress;
                        break;
                    }
                    
                }
                
            }
            
            DLog(@"下载列表 %d", [D5HJMusicDownloadList shareInstance].list.count);

            if ([self checkDelegate] && [_delegate respondsToSelector:@selector(getDownloadingMusicListFish:response:)]) {
                [_delegate getDownloadingMusicListFish:YES response:dict];
            }
        }
    }
}

-(BOOL)isContainMusicDic:(NSArray*)array dict:(NSNumber*)dictMusicID{
    BOOL result = NO;
    for (NSDictionary* obj in array) {
        NSNumber *musicId = obj[@"serverId"];
        if ([musicId isEqual:dictMusicID]) {
            
            result = YES;
        }
        
    }
    return  result;

}
-(void)addDataModel:(NSDictionary*)dict{

    NSNumber *musicId = dict[@"serverId"];
    NSString *albumURL = dict[@"albumImgUrl"];
    NSString *albumTitle = dict[@"albumName"];
    NSString *musicName = dict[@"name"];
    NSString *singer = dict[@"singerName"];
    NSString *musicURL = dict[@"url"];
    
    D5HJMusicDownloadManageModel *obj = [[D5HJMusicDownloadManageModel alloc] init];
    obj.progress = 0.0f;
    obj.downloadStatus = UpdateDownloadStatusReady;
    obj.albumURL = albumURL;
    obj.albumTitle = albumTitle;
    obj.musicName = musicName;
    obj.singer = singer;
    obj.musicID =  musicId;
    obj.musicURL = musicURL;
    
    [[D5HJMusicDownloadList shareInstance] addDownloadMusicList:obj];
}

- (void)checkModel:(D5HJMusicDownloadManageModel *)model withDict:(NSDictionary *)dict {
    @autoreleasepool {
        NSNumber *musicId = dict[@"serverId"];
        if (model && [musicId integerValue] == [model.musicID integerValue]) {
            //添加进全局的下载列表
            [[D5HJMusicDownloadList shareInstance] addDownloadMusicList:model];
        } else {
            NSString *albumURL = dict[@"albumImgUrl"];
            NSString *albumTitle = dict[@"albumName"];
            NSString *musicName = dict[@"name"];
            NSString *singer = dict[@"singerName"];
            NSString *musicURL = dict[@"url"];
            
            D5HJMusicDownloadManageModel *obj = [[D5HJMusicDownloadManageModel alloc] init];
            obj.progress = 0.0f;
            obj.downloadStatus = UpdateDownloadStatusReady;
            obj.albumURL = albumURL;
            obj.albumTitle = albumTitle;
            obj.musicName = musicName;
            obj.singer = singer;
            obj.musicID =  musicId;
            obj.musicURL = musicURL;
            
            [[D5HJMusicDownloadList shareInstance] addDownloadMusicList:obj];
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    @autoreleasepool {
       if(header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_CancelDownload_Music){
           
            if ([self checkDelegate] && [_delegate respondsToSelector:@selector(cancelMusicDownloadFish:musicID:)]) {
                [_delegate cancelMusicDownloadFish:NO musicID:@(-1)];
            }
        }else if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Downloading_MusicList){
            if ([self checkDelegate] && [_delegate respondsToSelector:@selector(getDownloadingMusicListFish:response:)]) {
                [_delegate getDownloadingMusicListFish:NO response:nil];
            }
        }
    }
}

#pragma mark - 跳转VC
- (void)pushToMusicVCAndRefresh {
    @autoreleasepool {
        if (!_delegate || ![_delegate isKindOfClass:[UIViewController class]]) {
            return;
        }
        
        UIViewController *delegateVC = (UIViewController *)_delegate;
        
        for (UIViewController* vc in delegateVC.navigationController.viewControllers) {
            @autoreleasepool {
                if ([vc isKindOfClass:[D5MainViewController class]]) {
                    [delegateVC.navigationController popToViewController:vc animated:YES];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
                    });
                    break;
                }
            }
        }
    }
}

@end
