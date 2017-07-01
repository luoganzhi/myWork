//
//  D5CurrentMusicModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5CurrentMusicModel : NSObject
/** name */
@property (nonatomic, copy) NSString *name;
/** id */
@property (nonatomic, assign) int musicId;
/** key */
@property (nonatomic, copy) NSString *key;
/** code */
@property (nonatomic, assign) int code;
/** progress */
@property (nonatomic, assign) int progress;


@end
