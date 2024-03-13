
#import "NSAttributedString+SYAttributedString.h"
#import "UIImage+Addition.h"

#define DefaultAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}

@implementation NSAttributedString (SYAttributedString)

+ (NSAttributedString *)changeAttributedStringFromStrings:(NSArray<NSString *> *)strings
                                            addAttributes:(NSArray <NSDictionary<NSString *, id> *> *)attrs
                                            connectString:(NSString *)connectString
                                              lineSpacing:(CGFloat)lineSpacing
{
    NSString * str;
    if (connectString) {
        str = [strings componentsJoinedByString:@"\n"];
    }else{
        str = [strings componentsJoinedByString:@""];
    }
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, 0);
    
    for (NSString * str in strings) {
        NSInteger i = [strings indexOfObject:str];
        if (connectString) {
            range.length = str.length + 1;
        }else{
            range.length = str.length;
        }
        [attStr addAttributes:attrs[i] range:range];
        range.location += str.length;
    }
    if ([connectString isEqualToString:@"\n"]) {
        //    行间距
        NSMutableParagraphStyle * paraStyle = [NSMutableParagraphStyle new];
        paraStyle.lineSpacing = lineSpacing;
        paraStyle.alignment = NSTextAlignmentCenter;
        [attStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, str.length)];
    }
    
    return attStr;
}


+ (NSAttributedString *)changeAttributedStringFromStrings:(NSArray *)strings
                                            addAttributes:(NSArray<NSDictionary<NSString *,id> *> *)attrs connectStringArray:(NSArray<NSString *> *)connectStringArr
                                              lineSpacing:(CGFloat)lineSpacing
{
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary * defaultAttrs = [attrs firstObject];
    
    NSString * defaultConnectStr = @"";
    
    NSInteger i = 0;
    
    for (id obj in strings) {
        
        NSString * connectString = nil;
        
        if (connectStringArr.count > i) {
            
            connectString = connectStringArr[i];
            
        }else{
            connectString = defaultConnectStr;
        }
        
        if ([obj isMemberOfClass:[UIImage class]]) {
            //缩略图
            UIImage * image = (UIImage *)obj;
                        
            if (i < attrs.count) {
                
                for (NSString * key in attrs[i]) {
                    
                    if ([key isEqualToString:NSForegroundColorAttributeName]) {
                        
                        image = [UIImage imageWithColor:attrs[i][NSForegroundColorAttributeName]];
                    }
                }

            }
            
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = image;
            // 设置图片大小
            attch.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            
            [attStr appendAttributedString:string];
            // 连接字符
            if (i < attrs.count) {
                
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:connectString attributes:attrs[i]]];
                
            }else{
                
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:connectString attributes:defaultAttrs]];

            }
            
        }else if ([obj isKindOfClass:[NSString class]]) {
            
            NSString * str = [NSString stringWithFormat:@"%@%@",strings[i],connectString];
            
            if (i < attrs.count) {
                
                NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:str attributes:attrs[i]];
                
                [attStr appendAttributedString:attributedString];
                
            } else {
                
                NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:str attributes:defaultAttrs];
                
                [attStr appendAttributedString:attributedString];

            }
            
        }else{

        }
        
        i++;
    }
    
    for (NSString * connectString  in connectStringArr) {
        if ([connectString isEqualToString:@"\n"]) {
            //    行间距
            NSMutableParagraphStyle * paraStyle = [NSMutableParagraphStyle new];
            paraStyle.lineSpacing = lineSpacing;
            paraStyle.alignment = NSTextAlignmentCenter;
            [attStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attStr.length)];
        }
    }
    
    return attStr;
    
}
@end
