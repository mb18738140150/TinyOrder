//
//  PublicNumModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicNumModel : NSObject


@property (nonatomic, copy)NSString * autoType;

@property (nonatomic, copy)NSString * num;

@property (nonatomic, strong)NSNumber * numCommission;


@property (nonatomic, strong)NSNumber * numId;

@property (nonatomic, copy)NSString * numInfo;

@property (nonatomic, copy)NSString * numName;

@property (nonatomic, strong)NSNumber * numState;

@property (nonatomic, copy)NSString * numType;

@property (nonatomic, copy)NSString * reason;

@property (nonatomic, assign)int  isDelivery;
/**
 *  用来记录是已入住列表的Model还是所有公众号列表的Model
 */
@property (nonatomic, strong)NSNumber * isApply;



- (id)initWithDictionary:(NSDictionary *)dic;

@end
