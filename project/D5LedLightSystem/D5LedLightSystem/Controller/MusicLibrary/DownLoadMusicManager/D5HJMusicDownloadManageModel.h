//
//  D5HJMusicDownloadManageModel.h
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/7.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

//下载的音乐编辑状态
typedef enum : NSUInteger {
    Edit_NOSelect = 0,//未选中
    Edit_Select = 1,//选中
    
} D5HJMusic_Download_SelcteType;

//下载的音乐下载状态
typedef enum : NSUInteger {
    Music_PreDownload,//准备下载
    Music_Downloading,//下载中
    Music_PauseDownload,//暂停下载
    Music_CompleteDownload,//下载完成
} D5HJMusic_Download_Status;

@interface D5HJMusicDownloadManageModel : NSObject

@property(nonatomic,strong)NSNumber* musicID;//音乐id
@property(nonatomic,copy)NSString* musicName;//音乐名称
@property(nonatomic,copy)NSString*centreBoxID;//中控盒子ID
@property(nonatomic,copy)NSString*singer;//歌手
@property(nonatomic,copy)NSString*albumTitle;//专辑
@property(nonatomic,copy)NSString*albumURL;//网络上获取到的专辑图片的地址
@property(nonatomic,copy)NSString*musicURL;
@property(nonatomic,assign)D5HJMusic_Download_SelcteType editSelcteType;//编辑选中状态
@property(nonatomic,assign)UpdateDownloadStatus downloadStatus;//下载状态
@property(nonatomic,assign)NSInteger progress;//下载进度
//@property()

@end
