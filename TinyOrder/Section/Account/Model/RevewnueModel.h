//
//  RevewnueModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevewnueModel : NSObject


@property (nonatomic, strong)NSNumber * type;
@property (nonatomic, strong)NSString * actionName;
@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, strong)NSString * date;
@property (nonatomic, strong)NSNumber * state;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
