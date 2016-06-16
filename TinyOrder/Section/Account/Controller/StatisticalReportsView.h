//
//  StatisticalReportsView.h
//  TinyOrder
//
//  Created by 仙林 on 16/6/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScreenValueBlock)(NSDictionary * dic);

@interface StatisticalReportsView : UIView


@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * selectsdArr;
@property (nonatomic, strong)UIButton * searchBT;
@property (nonatomic, strong)UIScrollView * dataView;
- (void)showinSuperView;
- (void)dismissfromSuperView;
- (instancetype)initWithFrame:(CGRect)frame DataArray:(NSMutableArray *)arr;

- (void)screenWithDic:(ScreenValueBlock)screenBlock;

@end
