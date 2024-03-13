

#import "UIImage+Addition.h"
//#import "UIImage+fixOrientation.h"

@implementation UIImage (Addition)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

/** 渲染图片颜色的对象方法 */
- (UIImage *)imageWithColor:(UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 二维码生成

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    
    return [[self alloc] createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    
    if (waterImagesize) {
        //logo图
        UIImage * waterimage = [UIImage imageNamed:@"weixin_icon_shipper_108"];
        //    把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
        [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    }
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRelease(scaledImage);
    
    return newPic;
}
/** 生成渐变图片 */
+ (UIImage*)bgImageFromColors:(NSArray*)colors
                    withFrame:(CGRect)frame
                directionType:(GradientDirectionType)directionType
{
    
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        
        [ar addObject:(id)c.CGColor];
        
    }
    
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    CGPoint start;
    
    CGPoint end ;
    
    start = CGPointMake(0.0, 0.0);
    
    switch (directionType) {
        case GradientDirectionTypeUprightToLowleft:
        {
            end = CGPointMake(0.0, frame.size.height);
            
            start = CGPointMake(frame.size.width, 0.0);
            
        }
            break;
            
        case GradientDirectionTypeLeftToRight:
        {
            end = CGPointMake(frame.size.width, 0);
            
        }
            break;
            
        case GradientDirectionTypeUpleftToLowright:
        {
            end = CGPointMake(frame.size.width, frame.size.height);
            
        }
            break;
        default:
        {
            end = CGPointMake(0.0, frame.size.height);
            
        }
            break;
    }
    
    
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
    
    UIGraphicsEndImageContext();
    
//    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return image;
    
}
+ (UIImage *)scaleImage:(UIImage *)origin width:(CGFloat)width {
    
    CGFloat imgH = origin.size.height;
    
    CGFloat imgW = origin.size.width;
    
    CGFloat height;
    
    if (imgW > width) {
    
        height = width / imgW * imgH;
        
    }else{

        return origin;
    }

    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    [origin drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/** 生成圆角UIIamge 的方法 */
- (UIImage *)imageWithRoundedCornersSize:(CGFloat)cornerRadius {
    
    UIImage *original = self;
    
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
    // 添加圆角
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // 绘制图片
    [original drawInRect:frame];
    // 接受绘制成功的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 压缩图片到指定尺寸 */
+ (UIImage*)scaleImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    
    NSLog(@"orgi  %.3f kb",data.length / 1024.0);
    
    CGSize imageSize = image.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height) {
        
        return image;
        
    }
    
    if (width == 0 || height == 0) {
        
        return image;
        
    }
    
    CGFloat widthFactor = newSize.width / width;
    
    CGFloat heightFactor = newSize.height / height;
    
    CGFloat scaleFactor = (widthFactor > heightFactor) ? (widthFactor) : (heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    
    CGFloat scaledHeight = height * scaleFactor;
    
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 裁剪图片到指定尺寸 */
- (UIImage *)cutUpImageSize:(CGRect)frame scale:(CGFloat)scale {
    
    //    UIImage * img = [self fixOrientation];
    
    //    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (!scale) scale = 1;
    
    frame.origin.x *= scale;
    
    frame.origin.y *= scale;
    
    frame.size.width *= scale;
    
    frame.size.height *= scale;
    
    //裁剪区域在原始图片上的位置
    CGRect myImageRect = frame;
    
    //裁剪图片
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(myImageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//返回裁剪区域图片
- (UIImage*)clicpViewWithRect:(CGRect)aRect {
    //arect 想要截图的区域
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    aRect.origin.x*= scale;
    
    aRect.origin.y*= scale;
    
    aRect.size.width*= scale;
    
    aRect.size.height*= scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), YES, scale);
    
    //    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    //转化为位图
    CGImageRef imageRef = viewImage.CGImage;
    //根据范围截图
    imageRef = CGImageCreateWithImageInRect(imageRef, aRect);
    //得到新的图片
    UIImage*sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef) ;
    
    return sendImage;
    
}



+ (UIImage *)arrowImageWithRotation:(UIImageOrientation)orientation{

    UIImage *image = [UIImage imageNamed:@"arrow_right"];
    
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    newPic = [UIImage scaleImage:newPic scaledToSize:CGSizeMake(40, 30)];
    
    return newPic;

}

#pragma mark - IOS中两张图片合成为一张图片的方法
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 orgin:(CGPoint)orgin
{
    UIGraphicsBeginImageContext(image2.size);
    
    //Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    //Draw image1
    [image1 drawInRect:CGRectMake(orgin.x, orgin.y, image1.size.width, image1.size.height)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
