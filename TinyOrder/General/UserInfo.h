//
//  UserInfo.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (UserInfo *)shareUserInfo;
@property (nonatomic, strong)NSNumber * userId;
@property (nonatomic, copy)NSString * userName;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, copy)NSString * StroeName;
@property (nonatomic, strong)NSNumber *printState;
@property (nonatomic, copy)NSString * phoneNumber;

@property (nonatomic, strong)NSNumber * isShowPayCode;
@property (nonatomic, copy)NSString * payCodeDes;
@property (nonatomic, copy)NSString * customPayCodeContent;
//@property (nonatomic, copy)NSString * registrationID;

- (void)setUserInfoWithDictionary:(NSDictionary *)dic;

@end
