//
//  D5TipView.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5TipView;

typedef enum _connect_status {
    ConnectStatusDisConnect = 100,
    ConnectStatusConnectIng,
    ConnectStatusConnectFailed,
    ConnectStatusConnectSuccess
}ConnectStatus;

@protocol D5TipViewDelegate <NSObject>

@optional
- (void)tipViewCancelUpload:(D5TipView *)tipView;
- (void)tipViewReUpload:(D5TipView *)tipView currentIndex:(int)index;

@end

@interface D5TipView : UIView

@property (nonatomic, assign) id<D5TipViewDelegate> delegate;

/** 连接状态 */
@property (nonatomic, assign) ConnectStatus connectStatus;

+ (instancetype)sharedTipView;

/**
 转圈的imgView

 @return 转圈的imgView
 */
- (UIImageView *)loadingImgView;

/**
 显示上传中

 @param index 当前上传的歌曲index
 @param totalCount 要上传的歌曲总数
 @param name 当前上传的歌曲名
 @param progress 当前的上传进度
 */
- (void)showUploadIngViewByIndex:(int)index totalCount:(int)totalCount musicName:(NSString *)name progress:(int)progress;

/**
 更新上传进度和当前歌曲index、当前音乐名 (如果只更新其中一项，则其它参数输入-1（int类型的），nil(NSString类型的)

 @param progress 进度
 @param index 当前上传歌曲index
 @param name 当前歌曲名
 */
- (void)updateProgress:(int)progress currentIndex:(int)index musicName:(NSString *)name;

/**
 显示上传失败
 */
- (void)showUploadFailedView;

/**
 显示上传成功
 */
- (void)showUploadSuccessView;

/**
 显示连接断开
 */
- (void)showDisConnectView;

/**
 隐藏tipview
 */
- (void)hideTipView;

@end
