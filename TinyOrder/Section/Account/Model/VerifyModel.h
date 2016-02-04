//
//  VerifyModel.h
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyModel : NSObject

@property (nonatomic, copy)NSString * orderDate;
@property (nonatomic, assign)int orderCount;
@property (nonatomic, strong)NSMutableArray * VerifyOrderList;
- (id)initWithDictionary:(NSDictionary *)dic;
@end
