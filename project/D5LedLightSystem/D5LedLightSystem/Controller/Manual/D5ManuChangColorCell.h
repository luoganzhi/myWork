//
//  D5ManuChangColorCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5CornerButton.h"
#define ManuChangColorCellIndentifer @"D5ManuChangColorCell"

typedef void(^ChangeColor) (UIColor *selectedColor, NSInteger LightIndex, NSInteger colorIndex);

@interface D5ManuChangColorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet D5CornerButton *bt1;//颜色按钮索引1
@property (weak, nonatomic) IBOutlet D5CornerButton *bt2;//颜色按钮索引2
@property (weak, nonatomic) IBOutlet D5CornerButton *bt3;//颜色按钮索引3
@property (weak, nonatomic) IBOutlet D5CornerButton *bt4;//颜色按钮索引4
@property (weak, nonatomic) IBOutlet D5CornerButton *bt5;//颜色按钮索引5
@property (weak, nonatomic) IBOutlet D5CornerButton *bt6;//颜色按钮索引6
@property (copy, nonatomic) ChangeColor changeColor;//改变当前灯颜色
@property (strong, nonatomic) UIColor *color;
@property (nonatomic, strong) NSArray *btnArray;//六个颜色按钮数组
@property (nonatomic, assign) NSInteger section;

- (void)setUserInteractionEnabledAbutLight:(NSArray*)datas  enabled:(BOOL)enabled;

- (void)setDatas:(NSArray *)datas inSection:(NSInteger)section;

@end
