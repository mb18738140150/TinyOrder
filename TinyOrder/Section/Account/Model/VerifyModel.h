//
//  VerifyModel.h
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyModel : NSObject

@property (nonatomic, copy)NSString * orderDate;// 验证日期
@property (nonatomic, assign)int orderCount;// 菜品总份数
@property (nonatomic, strong)NSNumber * totalMoney;// 总价钱
@property (nonatomic, strong)NSMutableArray * VerifyOrderList;
- (id)initWithDictionary:(NSDictionary *)dic;
@end
