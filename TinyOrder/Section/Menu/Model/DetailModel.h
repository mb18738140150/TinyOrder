//
//  DetailModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: NSInteger {
    Select_nomal = 0,
    Select_no =1 ,
    Select_select = 2,
} SelectType;

@interface DetailModel : NSObject

@property (nonatomic, assign)SelectType selectType;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, strong)NSNumber * mealId;
@property (nonatomic, strong)NSNumber * oldMoney;
@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, strong)NSNumber * count;
@property (nonatomic, strong)NSNumber * soldCount;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, strong)NSNumber * mealState; // 1为已估清(下架),2已上架
@property (nonatomic, strong)NSNumber * foodBoxMoney;
@property (nonatomic, assign)int integral;
@property (nonatomic, copy)NSString * unit;
@property (nonatomic, copy)NSString * mark;
@property (nonatomic, copy)NSString * describe;
@property (nonatomic, strong)NSArray * attList;
@property (nonatomic, assign)int SortCode;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
