//
//  Refresh.m
//  TinyOrder
//
//  Created by 仙林 on 16/3/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "Refresh.h"

@implementation Refresh

+(Refresh *)shareRefresh
{
    static Refresh * refresh = nil;
    static dispatch_once_t onceTolen;
    dispatch_once(&onceTolen, ^{
        refresh = [[Refresh alloc]init];
        refresh.nOrder = 1;
        refresh.processOrder = 1;
        refresh.menuOrder = 1;
    });
    return refresh;
}

@end
