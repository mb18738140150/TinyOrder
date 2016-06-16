//
//  MealStatisticalModel.h
//  TinyOrder
//
//  Created by 仙林 on 16/6/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MealStatisticalModel : NSObject
@property (nonatomic, copy)NSString * mealName;
@property (nonatomic, strong)NSNumber * saleCount;
@property (strong, nonatomic)NSNumber * money;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
