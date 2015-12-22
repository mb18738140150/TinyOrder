//
//  NSDictionary+NSDictionary_Unicode.m
//  TinyOrder
//
//  Created by 仙林 on 15/11/5.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "NSDictionary+NSDictionary_Unicode.h"

@implementation NSDictionary (NSDictionary_Unicode)

- (NSString * )my_description
{
    NSString * desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

@end
