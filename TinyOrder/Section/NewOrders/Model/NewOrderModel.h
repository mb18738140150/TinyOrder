//
//  NewOrderModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewOrderModel : NSObject

@property (nonatomic, strong)NSString * orderNum;
@property (nonatomic, strong)NSString * orderId;
@property (nonatomic, copy)NSString * dealState;
@property (nonatomic, copy)NSString * orderTime;
@property (nonatomic, copy)NSString * hopeTime;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * contect;
@property (nonatomic, copy)NSString * tel;
@property (nonatomic, strong)NSNumber * otherMoney;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, strong)NSNumber * pay;
@property (nonatomic, strong)NSMutableArray * mealArray;
@property (nonatomic, strong)NSNumber * PayMath;
@property (nonatomic, copy)NSString * remark;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
