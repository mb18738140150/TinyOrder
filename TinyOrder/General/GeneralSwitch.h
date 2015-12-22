//
//  GeneralSwitch.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralSwitch : NSObject

@property (nonatomic, strong)UISwitch *bluetoothSwitch;
@property (nonatomic, strong)UISwitch *GPRSSwitch;

+ (GeneralSwitch *)shareGeneralSwitch;

@end
