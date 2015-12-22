//
//  GeneralSwitch.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GeneralSwitch.h"

@implementation GeneralSwitch

+(GeneralSwitch *)shareGeneralSwitch
{
    static GeneralSwitch *generalSwitch = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generalSwitch = [[GeneralSwitch alloc]init];
        generalSwitch.bluetoothSwitch = [[UISwitch alloc]init];
        generalSwitch.bluetoothSwitch.on = NO;
        generalSwitch.GPRSSwitch = [[UISwitch alloc]init];
    });
    return generalSwitch;
}


@end
