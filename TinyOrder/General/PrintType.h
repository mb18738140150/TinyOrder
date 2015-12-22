//
//  PrintType.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintType : NSObject

@property (nonatomic, assign)int printType;
@property (nonatomic, assign)BOOL isGPRS;
@property (nonatomic, assign)BOOL isGPRSenable;
@property (nonatomic, assign)BOOL isBlutooth;
@property (nonatomic, assign)int gprsPrintNum;
@property (nonatomic, assign)int printState;
//@property (nonatomic, assign)int gprsPrintCount;

+ (PrintType *)sharePrintType;

@end
