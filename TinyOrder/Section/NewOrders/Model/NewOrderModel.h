//
//  NewOrderModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewOrderModel : NSObject

@property (nonatomic, assign)BOOL isOrNo;
// 外卖订单参数
@property (nonatomic, assign)int order;
@property (nonatomic, strong)NSString * orderId;
@property (nonatomic, assign)int orderNum;
@property (nonatomic, strong)NSNumber * dealState;// 处理状态
@property (nonatomic, copy)NSString * name;//客户名
@property (nonatomic, copy)NSString * orderTime;// 下单时间
@property (nonatomic, copy)NSString * hopeTime;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * contect;//客户名
@property (nonatomic, copy)NSString * tel;
@property (nonatomic, strong)NSNumber * otherMoney;
@property (nonatomic, strong)NSNumber * delivery;//
@property (nonatomic, strong)NSNumber * foodBox;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, assign)int  pays;
@property (nonatomic, strong)NSMutableArray * mealArray;
@property (nonatomic, strong)NSNumber * PayMath;// 支付方式
@property (nonatomic, copy)NSString * remark;// 备注
@property (nonatomic, copy)NSString * gift;// 赠品
@property (nonatomic, strong)NSNumber * firstReduce;
@property (nonatomic, strong)NSNumber * fullReduce;
@property (nonatomic, strong)NSNumber * reduceCard;// 优惠券
@property (nonatomic, strong)NSNumber * internal;// 积分
@property (nonatomic, assign)double discount; // 打折
@property (nonatomic, assign)int orderType;// 0、外卖订单 1、堂食订单
// 堂食新增参数
@property (nonatomic, assign)int isprints;// 是否已经打印
@property (nonatomic, copy)NSString * eatLocation;// 用餐位置
@property (nonatomic, assign)int customerCount;// 用餐人数
@property (nonatomic, assign)double tablewareFee;// 餐具费
@property (nonatomic, assign)int isVerifyOrder;// 0,正常订单，1未验证，2已验证

@property (nonatomic, strong)NSNumber *  isReserve;// 是否预定
@property (nonatomic, copy)NSString * reserveTime;// 预定时间
@property (nonatomic, copy)NSString * openMealTime;// 开餐时间
@property (nonatomic, copy)NSString * reserveName;// 预订人
@property (nonatomic, copy)NSString * reservePhoneNo;// 预订人联系方式

// 配送员信息
@property (nonatomic, strong)NSNumber * deliveryUserId;
@property (nonatomic, copy)NSString * deliveryRealName;
@property (nonatomic, copy)NSString * deliveryPhoneNo;
@property (nonatomic, strong)NSNumber * commission;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
