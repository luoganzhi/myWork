//
//  D5MusicListModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/8/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5MusicListModel : NSObject
/** name */
@property (nonatomic, copy) NSString *name;
/** serverId */
@property (nonatomic, copy) NSString *serverId;

/** isShow */
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSArray *musicSpecialDatas;
@end
