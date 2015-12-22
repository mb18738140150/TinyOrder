//
//  ActivityModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject



@property (nonatomic, strong)NSNumber * actionId;

@property (nonatomic, copy)NSString * actionName;

@property (nonatomic, strong)NSNumber * actionType;
@property (nonatomic, strong)NSNumber * actionSort;
@property (nonatomic, copy)NSString * createTime;
@property (nonatomic, copy)NSString * actionTime;
@property (nonatomic, copy)NSString * noActionFood;


- (id)initWithDictionary:(NSDictionary *)dic;


@end
