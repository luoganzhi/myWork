//
//  UIWindow+D5Helper.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/10/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "UIWindow+D5Helper.h"

@implementation UIWindow (D5Helper)
//获取当前的显示的controler
+(UIViewController*)getCurrentShowController{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];
    
     if ([nextResponder isKindOfClass:[UINavigationController class]]){
         
        UINavigationController * nav = (UINavigationController *)nextResponder;
         
        result = nav.childViewControllers.lastObject;
    }
      else if ([nextResponder isKindOfClass:[UIViewController class]]){
         
          result = nextResponder;
      }
      else{
        
          result = window.rootViewController;
      }
    
    return result;
    
}




@end
