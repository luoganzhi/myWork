//
//  D5BtLightViewCell.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/12/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5BTUpdateLightData.h"

#define DONE_STR                    @"完成"
#define REUPDATE_STR                @"重新升级"

#define BTLIGHT_CELL_ID @"BTLIGHT_CELL"

/**
 升级结果的block

 @param title 按钮的标题--完成/重新升级
 @param allFailed 是否全部失败
 */
typedef void(^UpdateBlock)(NSString *title, BOOL allFailed);

typedef void(^FailedBlock)(int lightID);


@interface D5BtLightViewCell : UICollectionViewCell

/**
 给cell设置数据

 @param data 数据
 @param dict 灯编号--升级状态（键值对）
 */
- (void)setData:(D5BTUpdateLightData *)data;

@end
