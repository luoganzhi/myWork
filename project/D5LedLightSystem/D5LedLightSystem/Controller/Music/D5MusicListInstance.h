//
//  D5MusicListInstance.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/12/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5MusicListInstance : NSObject

/** musiclist */
@property (nonatomic, strong) NSMutableArray *allMusicList;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;

/** pageSize */
@property (nonatomic, assign) NSInteger totalNum;

/** totalSize */
@property (nonatomic, assign) NSInteger totalSize;

/** currentIndex */
@property (nonatomic, assign) int currentIndex;


+ (instancetype)sharedInstance;

- (void)clear;

@end
