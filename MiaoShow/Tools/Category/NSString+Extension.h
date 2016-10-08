//
//  NSString+Extension.h
//  mp_business
//
//  Created by pengkaichang on 14-10-8.
//  Copyright (c) 2014年 com.soudoushi.makepolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

+ (NSString *)md5:(NSString *)str;

+ (NSString *)timeStamp;

+ (NSUInteger)getBytesLengthWithSring:(NSString *)str;

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
// 计算特定行距和特定字体的文本高度
- (CGFloat)heightWithSize:(CGSize)size LineSpace:(CGFloat)lineSpace font:(UIFont *)font;

+ (NSString *)cachePath;

//处理UM广告URL
+ (NSString *)encodeUMengURL:(NSString *)adURL;
//中英文，数字，字母，下划线‘_’的判断
- (BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore;
//邮箱格式匹配
- (BOOL)isLegalEmail;
//电话号码格式匹配
- (BOOL)isLegalPhoneNumber;
//返回字符串中的中文字符数
+ (NSUInteger)numberOfChineseCharacter:(NSString *)string;

@end

@interface NSDictionary(composeType)
+ (NSDictionary *)attributedDictionaryWithLineSpace:(CGFloat)lineSpace font:(UIFont *)font;
@end

