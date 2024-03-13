

#import <Foundation/Foundation.h>

@interface NSAttributedString (SYAttributedString)
/**
 字符串数组转化成属性字符串

 @param strings 只能放字符串或图片的数组
 @param attrs 只能放字符串或图片的数组
 @param connectString 连接字符串，如\n，空格等
 @param lineSpacing  行间距
 @return 返回结果字符串

+ (NSAttributedString *)changeAttributedStringFromStrings:(NSArray<NSString *> *)strings addAttributes:(NSArray <NSDictionary<NSString *, id> *> *)attrs connectString:(NSString *)connectString lineSpacing:(CGFloat)lineSpacing; */


/**
 字符串数组或者图片转化成属性字符串  不同的链接字符

 @param strings 只能放字符串或图片的数组
 @param attrs 只能放字符串或图片的数组
 @param connectStringArr  连接字符串，如\n，空格等
 @param lineSpacing  行间距
 @return 返回结果字符串
 */
+ (NSAttributedString *)changeAttributedStringFromStrings:(NSArray *)strings
                                            addAttributes:(NSArray <NSDictionary<NSString *, id> *> *)attrs connectStringArray:(NSArray <NSString *> *)connectStringArr
                                              lineSpacing:(CGFloat)lineSpacing;

@end
