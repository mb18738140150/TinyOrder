//
//  DetailModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject


@property (nonatomic, copy)NSString * name;
@property (nonatomic, strong)NSNumber * mealId;
@property (nonatomic, strong)NSNumber * oldMoney;
@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, strong)NSNumber * count;
@property (nonatomic, strong)NSNumber * soldCount;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, strong)NSNumber * mealState;
@property (nonatomic, strong)NSNumber * foodBoxMoney;
@property (nonatomic, assign)int integral;
@property (nonatomic, copy)NSString * unit;
@property (nonatomic, copy)NSString * mark;
@property (nonatomic, copy)NSString * describe;
@property (nonatomic, strong)NSArray * attList;
@property (nonatomic, assign)int SortCode;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
