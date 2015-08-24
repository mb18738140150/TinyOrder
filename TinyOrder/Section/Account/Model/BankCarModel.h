//
//  BankCarModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCarModel : NSObject


@property (nonatomic, strong)NSNumber * bankCardId;
@property (nonatomic, copy)NSString * bankCardName;
@property (nonatomic, copy)NSString * bankCardNumber;
@property (nonatomic, strong)NSNumber * bankCardType;


- (id)initWithDictionary:(NSDictionary *)dic;

@end
