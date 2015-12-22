//
//  PrintTypeViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewOrderModel;
@class DealOrderModel;

@interface PrintTypeViewController : UIViewController

@property (nonatomic, strong)NewOrderModel *nOrderModel;
@property (nonatomic, strong)DealOrderModel * dealOrderModel;
@property (nonatomic, assign)int fromWitchController;

@end
