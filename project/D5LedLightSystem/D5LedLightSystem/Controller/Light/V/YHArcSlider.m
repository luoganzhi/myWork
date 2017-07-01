




//  YHArcCircleSlider.m
//  YHArcSlider
//
//  Created by baiwei－mac on 16/4/18.
//  Copyright © 2016年 BWDV. All rights reserved.
//

#import "YHArcSlider.h"

//整个slider需要的信息参数结构体
typedef struct{
    CGPoint circleCenter;
    CGFloat radius;
    
    double fullLine;
    double circleOffset;
    double circleLine;
    double circleEmpty;
    
    double circleOffsetAngle;
    double circleLineAngle;
    double circleEmptyAngle;
    
    CGPoint startMarkerCenter;
    CGPoint endMarkerCenter;
    
    CGFloat startMarkerRadius;
    CGFloat endMarkerRadius;
    
    CGFloat startMarkerFontSize;
    CGFloat endMarkerFontize;
    
    CGFloat startMarkerAlpha;
    CGFloat endMarkerAlpha;
    
} YHSectorDrawingInformation;


//#define SliderColor ]//黄色
@implementation YHArcSlider{
   //变化的点
    YHSectorDrawingInformation trackingSectorDrawInf;//变化点的信息
    
    BOOL trackingSectorStartMarker;
}
@synthesize trackingSector;

-(void)setLightBritgressValue:(CGFloat)value
{
//    drawInf.fullLine = _sector.maxValue - _sector.minValue;
//    drawInf.circleOffset = _sector.startValue - _sector.minValue;
//    drawInf.circleLine = _sector.endValue - _sector.startValue;
//    drawInf.circleEmpty = _sector.maxValue - _sector.endValue;
float valu= (_sector.startValue - _sector.minValue)/(_sector.maxValue - _sector.minValue);
//    * M_PI * 2 + self.startAngle;
    
    self.sector.startValue=value*3/4;
    self.sector.endValue=75;
    self.sector.maxValue=100;
    self.sector.minValue=0;
    [self setNeedsDisplay];
    
   
    

}

#pragma mark - Initializators

- (instancetype)init{
    if(self = [super init]){
        [self setupDefaultConfigurations];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupDefaultConfigurations];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupDefaultConfigurations];
    }
    return self;
}
//初始化
- (void) setupDefaultConfigurations{
    self.sectorsRadius = 45.0;
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = toRadians(270);
    self.markRadius = 20;
    self.circleLineWidth = 4;
    self.lineWidth = 1.0;
}

#pragma mark - Setters

- (void)setSectorsRadius:(double)sectorsRadius{
    _sectorsRadius = sectorsRadius;
    [self setNeedsDisplay];
}
-(void)setIsSwitch:(BOOL)isSwitch
{
//    _isSwitch=isSwitch;
    [self setNeedsDisplay];

}
-(BOOL)showTips
{
    if ([[NSDate date]timeIntervalSince1970]-_interval<=1) {
        return YES;
    }
    else
    {
        _interval=[[NSDate date]timeIntervalSince1970];
        return NO;
    }
}

//-(void)set
//-(UIColor*)getSliderColor
//{
////    if (_isSwitch==YES) {
////        
////        return [UIColor colorWithRed:255/255.0 green:212/255.0 blue:0/255.0 alpha:1.0];
////    }
////    else
////    {
////        return [UIColor grayColor];
////    }
//
//}

#pragma mark - Events manipulator
//开始
- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if ([self showTips]) {
//        [iToast showButtomTitile:@"请至少打开一盏灯"];
        return YES;
    }
    
        YHSector *sector = self.sector;
    
        YHSectorDrawingInformation drawInf =[self sectorToDrawInf:sector ];
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.endMarkerCenter]){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = NO;
            return YES;
        }
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.startMarkerCenter]){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = YES;
            return YES;
        }
    
    return NO;
}
//持续
- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
   
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint ceter = [self multiselectCenter];
    YHPolarCoordinate polar = decartToPolar(ceter, touchPoint);
    
    double correctedAngle;
    if(polar.angle < self.startAngle) correctedAngle = polar.angle + (2 * M_PI - self.startAngle);
    else correctedAngle = polar.angle - self.startAngle;
    
    double procent = correctedAngle / (M_PI * 2);
    
    double newValue = procent * (trackingSector.maxValue - trackingSector.minValue) + trackingSector.minValue;
    
    if(trackingSectorStartMarker){
        if(newValue > trackingSector.startValue){
            double diff = newValue - trackingSector.startValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.startValue = trackingSector.minValue;
                [self valueChangedNotification];
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue >= trackingSector.endValue){
            trackingSector.startValue = trackingSector.endValue;
            [self valueChangedNotification];
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.startValue = newValue;
        [self valueChangedNotification];
    }
    else{
        if(newValue < trackingSector.endValue){
            double diff = trackingSector.endValue - newValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.endValue = trackingSector.maxValue;
                [self valueChangedNotification];
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue <= trackingSector.startValue){
            trackingSector.endValue = trackingSector.startValue;
            [self valueChangedNotification];
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.endValue = newValue;
        [self valueChangedNotification];
    }
    
    
    [self setNeedsDisplay];
    
    return YES;
}
//结束
- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    trackingSector = nil;
    trackingSectorStartMarker = NO;
}

- (CGPoint) multiselectCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

//判断点击的位置是否是mark内
- (BOOL) touchInCircleWithPoint:(CGPoint)touchPoint circleCenter:(CGPoint)circleCenter{
    YHPolarCoordinate polar = decartToPolar(circleCenter, touchPoint);
    if(polar.radius >= self.markRadius)
        return NO;
    else
        return YES;
}

- (void) valueChangedNotification{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect{
    
        [self drawSector:self.sector];
}

- (void)drawSector:(YHSector *)sector{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, self.circleLineWidth);
    
    UIColor *startCircleColor = sector.color;

    UIColor *markBackcolor = [UIColor whiteColor];
    
    YHSectorDrawingInformation drawInf = [self sectorToDrawInf:sector];
    
    CGFloat x = drawInf.circleCenter.x;
    CGFloat y = drawInf.circleCenter.y;
    CGFloat r = drawInf.radius;
    
    
    //start circle line
//    [startCircleColor setStroke];
//    
//    CGContextAddArc(context, x, y, r, self.startAngle, drawInf.circleOffsetAngle, 0);
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextStrokePath(context);

    
//    CGContextRef context = UIGraphicsGetCurrentContext();//绘制大背景色
//    addColorStop
    
    
    
    //颜色渐变代码
    /*
    CGColorSpaceRef colorSpaceRef=CGColorSpaceCreateDeviceRGB();
    CGFloat colors[]=
    {
        1.0, 0.0, 0.0, 1.0,   //RGBA values (so red to green in this case)
        0.0, 1.0, 0.0, 1.0
    };
//    CGColorSpaceRelease(colorSpaceRef);
    
    CGMutablePathRef arc=CGPathCreateMutable();
    CGPathMoveToPoint(arc, NULL, x, y);
    CGPathAddArc(arc, NULL, x, y, r, self.startAngle,0, 0);
    CGPathRef storkedArc=CGPathCreateCopyByStrokingPath(arc, NULL, 5.0, kCGLineCapButt, kCGLineJoinMiter, 10.0f);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, storkedArc);
    CGContextClip(context);
    
    // 创建起点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.01f, 0.99f, 0.01f, 1.0f});
    
    // 创建终点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.99f, 0.99f, 0.01f, 1.0f});
    
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
//    CFArrayRef cfArrayRef=cfa
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,       // 对应起点颜色位置
        1.0f        // 对应终点颜色位置
    });
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(20, 20),CGPointMake(100, 100), 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
  
    CGContextRestoreGState(context);
    
    */
    
    //绘制灰色大背景色
    CGContextAddArc(context, x, y, r,self.startAngle,M_PI_4, 0);
    [[UIColor grayColor] setStroke];
    CGContextSetLineWidth(context, 4.0f);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    CGContextAddArc(context, x, y, r,self.startAngle, drawInf.circleOffsetAngle, 0);
    [[UIColor colorWithRed:255/255.0 green:212/255.0 blue:0/255.0 alpha:1.0] setStroke];
    CGContextSetLineWidth(context, 4.0f);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextDrawPath(context, kCGPathStroke);

    
    
//    //clearing place for start marker
//    CGContextSaveGState(context);
//    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius - (self.lineWidth/2.0), 0.0, 6.28, 0);
//    CGContextClip(context);
//    CGContextClearRect(context, self.bounds);
//    CGContextRestoreGState(context);
//    
//    
//    //clearing place for end marker
//    CGContextSaveGState(context);
//    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius - (self.lineWidth/2.0), 0.0, 6.28, 0);
//    CGContextClip(context);
//    CGContextClearRect(context, self.bounds);
//    CGContextRestoreGState(context);
    
    CGFloat len = r/sqrt(2);
    
//    //外圆弧
//    CGContextSetLineWidth(context, self.lineWidth);
//    CGContextAddArc(context, x, y, r+10, self.startAngle, M_PI_4, 0);
//    CGContextStrokePath(context);
    
//    //左端点
//    CGContextSaveGState(context);
//    CGContextAddArc(context, x-len, y+len, 10, -M_PI_4, M_PI_4*3, 0);
//    CGContextStrokePath(context);
    
    //内圆弧
//    CGContextSaveGState(context);
//    CGContextAddArc(context, x, y, r-10, self.startAngle, M_PI_4, 0);
//    CGContextStrokePath(context);
//    //右端点
//    CGContextSaveGState(context);
//    CGContextAddArc(context, x+len, y+len, 10, M_PI_4, M_PI_4*5, 0);
//    CGContextStrokePath(context);
    
    //如果需要圆弧上面有字
    if (self.drowNumber) {
        self.drowNumber(r,x,y);
    }
    
    //标记
//    CGContextSetLineWidth(context, self.lineWidth);
//    [[startCircleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setStroke];
//    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius, 0.0, 6.28, 0);
    //标记背景色
//    CGContextStrokePath(context);
//    [markBackcolor setFill];
//    [[startCircleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setStroke];
//    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius-1, 0.0, 6.28, 0);
//    CGContextFillPath(context);
    
    CGContextSetRGBStrokeColor(context, 255/255.0, 255/255.0, 255/255.0, 1);
    CGContextSetLineWidth(context, 12);
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, 12, 0,6.28, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255/255.0 green:212/255.0 blue:0/255.0 alpha:1.0].CGColor);
//    CGContextSetLineWidth(context, 8);
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, 6.0f, 0,6.28, 0);
    CGContextDrawPath(context, kCGPathFill);
    


//    //标记上面的字
//    NSString *startMarkerStr = [NSString stringWithFormat:@"%.0f", sector.startValue+16];
//    [self drawString:startMarkerStr
//            withFont:drawInf.startMarkerFontSize
//               color:[startCircleColor colorWithAlphaComponent:drawInf.startMarkerAlpha]
//          withCenter:drawInf.startMarkerCenter];
}


- (YHSectorDrawingInformation) sectorToDrawInf:(YHSector *)sector {
    YHSectorDrawingInformation drawInf;
    
    drawInf.circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height /2);
    drawInf.radius = self.sectorsRadius;//圆半径
    
    drawInf.fullLine = sector.maxValue - sector.minValue;
    drawInf.circleOffset = sector.startValue - sector.minValue;
    drawInf.circleLine = sector.endValue - sector.startValue;
    drawInf.circleEmpty = sector.maxValue - sector.endValue;
    
    drawInf.circleOffsetAngle = (drawInf.circleOffset/drawInf.fullLine) * M_PI * 2 + self.startAngle;
    
    drawInf.circleLineAngle = (drawInf.circleLine/drawInf.fullLine) * M_PI * 2 + drawInf.circleOffsetAngle;
    drawInf.circleEmptyAngle = M_PI * 2 + self.startAngle;
    
    
    drawInf.startMarkerCenter = polarToDecart(drawInf.circleCenter, drawInf.radius, drawInf.circleOffsetAngle);
    
    drawInf.startMarkerRadius = self.markRadius;
    
    drawInf.startMarkerFontSize = 18;
    drawInf.startMarkerAlpha = 1.0;

    return drawInf;
}
//mark上面的字
- (void) drawString:(NSString *)s withFont:(CGFloat)fontSize color:(UIColor *)color withCenter:(CGPoint)center{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                          NSForegroundColorAttributeName : color,
                          NSParagraphStyleAttributeName : paragraph};
    
    CGFloat x = center.x - (self.markRadius);
    CGFloat y = center.y - (self.markRadius / 2);
    CGRect textRect = CGRectMake(x, y, self.markRadius*2, self.markRadius);
    
    [s drawInRect:textRect withAttributes:dic];
}
@end





@implementation YHSector

- (instancetype)init{
    if(self = [super init]){
        self.minValue = 0.0;
        self.maxValue = 100.0;
        self.startValue = 0.0;
        self.endValue = 50.0;
        self.tag = 0;
        self.color = [UIColor greenColor];
    }
    return self;
}

+ (instancetype) sector{
    return [[YHSector alloc] init];
}

+ (instancetype) sectorWithColor:(UIColor *)color{
    YHSector *sector = [self sector];
    sector.color = color;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color maxValue:(double)maxValue{
    YHSector *sector = [self sectorWithColor:color];
    sector.maxValue = maxValue;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color minValue:(double)minValue maxValue:(double)maxValue{
    YHSector *sector = [self sectorWithColor:color maxValue:maxValue];
    sector.minValue = minValue;
    return sector;
}

@end
