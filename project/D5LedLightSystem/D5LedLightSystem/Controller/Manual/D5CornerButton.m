//
//  D5CornerButton.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5CornerButton.h"

@implementation D5CornerButton

-(void)setcordius:(CGFloat)height
{
    self.layer.cornerRadius = height/2.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor =[UIColor clearColor].CGColor;
//    self.clipsToBounds = YES;//去除边
    self.layer.masksToBounds = YES;
}

-(void)awakeFromNib
{
    [super awakeFromNib];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
        self.layer.cornerRadius =self.frame.size.height/2.0f;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor =[UIColor clearColor].CGColor;
        self.clipsToBounds = TRUE;//

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {

    }
    
    return self;

}
@end
