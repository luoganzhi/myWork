//
//  D5SearchTagData.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/14.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SearchTagData.h"

#define BTN_ROUND_RADIUS 12
#define BTN_HEIGHT 24

@interface D5SearchTagData ()

@property (nonatomic, assign) int currentRow;
@property (nonatomic, assign) CGFloat currentRowWidth, btnHeight, viewWidth;

@end

@implementation D5SearchTagData

#pragma mark - 创建D5SearchTagData
- (instancetype)initWithDict:(NSMutableDictionary *)dict {
    if (self = [super init]) {
        self.headerTitle = [dict objectForKey:HEADER_KEY];
        self.contentArr = [dict objectForKey:TAGS_KEY];
    }
    
    return self;
}

+ (instancetype)dataWithDict:(NSMutableDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}


/**
 *  设置self的内容
 *
 *  @param data   内容data
 *  @param height self里面button的高度
 *  @param width cell的宽度
 */
- (void)setData:(D5SearchTagData *)data viewWidth:(CGFloat)width {
    self.headerTitle = data.headerTitle;
    self.contentArr = data.contentArr;
    
    if (!self.contentArr || self.contentArr.count <= 0) {
        self.height = 0;
        return;
    }
    
    _btnHeight = BTN_HEIGHT;
    _viewWidth = width;
    
    _currentRow = 0;
    _currentRowWidth = 0;
    for (int i = 0; i < self.contentArr.count; i ++) {
        [self addBtnWithTitle:self.contentArr[i] atIndex:i];
    }
}

/**
 *  根据text的字数得到button的宽度
 *
 *  @param text 参数
 *
 *  @return 适应text字数的宽度
 */
- (CGFloat)buttonWidthWithText:(NSString *)text {
    @autoreleasepool {
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(_viewWidth, _btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FLOW_BUTTON_FONT} context:nil].size;
        return textSize.width + 20;
    }
}

/**
 *  添加button, 在dataList里面索引为index
 *
 *  @param title button的标题
 *  @param index datalist中所在的索引
 */
- (void)addBtnWithTitle:(NSString *)title atIndex:(int)index {
    @autoreleasepool {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FLOW_BUTTON_FONT;
        
        CGFloat width = [self buttonWidthWithText:title];
        
        CGFloat margin = 8;
        CGFloat x = 0;
        CGFloat y = 0;
        
        // 对第一个Button进行设置
        CGFloat newAddWidth = width + margin;
        if (index == 0) {
            _currentRowWidth += newAddWidth;
        } else {
            if (((_currentRowWidth + newAddWidth) >= _viewWidth) && ((_currentRowWidth + newAddWidth - margin) >= _viewWidth)) {
                _currentRow ++;
                _currentRowWidth = newAddWidth;
            } else {
                x = _currentRowWidth;
                _currentRowWidth += newAddWidth;
            }
        }
        
        
        y = (_currentRow + 1) * margin + _currentRow * _btnHeight;
        
        button.frame = CGRectMake(x, y, width, _btnHeight);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([self.headerTitle isEqualToString:@"热门搜索"]) {
            if (index == 0 || index == 1 || index == 2) {
                [D5Round showCornerWithView:button withColor:FLOW_BUTTON_PURPLE_BORDER withRadius:BTN_ROUND_RADIUS withBoarderWith:1.0f];
            } else if (index == 3 || index == 4 || index == 5 || index == 6) {
                [D5Round showCornerWithView:button withColor:FLOW_BUTTON_YELLOW_BORDER withRadius:BTN_ROUND_RADIUS withBoarderWith:0.5f];
            } else if (index == 7) {
                [D5Round showCornerWithView:button withColor:FLOW_BUTTON_RED_BORDER withRadius:BTN_ROUND_RADIUS withBoarderWith:0.5f];
            } else if (index == 8) {
                [D5Round showCornerWithView:button withColor:FLOW_BUTTON_GREEN_BORDER withRadius:BTN_ROUND_RADIUS withBoarderWith:0.5f];
            } else {
                [D5Round showCornerWithView:button withColor:FLOW_BUTTON_BLUE_BORDER withRadius:BTN_ROUND_RADIUS withBoarderWith:0.5f];
            }
        } else {
            [D5Round showCornerWithView:button withColor:[UIColor colorWithWhite:1 alpha:0.6f] withRadius:0 withBoarderWith:1.0f];
        }
        
        [self.buttonList addObject:button];
        
        if (index == self.contentArr.count - 1) {
            self.height = CGRectGetMaxY(button.frame) + margin;
        }
    }
}

- (NSMutableArray *)buttonList {
    if (!_buttonList) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

@end
