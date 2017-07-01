//
//  D5UploadingView.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5BaseTipView.h"

@class D5UploadingView;

@protocol D5UploadingViewDelegate <NSObject>

- (void)uploadIngCancelUpload:(D5UploadingView *)uploadView;

@end

@interface D5UploadingView : D5BaseTipView

@property (nonatomic, weak) id<D5UploadingViewDelegate> delegate;

+ (instancetype)sharedUploadingView;

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
 停止imgView的旋转
 
 @param imgView
 */
- (void)stopRotateForImg:(UIImageView *)imgView;

/**
 开始imgvIEW的旋转
 
 @param imgView
 */
- (void)startRotateForImg:(UIImageView *)imgView;

@end
