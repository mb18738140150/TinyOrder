//
//  GPRSPrintViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewOrderModel;

typedef enum: NSInteger {
    GPRSPrint = 0,
    GugujiPrint =1 ,
    MstchingPrint = 2,
} OnlinePrintType;

@interface GPRSPrintViewController : UITableViewController

//@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NewOrderModel *nOrderModel;

@property (nonatomic, assign)OnlinePrintType onlineprintType;

@end
