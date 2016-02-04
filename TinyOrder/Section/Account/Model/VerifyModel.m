//
//  VerifyModel.m
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyModel.h"
#import "VerifyMealModel.h"


@implementation VerifyModel

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
    if ([key isEqualToString:@"OrderList"]) {
        NSArray * oderlistarray = (NSArray *)value;
        for (NSDictionary * dic in oderlistarray) {
            VerifyMealModel * model = [[VerifyMealModel alloc]initWithDictionary:dic];
            [self.VerifyOrderList addObject:model];
        }
    }
}

- (NSMutableArray *)VerifyOrderList
{
    if (!_VerifyOrderList) {
        self.VerifyOrderList = [NSMutableArray array];
    }
    return _VerifyOrderList;
}


@end
