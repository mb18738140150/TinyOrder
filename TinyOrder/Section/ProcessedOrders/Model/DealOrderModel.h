//
//  DealOrderModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealOrderModel : NSObject

@property BOOL isSelete;
@property (nonatomic, assign)int order;

@property (nonatomic, strong)NSString * orderId;
@property (nonatomic, strong)NSNumber * orderNum;
@property (nonatomic, strong)NSNumber * dealState;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * orderTime;
@property (nonatomic, copy)NSString * hopeTime;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * contect;
@property (nonatomic, copy)NSString * tel;
@property (nonatomic, strong)NSNumber * otherMoney;
@property (nonatomic, strong)NSNumber * delivery;
@property (nonatomic, strong)NSNumber * foodBox;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, strong)NSNumber * pay;
@property (nonatomic, strong)NSMutableArray * mealArray;
@property (nonatomic, copy)NSString * remark;
@property (nonatomic, copy)NSString * gift;
@property (nonatomic, strong)NSNumber * payMath;
@property (nonatomic, strong)NSNumber * firstReduce;
@property (nonatomic, strong)NSNumber * fullReduce;
@property (nonatomic, strong)NSNumber * reduceCard;
@property (nonatomic, assign)double discount;
@property (nonatomic, strong)NSNumber * internal;// 积分

@property (nonatomic, strong)NSNumber * deliveryUserId;
@property (nonatomic, copy)NSString * deliveryRealName;
@property (nonatomic, copy)NSString * deliveryPhoneNo;
@property (nonatomic, strong)NSNumber * commission;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
