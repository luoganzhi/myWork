//
//  D5MusicCategoryPopView.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedMusicCategoryList) (NSString*musicClassfyName,NSString*musicClassfyID,NSInteger categoryID);

typedef void (^MusicCategoryPopViewHiden)(BOOL isHiden);
@interface D5MusicCategoryPopView : UIView

@property(nonatomic,copy)SelectedMusicCategoryList selectedMusicCategoryList;
@property(nonatomic,copy)MusicCategoryPopViewHiden popViewHiden;
@property(nonatomic,assign)NSInteger categoryID;
-(void)setDataList:(NSArray*)dataArrayList selctedCategory:(NSString*)name;
-(void)removePopView;
-(void)hidenView:(BOOL)isHiden;


@end




typedef void (^TouchCategoryRow)(NSInteger row);

@interface D5MusicCategoryPopViewCell : UICollectionViewCell
@property(nonatomic,copy)TouchCategoryRow touchCategory;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,strong)UIButton*title;




@end
@interface D5MusicCategoryPopViewFootView : UICollectionReusableView

@end
