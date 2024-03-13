

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientDirectionType) {
    
    GradientDirectionTypeTopToBottom = 0,//从上到下
    
    GradientDirectionTypeLeftToRight = 1,//从左到右
    
    GradientDirectionTypeUpleftToLowright = 2,//左上到右下
    
    GradientDirectionTypeUprightToLowleft = 3,//右上到左下
    
};

@interface UIImage (Addition)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/** 渲染图片颜色的对象方法 */
- (UIImage *)imageWithColor:(UIColor *)color;

/** 生成二维码图片 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize ;

/**
 生成渐变图片
 
 @param colors 起始颜色
 @param frame 图片的大小
 @param directionType 渐变方向
 @return 生成的图片
 */
+ (UIImage*)bgImageFromColors:(NSArray*)colors
                    withFrame:(CGRect)frame
                directionType:(GradientDirectionType)directionType ;

+ (UIImage *)scaleImage:(UIImage *)origin width:(CGFloat)width ;

/** 生成圆角UIImage 的方法 */
- (UIImage *)imageWithRoundedCornersSize:(CGFloat)cornerRadius ;

/** 压缩图片到指定尺寸 */
+ (UIImage*)scaleImage:(UIImage*)image scaledToSize:(CGSize)newSize ;

/** 裁剪图片到指定尺寸 */
- (UIImage *)cutUpImageSize:(CGRect)frame scale:(CGFloat)scale ;

/** 裁剪图片到指定尺寸 */
- (UIImage*)clicpViewWithRect:(CGRect)aRect ;

+ (UIImage *)arrowImageWithRotation:(UIImageOrientation)orientation;

#pragma mark - IOS中两张图片合成为一张图片的方法
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 orgin:(CGPoint)orgin ;

@end


