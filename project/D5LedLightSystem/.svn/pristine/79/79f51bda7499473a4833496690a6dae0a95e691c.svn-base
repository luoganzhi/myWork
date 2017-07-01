//
//  D5SearchMusicModel.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/1.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SearchMusicModel.h"
#import "D5MusicLibraryData.h"
#import "D5HUploadLocalMusic.h"
#import "UIImageView+WebCache.h"

@implementation D5SearchMusicModel


+(void)getHotMusic:(D5HResponseSuccess)success fail:(D5HResponseFail)fail
{
    NSString*parament=@"{\"cmd\":9}";
    [D5HUploadLocalMusic afNewNetworkingServer:parament cmd:9 success:^(id response) {
    
    NSDictionary*dataD=[response valueForKey:@"data"];
    NSArray*music=[dataD valueForKey:@"music"];
    NSArray*singer=[dataD valueForKey:@"singer"];
    NSMutableArray *singerArray=[NSMutableArray array];
    NSMutableArray*songArray=[NSMutableArray array];
    for (NSDictionary*dic in music) {
        
        MusicModel*obj=[[MusicModel alloc]init];
        obj.musicID=[[dic valueForKey:@"id"]integerValue];
        obj.musicName=[dic valueForKey:@"name"];
         obj.musicName=[obj.musicName removeSongSuffix];
        [songArray addObject:obj];
    }
    for (NSDictionary*dic in singer) {
         MusicModel*obj=[[MusicModel alloc]init];
        obj.musicName=[dic valueForKey:@"name"];
         obj.musicName=[obj.musicName removeSongSuffix];
        [singerArray addObject:obj];

    }
    
    NSDictionary*dic=@{@"singer":singerArray,@"songs":songArray};
    success(dic);
    
} fail:^(NSError *error) {
   
    fail(error);
}];
}


+(void)getClassifyMusic:(D5HResponseSuccess)success fail:(D5HResponseFail)fail
{
    NSString*parament=@"{\"cmd\":6}";
    [D5HUploadLocalMusic afNewNetworkingServer:parament cmd:6 success:^(id response) {
       
//        //DLog(@"%@",response);
        
        NSDictionary*data=[response valueForKey:@"data"];
        NSArray*classfy=[data valueForKey:@"classify"];
        NSMutableDictionary*dataMutableDic=[NSMutableDictionary dictionary];
        for (NSDictionary*dic in classfy) {
        
            NSArray*array=[dic valueForKey:@"c_list"];
            NSMutableArray*dataArray=[NSMutableArray array];
            for (NSDictionary*musicDic in array) {
                MusicModel*model=[[MusicModel alloc]init];
                model.musicID=[[musicDic valueForKey:@"id"]integerValue];
                model.musicName=[musicDic valueForKey:@"name"];
                 model.musicName=[model.musicName removeSongSuffix];
                [dataArray addObject:model];
            }
            NSString*title=[dic valueForKey:@"name"];
            [dataMutableDic setObject:dataArray forKey:title];
        
        }
        
        success(dataMutableDic);
        
    } fail:^(NSError *error) {
      
        fail(error);
    }];
    

}

+(void)getClassifyAllSongs:(NSString *)subURL cmd:(NSInteger)cmd TotalPage:(D5HTotalPage)totalPage success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail

{
    [D5HUploadLocalMusic afNewNetworkingServer:subURL cmd:(NSInteger)cmd success:^(id response) {
        NSDictionary*DataDic=[response valueForKey:@"data"];
        NSArray*musicArray=[DataDic valueForKey:@"music"];
        NSMutableArray*modelArray=[NSMutableArray array];
        if ([musicArray isEqual:[NSNull null]]) {
            
            success(modelArray);
            return ;
        }

        for (NSDictionary*dic in musicArray) {
            
            D5MusicLibraryData*model=[[D5MusicLibraryData alloc]init];
            model.musicId=[dic[@"id"]integerValue];
            model.musicName=([dic[@"name"] isEqual:[NSNull null]])? @"":dic[@"name"];
           model.musicName= [model.musicName removeSongSuffix];
            model.musicSinger=([dic[@"singer"] isEqual:[NSNull null]])? @"":dic[@"singer"];
            model.album =([dic[@"album_name"] isEqual:[NSNull null]])? @"":dic[@"album_name"];
            model.albumURL=([dic[@"album_img"] isEqual:[NSNull null]])? @"":dic[@"album_img"];

            [modelArray addObject:model];
        }
        success(modelArray);
        NSInteger totalPages=[DataDic[@"totalPage"]integerValue];
        totalPage(totalPages);
        
        //DLog(@"%@",response);
        
    } fail:^(NSError *error) {
        
        
        fail(error);
    }];


}

+(void)getRecomondAllSongs:(NSString *)subURL cmd:(NSInteger)cmd TotalPage:(D5HTotalPage)totalPage success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail
{
     NSString*requstURLString = subURL;
  
    [D5HUploadLocalMusic afNewNetworkingServer:requstURLString cmd:cmd success:^(id response) {
        
        NSDictionary*DataDic=[response valueForKey:@"data"];
        NSArray*musicArray=[DataDic valueForKey:@"music"];
        NSMutableArray*modelArray=[NSMutableArray array];
        if ([musicArray isEqual:[NSNull null]]) {
            
            success(modelArray);
            return ;
        }
        for (NSDictionary*dic in musicArray) {
            
            D5MusicLibraryData*model=[[D5MusicLibraryData alloc]init];
            model.musicId=[dic[@"id"]integerValue];
            model.musicName=([dic[@"name"] isEqual:[NSNull null]])? @"":dic[@"name"];
            model.musicSinger=([dic[@"singer"] isEqual:[NSNull null]])? @"":dic[@"singer"];
            model.musicName=[model.musicName removeSongSuffix];
            model.album =([dic[@"album_name"] isEqual:[NSNull null]])? @"":dic[@"album_name"];
            model.albumURL=([dic[@"album_img"] isEqual:[NSNull null]])? @"":dic[@"album_img"];
            [modelArray addObject:model];
        }
        success(modelArray);
        NSInteger totalPages=[DataDic[@"totalPage"]integerValue];
        totalPage(totalPages);
        

        
    } fail:^(NSError *error) {
        
        fail(error);
        
    }];
    

}


+(void)getSearchKeyworldsAllSongs:(NSString *)subURL cmd:(NSInteger)cmd TotalPage:(D5HTotalPage)totalPage success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail
{

    
      [D5HUploadLocalMusic afNewNetworkingServer:subURL cmd:cmd success:^(id response) {
      NSDictionary*DataDic = [response valueForKey:@"data"];
      NSArray*musicArray = [DataDic valueForKey:@"music"];
      NSMutableArray*modelArray=[NSMutableArray array];
     if ([musicArray isEqual:[NSNull null]]) {
            musicArray = nil;
        }
      for (NSDictionary*dic in musicArray) {
            
            D5MusicLibraryData*model=[[D5MusicLibraryData alloc]init];
            model.musicId=[dic[@"id"]integerValue];
            model.musicName=([dic[@"name"] isEqual:[NSNull null]])? @"":dic[@"name"];
            model.musicName=[model.musicName removeSongSuffix];
            model.musicSinger=([dic[@"singer"] isEqual:[NSNull null]])? @"":dic[@"singer"];
            model.album=([dic[@"album_name"] isEqual:[NSNull null]])? @"":dic[@"album_name"];
            model.albumURL=([dic[@"album_img"] isEqual:[NSNull null]])? @"":dic[@"album_img"];
            
            [modelArray addObject:model];
        }
        NSString* keyworlds = DataDic[@"keyword"];
        NSDictionary* data = @{@"keyWorlds":keyworlds,@"data":modelArray};
        NSInteger totalPageNum = [DataDic[@"totalPage"]integerValue];
        totalPage(totalPageNum);
        success(data);
//          success(modelArray);

    } fail:^(NSError *error) {
        
        fail(error);
        
    }];
    
    
}

//mid 歌曲ID，不能为空
//cid 配置ID，没有则为0
//+(void)addLikeMusicOrMusicConfiguration:(NSString *)subURL success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail
//{
//    NSString*requstURLString=[NSString stringWithFormat:@"%@%@",D5LED_ADD_LIKE,subURL];
//    
//    [D5HUploadLocalMusic afNetworkingServer:requstURLString success:^(id response) {
//        
//        NSNumber* status=[response valueForKey:@"status"];
//        //返回1为成功，0为失败
//        success(status);
//        
//    } fail:^(NSError *error) {
//        
//        fail(error);
//        
//    }];
//
//
//}

@end
