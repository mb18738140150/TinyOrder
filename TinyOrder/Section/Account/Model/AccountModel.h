//
//  AccountModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

@property (nonatomic, copy)NSString * iconName;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * detail;
@property (nonatomic, strong)NSNumber * state;

@end
