//
//  UserInfo.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo


+ (UserInfo *)shareUserInfo
{
    static UserInfo * userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc] init];
    });
    return userInfo;
}


- (void)setUserInfoWithDictionary:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
    NSLog(@",,,%@, %@", self.userName, self.userId);
//    NSLog(@"%@, %@, %@", self.userName, self.userId, self.icon);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
