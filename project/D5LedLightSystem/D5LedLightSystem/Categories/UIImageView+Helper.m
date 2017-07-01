//
//  UIImageView+Helper.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "UIImageView+Helper.h"

@implementation UIImageView (Helper)

-(void)setBtnFillet
{
    [self.layer setCornerRadius:20];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
}
@end
