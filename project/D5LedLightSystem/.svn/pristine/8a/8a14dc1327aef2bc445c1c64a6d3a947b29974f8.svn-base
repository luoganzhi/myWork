//
//  D5HJMusicDownloadEditCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5HJMusicDownloadManageModel.h"
typedef void (^SelectEdit)(BOOL isSelect,NSNumber *musicID);
@interface D5HJMusicDownloadEditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *abulmImage;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLable;
@property (weak, nonatomic) IBOutlet UILabel *musicSingerLable;
@property (weak, nonatomic) IBOutlet UIButton *selcteStatus;
@property(nonatomic)SelectEdit selectEdit;
@property(nonatomic,strong)NSNumber *musicID;
-(void)setUIforMusicData:(D5HJMusicDownloadManageModel*)data;

@end
