//
//  TypeViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeViewController : UIViewController


@property (nonatomic, assign)BOOL isHaveFirst;//是否已经有首单立减
@property (nonatomic, assign)int fromeWaimaiOrTangshi;// 1、外卖 2、堂食

@end
