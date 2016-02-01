//
//  PrintType.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintType : NSObject

//@property (nonatomic, assign)int printType;
@property (nonatomic, assign)BOOL isGPRS;// GPRS打印机连接状态
@property (nonatomic, assign)BOOL isGPRSenable;// 是否启动GPRS打印
@property (nonatomic, assign)BOOL isBlutooth;// 是否启动蓝牙打印
@property (nonatomic, assign)int gprsPrintNum;
@property (nonatomic, assign)int printState;//记录GPRS打印机状态

//@property (nonatomic, assign)int gprsPrintCount;

+ (PrintType *)sharePrintType;

@end
