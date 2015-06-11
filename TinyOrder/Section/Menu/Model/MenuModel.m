//
//  MenuModel.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel


- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
//        if (self.describe.length == 0) {
//            self.describe = @"点餐送饮料";
//        }
//        NSLog(@"%@", self.name);
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}


@end
