//
//  D5EditTableViewCell.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5BaseListModel;
@interface D5EditTableViewCell : UITableViewCell

/** musicModel */
@property (nonatomic, strong) D5BaseListModel *musicModel;

/** index */
@property (nonatomic, assign) NSInteger indexRow;

/** 选择的回调 */
@property (nonatomic, copy) void(^checkBlock)();



@end
