//
//  DetailModel.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel


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
