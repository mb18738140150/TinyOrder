//
//  StoreCreateViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/8/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
@interface StoreCreateViewController : UIViewController

@property (nonatomic, strong)NSNumber * userId;

@property (nonatomic, copy)NSString * logoURL;
@property (nonatomic, copy)NSString * barcodeURL;


@property (nonatomic, assign)int changestore;

@end
