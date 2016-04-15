//
//  EquipmentInformationViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum: NSInteger {
    addGPRSPrint = 0,
    addGugujiPrint =1 ,
} addOnlinePrintType;


@interface EquipmentInformationViewController : UIViewController
@property (nonatomic, assign)addOnlinePrintType addOnlineprintType;
@property (nonatomic, strong)NSNumber * printID;

@end
