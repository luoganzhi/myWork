//
//  D5LightGroupCell.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLLECTIONVIEW_MARGIN 30
#define COLLECTION_CELL_HEIGHT 130

@class D5LedData;

#define LIGHT_GROUP_CELL_ID @"LIGHT_GROUP_CELL"

@interface D5LightGroupCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lightStatusImgView;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;

- (void)setData:(D5LedData *)data isEdit:(BOOL)isEdit;

@end
