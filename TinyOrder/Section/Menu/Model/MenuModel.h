//
//  MenuModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * describe;
@property (nonatomic, strong)NSNumber * classifyId;
@property (nonatomic, assign)int foodCount;
@property (nonatomic, assign)int SortCode;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
