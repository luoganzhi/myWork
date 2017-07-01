//
//  D5MusicStateMusicModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5MusicStateMusicModel : NSObject

/** musicName */
@property (nonatomic, copy) NSString *name;

/** musicSinger */
@property (nonatomic, copy) NSString *singer;

/** musicID */
@property (nonatomic, assign) NSInteger musicID;

/** serverId */
@property (nonatomic, assign) NSInteger serverId;
/** 专辑封面 */
@property (nonatomic, copy) NSString *album_img;

/** 专辑名 */
@property (nonatomic, copy) NSString *album_name;



@end
