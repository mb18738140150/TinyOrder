//
//  GPRSPrintModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPRSPrintModel : NSObject

@property (nonatomic, copy)NSString *printName;
@property (nonatomic, assign)int printId;
@property (nonatomic, assign)int printState;
@property (nonatomic, copy)NSString *printNum;
@property (nonatomic, assign)int isEnable;
@property (nonatomic, assign)int printCount;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
