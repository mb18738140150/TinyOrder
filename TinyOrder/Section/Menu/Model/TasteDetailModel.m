//
//  TasteDetailModel.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/31.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "TasteDetailModel.h"

@implementation TasteDetailModel

- (id)initWithDiationary:(NSDictionary *)dic
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
