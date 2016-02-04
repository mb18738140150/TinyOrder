//
//  VerifyMealModel.h
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyMealModel : NSObject

@property (nonatomic, copy)NSString * orderId;
@property (nonatomic, copy)NSString * foodIcon;
@property (nonatomic, copy)NSString * foodName;
@property (nonatomic, assign)double foodPrice;
@property (nonatomic, assign)int foodCount;
- (id)initWithDictionary:(NSDictionary *)dic;
@end
