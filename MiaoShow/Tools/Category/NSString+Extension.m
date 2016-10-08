//
//  NSString+Extension.m
//  mp_business
//
//  Created by pengkaichang on 14-10-8.
//  Copyright (c) 2014年 com.soudoushi.makepolo. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)timeStamp
{
    return [NSString stringWithFormat:@"%llu",(unsigned long long)[[NSDate date] timeIntervalSince1970]];
}

+ (NSUInteger)getBytesLengthWithSring:(NSString *)str
{
    NSUInteger len = 0;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    len = [str lengthOfBytesUsingEncoding:enc];
    
    return len;
}

+(NSString *) encodeURIComponent:(NSString *)component
{
    ///Users/huhang/Desktop/MiaoShow/MiaoShow/Tools/NSString+Extension.m:46:57: 'CFURLCreateStringByAddingPercentEscapes' is deprecated: first deprecated in iOS 9.0 - Use [NSString stringByAddingPercentEncodingWithAllowedCharacters:] instead, which always uses the recommended UTF-8 encoding, and which encodes for a specific URL component or subcomponent (since each URL component or subcomponent has different rules for what characters are valid).
    // Encode all the reserved characters, per RFC 3986
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]_"];;
    NSString *outputStr = [component stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    return outputStr;
    
}

+ (NSString *)cachePath {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Resources"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return path;
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。字体大小+行间距=行高
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}

- (CGFloat)heightWithSize:(CGSize)size LineSpace:(CGFloat)lineSpace font:(UIFont *)font {
    
    if ([self isEqualToString:@""]) {
        return 0;
    }
    
    CGRect tempRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.lineHeight) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
    
    // 单行，行距为0
    if (tempRect.size.width + 5 <= size.width) {
        return font.lineHeight;
    }
    
    NSDictionary *attrDic = [NSDictionary attributedDictionaryWithLineSpace:lineSpace font:font];
    // 计算大小
    CGRect boundRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil];
    return boundRect.size.height;
    
}

+ (NSString *)encodeUMengURL:(NSString *)adURL
{
    NSString *urlHost = [[adURL componentsSeparatedByString:@"?"] objectAtIndex:0];
    NSString *parameters = [[adURL componentsSeparatedByString:@"?"] objectAtIndex:1];
    NSArray *parasArry = [parameters componentsSeparatedByString:@"&"];
    NSMutableArray *newParasArry = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSString *obj in parasArry) {
        
        NSArray *pair = [obj componentsSeparatedByString:@"="];
        NSMutableArray *newPaisArry = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSString *oldStr in pair) {
            
            NSString *encodedStr = [self encodeURIComponent:oldStr];
            [newPaisArry addObject:encodedStr];
        }
        
        NSString *newPairStr = [newPaisArry componentsJoinedByString:@"="];
        [newParasArry addObject:newPairStr];
    }
    
    NSString *newParameters = [newParasArry componentsJoinedByString:@"&"];
    NSString *encodedAdURLStr = [urlHost stringByAppendingFormat:@"?%@",newParameters];
    
    return encodedAdURLStr;
}

- (BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore
{
    NSInteger len=self.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[self characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
            return NO;
    }
    return YES;
}

- (BOOL)isLegalEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [emailPre evaluateWithObject:self];
    
}

- (BOOL)isLegalPhoneNumber {
    
    NSString *regex = @"1\\d{10}";
    NSPredicate *phoneNumPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phoneNumPre evaluateWithObject:self];
    
}

+ (NSUInteger)numberOfChineseCharacter:(NSString *)string {
    
    NSUInteger len = string.length;
    
    NSUInteger countNum = 0;
    for (int i = 0; i < len; i ++) {
        
        unichar a = [string characterAtIndex:i];
        
        if ((a >= 0x4e00 && a <= 0x9fa6)) {
            
            countNum ++ ;
        }
    }
    
    return countNum;
}
@end

@implementation NSDictionary (composeType)

+ (NSDictionary *)attributedDictionaryWithLineSpace:(CGFloat)lineSpace font:(UIFont *)font
{
    // 设置段落的属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.firstLineHeadIndent = 0;
    
    NSDictionary *attrDic = @{NSFontAttributeName : font,
                              NSKernAttributeName: @(0),
                              NSParagraphStyleAttributeName : paragraphStyle
                              };
    
    return attrDic;
}

@end
