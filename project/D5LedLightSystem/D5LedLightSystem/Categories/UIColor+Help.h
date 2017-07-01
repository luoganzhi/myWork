//
//  UIColor+Help.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/13.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UNDEFINED 0

typedef struct {float r, g, b;} RGBType;
typedef struct {float h, s, v;} HSVType;

RGBType RGBTypeMake(float r, float g, float b);
HSVType HSVTypeMake(float h, float s, float v);

HSVType RGB_to_HSV( RGBType RGB );
RGBType HSV_to_RGB( HSVType HSV );

@interface UIColor (Help)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

@end
