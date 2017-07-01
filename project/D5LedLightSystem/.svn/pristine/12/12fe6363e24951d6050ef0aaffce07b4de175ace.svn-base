//
//  D5ManuSwitchCell.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5LedData;

#define ManuSwitchCellIndentifer @"D5ManuSwitchCell"

#define light_white [UIColor colorWithHex:0xffffff alpha:1.0f]
#define light_red [UIColor colorWithHex:0xfe0100 alpha:1.0f]
#define light_orange [UIColor colorWithHex:0xfe8500 alpha:1.0f]
#define light_yellow [UIColor colorWithHex:0xfff200 alpha:1.0f]
#define light_green [UIColor colorWithHex:0x65e335 alpha:1.0f]
#define light_cyan [UIColor colorWithHex:0x00ffff alpha:1.0f]
#define light_blue [UIColor colorWithHex:0x00b9ed alpha:1.0f]
#define light_purple [UIColor colorWithHex:0x9301e1 alpha:1.0f]
#define light_gray [UIColor colorWithHex:0x222222 alpha:1.0f]

#define light_warm [UIColor colorWithHex:0xfcf0c3 alpha:1.0f]

#define light_off_offline [UIColor colorWithHex:0x808080 alpha:1.0]
#define light_not_add   [UIColor colorWithHex:0x333333 alpha:1.0]

#define IMAGE_WITH_COLOR(color) [NSString stringWithFormat:@"manual_%@", color]

typedef void (^SwitchOpen)(UIButton *btn, NSInteger index);

@interface D5ManuSwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *light1;

@property (weak, nonatomic) IBOutlet UIButton *light2;

@property (weak, nonatomic) IBOutlet UIButton *light3;

@property (weak, nonatomic) IBOutlet UIButton *light4;

@property (weak, nonatomic) IBOutlet UIButton *light5;

@property (weak, nonatomic) IBOutlet UIButton *light6;

@property (weak, nonatomic) IBOutlet UILabel *index1;
@property (weak, nonatomic) IBOutlet UILabel *index2;
@property (weak, nonatomic) IBOutlet UILabel *index3;
@property (weak, nonatomic) IBOutlet UILabel *index4;
@property (weak, nonatomic) IBOutlet UILabel *index5;
@property (weak, nonatomic) IBOutlet UILabel *index6;


@property (nonatomic, copy) SwitchOpen switchOpen;

- (void)setDatas:(NSArray *)datas;
//- (void)setLightswitchStatus:(NSArray *)data onColor:(UIColor *)labelColor onImage:(UIImage *)image;
@end
