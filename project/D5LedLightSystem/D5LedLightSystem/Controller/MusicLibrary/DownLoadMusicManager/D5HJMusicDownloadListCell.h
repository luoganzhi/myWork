//
//  D5HJMusicDownloadListCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5HJMusicDownloadManageModel.h"
@interface D5HJMusicDownloadListCell : UITableViewCell
//UI
@property (weak, nonatomic) IBOutlet UIImageView *abulmImage;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLable;
@property (weak, nonatomic) IBOutlet UILabel *musicSingerLable;
@property (weak, nonatomic) IBOutlet UIButton *downStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *progressLable;


@property(nonatomic,strong)D5HJMusicDownloadManageModel* data;

-(void)setDownLoadMusicCellUI:(D5HJMusicDownloadManageModel*)data;

@end
