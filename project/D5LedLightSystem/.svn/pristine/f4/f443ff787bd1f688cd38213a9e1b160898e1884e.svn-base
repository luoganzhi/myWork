//
//  D5RearchMusicResultCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5RearchMusicResultCell.h"

@interface D5RearchMusicResultCell ()
{
    NSTimeInterval interval;
}

@end
@implementation D5RearchMusicResultCell

//下载歌曲到中控的按钮响应
- (IBAction)downloadMusicToCentreBox:(UIButton *)sender {

//    if([self showTips]){
//        return;
//    }
    if(_selectData.isNOPermitDownload){
        [iToast showButtomTitile:@"正在下载到中控"];
        return;
    }
    _downLoadMusic(_selectData);

}
-(BOOL)showTips
{
    if ([[NSDate date]timeIntervalSince1970]-interval<=1) {
        return YES;
    }
    else
    {
        interval=[[NSDate date]timeIntervalSince1970];
        
        return NO;
    }
}

@end
