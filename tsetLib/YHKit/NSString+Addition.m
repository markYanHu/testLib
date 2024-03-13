

#import "NSString+Addition.h"

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width maxNumberLines:(int)num {
    
    CGSize size = CGSizeZero;
    
    if (self.length == 0) {
        
        return size;
    }
    
    if (num > 0) {
        
        size = [self boundingRectWithSize:CGSizeMake(width, font.lineHeight*num) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
    } else if (num == 0) {
        
        size = [self sizeWithFont:font maxWidth:width maxNumberLines:-10];
        
    } else if (num < 0) {
        
        num = num* -1;
        
        int i = 1;
        
        CGFloat h1, h2;
        
        do {
            size = [self sizeWithFont:font maxWidth:width maxNumberLines:num*i];
            
            h1 = size.height;
            
            h2 = font.lineHeight * num * i++;
            
        } while (h1 >= h2);
    }
    
    return size;
}

#pragma mark 首字母变小写
+ (NSString *)lowercaseFristString:(NSString *)str {
    
    if (str) {
        
        NSString * firstStr = [str substringToIndex:1];
        
        NSString * lastStr = [str substringFromIndex:1];
        
        firstStr = [firstStr lowercaseString];
        
        return [NSString stringWithFormat:@"%@%@",firstStr,lastStr];
    }
    return nil;
}

/** 首字母变大写 */
+ (NSString *)uppercaseStringFristString:(NSString *)str {
    
    if (str) {
        
        NSString * firstStr = [str substringToIndex:1];
        
        NSString * lastStr = [str substringFromIndex:1];
        
        firstStr = [firstStr uppercaseString];
        
        return [NSString stringWithFormat:@"%@%@",firstStr,lastStr];
        
    }
    return nil;
    
}

+ (SEL)setSelector:(NSString *)str {
    
    NSString * setStr = [NSString stringWithFormat:@"set%@:",[NSString uppercaseStringFristString:str]];
    
    return NSSelectorFromString(setStr);
    
}

/**
 数组转json字符串

 @param array 数组
 @return 结果字符串
 */
+ (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    return jsonString;

}

/**  对象格式化成json  */
+ (NSString *)formaterToJSONString:(id)obj {
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    return jsonString;
}

#pragma mark - 格式化金额

+ (NSString *)formaterMoneyString:(NSString *)moneyStr {
    
    if (!moneyStr) {
        
        return @"0.00";
    }
    
    NSDecimalNumber * num = [NSDecimalNumber decimalNumberWithString:moneyStr];

    return [NSString formaterMoneyDecimal:num];

}

+ (NSString *)formaterMoneyFloat:(double)money {
    
    NSString * floatString = [NSString stringWithFormat:@"%lf", money];
    
    NSDecimalNumber * num = [NSDecimalNumber decimalNumberWithString:floatString];
    
    //去掉逗号
    return [NSString formaterMoneyDecimal:num];

}
+ (NSString *)formaterMoneyDecimal:(NSDecimalNumber *)moneyDeci {
    
    NSNumberFormatter * numberFormatter = [NSNumberFormatter new];

    numberFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    // 小数位最多位数
    numberFormatter.maximumFractionDigits = 2;
    // 小数位最少位数
    numberFormatter.minimumFractionDigits = 0 ;
    //去掉逗号
    return [[numberFormatter stringFromNumber:moneyDeci] stringByReplacingOccurrencesOfString:@"," withString:@""];
}

/**
 格式化成金额字符串
 
 @param moneyNum 金额（单位：分）
 @param isHasPrefix 是否展示人民币符号¥
 @return 格式化后的字符串
 */
+ (NSString *)formaterMoneyNumber:(NSInteger)moneyNum isHasPrefix:(BOOL)isHasPrefix {
    
    NSDecimalNumber * moneyDeci = [NSDecimalNumber decimalNumberWithMantissa:moneyNum
                                                              exponent:-2
                                                            isNegative:NO] ;
    
    NSNumberFormatter * numberFormatter = [NSNumberFormatter new];
    
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ;
    
    numberFormatter.numberStyle = isHasPrefix ? kCFNumberFormatterCurrencyStyle : kCFNumberFormatterDecimalStyle ;
    // 小数位最多位数
    numberFormatter.maximumFractionDigits = 2;
    // 小数位最少位数
    numberFormatter.minimumFractionDigits = 0 ;
    //去掉逗号
    return [numberFormatter stringFromNumber:moneyDeci] ;
    
}

/**过滤html标签 */
+ (NSString *)removeHTML:(NSString *)html {
    
    NSScanner *theScanner;
    
    NSString *text = nil;
    
//    NSString *str = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    return html;
}

+ (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent
{
    [strContent appendString:@"<html>"];
    [strContent appendString:@"<head>"];
    [strContent appendString:@"<meta charset=\"utf-8\">"];
    [strContent appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width*0.9,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [strContent appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [strContent appendString:@"<style>img{width:100%;}</style>"];
    [strContent appendString:@"<style>table{width:100%;}</style>"];
    [strContent appendString:@"<title>webview</title>"];
    
    return strContent;
}


/**
 格式化银行卡
 
 @param bankCard 真实银行卡号
 @return 格式化后的银行卡
 */
+ (NSString *)formaterBankCardNo:(NSString * _Nonnull)bankCard {
    
    NSInteger loc = 0;
    
    NSInteger len = 4;
    
    NSUInteger cardNum = bankCard.length;
    
    NSMutableString * targetNo = [NSMutableString string];
    
    while (loc < cardNum) {
        
        if (cardNum - loc < len) {
            
            len = cardNum - loc;
        }
        
        NSRange range = NSMakeRange(loc, len);
        
        NSString * subNo = [bankCard substringWithRange:range];
        
        [targetNo appendString:subNo];
        
        if (len + loc < cardNum) {
            
            [targetNo appendString:@" "];
            
        }
        
        loc += len;
    }
    return targetNo;
}
@end
