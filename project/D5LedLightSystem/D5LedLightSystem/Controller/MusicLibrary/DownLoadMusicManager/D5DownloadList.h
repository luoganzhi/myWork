//
//  D5DownloadList.h
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/10.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5DownloadList : NSObject
//下载的音乐下载列表
@property(nonatomic,strong)NSMutableArray* list;
+(D5DownloadList*)shareInstance;
@end
