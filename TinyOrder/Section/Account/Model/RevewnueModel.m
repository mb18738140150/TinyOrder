//
//  RevewnueModel.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "RevewnueModel.h"

@implementation RevewnueModel


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
