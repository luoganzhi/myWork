//
//  D5MusicModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5MusicModel : NSObject
///** 配置数组 */
//@property (nonatomic, strong) NSMutableArray *effects;


/** musicID */
@property (nonatomic, assign) NSInteger musicID;

/** 音乐名 */
@property (nonatomic, copy) NSString *name;

/** 歌手 */
@property (nonatomic, copy) NSString *singerName;

/** 专辑名 */
@property (nonatomic, copy) NSString *albumName;

/** 专辑封面地址 */
@property (nonatomic, copy) NSString *albumImgUrl;

/** 服务器id */
@property (nonatomic, assign) int serverId;

/** 播放状态 */
@property (nonatomic, assign) PlayStatusType playStatus;

/** selected */
@property (nonatomic, assign) BOOL selected;




@end
