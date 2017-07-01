//
//  D5BrightessSlider.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/28.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BrightessSlider.h"

#define SLIDERWIDTH 4.0f
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )//toDegrees
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )//toRadians
#define SQR(x)			( (x) * (x) )


@interface D5BrightessSlider ()

@property(nonatomic,assign)float radius;//半径
@property(nonatomic,assign)CGPoint cyclePoint;//圆心的坐标值

@end

@implementation D5BrightessSlider


-(void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor clearColor];
    _lineWidth=5.0f;
    _radius=90;
    _angle =45;
   


}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//     Drawing code
    [super drawRect:rect];
     _cyclePoint=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    /* Add an arc of a circle to the context's path, possibly preceded by a
     straight line segment. `(x, y)' is the center of the arc; `radius' is its
     radius; `startAngle' is the angle to the first endpoint of the arc;
     `endAngle' is the angle to the second endpoint of the arc; and
     `clockwise' is 1 if the arc is to be drawn clockwise, 0 otherwise.
     `startAngle' and `endAngle' are measured in radians. */
 //绘制大背景色
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, _radius,  M_PI*3/4,  M_PI/4, 0);
    [[UIColor grayColor] setStroke];
    CGContextSetLineWidth(context, SLIDERWIDTH);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextDrawPath(context, kCGPathStroke);
    
    //绘制进度
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,_radius,M_PI*3/4,ToRad(_angle), 0);
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
//    _angle = 210;
    //绘制拖动空心圆
    CGPoint nowPoint=[self pointFromAngle:_angle];//当前进度条的位置
    CGContextSetRGBStrokeColor(context, 255/255.0, 106/255.0, 0/255.0, 1);
    CGContextSetLineWidth(context, SLIDERWIDTH);
    CGContextAddArc(context, nowPoint.x, nowPoint.y, 10, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}


-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    //获取触摸点
    CGPoint lastPoint = [touch locationInView:self];
    if (![self isOperationCycleL:lastPoint]) {
        
        return YES;
    }
    //使用触摸点来移动小块
    [self movehandle:lastPoint];
    //发送值改变事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

//用户的点击范围
-(BOOL)isOperationCycleL:(CGPoint)point;
{
    float x=point.x-_cyclePoint.x;
    float y=point.y-_cyclePoint.y;
    float distance=SQR(x)+SQR(y);
    if (SQR(_radius)>distance) {
       
        return NO;
        
    }else
    {
        return YES;
    }
    
    

}

-(void)movehandle:(CGPoint)lastPoint{
    
    //获得中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2,
                                      self.frame.size.height/2);
    
    //计算中心点到任意点的角度
    float currentAngle = AngleFromNorth(centerPoint,
                                        lastPoint,
                                        NO);
    
    if (currentAngle>360) {
        
//        //DLog(@"大于360读=度");
    }
    int angleInt = floor(currentAngle);
    
    //保存新角度
    self.angle = angleInt;
    
    //重新绘制
    [self setNeedsDisplay];
}

-(void)changeAngle:(int)angle{
    _angle = angle;
    
    if (ToRad(_angle)>M_PI/4&&ToRad(_angle)<M_PI*3/4) {
        
        return;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

//从苹果是示例代码clockControl中拿来的函数
//计算中心点到任意点的角度
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}
//角度获取到
-(CGPoint)pointFromAngle:(int)angleInt{
    //中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth, self.frame.size.height/2 - _lineWidth);
    
    //根据角度得到圆环上的坐标
    CGPoint result;
    result.y = round(centerPoint.y + _radius * sin(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + _radius * cos(ToRad(angleInt)));
    
    return result;
}


@end
