//
//  D5ConfigViewController.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"
@class D5MusicModel;
@class D5BaseListModel;
@interface D5ConfigViewController : D5BaseViewController

/** config */
@property (nonatomic, strong)D5BaseListModel *musicModel;

/** 播放回调 */
@property (nonatomic, copy) void(^playConfigBlock)();



@end
