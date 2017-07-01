//
//  D5ZKTCollectionCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/1.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ZKTCollectionCell.h"

#define SELECTED_ZKT_BG_COLOR [UIColor colorWithRed:0.957 green:0.902 blue:0.004 alpha:0.300]
#define NORMAL_ZKT_BG_COLOR [UIColor colorWithRed:0.220 green:0.788 blue:0.788 alpha:0.300]

#define SELECTED_ZKT_ICON_IMAGE [UIImage imageNamed:@"zkt_cell_icon_selected"]
#define NORMAL_ZKT_ICON_IMAGE [UIImage imageNamed:@"zkt_cell_icon"]

@interface D5ZKTCollectionCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *zktNameLabel;

@end

@implementation D5ZKTCollectionCell

- (void)drawRect:(CGRect)rect {
    @autoreleasepool {
        
    }
}

- (void)setData:(D5LedZKTBoxData *)data {
    @autoreleasepool {
        _zktNameLabel.text = data.boxName;
        
        NSDictionary *selectedZKT = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_ZKT_KEY];
        BOOL isSelectedZKT = NO;
        if (selectedZKT) {
            NSString *selectedImeiCode = [selectedZKT objectForKey:ZKT_BOX_IDENTIFY];
            isSelectedZKT = [data.imeiCode isEqualToString:selectedImeiCode];
        }
        
        _bgView.backgroundColor = isSelectedZKT ? SELECTED_ZKT_BG_COLOR : NORMAL_ZKT_BG_COLOR;
        _selectedBgImgView.hidden = !isSelectedZKT;
        _iconImgView.image = isSelectedZKT ? SELECTED_ZKT_ICON_IMAGE : NORMAL_ZKT_ICON_IMAGE;
    }
}

@end
