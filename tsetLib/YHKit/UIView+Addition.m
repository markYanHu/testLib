

#import "UIView+Addition.h"
#import <objc/runtime.h>

//static NSString * kObserve = @"isObserveFrame";
//static NSString * kRadius = @"radius";


@implementation UIView (Addtions)


//@dynamic isObserveFrame;
//@dynamic radius;

- (instancetype)roundCornersOnTopLeft:(BOOL)tl
                             topRight:(BOOL)tr
                           bottomLeft:(BOOL)bl
                          bottomRight:(BOOL)br
                               radius:(float)radius
{
    self.clipsToBounds = YES;
    //    if (tl || tr || bl || br) {
    UIRectCorner corner = 0;     //holds the corner
    //Determine which corner(s) should be changed
    if (tl) {
        corner = UIRectCornerTopLeft;
    }
    if (tr) {
        UIRectCorner add = corner | UIRectCornerTopRight;
        corner = add;
    }
    if (bl) {
        UIRectCorner add = corner | UIRectCornerBottomLeft;
        corner = add;
    }
    if (br) {
        UIRectCorner add = corner | UIRectCornerBottomRight;
        corner = add;
    }
    
    UIView *roundedView = self;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = roundedView.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    roundedView.layer.mask = maskLayer;
    
    return roundedView;
    //    } else {
    //        return self;
    //    }
}

- (instancetype)roundCornersAll:(CGFloat)radius {
    
    self.cornerR = radius;
        
    [self settingroundCorners];
/*
    if (self.bounds.size.height && self.bounds.size.width) {

        [self settingroundCorners];

    }else{
        
        self.isObserveFrame = YES;

        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        LFLog(@"isObserveFrame --- %d",self.isObserveFrame);

    }*/
    
    return self;
}


/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"bounds"]) {
        
        [self settingroundCorners];
    }
}
- (void)dealloc {
    
    if (self.isObserveFrame) {
        
        [self removeObserver:self forKeyPath:@"bounds"];
        
    }
    
}*/


- (void)settingroundCorners {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.cornerR, self.cornerR)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
}





///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView *child in self.subviews) {
        UIView *it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

////////////////
- (UIImage *)imageByRenderingView {
    
    CGSize size = self.bounds.size;
    //size.width = size.width/2;
    //size.height = size.height/2;
    
    UIGraphicsBeginImageContext(size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}



/** 设置渐变背景 */
- (void)addGradientLayer:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
              startColor:(UIColor *)startColor
                endColor:(UIColor *)endColor
                   frame:(CGRect)frame
{
    
    //设置渐变背景
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    
    BOOL isEqual =  CGRectEqualToRect(frame, CGRectZero);
    
    frame = isEqual ? self.frame : frame ;
    
    gradientLayer.frame = frame;
    //    [self.headerBGView.layer addSublayer:gradientLayer];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    //    [self.layer replaceSublayer:[self.layer.sublayers firstObject] with:gradientLayer];
    
    //设置渐变方向
    gradientLayer.startPoint = startPoint;
    
    gradientLayer.endPoint = endPoint;
    //设置渐变颜色
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    
}

- (void)dashedLineLength:(CGFloat)lineL
                   space:(CGFloat)space
                   width:(CGFloat)width
            cornerRadius:(CGFloat)cornerRadius
               lineColor:(UIColor *)lineColor
{
    
    lineL = lineL ? lineL : 4;
    
    space = space ? space : 2;
    
    width = width ? width : 1.0f;
    
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = lineColor.CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    
    //设置路径
    border.path = path.CGPath;
    
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = width;
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@(lineL), @(space)];
    
    if (cornerRadius) {
        
        self.layer.cornerRadius = cornerRadius;
        
        self.layer.masksToBounds = YES;
    }
    
    [self.layer addSublayer:border];
    
}

#pragma mark - setter && getter

- (void)setCornerR:(CGFloat)cornerR {
    
    objc_setAssociatedObject(self, @selector(cornerR),@(cornerR), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)cornerR {
    
    NSNumber * num = objc_getAssociatedObject(self, @selector(cornerR));
    
    return [num floatValue];
}

- (void)setIsObserveFrame:(BOOL)isObserveFrame {
    
    objc_setAssociatedObject(self, @selector(isObserveFrame),@(isObserveFrame), OBJC_ASSOCIATION_ASSIGN);
    
}

- (BOOL)isObserveFrame {
    
    return objc_getAssociatedObject(self, @selector(isObserveFrame));
    
}


//隐藏多余cell
+ (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - 获取当前屏幕显示的viewcontroller
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [[self class] getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    
    UIViewController * currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [[self class] getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [[self class] getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
    
}

@end
