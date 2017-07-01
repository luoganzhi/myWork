//
//  D5HUploadLocalMusicNetworking.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5HUploadLocalMusicNetworking.h"

@implementation D5HUploadLocalMusicNetworking

+(id)shareInstance
{
    static D5HUploadLocalMusicNetworking*obj;
    static dispatch_once_t once;
   dispatch_once(&once, ^{
       obj=[[D5HUploadLocalMusicNetworking alloc]init];
   });
    
    return obj;
    
}
//上传单个音乐
-(void)uploadLocalMusic
{

}
@end
