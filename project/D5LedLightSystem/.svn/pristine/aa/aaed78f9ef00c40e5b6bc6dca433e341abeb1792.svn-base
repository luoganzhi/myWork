//
//  D5SearchSongsResultController.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SearchSongsResultVC @"SearchSongsResul"
typedef void (^DownloadManage)(void);
@interface D5SearchSongsResultController : D5BaseViewController

@property (nonatomic, copy) NSString * searchKeyWorlds;
@property (nonatomic, strong) NSMutableArray * searchList;
@property (weak, nonatomic)  IBOutlet UIView *searchNullDataView;
@property(nonatomic)DownloadManage downloadManage;//下载音乐管理
- (void)startsearch:(NSString *)keyWorlds;

@end
