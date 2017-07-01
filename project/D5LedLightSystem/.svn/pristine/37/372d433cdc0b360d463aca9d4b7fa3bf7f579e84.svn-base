//
//  D5MusicCategoryStatusModel.h
//  D5LedLightSystem
//
//  Created by 黄金 on 17/3/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct  {
    NSInteger nowPage;//当前选择
    NSInteger prePage;//上一次选择
}MusiccategoryType;

//用户记录用户选择音乐类别的
@interface D5MusicCategoryStatusModel : NSObject
@property(nonatomic) MusiccategoryType* options; //记录上一个和当前的选择
@property(nonatomic,assign)BOOL isShowPopView;//是否显示当前的Popview
//设置按钮的选项
-(void)setBtnImageWithCategoryOption:(UIButton*)btn popBnt:(UIButton*)popBtn;
-(BOOL)isShowPopView;

@end
