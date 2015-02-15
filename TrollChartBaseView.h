//
//  TrollCharBaseView.h
//  TrollExpandTableViewDemo
//
//  Created by user on 15/2/9.
//  Copyright (c) 2015年 ways. All rights reserved.
//


/*
 使用须知:
    该控件提供两种方式来控制显示/隐藏图表内容
    1、依据图例和图标内容的颜色;
        这种条件下，务必要保证图例和图标内容的颜色一致，而且颜色不能有重复的;
    2、依据数据内容标识来控制显示/隐藏图标内容
        这种条件下，在设定图表内容和图例内容时一定要通过设定KTrollContentName和KTrollLegendName,并且两者要一致
 */

#import <UIKit/UIKit.h>

static NSString * const KTrollContentValue = @"ContentValue";

/*
    属性可设置的内容
 */
static NSString * const KTrollContentStyle = @"ContentStyle";
static NSString * const KTrollContentLeftOrRight = @"ContentLeftOrRight";
static NSString * const KTrollContentNumberAfterDot = @"ContentNumberAfterDot";
static NSString * const KTrollContentColor = @"ContentColor";
static NSString * const KTrollContentName = @"ContentName";
static NSString * const KTrollContentLineWidth = @"ContentLineWidth";
static NSString * const KTrollContentTextPosition = @"ContentTextPosition";

/*
    TextPosition
 */
static NSString * const KTrollContentTextPositionAboveContent = @"Above";
static NSString * const KTrollContentTextPositionBelowContent = @"Below";

/*
    Style 可设置的内容
 */
static NSString * const KTrollContentStyleHistogram = @"Histogram";
static NSString * const KTrollContentStyleLine = @"Line";
static NSString * const KTrollContentStyleDashLine = @"DashLine";
static NSString * const KTrollContentStyleLineCanBroken = @"LineCanBroken";

/*
    相对于左还是右Y轴
 */
static NSString * const KTrollContentRelativeToLeft = @"RelativeToLeft";
static NSString * const KTrollContentRelativeToRight = @"RelativeToRight";

/*
    小数点后位数
 */
static NSString * const KTrollContentNumberAfterDotZero = @"0";
static NSString * const KTrollContentNumberAfterDotOne = @"1";
static NSString * const KTrollContentNumberAfterDotTwo = @"2";
static NSString * const KTrollContentNumberAfterDotThree = @"3";

/*
    图例
 */
static NSString * const KTrollLegendStyle = @"LegendStyle";
static NSString * const KTrollLegendTitle = @"LegendTitle";
static NSString * const KTrollLegendColor = @"LegendColor";
static NSString * const KTrollLegendName  = @"LegendName";

/*
    图例样式
 */

static NSString * const KTrollLegendLineCircleStyle = @"LegendCircle";
static NSString * const KTrollLegendLineRectStyle = @"LegendRect";
static NSString * const KTrollLegendCircleStyle = @"LegendCircle";
static NSString * const KTrollLegendRectStyle = @"LegendRect";

typedef NS_ENUM(NSInteger, TrollLegendPosition) {
    KTrollLegendPositionTop = 2 << 1,
    KTrollLegendPositionBottom = 2 << 2
};

typedef NS_ENUM(NSInteger, TrollContentShowOrHideDependOnType) {
    KTrollContentShowOrHideDependOnName = 3 << 1,
    KTrollContentShowOrHideDependOnColor = 3 << 2
};

typedef NS_ENUM(NSInteger, TrollRefreshDirection) {
    KTrollRefreshDirectionLeft = 4 << 1,
    KTrollRefreshDirectionRight = 4 << 2
};

#pragma mark - TrollChartRefreshDelegate

@class TrollChartBaseView;

@protocol TrollChartRefreshDelegate <NSObject>

@optional
- (void)TrollChartBaseView:(TrollChartBaseView *)baseView DidBeginRefreshingWithDirection:(TrollRefreshDirection)direction;

@end

#pragma mark - TrollChartBaseView

@interface TrollChartBaseView : UIView

@property (nonatomic, assign) id<TrollChartRefreshDelegate>delegate;
@property (nonatomic, assign) TrollContentShowOrHideDependOnType contentShowOrHideDependOnType;
@property (nonatomic, assign) TrollLegendPosition legendPosition;
@property (nonatomic, assign) BOOL hasLegend;
@property (nonatomic, assign) BOOL showYAxis;
@property (nonatomic, assign) CGFloat eachHeight;
@property (nonatomic, strong) NSArray *xAxisValues;
@property (nonatomic, strong) NSArray *yLeftAxisValues;
@property (nonatomic, strong) NSArray *yRightAxisValues;
@property (nonatomic, assign) CGFloat histogramWidth;
@property (nonatomic, assign) CGFloat yLeftAxisMaxValue;
@property (nonatomic, assign) CGFloat yLeftAxisMinValue;
@property (nonatomic, assign) CGFloat yRightAxisMaxValue;
@property (nonatomic, assign) CGFloat yRightAxisMinValue;
@property (nonatomic, strong) NSArray *legendArray;
@property (nonatomic, strong) NSArray *histogramContentArray;
@property (nonatomic, strong) NSArray *lineContentArray;
@property (nonatomic, strong) NSArray *dashLineContentArray;
@property (nonatomic, strong) NSArray *lineCanBrokenContentArray;


- (void)ReloadChartView;

- (void)DrawXAxis:(NSArray *)xAxis YLeftAxis:(NSArray *)yLeftAxis YRightAxis:(NSArray *)yRightAxis;

- (void)finishLeftRefresh;
- (void)finishRightRefresh;

@end

#pragma mark - TrollChartValue

@interface TrollChartValue : NSObject

@property (nonatomic, strong) NSString *xValue;
@property (nonatomic, assign) CGFloat yValue;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL iSNull;

@end


