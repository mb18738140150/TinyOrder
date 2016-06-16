//
//  MealStatisticalModel.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MealStatisticalModel.h"

@implementation MealStatisticalModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
