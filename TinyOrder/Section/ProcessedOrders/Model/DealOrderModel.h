//
//  DealOrderModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealOrderModel : NSObject


@property (nonatomic, strong)NSString * orderId;
@property (nonatomic, strong)NSNumber * orderNumber;
@property (nonatomic, copy)NSString * dealState;
@property (nonatomic, copy)NSString * orderTime;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * contect;
@property (nonatomic, copy)NSString * tel;
@property (nonatomic, strong)NSNumber * otherMoney;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, strong)NSNumber * pay;
@property (nonatomic, strong)NSMutableArray * mealArray;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
