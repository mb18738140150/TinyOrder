//
//  DishDetailViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/11/7.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
typedef void(^ReturnValueBlock)();


@interface DishDetailViewController : UIViewController
@property (nonatomic, assign)int isFromeWaimaiOrTangshi;
@property (nonatomic, strong)DetailModel * detailMD;
@property (nonatomic, assign)int foodId;
- (void)returnPropertyValue:(ReturnValueBlock)valueBlock;


@end
