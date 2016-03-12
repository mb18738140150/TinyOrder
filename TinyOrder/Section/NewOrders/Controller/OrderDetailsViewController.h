//
//  OrderDetailsViewController.h
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSUInteger{
    Waimai = 1,
    Tangshi = 2,
} Isfrom;

@interface OrderDetailsViewController : UIViewController

@property (nonatomic, copy)NSString * orderID;
@property (nonatomic, assign)Isfrom isWaimaiorTangshi;

@end
