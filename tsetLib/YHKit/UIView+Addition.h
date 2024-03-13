

#import <UIKit/UIKit.h>

//IB_DESIGNABLE

@interface UIView (Addtions)



/** 是否需要观察frame变化 */
@property (nonatomic,assign) BOOL isObserveFrame;
/** 圆角半径 */
@property (nonatomic,assign) CGFloat  cornerR;


/**
 给视图添加圆角
 
 @param tl 左上角
 @param tr 右上角
 @param bl 左下角
 @param br 右下角
 @param radius 圆角半径
 @return 添加之后的视图
 */
- (instancetype)roundCornersOnTopLeft:(BOOL)tl
                             topRight:(BOOL)tr
                           bottomLeft:(BOOL)bl
                          bottomRight:(BOOL)br
                               radius:(float)radius;

/**
 给视图添加4个圆角
 
 @param radius 圆角半径
 @return 添加之后的视图
 */
- (instancetype)roundCornersAll:(CGFloat)radius;

- (UIView *)descendantOrSelfWithClass:(Class)cls;

- (UIView *)ancestorOrSelfWithClass:(Class)cls;

/**
 移除所有子视图
 */
- (void)removeAllSubviews;

- (UIImage *)imageByRenderingView;

/**
 设置渐变背景
 
 @param startPoint 起始点（如0，0）
 @param endPoint 终点（如1，0）
 @param startColor 颜色范围-开始颜色
 @param endColor 颜色范围-结束颜色
 */
- (void)addGradientLayer:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
              startColor:(UIColor *)startColor
                endColor:(UIColor *)endColor
                   frame:(CGRect)frame;

/**
 设置虚线边框
 
 @param lineL 实线长度
 @param space 间隙长度
 @param width 线宽
 @param cornerRadius 圆角半径
 @param lineColor 虚线颜色
 */
- (void)dashedLineLength:(CGFloat)lineL
                   space:(CGFloat)space
                   width:(CGFloat)width
            cornerRadius:(CGFloat)cornerRadius
               lineColor:(UIColor *)lineColor ;

//隐藏多余cell
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

/** 获取当前屏幕显示的viewcontroller */
+ (UIViewController *)getCurrentVC ;

@end
