//
//  TrollCharBaseView.m
//  TrollExpandTableViewDemo
//
//  Created by user on 15/2/9.
//  Copyright (c) 2015年 ways. All rights reserved.
//

#import "TrollChartBaseView.h"

static NSString * const kHistogramLayer = @"HistogramLayer";
static NSString * const kLineLayer = @"LineLayer";
static NSString * const kDashLineLayer = @"DashLineLayer";
static NSString * const kLineCanBrokenLayer = @"LineCanBrokenLayer";

typedef NS_ENUM(NSInteger, TrollYAxisDrawingType) {
    KTrollYAxisDrawingLeft = 1 << 0,
    KTrollYAxisDrawingRight = 1 << 1,
    KTrollYAxisDrawingBoth  = 1 << 2,
    KTrollYAxisDrawingNone  = 1 << 3
};

#define TEXT_WIDTH                  35
#define XAXIS_HEIGHT                30
#define LENGEND_HEIGHT              20
#define YAXIS_WIDTH                 40
#define YAXIS_HEIGHT                30
#define XAXIS_BLANK_WIDTH           5
#define YAXIS_BLANK_HEIGHT          15
#define LEGEND_HEIGHT               25
#define LEGEND_BLANK                5
#define LEGEND_RIGHT_BLANK          15
#define LEGEND_DISTANCE             3
#define LEGEND_IMAGE_WIDTH          20
#define HISTOGRAM_DEFAULT_WIDTH     10
#define CONTENT_HEIGHT              25


#pragma mark - TrollChartPoint

@interface TrollChartPoint : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL iSNull;

@end

@implementation TrollChartPoint


@end

#pragma mark - TrollChartValue

@implementation TrollChartValue


@end

#pragma mark - TrollCAShapeLayer

@interface TrollCAShapeLayer : CAShapeLayer

@property (nonatomic, strong) NSString *name;

@end

@implementation TrollCAShapeLayer


@end

#pragma mark - TrollCATextLayer

@interface TrollCATextLayer : CATextLayer

@property (nonatomic, strong) NSString *name;

@end

@implementation TrollCATextLayer

@end

#pragma mark - TrollChartLegendView

@protocol TrollLegendDelegate <NSObject>

@optional
- (void)TrollLegendTapOnLayer:(TrollCAShapeLayer *)layer;

@end

@interface TrollChartLegendView : UIView

@property (nonatomic, strong) NSMutableArray *legendArray;
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, assign) id<TrollLegendDelegate>delegate;

@end

@implementation TrollChartLegendView

- (void)DrawLegendWithTitle:(NSArray *)titles Color:(NSArray *)colors Style:(NSArray *)styles Names:(NSArray *)names{
    
    NSAssert(titles && colors && titles.count == colors.count, @"TrollLegengView drawing failed as count of titles and colors is not equal ");
    
    if(_legendArray == nil){
        _legendArray = [NSMutableArray array];
    }
    
    for(TrollCAShapeLayer *layer in _legendArray){
        [layer removeFromSuperlayer];
    }
    
    if(_textArray == nil){
        _textArray = [NSMutableArray array];
    }
    
    for(CATextLayer *textLayer in _textArray){
        [textLayer removeFromSuperlayer];
    }
    
    [_textArray removeAllObjects];
    [_legendArray removeAllObjects];
    
    CGFloat rightDistance = LEGEND_RIGHT_BLANK;
    for(NSInteger i=0; i<titles.count; i++){
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = titles[i];
        textLayer.fontSize = 11;
        textLayer.contentsScale =  [[UIScreen mainScreen] scale];
        textLayer.foregroundColor = [[colors objectAtIndex:i] CGColor];
        CGSize size = [textLayer.string boundingRectWithSize:CGSizeMake(MAXFLOAT, LEGEND_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
        rightDistance += size.width + LEGEND_BLANK;
        textLayer.frame = CGRectMake(self.frame.size.width-rightDistance, 6, size.width, size.height);
        [self.layer addSublayer:textLayer];
        [_textArray addObject:textLayer];
        
        NSString *name = nil;
        if(names.count > i){
            name = names[i];
        }
        
        TrollCAShapeLayer *legendLayer = [TrollCAShapeLayer layer];
        rightDistance += LEGEND_DISTANCE+LEGEND_IMAGE_WIDTH;
        legendLayer.frame = CGRectMake(self.frame.size.width-rightDistance, 0, LEGEND_IMAGE_WIDTH, LEGEND_HEIGHT);
        legendLayer.fillColor = [UIColor whiteColor].CGColor;
        legendLayer.strokeColor = [[colors objectAtIndex:i] CGColor];
        legendLayer.name = name;
        
        UIBezierPath *path = nil;
        
        NSString *style = styles[i];
        
        if([style isEqualToString:KTrollLegendLineCircleStyle]){
            path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, LEGEND_HEIGHT/2.0)];
            [path addLineToPoint:CGPointMake(6, LEGEND_HEIGHT/2.0)];
            
            UIBezierPath *pathCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(6, LEGEND_HEIGHT/2.0-4, 8, 8)];
            [path appendPath:pathCircle];
            
            UIBezierPath *pathLine = [UIBezierPath bezierPath];
            [pathLine moveToPoint:CGPointMake(14, LEGEND_HEIGHT/2.0)];
            [pathLine addLineToPoint:CGPointMake(20, LEGEND_HEIGHT/2.0)];
            [path appendPath:pathLine];
        }else if ([style isEqualToString:KTrollLegendLineRectStyle]){
            path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, LEGEND_HEIGHT/2.0)];
            [path addLineToPoint:CGPointMake(6, LEGEND_HEIGHT/2.0)];
            
            UIBezierPath *pathRect = [UIBezierPath bezierPathWithRect:CGRectMake(6, LEGEND_HEIGHT/2.0-2, 8, 4)];
            [path appendPath:pathRect];
            
            UIBezierPath *pathLine = [UIBezierPath bezierPath];
            [pathLine moveToPoint:CGPointMake(14, LEGEND_HEIGHT/2.0)];
            [pathLine addLineToPoint:CGPointMake(20, LEGEND_HEIGHT/2.0)];
            [path appendPath:pathLine];
        }else if ([style isEqualToString:KTrollLegendCircleStyle]){
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(12, LEGEND_HEIGHT/2.0) radius:6 startAngle:0 endAngle:2*M_PI clockwise:YES];
        }else if ([style isEqualToString:KTrollLegendRectStyle]){
            path = [UIBezierPath bezierPathWithRect:CGRectMake(3, LEGEND_HEIGHT/2.0-4, 14, 8)];
        }
        
        legendLayer.path = path.CGPath;
        [self.layer addSublayer:legendLayer];
        [self.legendArray addObject:legendLayer];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint ptInView = [touch locationInView:self];
    for(TrollCAShapeLayer *layer in _legendArray){
        CGPoint ptInLayer = [self.layer convertPoint:ptInView toLayer:layer];
        if([layer containsPoint:ptInLayer]){
            
            if(layer.fillColor == [UIColor lightGrayColor].CGColor){
                layer.fillColor = [UIColor whiteColor].CGColor;
            }else{
                layer.fillColor = [UIColor lightGrayColor].CGColor;
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(TrollLegendTapOnLayer:)]){
                [self.delegate TrollLegendTapOnLayer:layer];
            }
            
            break;
        }
    }
}

@end

#pragma mark - TrollChartLine

@interface TrollChartLine : TrollCAShapeLayer

@property (nonatomic, strong) NSMutableArray *textArray;

@end

@implementation TrollChartLine

- (void)DrawLine:(NSArray *)contents color:(UIColor *)color lineWidth:(CGFloat)lineWidth name:(NSString *)name textPosition:(NSString *)position iSReuse:(BOOL)iSReuse{
    
    if(self.textArray == nil){
        self.textArray = [NSMutableArray array];
    }
    
    for(CATextLayer *layer in self.textArray){
        [layer removeFromSuperlayer];
    }
    
    [self.textArray removeAllObjects];
    
    //Drawing Text
    
    for(NSInteger i=0; i<contents.count; i++){
        TrollChartPoint *point = contents[i];
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = point.title;
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        textLayer.fontSize = 9;
        textLayer.foregroundColor = color.CGColor;
        CGSize size = [textLayer.string boundingRectWithSize:CGSizeMake(MAXFLOAT, CONTENT_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
        CGRect rect;
        if(!position || [position isEqualToString:KTrollContentTextPositionAboveContent]){
            rect = CGRectMake(point.point.x-size.width/2.0, point.point.y-size.height, size.width, size.height);
        }else{
            rect = CGRectMake(point.point.x-size.width/2.0, point.point.y, size.width, size.height);
        }
        textLayer.frame = rect;
        [self addSublayer:textLayer];
        [self.textArray addObject:textLayer];
    }
    
    //Drawing Line
    
    self.fillColor = color.CGColor;
    self.strokeColor = color.CGColor;
    self.lineWidth = lineWidth;
    self.strokeStart = 0.0;
    self.strokeEnd = 1.0;
    self.name = name;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    TrollChartPoint *firstPoint = [contents firstObject];
    [path moveToPoint:firstPoint.point];
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(firstPoint.point.x-1, firstPoint.point.y-1, 2, 2) cornerRadius:1];
    [path appendPath:dotPath];
    for(NSInteger i=1; i<contents.count; i++){
        TrollChartPoint *point = contents[i];
        [path addLineToPoint:point.point];
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.point.x-1, point.point.y-1, 2, 2) cornerRadius:1];
        [path appendPath:dotPath];
    }
    
    if(iSReuse){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (id)self.path;
        animation.toValue = (id)path.CGPath;
        animation.duration = 0.5;
        [self addAnimation:animation forKey:nil];
    }else{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = 0.5;
        [self addAnimation:animation forKey:nil];
    }
    self.path = path.CGPath;
}

@end

#pragma mark - TrollChartDashLine

@interface TrollChartDashLine : CAShapeLayer

@end

@implementation TrollChartDashLine

@end

#pragma mark - TrollChartLineCanBroken

@interface TrollChartLineCanBroken : TrollCAShapeLayer

@property (nonatomic, strong) NSMutableArray *textArray;

@end

@implementation TrollChartLineCanBroken

- (void)DrawLineCanBroken:(NSArray *)contents color:(UIColor *)color lineWidth:(CGFloat)lineWidth name:(NSString *)name textPosition:(NSString *)position iSReuse:(BOOL)iSReuse{
    if(self.textArray == nil){
        self.textArray = [NSMutableArray array];
    }
    
    for(CATextLayer *layer in self.textArray){
        [layer removeFromSuperlayer];
    }
    
    [self.textArray removeAllObjects];
    
    //Drawing Text
    
    for(NSInteger i=0; i<contents.count; i++){
        TrollChartPoint *point = contents[i];
        if(point.iSNull){
            continue;
        }
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = point.title;
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        textLayer.fontSize = 9;
        textLayer.foregroundColor = color.CGColor;
        CGSize size = [textLayer.string boundingRectWithSize:CGSizeMake(MAXFLOAT, CONTENT_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
        CGRect rect;
        if(!position || [position isEqualToString:KTrollContentTextPositionAboveContent]){
            rect = CGRectMake(point.point.x-size.width/2.0, point.point.y-size.height, size.width, size.height);
        }else{
            rect = CGRectMake(point.point.x-size.width/2.0, point.point.y, size.width, size.height);
        }
        textLayer.frame = rect;
        [self addSublayer:textLayer];
        [self.textArray addObject:textLayer];
    }
    
    //Drawing Line
    
    self.fillColor = color.CGColor;
    self.strokeColor = color.CGColor;
    self.lineWidth = lineWidth;
    self.strokeStart = 0.0;
    self.strokeEnd = 1.0;
    self.name = name;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(NSInteger i=0; i<contents.count; i++){
        TrollChartPoint *currentPoint = contents[i];
        
        if(currentPoint.iSNull){
            continue;
        }else{
            TrollChartPoint *lastPoint = nil;
            if(i > 0){
                lastPoint = contents[i-1];
                
                if(lastPoint.iSNull){
                    [path moveToPoint:currentPoint.point];
                    UIBezierPath *dotPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(currentPoint.point.x-1, currentPoint.point.y-1, 2, 2) cornerRadius:1];
                    [path appendPath:dotPath];
                }else{
                    [path addLineToPoint:currentPoint.point];
                    UIBezierPath *dotPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(currentPoint.point.x-1, currentPoint.point.y-1, 2, 2) cornerRadius:1];
                    [path appendPath:dotPath];
                }
                
            }else{
                [path moveToPoint:currentPoint.point];
                UIBezierPath *dotPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(currentPoint.point.x-1, currentPoint.point.y-1, 2, 2) cornerRadius:1];
                [path appendPath:dotPath];
            }
        }
    }
    
    /*  重用效果不太好，暂时屏蔽
    if(iSReuse){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (id)self.path;
        animation.toValue = (id)path.CGPath;
        animation.duration = 0.5;
        [self addAnimation:animation forKey:nil];
    }else
     */
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = 0.5;
        [self addAnimation:animation forKey:nil];
    }
    self.path = path.CGPath;
}

@end

#pragma mark - TrollChartHistogram

@interface TrollChartHistogram : CAShapeLayer

@property (nonatomic, assign) NSInteger No;
@property (nonatomic, strong) NSMutableArray *layerArray;
@property (nonatomic, strong) NSMutableArray *textArray;

@end

@implementation TrollChartHistogram

#pragma mark - Show Or Hide Histogram With Name

- (void)HideHistogramWithName:(NSString *)name{
    for(TrollCAShapeLayer *layer in self.layerArray){
        if([layer.name isEqualToString:name]){
            layer.hidden = YES;
        }
    }
    
    for(TrollCATextLayer *text in self.textArray){
        if([text.name isEqualToString:name]){
            text.hidden = YES;
        }
    }
}

- (void)ShowHistogramWithName:(NSString *)name{
    for(TrollCAShapeLayer *layer in self.layerArray){
        if([layer.name isEqualToString:name]){
            layer.hidden = NO;
        }
    }
    
    for(TrollCATextLayer *layer in self.textArray){
        if([layer.name isEqualToString:name]){
            layer.hidden = NO;
        }
    }
}

#pragma mark - Show Or Hide Histogram With Color

- (void)HideHistogramWithColor:(CGColorRef)color{
    for(TrollCAShapeLayer *layer in self.layerArray){
        if(CGColorEqualToColor(layer.strokeColor, color)){
            layer.hidden = YES;
        }
    }
    
    for(TrollCATextLayer *text in self.textArray){
        if(CGColorEqualToColor(text.foregroundColor, color)){
            text.hidden = YES;
        }
    }
}

- (void)ShowHistogramWithColor:(CGColorRef)color{
    for(TrollCAShapeLayer *layer in self.layerArray){
        if(CGColorEqualToColor(layer.strokeColor, color)){
            layer.hidden = NO;
        }
    }
    
    for(TrollCATextLayer *text in self.textArray){
        if(CGColorEqualToColor(text.foregroundColor, color)){
            text.hidden = NO;
        }
    }
}

- (void)DrawHistogram:(NSArray *)contents colors:(NSArray *)colors width:(CGFloat)width names:(NSArray *)names textPositions:(NSArray *)positions{
    if(_layerArray == nil){
        _layerArray = [NSMutableArray array];
    }
    
    if(_textArray == nil){
        _textArray = [NSMutableArray array];
    }
    
    for(TrollCAShapeLayer *layer in _layerArray){
        layer.path = nil;
        [layer removeFromSuperlayer];
    }
    
    for(TrollCATextLayer *layer in _textArray){
        [layer removeFromSuperlayer];
    }
    [_textArray removeAllObjects];
    [_layerArray removeAllObjects];
    
    NSInteger histogramNum = colors.count;
    NSInteger totalNumOfEachHistogram = contents.count/histogramNum;
    for(NSInteger i=0; i<totalNumOfEachHistogram; i++){
        for(NSInteger j=0; j<histogramNum; j++){
            NSString *name = nil;
            if(names.count > j){
                name = names[j];
            }
            TrollCAShapeLayer *histogramLayer = [TrollCAShapeLayer layer];
            
            histogramLayer.strokeColor = [[colors objectAtIndex:j] CGColor];
            histogramLayer.lineWidth = width;
            histogramLayer.strokeStart = 0;
            histogramLayer.strokeEnd = 1.0;
            histogramLayer.name = name;
            
            CGFloat delXPoint;
            if (histogramNum == 1) {
                delXPoint = 0;
            }else{
                delXPoint = ((j+1)-histogramNum/2.0-1)*width+width/2;
            }
            
            TrollChartPoint *point = contents[j*totalNumOfEachHistogram+i];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(point.point.x+delXPoint, self.frame.size.height)];
            [path addLineToPoint:CGPointMake(point.point.x+delXPoint, point.point.y)];
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @0;
            animation.toValue = @1;
            animation.duration = 0.5;
            [histogramLayer addAnimation:animation forKey:nil];
            histogramLayer.path = path.CGPath;
            [self addSublayer:histogramLayer];
            [_layerArray addObject:histogramLayer];
        }
        
        for(NSInteger k=0; k<histogramNum; k++){
            NSString *name = nil;
            if(names.count > k){
                name = names[k];
            }
            TrollCATextLayer *textLayer = [TrollCATextLayer layer];
            textLayer.name = name;
            [self addSublayer:textLayer];
            [_textArray addObject:textLayer];
            
            CGFloat delXPoint;
            if (histogramNum == 1) {
                delXPoint = 0;
            }else{
                delXPoint = ((k+1)-histogramNum/2.0-1)*width+width/2;
            }
            
            TrollChartPoint *point = contents[k*totalNumOfEachHistogram+i];
            textLayer.string = point.title;
            textLayer.fontSize = 9;
            textLayer.foregroundColor = [[colors objectAtIndex:k] CGColor];
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
            CGSize size = [textLayer.string boundingRectWithSize:CGSizeMake(MAXFLOAT, CONTENT_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
            CGRect rect;
            
            NSString *position = nil;
            if(k < positions.count){
                position = positions[k];
            }
            
            if(!position || [position isEqualToString:KTrollContentTextPositionAboveContent]){
                rect = CGRectMake(point.point.x-size.width/2.0+delXPoint, point.point.y-size.height, size.width, size.height);
            }else{
                rect = CGRectMake(point.point.x-size.width/2.0+delXPoint, point.point.y, size.width, size.height);
            }
            
            textLayer.frame = rect;
        }
    }
}


- (void)DrawHistogram:(NSArray *)points color:(UIColor *)color width:(CGFloat)width totalNumber:(NSInteger)totalNumber names:(NSArray *)names{
    if(_layerArray == nil){
        _layerArray = [NSMutableArray array];
    }
    
    if(_textArray == nil){
        _textArray = [NSMutableArray array];
    }
    
    for(TrollCAShapeLayer *layer in _layerArray){
        layer.path = nil;
        [layer removeFromSuperlayer];
    }
    
    [_layerArray removeAllObjects];
    
    static BOOL isFirst = YES;
    
    for(NSInteger i=0; i<[points count]; i++){
        
        NSString *name = nil;
        if(names.count > i){
            name = names[i];
        }
        TrollCAShapeLayer *histogramLayer = [TrollCAShapeLayer layer];
        
        histogramLayer.strokeColor = color.CGColor;
        histogramLayer.lineWidth = width;
        histogramLayer.strokeStart = 0;
        histogramLayer.strokeEnd = 1.0;
        histogramLayer.name = name;
        
        CGFloat delXPoint;
        if (totalNumber == 1) {
            delXPoint = 0;
        }else{
            delXPoint = (self.No-totalNumber/2.0-1)*width+width/2;
        }
        
        TrollChartPoint *point = points[i];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(point.point.x+delXPoint, self.frame.size.height)];
        [path addLineToPoint:CGPointMake(point.point.x+delXPoint, point.point.y)];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = 0.5;
        [histogramLayer addAnimation:animation forKey:nil];
        histogramLayer.path = path.CGPath;
        [self addSublayer:histogramLayer];
        [_layerArray addObject:histogramLayer];
    }
    
    for(NSInteger i=0; i<[points count]; i++){
        
        CGFloat delXPoint;
        if (totalNumber == 1) {
            delXPoint = -(width/2.0);
        }else{
            delXPoint = (self.No-(totalNumber+1)/2-1)*width;
        }
        NSString *name = nil;
        if(names.count > i){
            name = names[i];
        }
        
        TrollChartPoint *point = points[i];
        TrollCATextLayer *textLayer = nil;
        
        if(i >= _textArray.count){
            textLayer = [TrollCATextLayer layer];
            [self addSublayer:textLayer];
            [_textArray addObject:textLayer];
        }else{
            textLayer = [_textArray objectAtIndex:i];
        }
        
        textLayer.name = name;
        textLayer.string = point.title;
        textLayer.fontSize = 9;
        textLayer.foregroundColor = [color CGColor];
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        CGSize size = [textLayer.string boundingRectWithSize:CGSizeMake(MAXFLOAT, CONTENT_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
        if(isFirst){
            textLayer.frame = CGRectMake(point.point.x-size.width/2.0+delXPoint, 0, size.width, size.height);
            isFirst = NO;
        }
        
        CGRect rect = CGRectMake(point.point.x-size.width/2.0+delXPoint, point.point.y-size.height, size.width, size.height);
        CABasicAnimation *textAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
        textAnimation.fromValue = [NSValue valueWithCGRect:textLayer.frame];
        textAnimation.toValue = [NSValue valueWithCGRect:rect];
        textAnimation.duration = 0.5;
        [textLayer addAnimation:textAnimation forKey:nil];
        textLayer.frame = rect;
    }
}

@end

#pragma mark - TrollChartXAxis

@interface TrollChartXAxisView : UIView

@property (nonatomic, strong) NSMutableArray *xTextArray;   //存储X轴值
@property (nonatomic, assign) CGFloat eachWidth;

@end

@implementation TrollChartXAxisView

- (void)DrawXAxis:(NSArray *)xAxis{
    if(_xTextArray == nil){
        _xTextArray = [NSMutableArray array];
        for(NSInteger i=0; i<xAxis.count; i++){
            UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(XAXIS_BLANK_WIDTH+_eachWidth*i, -2, _eachWidth, self.frame.size.height-3)];
            text.numberOfLines = 2;
            text.text = [xAxis objectAtIndex:i];
            text.font = [UIFont systemFontOfSize:11];
            text.textAlignment = NSTextAlignmentCenter;
            [self addSubview:text];
            [_xTextArray addObject:text];
        }
    }else{
        for(NSInteger i=0; i<xAxis.count; i++){
            UILabel * text = [_xTextArray objectAtIndex:i];
            text.text = [xAxis objectAtIndex:i];
            text.font = [UIFont systemFontOfSize:11];
        }
    }
}

@end

#pragma mark - TrollChartYAxis

@interface TrollChartYAxisView : UIView

@property (nonatomic, strong) NSMutableArray *yTextArray;
@property (nonatomic, assign) CGFloat eachHeight;

@end

@implementation TrollChartYAxisView

- (void)DrawYAxis:(NSArray *)yAxis yAxisType:(TrollYAxisDrawingType)type{
    switch (type) {
        case KTrollYAxisDrawingLeft:
        {
            [self DrawYLeftAxis:yAxis];
        }
            break;
        case KTrollYAxisDrawingRight:
        {
            [self DrawYRightAxis:yAxis];
        }
            break;
        default:
            break;
    }
}

- (void)DrawYLeftAxis:(NSArray *)yAxis{
    
    static BOOL isFirst = YES;
    if(isFirst){
        isFirst = NO;
        CAShapeLayer *yLeftAxisLayer = [CAShapeLayer layer];
        yLeftAxisLayer.frame = CGRectMake(YAXIS_WIDTH-1, 0, 1, self.frame.size.height);
        yLeftAxisLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
        yLeftAxisLayer.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(1, 0)];
        [path addLineToPoint:CGPointMake(1, self.frame.size.height)];
        
        yLeftAxisLayer.path = path.CGPath;
        [self.layer addSublayer:yLeftAxisLayer];
    }
    
    CGFloat eachHeight = self.frame.size.height/(yAxis.count-1);
    
    if(_yTextArray == nil){
        _yTextArray = [NSMutableArray array];
        
        for(NSInteger i=0; i<yAxis.count; i++){
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, i*eachHeight-YAXIS_HEIGHT/2.0, YAXIS_WIDTH-3, YAXIS_HEIGHT)];
            text.numberOfLines = 0;
            text.font = [UIFont systemFontOfSize:10];
            text.text = [yAxis objectAtIndex:i];
            text.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:text];
            [_yTextArray addObject:text];
        }
    }else{
        for(NSInteger i=0; i<yAxis.count; i++){
            UILabel *text = [_yTextArray objectAtIndex:i];
            text.text = [yAxis objectAtIndex:i];
        }
    }
}

- (void)DrawYRightAxis:(NSArray *)yAxis{
    
    static BOOL isFirst = YES;
    if (isFirst) {
        isFirst = NO;
        
        CAShapeLayer *yRightAxisLayer = [CAShapeLayer layer];
        yRightAxisLayer.frame = CGRectMake(0, 0, 1, self.frame.size.height);
        yRightAxisLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
        yRightAxisLayer.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
        
        yRightAxisLayer.path = path.CGPath;
        [self.layer addSublayer:yRightAxisLayer];
    }
    
    CGFloat eachHeight = self.frame.size.height/(yAxis.count-1);
    
    if(_yTextArray == nil){
        _yTextArray = [NSMutableArray array];
        
        for(NSInteger i=0; i<yAxis.count; i++){
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(3, i*eachHeight-YAXIS_HEIGHT/2.0, YAXIS_WIDTH-3, YAXIS_HEIGHT)];
            text.numberOfLines = 0;
            text.textAlignment = NSTextAlignmentLeft;
            text.font = [UIFont systemFontOfSize:10];
            text.text = [yAxis objectAtIndex:i];
            [self addSubview:text];
            [_yTextArray addObject:text];
        }
    }else{
        for(NSInteger i=0; i<yAxis.count; i++){
            UILabel *text = [_yTextArray objectAtIndex:i];
            text.text = [yAxis objectAtIndex:i];
        }
    }
}

@end

#pragma mark - TrollChartContentView

@interface TrollChartContentView : UIView

@property (nonatomic, assign) CGFloat eachWidth;
@property (nonatomic, assign) CGFloat histogramWidth;
@property (nonatomic, strong) NSDictionary *xAxis;
@property (nonatomic, assign) CGFloat yLeftAxisMinValue;
@property (nonatomic, assign) CGFloat yLeftAxisMaxValue;
@property (nonatomic, assign) CGFloat yRightAxisMinValue;
@property (nonatomic, assign) CGFloat yRightAxisMaxValue;
@property (nonatomic, assign) NSInteger hasDrawHisogramNumber;
@property (nonatomic, assign) NSInteger histogramNumber;
@property (nonatomic, strong) TrollChartHistogram *histogram;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) NSMutableArray *lineCanBrokenArray;
@property (nonatomic, strong) NSMutableArray *backgroundLinesArray;

@end

@implementation TrollChartContentView

#pragma mark - Show Or Hide Content With Name

- (void)HideContentWithName:(NSString *)name{
    [self.histogram HideHistogramWithName:name];
    
    for(TrollChartLine *line in self.lineArray){
        if([line.name isEqualToString:name]){
            line.hidden = YES;
        }
    }
    
    for(TrollChartLineCanBroken *line in self.lineCanBrokenArray){
        if([line.name isEqualToString:name]){
            line.hidden = YES;
        }
    }
}

- (void)ShowContentWithName:(NSString *)name{
    [self.histogram ShowHistogramWithName:name];
    
    for(TrollChartLine *line in self.lineArray){
        if([line.name isEqualToString:name]){
            line.hidden = NO;
        }
    }
    
    for(TrollChartLineCanBroken *line in self.lineCanBrokenArray){
        if([line.name isEqualToString:name]){
            line.hidden = NO;
        }
    }
}

#pragma mark - Show Or Hide Content With Color

- (void)HideContentWithColor:(CGColorRef)color{
    [self.histogram HideHistogramWithColor:color];
    
    for(TrollChartLine *line in self.lineArray){
        if(CGColorEqualToColor(line.strokeColor, color)){
            line.hidden = YES;
        }
    }
    
    for(TrollChartLineCanBroken *line in self.lineCanBrokenArray){
        if(CGColorEqualToColor(line.strokeColor, color)){
            line.hidden = YES;
        }
    }
}

- (void)ShowContentWithColor:(CGColorRef)color{
    
    [self.histogram ShowHistogramWithColor:color];
    
    for(TrollChartLine *line in self.lineArray){
        if(CGColorEqualToColor(line.strokeColor, color)){
            line.hidden = NO;
        }
    }
    
    for(TrollChartLineCanBroken *line in self.lineCanBrokenArray){
        if(CGColorEqualToColor(line.strokeColor, color)){
            line.hidden = NO;
        }
    }
}

- (void)DrawXAxisLayer{
    static BOOL isFirst = YES;
    if(isFirst){
        isFirst = NO;
        CAShapeLayer *xAxisLayer = [CAShapeLayer layer];
        xAxisLayer.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
        xAxisLayer.fillColor = [UIColor grayColor].CGColor;
        xAxisLayer.strokeColor = [UIColor grayColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 1)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, 1)];
        xAxisLayer.path = path.CGPath;
        [self.layer addSublayer:xAxisLayer];
    }
}

- (void)DrawBackGroundLines:(NSInteger)lines{
    
    if(self.backgroundLinesArray == nil){
        self.backgroundLinesArray = [NSMutableArray array];
    }
    
    for(CAShapeLayer *line in self.backgroundLinesArray){
        [line removeFromSuperlayer];
    }
    
    [self.backgroundLinesArray removeAllObjects];
    
    CAShapeLayer *backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1].CGColor;
    backGroundLayer.strokeColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for(int i=0; i<lines; i++){
        [path moveToPoint:CGPointMake(XAXIS_BLANK_WIDTH+_eachWidth*i+_eachWidth/2, 0)];
        [path addLineToPoint:CGPointMake(XAXIS_BLANK_WIDTH+_eachWidth*i+_eachWidth/2, self.frame.size.height-1)];
    }
    backGroundLayer.path = path.CGPath;
    [self.layer addSublayer:backGroundLayer];
}

- (void)DrawHistogram:(NSArray *)content{
    
    if(content == nil || content.count == 0){
        self.histogram.hidden = YES;
        return;
    }
    
    if(self.histogramWidth == 0){
        self.histogramWidth = HISTOGRAM_DEFAULT_WIDTH;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *contents = [NSMutableArray array];
        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *names = [NSMutableArray array];
        NSMutableArray *textPositions = [NSMutableArray array];
        
        for(NSInteger i=0; i<content.count; i++){
            NSAssert([[content firstObject] isKindOfClass:[NSDictionary class]], @"Histogram content must be NSDictionary class");
            NSDictionary *contentDic = [content objectAtIndex:i];
            NSString *leftOrRight = [contentDic objectForKey:KTrollContentLeftOrRight];
            NSString *numberAfterDot = [contentDic objectForKey:KTrollContentNumberAfterDot];
            NSArray *contentArray = [contentDic objectForKey:KTrollContentValue];
            NSString *name = [contentDic objectForKey:KTrollContentName];
            UIColor *color = [contentDic objectForKey:KTrollContentColor];
            NSString *textPosition = [contentDic objectForKey:KTrollContentTextPosition];
            CGFloat yMinValue, yMaxValue;
            if([leftOrRight isEqualToString:KTrollContentRelativeToLeft]){
                yMinValue = self.yLeftAxisMinValue;
                yMaxValue = self.yLeftAxisMaxValue;
            }else{
                yMinValue = self.yRightAxisMinValue;
                yMaxValue = self.yRightAxisMaxValue;
            }
            
            [colors addObject:color];
            
            if(name){
                [names addObject:name];
            }
            
            if(textPosition){
                [textPositions addObject:textPosition];
            }
            
            for(TrollChartValue *value in contentArray){
                TrollChartPoint *point = [self ConvertToChartPointWithValue:value yMinValue:yMinValue yMaxValue:yMaxValue floatNumbersAfterDot:[numberAfterDot integerValue]];
                [contents addObject:point];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.histogram == nil){
                self.histogram = [TrollChartHistogram layer];
                self.histogram.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                [self.layer addSublayer:self.histogram];
            }
            else{
                self.histogram.hidden = NO;
            }
            self.histogram.zPosition = 1;
            [self.histogram DrawHistogram:contents colors:colors width:self.histogramWidth names:names textPositions:textPositions];
        });
    });
}

//绘制折线图 不可断点
- (void)DrawLine:(NSArray *)contents{
    
    if(contents == nil || contents.count == 0){
        for(TrollChartLine *line in self.lineArray){
            line.hidden = YES;
        }
        return;
    }
    
    if(self.lineArray == nil){
        self.lineArray = [NSMutableArray array];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(NSInteger i=0; i<contents.count; i++){
            NSAssert([[contents firstObject] isKindOfClass:[NSDictionary class]], @"Line content must be NSDictionary class");
            NSDictionary *contentDic = [contents objectAtIndex:i];
            NSString *leftOrRight = [contentDic objectForKey:KTrollContentLeftOrRight];
            NSString *numberAfterDot = [contentDic objectForKey:KTrollContentNumberAfterDot];
            NSArray *contentArray = [contentDic objectForKey:KTrollContentValue];
            NSString *lineWidthString = [contentDic objectForKey:KTrollContentLineWidth];
            NSString *name = [contentDic objectForKey:KTrollContentName];
            NSString *textPosition = [contentDic objectForKey:KTrollContentTextPosition];
            CGFloat lineWidth;
            if(lineWidthString && [lineWidthString floatValue]>0.0f){
                lineWidth = [lineWidthString floatValue];
            }else{
                lineWidth = 1.f;
            }
            UIColor *color = [contentDic objectForKey:KTrollContentColor];
            CGFloat yMinValue, yMaxValue;
            if([leftOrRight isEqualToString:KTrollContentRelativeToLeft]){
                yMinValue = self.yLeftAxisMinValue;
                yMaxValue = self.yLeftAxisMaxValue;
            }else{
                yMinValue = self.yRightAxisMinValue;
                yMaxValue = self.yRightAxisMaxValue;
            }
            
            NSMutableArray *points = [NSMutableArray array];
            
            for(TrollChartValue *value in contentArray){
                TrollChartPoint *point = [self ConvertToChartPointWithValue:value yMinValue:yMinValue yMaxValue:yMaxValue floatNumbersAfterDot:[numberAfterDot integerValue]];
                [points addObject:point];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.lineArray.count >= contents.count){    //已经存在的LineLayer多于或等于要绘制的
                    TrollChartLine *line = self.lineArray[i];
                    line.zPosition = 2;
                    line.hidden = NO;
                    [line DrawLine:points color:color lineWidth:lineWidth name:name textPosition:textPosition iSReuse:YES];
                    for(NSInteger j=contents.count; j<self.lineArray.count; j++){
                        TrollChartLine *line= self.lineArray[j];
                        line.hidden = YES;
                    }
                    
                }else{
                    if(i < self.lineArray.count){   //已经存在LineLayer
                        TrollChartLine *line = self.lineArray[i];
                        line.hidden = NO;
                        line.zPosition = 2;
                        if(self.histogram){
                            line.zPosition = self.histogram.zPosition + 1;
                        }
                        [line DrawLine:points color:color lineWidth:lineWidth name:name textPosition:textPosition iSReuse:YES];
                    }else{
                        TrollChartLine *line = [TrollChartLine layer];
                        line.zPosition = 2;
                        if(self.histogram){
                            line.zPosition = self.histogram.zPosition + 1;
                        }
                        line.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                        [line DrawLine:points color:color lineWidth:lineWidth name:name textPosition:textPosition iSReuse:NO];
                        [self.layer addSublayer:line];
                        [self.lineArray addObject:line];
                    }
                }
            });
        }
    });
}

//绘制折线图 可以断点
- (void)DrawLineCanBroken:(NSArray *)contents{
    if(contents == nil || contents.count == 0){
        for(TrollChartLineCanBroken *line in self.lineCanBrokenArray){
            line.hidden = YES;
            return;
        }
    }
    
    if(self.lineCanBrokenArray == nil){
        self.lineCanBrokenArray = [NSMutableArray array];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(NSInteger i=0; i<contents.count; i++){
            NSAssert([[contents firstObject] isKindOfClass:[NSDictionary class]], @"Line content must be NSDictionary class");
            NSDictionary *contentDic = [contents objectAtIndex:i];
            NSString *leftOrRight = [contentDic objectForKey:KTrollContentLeftOrRight];
            NSString *numberAfterDot = [contentDic objectForKey:KTrollContentNumberAfterDot];
            NSArray *contentArray = [contentDic objectForKey:KTrollContentValue];
            NSString *lineWidthString = [contentDic objectForKey:KTrollContentLineWidth];
            NSString *name = [contentDic objectForKey:KTrollContentName];
            NSString *textPosition = [contentDic objectForKey:KTrollContentTextPosition];
            CGFloat lineWidth;
            if(lineWidthString && [lineWidthString floatValue]>0.0f){
                lineWidth = [lineWidthString floatValue];
            }else{
                lineWidth = 1.f;
            }
            UIColor *color = [contentDic objectForKey:KTrollContentColor];
            CGFloat yMinValue, yMaxValue;
            if([leftOrRight isEqualToString:KTrollContentRelativeToLeft]){
                yMinValue = self.yLeftAxisMinValue;
                yMaxValue = self.yLeftAxisMaxValue;
            }else{
                yMinValue = self.yRightAxisMinValue;
                yMaxValue = self.yRightAxisMaxValue;
            }
            
            NSMutableArray *points = [NSMutableArray array];
            
            for(TrollChartValue *value in contentArray){
                TrollChartPoint *point = [self ConvertToChartPointWithValue:value yMinValue:yMinValue yMaxValue:yMaxValue floatNumbersAfterDot:[numberAfterDot integerValue]];
                [points addObject:point];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.lineCanBrokenArray.count >= contents.count){    //已经存在的LineLayer多于或等于要绘制的
                    TrollChartLineCanBroken *line = self.lineCanBrokenArray[i];
                    line.hidden = NO;
                    line.zPosition = 2;
                    [line DrawLineCanBroken:points color:color lineWidth:lineWidth name:name textPosition:textPosition iSReuse:YES];
                    for(NSInteger j=contents.count; j<self.lineCanBrokenArray.count; j++){
                        TrollChartLineCanBroken *line= self.lineCanBrokenArray[j];
                        line.hidden = YES;
                    }
                    
                }else{
                    if(i < self.lineCanBrokenArray.count){   //已经存在LineLayer
                        TrollChartLineCanBroken *line = self.lineCanBrokenArray[i];
                        line.hidden = NO;
                        line.zPosition = 2;
                        [line DrawLineCanBroken:points color:color lineWidth:lineWidth name:name textPosition:textPosition iSReuse:YES];
                    }else{
                        TrollChartLineCanBroken *line = [TrollChartLineCanBroken layer];
                        line.zPosition = 2;
                        line.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                        [line DrawLineCanBroken:points color:color lineWidth:lineWidth name:name textPosition:textPosition iSReuse:NO];
                        [self.layer addSublayer:line];
                        [self.lineCanBrokenArray addObject:line];
                    }
                }
            });
        }
    });
}

//绘制虚线折线图 不可断点
- (void)DrawDashLine:(NSArray *)points withColor:(UIColor *)color name:(NSString *)name{
    
}

//将value转换成point
- (TrollChartPoint *)ConvertToChartPointWithValue:(TrollChartValue *)value yMinValue:(CGFloat)yMinValue yMaxValue:(CGFloat)yMaxValue floatNumbersAfterDot:(NSInteger)number{
    if(value){
        TrollChartPoint *point = [[TrollChartPoint alloc] init];
        point.iSNull = value.iSNull;
        CGFloat xPoint = [self GetXAxisWithXTitle:value.xValue];
        CGFloat yPoint = (yMaxValue - value.yValue)/(yMaxValue - yMinValue)*self.frame.size.height;
        point.point = CGPointMake(xPoint, yPoint);
        if (value.title == nil) {
            switch (number) {
                case 0:
                {
                    point.title = [NSString stringWithFormat:@"%.0f",value.yValue];
                }
                    break;
                case 1:
                {
                    point.title = [NSString stringWithFormat:@"%.1f",value.yValue];
                }
                    break;
                case 2:
                {
                    point.title = [NSString stringWithFormat:@"%.2f",value.yValue];
                }
                    break;
                default:
                {
                    point.title = [NSString stringWithFormat:@"%.3f",value.yValue];
                }
                    break;
            }
        }else{
            point.title = value.title;
        }
        return point;
    }else{
        return nil;
    }
}

//获取X坐标
- (CGFloat)GetXAxisWithXTitle:(NSString *)xTitle{
    CGFloat xAxisWidth = [[_xAxis objectForKey:xTitle] floatValue];
    return xAxisWidth;
}

@end

#pragma mark - TrollChartBaseView

@interface TrollChartBaseView()<TrollLegendDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) TrollChartLegendView *legendView;
@property (nonatomic, strong) TrollChartXAxisView *xAxisView;
@property (nonatomic, strong) TrollChartYAxisView *yLeftAxisView;
@property (nonatomic, strong) TrollChartYAxisView *yRightAxisView;
@property (nonatomic, strong) TrollChartContentView *contentView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *xAxisScrollView;
@property (nonatomic, strong) UIView *leftRefreshView;
@property (nonatomic, strong) UIView *rightRefreshView;
@property (nonatomic, assign) CGPoint leftRefreshViewOrigin;
@property (nonatomic, assign) CGPoint rightRefreshViewOrigin;
@property (nonatomic, strong) NSMutableDictionary *xAxis;
@property (nonatomic, assign) CGFloat eachWidth;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation TrollChartBaseView

#pragma mark - Property

- (void)setXAxisValues:(NSArray *)xAxisValues{
    if(xAxisValues.count){
        _xAxisValues = xAxisValues;
    }
}

#pragma mark - Init Method

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _legendPosition = KTrollLegendPositionTop;
        _hasLegend = NO;
    }
    
    return self;
}

#pragma mark - Public Method

- (void)finishLeftRefresh{
    
    self.leftRefreshView.frame = CGRectMake(self.leftRefreshViewOrigin.x, self.leftRefreshViewOrigin.y, self.leftRefreshView.frame.size.width, self.leftRefreshView.frame.size.height);
    
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self.leftRefreshView viewWithTag:1000];
    [activity stopAnimating];
    
    UIImageView *imv = (UIImageView *)[self.leftRefreshView viewWithTag:1001];
    imv.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.xAxisScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    
    self.contentScrollView.scrollEnabled = YES;
    self.xAxisScrollView.scrollEnabled = YES;
    self.isLoading = NO;
}

- (void)finishRightRefresh{
    self.rightRefreshView.frame = CGRectMake(self.rightRefreshViewOrigin.x, self.rightRefreshViewOrigin.y, self.rightRefreshView.frame.size.width, self.rightRefreshView.frame.size.height);
    
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self.rightRefreshView viewWithTag:2000];
    [activity stopAnimating];
    
    UIImageView *imv = (UIImageView *)[self.rightRefreshView viewWithTag:2001];
    imv.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.xAxisScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    
    self.contentScrollView.scrollEnabled = YES;
    self.xAxisScrollView.scrollEnabled = YES;
    self.isLoading = NO;
}

- (void)ReloadChartView{
    
    if(_hasLegend){
        
        NSAssert((self.legendArray.count == self.lineCanBrokenContentArray.count + self.lineContentArray.count + self.dashLineContentArray.count + self.histogramContentArray.count), @"TrollLegend's count must be equal to contents'");
        
        [self DrawLegend:self.legendArray];
    }
    
    [self DrawXAxis:self.xAxisValues YLeftAxis:self.yLeftAxisValues YRightAxis:self.yRightAxisValues];
    [self DrawHistogram:self.histogramContentArray];
    [self DrawLine:self.lineContentArray];
    [self DrawDashLine:self.dashLineContentArray];
    [self DrawLineCanBroken:self.lineCanBrokenContentArray];
    [self ResetContentArray];
}

#pragma mark - Private Method

- (void)ResetContentArray{
    self.histogramContentArray = nil;
    self.lineContentArray = nil;
    self.dashLineContentArray = nil;
    self.lineCanBrokenContentArray = nil;
}

- (void)ConvertXAxisValuesToXAxis{
    if(!_xAxis){
        _xAxis = [NSMutableDictionary dictionary];
    }
    
    for(NSInteger i=0; i<_xAxisValues.count; i++){
        CGFloat xPoint = XAXIS_BLANK_WIDTH + i*_eachWidth + _eachWidth/2.0;
        [_xAxis setObject:[NSNumber numberWithFloat:xPoint] forKey:[_xAxisValues objectAtIndex:i]];
    }
}

- (void)DrawHistogram:(NSArray *)content{
    [self.contentView DrawHistogram:content];
}

- (void)DrawLine:(NSArray *)content{
    [self.contentView DrawLine:content];
}

- (void)DrawDashLine:(NSArray *)content{

}

- (void)DrawLineCanBroken:(NSArray *)content{
    [self.contentView DrawLineCanBroken:content];
}

- (void)DrawLegend:(NSArray *)contents{
    if(_legendView == nil){
        CGRect rect;
        switch (_legendPosition) {
            case KTrollLegendPositionTop:
            {
                rect = CGRectMake(0, 0, self.frame.size.width, LEGEND_HEIGHT);
            }
                break;
            case KTrollLegendPositionBottom:
            {
                rect = CGRectMake(0, self.frame.size.height-LEGEND_HEIGHT, self.frame.size.width, LEGEND_HEIGHT);
            }
                break;
            default:
                break;
        }
        
        _legendView = [[TrollChartLegendView alloc] initWithFrame:rect];
        _legendView.delegate = self;
        [self addSubview:_legendView];
    }
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *styles = [NSMutableArray array];
    NSMutableArray *names  = [NSMutableArray array];
    for(NSDictionary *contentDic in contents){
        NSString *title = [contentDic objectForKey:KTrollLegendTitle];
        [titles addObject:title];
        UIColor *color = [contentDic objectForKey:KTrollLegendColor];
        [colors addObject:color];
        NSString *style = [contentDic objectForKey:KTrollLegendStyle];
        [styles addObject:style];
        NSString *name = [contentDic objectForKey:KTrollContentName];
        if(name){
            [names addObject:name];
        }
    }
    
    [_legendView DrawLegendWithTitle:titles Color:colors Style:styles Names:names];
    self.legendArray = nil;
}

- (void)DrawXAxis:(NSArray *)xAxis YLeftAxis:(NSArray *)yLeftAxis YRightAxis:(NSArray *)yRightAxis{
    
    NSAssert(xAxis && xAxis.count, @"X axis can't be nil");
    
    CGFloat yLeftAxisWidth = 0.f, yRightAxisWidth = 0.f;
    
    BOOL hasRight = NO;
    BOOL hasLeft = NO;

    if(yRightAxis && yRightAxis.count){
        hasRight = YES;
        yRightAxisWidth = YAXIS_WIDTH;
    }
    
    if(yLeftAxis && yLeftAxis.count){
        hasLeft = YES;
        yLeftAxisWidth = YAXIS_WIDTH;
    }
    
    CGFloat height = 0;
    CGFloat yStart = 0;
    CGFloat xAxisYStart = 0;
    
    if (_hasLegend) {
        switch (_legendPosition) {
            case KTrollLegendPositionTop:
            {
                height = self.frame.size.height - LEGEND_HEIGHT - XAXIS_HEIGHT ;
                yStart = LEGEND_HEIGHT;
                xAxisYStart = self.frame.size.height - XAXIS_HEIGHT;
            }
                break;
            case KTrollLegendPositionBottom:
            {
                height = self.frame.size.height - LEGEND_HEIGHT - XAXIS_HEIGHT ;
                yStart = 0;
                xAxisYStart = self.frame.size.height - XAXIS_HEIGHT - LEGEND_HEIGHT;
            }
                break;
            default:
                break;
        }
    }else{
        height = self.frame.size.height - XAXIS_HEIGHT;
        yStart = 0;
    }
    
    if(_leftRefreshView == nil){
        _leftRefreshView = [[UIView alloc] initWithFrame:CGRectMake(-self.frame.size.width+yLeftAxisWidth, yStart, self.frame.size.width, height)];
        _leftRefreshView.backgroundColor = [UIColor blackColor];
        _leftRefreshView.alpha = 0.4;
        _leftRefreshViewOrigin = _leftRefreshView.frame.origin;
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.tag = 1000;
        activity.frame = CGRectMake(_leftRefreshView.frame.size.width-60, (_leftRefreshView.frame.size.height-activity.frame.size.height)/2, activity.frame.size.width, activity.frame.size.height);
        [_leftRefreshView addSubview:activity];
        [self addSubview:_leftRefreshView];
        
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(_leftRefreshView.frame.size.width-90, (_leftRefreshView.frame.size.height-30)/2, 80, 30)];
        imv.image = [UIImage imageNamed:@"arrow.png"];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        imv.tag = 1001;
        [_leftRefreshView addSubview:imv];
    }
    
    if(_rightRefreshView == nil){
        _rightRefreshView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-yLeftAxisWidth, yStart, self.frame.size.width, height)];
        _rightRefreshView.backgroundColor = [UIColor blackColor];
        _rightRefreshView.alpha = 0.4;
        _rightRefreshViewOrigin = _rightRefreshView.frame.origin;
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.tag = 2000;
        activity.frame = CGRectMake(20, (_rightRefreshView.frame.size.height-activity.frame.size.height)/2, activity.frame.size.width, activity.frame.size.height);
        [_rightRefreshView addSubview:activity];
        [self addSubview:_rightRefreshView];
        
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_leftRefreshView.frame.size.height-30)/2, 80, 30)];
        imv.image = [UIImage imageNamed:@"arrow.png"];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        imv.transform = CGAffineTransformMakeRotation(M_PI);
        imv.tag = 2001;
        [_rightRefreshView addSubview:imv];
    }
    
    if(hasRight){
        if(_yRightAxisView == nil){
            _yRightAxisView = [[TrollChartYAxisView alloc] initWithFrame:CGRectMake(self.frame.size.width-YAXIS_WIDTH, yStart, YAXIS_WIDTH, height)];
            _yRightAxisView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_yRightAxisView];
        }
        [_yRightAxisView DrawYAxis:yRightAxis yAxisType:KTrollYAxisDrawingRight];
    }
    
    if(hasLeft){
        if(_yLeftAxisView == nil){
            _yLeftAxisView = [[TrollChartYAxisView alloc] initWithFrame:CGRectMake(0, yStart, YAXIS_WIDTH, height)];
            _yLeftAxisView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_yLeftAxisView];
        }
        [_yLeftAxisView DrawYAxis:yLeftAxis yAxisType:KTrollYAxisDrawingLeft];
    }
    
    CGFloat xAxisWholeLength = self.frame.size.width-yLeftAxisWidth-yRightAxisWidth;
    CGFloat eachWidth = (xAxisWholeLength - 2*XAXIS_BLANK_WIDTH)/(xAxis.count);
    self.eachWidth = eachWidth;
    [self ConvertXAxisValuesToXAxis];
    
    if(_contentView == nil){
        
        _contentView = [[TrollChartContentView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-yLeftAxisWidth-yRightAxisWidth, height)];
    }
    
    _contentView.eachWidth = eachWidth;
    _contentView.xAxis = self.xAxis;
    _contentView.yLeftAxisMaxValue = self.yLeftAxisMaxValue;
    _contentView.yLeftAxisMinValue = self.yLeftAxisMinValue;
    _contentView.yRightAxisMaxValue = self.yRightAxisMaxValue;
    _contentView.yRightAxisMinValue = self.yRightAxisMinValue;
    
    [_contentView DrawXAxisLayer];
    [_contentView DrawBackGroundLines:xAxis.count];
    
    if(_contentScrollView == nil){
        
        CAShapeLayer *backLayer = [CAShapeLayer layer];
        backLayer.frame = CGRectMake(yLeftAxisWidth, yStart+height, self.frame.size.width-yLeftAxisWidth-yRightAxisWidth, 1);
        backLayer.strokeColor = [UIColor grayColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(backLayer.frame.size.width, 0)];
        backLayer.path = path.CGPath;
        [self.layer addSublayer:backLayer];
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(yLeftAxisWidth, yStart, self.frame.size.width-yLeftAxisWidth-yRightAxisWidth, height)];
        _contentScrollView.contentSize = CGSizeMake(_contentView.frame.size.width+1, _contentView.frame.size.height);
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        [_contentScrollView addSubview:_contentView];
        [self addSubview:_contentScrollView];
    }
    
    if(xAxis){
        if(!_xAxisView){
            _xAxisView = [[TrollChartXAxisView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-yLeftAxisWidth-yRightAxisWidth, XAXIS_HEIGHT)];
            _xAxisView.eachWidth = eachWidth;
        }
        
        [_xAxisView DrawXAxis:xAxis];
        
        if(!_xAxisScrollView){
            _xAxisScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(yLeftAxisWidth, xAxisYStart, self.frame.size.width-yLeftAxisWidth-yRightAxisWidth, XAXIS_HEIGHT)];
            _xAxisScrollView.contentSize = CGSizeMake(_xAxisView.frame.size.width+1, _xAxisView.frame.size.height);
            _xAxisScrollView.showsHorizontalScrollIndicator = NO;
            _xAxisScrollView.delegate = self;
            [_xAxisScrollView addSubview:_xAxisView];
            [self addSubview:_xAxisScrollView];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:self.contentScrollView]){
        self.xAxisScrollView.contentOffset = self.contentScrollView.contentOffset;
    }else if([scrollView isEqual:self.xAxisScrollView]){
        self.contentScrollView.contentOffset = self.xAxisScrollView.contentOffset;
    }
    
    if(self.isLoading == NO){
        if(scrollView.contentOffset.x < 0){
            _leftRefreshView.frame = CGRectMake(_leftRefreshViewOrigin.x-scrollView.contentOffset.x, _leftRefreshViewOrigin.y, _leftRefreshView.frame.size.width, _leftRefreshView.frame.size.height);
        }else if (scrollView.contentOffset.x > 0){
            _rightRefreshView.frame = CGRectMake(_rightRefreshViewOrigin.x-scrollView.contentOffset.x, _rightRefreshViewOrigin.y, _rightRefreshView.frame.size.width, _rightRefreshView.frame.size.height);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.contentOffset.x < -70){
        self.isLoading = YES;
        self.contentScrollView.scrollEnabled = NO;
        self.xAxisScrollView.scrollEnabled = NO;
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[_leftRefreshView viewWithTag:1000];
        [activity startAnimating];
        
        UIImageView *imv = (UIImageView *)[_leftRefreshView viewWithTag:1001];
        imv.hidden = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(0, 80, 0, 0);
        }];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(TrollChartBaseView:DidBeginRefreshingWithDirection:)]){
            [self.delegate TrollChartBaseView:self DidBeginRefreshingWithDirection:KTrollRefreshDirectionLeft];
        }
    }else if(scrollView.contentOffset.x > 70){
        self.isLoading = YES;
        self.contentScrollView.scrollEnabled = NO;
        self.xAxisScrollView.scrollEnabled = NO;
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[_rightRefreshView viewWithTag:2000];
        [activity startAnimating];
        
        UIImageView *imv = (UIImageView *)[_rightRefreshView viewWithTag:2001];
        imv.hidden = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 80);
        }];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(TrollChartBaseView:DidBeginRefreshingWithDirection:)]){
            [self.delegate TrollChartBaseView:self DidBeginRefreshingWithDirection:KTrollRefreshDirectionRight];
        }
    }
}

#pragma mark - TrollLegendDelegate

- (void)TrollLegendTapOnLayer:(TrollCAShapeLayer *)layer{
    
    switch (self.contentShowOrHideDependOnType) {
        case KTrollContentShowOrHideDependOnColor:
        {
            if(CGColorEqualToColor(layer.fillColor, [[UIColor whiteColor] CGColor])){
                [self.contentView ShowContentWithColor:layer.strokeColor];
            }else if (CGColorEqualToColor(layer.fillColor, [[UIColor lightGrayColor] CGColor])){
                [self.contentView HideContentWithColor:layer.strokeColor];
            }
        }
            break;
        case KTrollContentShowOrHideDependOnName:
        {
            if(CGColorEqualToColor(layer.fillColor, [[UIColor whiteColor] CGColor])){
                [self.contentView ShowContentWithName:layer.name];
            }else if (CGColorEqualToColor(layer.fillColor, [[UIColor lightGrayColor] CGColor])){
                [self.contentView HideContentWithName:layer.name];
            }
        }
            break;
        default:
            break;
    }
}

@end
