//
//  NewOrderModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewOrderModel : NSObject
// 外卖订单参数
@property (nonatomic, assign)int order;
@property (nonatomic, strong)NSString * orderId;
@property (nonatomic, assign)int orderNum;
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
@property (nonatomic, assign)BOOL * pay;
@property (nonatomic, strong)NSMutableArray * mealArray;
@property (nonatomic, strong)NSNumber * PayMath;
@property (nonatomic, copy)NSString * remark;
@property (nonatomic, copy)NSString * gift;
@property (nonatomic, assign)NSNumber * firstReduce;
@property (nonatomic, assign)NSNumber * fullReduce;
@property (nonatomic, assign)NSNumber * reduceCard;

// 堂食新增参数
@property (nonatomic, copy)NSString * eatLocation;
@property (nonatomic, assign)int customerCount;
@property (nonatomic, assign)double tablewareFee;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
