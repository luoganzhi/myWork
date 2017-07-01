//
//  D5BaseListModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class D5MusicModel;
@class D5EffectsModel;
@interface D5BaseListModel : NSObject

/** Effects */
@property (nonatomic, strong) NSMutableArray *effectsList;

/** music */
@property (nonatomic, strong) D5MusicModel *music;

@end
