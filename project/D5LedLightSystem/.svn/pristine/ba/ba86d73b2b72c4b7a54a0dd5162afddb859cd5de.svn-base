//
//  D5SearchMusicModel.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/1.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5HUploadLocalMusic.h"
@interface D5SearchMusicModel : NSObject

+(void)getHotMusic:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;//获取热门音乐信息
+(void)getClassifyMusic:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;//获取音乐分类列表
+(void)getClassifyAllSongs:(NSString *)subURL cmd:(NSInteger)cmd TotalPage:(D5HTotalPage)totalPage success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;//获取音乐分类下所有歌曲
+(void)getRecomondAllSongs:(NSString *)subURL cmd:(NSInteger)cmd TotalPage:(D5HTotalPage)totalPage success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;//获取音乐分类下所有歌曲
//+(void)getRecomondAllSongs:(NSString *)subURL parameters:(NSDictionary*)dic TotalPage:(D5HTotalPage)totalPage success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;

+(void)getSearchKeyworldsAllSongs:(NSString *)subURL cmd:(NSInteger)cmd TotalPage:(D5HTotalPage)totalPage success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;//获取关键字搜索的音乐

//+(void)addLikeMusicOrMusicConfiguration:(NSString *)subURL success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail;//点赞音乐和音乐配置
@end
