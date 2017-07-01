//
//  D5Refresh.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5Refresh.h"
@interface D5Refresh()

@end
@implementation D5Refresh
#pragma mark -- ScrollView Delegate

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    //开始拖拽
//    if (scrollView.contentOffset.y+scrollView.frame.size.height>=scrollView.contentSize.height) {
//        
//        //此处动画纯粹为了过度平滑
//        if (_nowPage==YEARS||HOURS==_nowPage) {
//            
//            return;
//        }
//        
//        
//        [self HudShowLoading];
//        
//        [UIView animateWithDuration:1.0f animations:^(void)  {
//            
//            _yTableview.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
//            
//        }completion:^(BOOL complete){
//            //处理需要加载的东西
//            if(_nowPage==MOUTH){
//                
//                _nSYearDate=[NSDate getMouthForYear:_nSYearDate isDeS:YES];
//                
//                [self getMouthPower:_nSYearDate];
//                _yTableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                
//            }else if(_nowPage==DAY)  {
//                
//                _nSMouthDate=[NSDate getdayforMouth:_nSMouthDate isDeS:YES];
//                [self getDayPower:_nSMouthDate];
//                _yTableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                
//            }else if (_nowPage==HOURS){
//                
//                [MBProgressHUD hideHUDForView:self.view];
//                _yTableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                
//            }
//        }];
//        
//    }
//    
//    _PrePoint=scrollView.contentOffset;
//    
//}

@end
