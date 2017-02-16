//
//  AccountModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

@property (nonatomic, copy)NSString * StoreIcon;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * detail;
@property (nonatomic, strong)NSNumber * state;

@property (nonatomic, copy)NSString * tel;
@property (nonatomic, assign)int bankCardCount;
@property (nonatomic, assign)int todayOrder;
@property (nonatomic, assign)double todayMoney;
@property (nonatomic, strong)NSNumber *tangState;
@property (nonatomic, strong)NSNumber *tangAutoState;
@property (nonatomic, strong)NSNumber * realNameCertificationState;
@property (nonatomic, strong)NSNumber * autoBusinessState;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
