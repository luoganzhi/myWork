//
//  D5SearchTagData.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/14.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLOW_BUTTON_FONT [UIFont systemFontOfSize:12]

#define FLOW_BUTTON_PURPLE_BORDER [UIColor colorWithRed:0.667 green:0.376 blue:1.000 alpha:1.000]
#define FLOW_BUTTON_YELLOW_BORDER [UIColor colorWithRed:0.957 green:0.902 blue:0.004 alpha:1.000]
#define FLOW_BUTTON_RED_BORDER [UIColor colorWithRed:0.949 green:0.188 blue:0.545 alpha:1.000]
#define FLOW_BUTTON_GREEN_BORDER [UIColor colorWithRed:0.020 green:1.000 blue:0.596 alpha:1.000]
#define FLOW_BUTTON_BLUE_BORDER [UIColor colorWithRed:0.000 green:0.408 blue:0.718 alpha:1.000]

#define HEADER_KEY @"aaa"
#define TAGS_KEY @"bbb"

@interface D5SearchTagData : NSObject

@property (nonatomic, strong) NSMutableArray *buttonList;
@property (nonatomic, copy) NSString *headerTitle;

@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithDict:(NSMutableDictionary *)dict;
+ (instancetype)dataWithDict:(NSMutableDictionary *)dict;

- (void)setData:(D5SearchTagData *)data viewWidth:(CGFloat)width;
@end
