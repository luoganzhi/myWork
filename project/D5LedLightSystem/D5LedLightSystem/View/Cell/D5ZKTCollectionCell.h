//
//  D5ZKTCollectionCell.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/1.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5LedZKTBoxData.h"

#define ZKT_COLLECTION_CELL_ID @"ZKT_COLLECTION_CELL"
#define ZKT_ADD_CELL_ID @"ZKT_ADD_CELL"

@interface D5ZKTCollectionCell : UICollectionViewCell

- (void)setData:(D5LedZKTBoxData *)data;

@end
