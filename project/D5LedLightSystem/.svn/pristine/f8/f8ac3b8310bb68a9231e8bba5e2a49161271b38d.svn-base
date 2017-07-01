//
//  D5MusicData.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5MusicData : NSObject

@property (nonatomic, assign)   int                 musicId;
@property (nonatomic, assign)   int                 serverId;
@property (nonatomic, copy)     NSString            *musicName;
@property (nonatomic, copy)     NSString            *singerName;
@property (nonatomic, copy)     NSString            *albumName;
@property (nonatomic, copy)     NSString            *albumImgUrl;
@property (nonatomic, assign)   int                 duration;
@property (nonatomic, assign)   int                 currentPos;
@property (nonatomic, assign)   LedPlayStatus  playStatus;

- (D5MusicData *)initWithDict:(NSDictionary *)dict;
+ (D5MusicData *)dataWithDict:(NSDictionary *)dict;

@end
