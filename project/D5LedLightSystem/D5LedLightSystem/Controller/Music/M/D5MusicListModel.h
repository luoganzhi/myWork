//
//  D5MusicListModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5MusicListModel : NSObject

/** 总数 */
@property (nonatomic, assign) NSInteger totalNum;

/** 所有歌曲模型数组 */
@property (nonatomic, strong) NSMutableArray *musicList;

/** 当前返回的页数 */
@property (nonatomic, assign) NSInteger pageNum;

/** totalSize */
@property (nonatomic, assign) NSInteger totalSize;



@end

