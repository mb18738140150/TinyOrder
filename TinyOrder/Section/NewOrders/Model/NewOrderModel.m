//
//  NewOrderModel.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "NewOrderModel.h"
#import "Meal.h"

@implementation NewOrderModel





- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
//        NSLog(@"***Pay = %@ class = %@", [dic objectForKey:@"Pay"], [[dic objectForKey:@"Pay"] class]);
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"MealList"]) {
        NSArray * mealList = (NSArray *)value;
        for (NSDictionary * dic in mealList) {
            Meal * meal = [[Meal alloc] initWithDictionary:dic];
            [self.mealArray addObject:meal];
        }
    }else if ([key isEqualToString:@"Pay"])
    {
        NSLog(@"[value class] = %@", [value class]);
        if ([value boolValue]) {
            self.pays = 1;
        }else
        {
            self.pays = 0;
        }
    }
}

- (NSMutableArray *)mealArray
{
    if (!_mealArray) {
        self.mealArray = [NSMutableArray array];
    }
    return _mealArray;
}





@end
