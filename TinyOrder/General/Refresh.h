//
//  Refresh.h
//  TinyOrder
//
//  Created by 仙林 on 16/3/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Refresh : NSObject

@property (nonatomic, assign)int nOrder;// 1、刷新 2、不刷新
@property (nonatomic, assign)int processOrder;// 1、刷新 2、不刷新
@property (nonatomic, assign)int menuOrder;// 1、刷新 2、不刷新
+ (Refresh *)shareRefresh;

@end
