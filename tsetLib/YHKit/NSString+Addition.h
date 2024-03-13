

#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGSize)sizeWithFont:(UIFont *_Nullable)font maxWidth:(CGFloat)width maxNumberLines:(int)num;


#pragma mark 首字母变小写
/**  首字母变小写 */
+ (NSString *_Nullable)lowercaseFristString:(NSString *_Nullable)str;

/**  首字母变大写 */
+ (NSString *_Nullable)uppercaseStringFristString:(NSString *_Nullable)str;

    /**  通过字符串 获取set方法 */
+ (SEL _Nullable )setSelector:(NSString *_Nullable)str;

 /**  格式化成金额字符串  */
+ (NSString *_Nullable)formaterMoneyString:(NSString *_Nullable)moneyStr ;

/**  格式化成金额字符串  */
+ (NSString *_Nullable)formaterMoneyFloat:(double)money ;

/**  格式化成金额字符串  */
+ (NSString *_Nullable)formaterMoneyDecimal:(NSDecimalNumber *_Nullable)moneyDeci ;

/**
 格式化成金额字符串

 @param moneyNum 金额（单位：分）
 @param isHasPrefix 是否展示人民币符号¥
 @return 格式化后的字符串
 */
+ (NSString *_Nullable)formaterMoneyNumber:(NSInteger)moneyNum isHasPrefix:(BOOL)isHasPrefix ;


/**
 数组格式化成json字符串
 
 @param array 数组
 @return 结果字符串
 */
+ (NSString *_Nullable)_NullablearrayToJSONString:(NSArray *_Nullable)array ;

/**  对象格式化成json  */
+ (NSString *_Nullable)formaterToJSONString:(id _Nullable )obj  ;

/**过滤html标签 */
+ (NSString *_Nullable)removeHTML:(NSString *_Nullable)html;

+ (NSMutableString *_Nullable)webImageFitToDeviceSize:(NSMutableString *_Nullable)strContent;


/**
 格式化银行卡

 @param bankCard 真实银行卡号
 @return 格式化后的银行卡
 */
+ (NSString *_Nullable)formaterBankCardNo:(NSString * _Nonnull)bankCard ;
    
@end
