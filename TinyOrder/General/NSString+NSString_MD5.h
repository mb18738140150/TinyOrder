//
//  NSString+NSString_MD5.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_MD5)

- (NSString *)md5;
/**
 *  验证手机号
 *
 *  @param str 输入手机号码
 *
 *  @return 手机号正确返回YES, 错误返回NO
 */
+ (BOOL)isTelPhoneNub:(NSString *)str;
//+ (BOOL) validateIdentityCard: (NSString *)identityCard;
/**
 *  验证身份证号码
 *
 *  @param value 身份证号码
 *
 *  @return 身份证正确返回 YES, 错误返回 NO.
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;
@end
