//
//  MenuActivityMD.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuActivityMD : NSObject


@property (nonatomic, copy)NSString * name;
@property (nonatomic, strong)NSNumber * mealId;


- (id)initWithDictionary:(NSDictionary *)dic;

@end
