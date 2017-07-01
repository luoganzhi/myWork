//
//  D5HDowlandMusicToCentreBox.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/20.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NOTIFICATION_DOWNLOADMUIC_SUCESS @"downMusicToCentreBoxSucess"
@protocol DowlandMusicToCentreBoxDelegate

@optional
-(void)downloadMusicToCentreBoxResult:(int64_t)status;

@end

@interface D5HDowlandMusicToCentreBox : D5LedCmd

-(void)downloadMusicToCentreBox:(NSArray*)MusicIds;
@end
