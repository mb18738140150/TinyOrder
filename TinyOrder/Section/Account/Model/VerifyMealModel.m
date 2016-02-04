//
//  VerifyMealModel.m
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyMealModel.h"

@implementation VerifyMealModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
