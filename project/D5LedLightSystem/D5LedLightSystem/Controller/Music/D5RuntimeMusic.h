//
//  D5RuntimeMusic.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5RuntimeMusic : NSObject





/** 歌曲id */
@property (nonatomic, assign) int musicId;

/** 歌曲服务器id */
@property (nonatomic, assign) int serverId;

/** 歌曲名 */
@property (nonatomic, copy) NSString *name;

/** 歌手名 */
@property (nonatomic, copy) NSString *singerName;

/** 专辑名 */
@property (nonatomic, copy) NSString *albumName;

/** 专辑地址 */
@property (nonatomic, copy) NSString *albumImgUrl;

/** 总时长 */
@property (nonatomic, assign) int duration;

/** 当前时间 */
@property (nonatomic, assign) int currentPos;

/** 播放状态 */
@property (nonatomic, assign) PlayStatusType playStatus;



@end
