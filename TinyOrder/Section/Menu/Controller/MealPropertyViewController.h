//
//  MealPropertyViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/10/30.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

typedef void(^ReturnValueBlock)();

@interface MealPropertyViewController : UIViewController

@property (nonatomic, strong)DetailModel * detailMD;

@property (nonatomic, strong)UIScrollView * tasteScroll;
@property (nonatomic, strong)UIPageControl * tastePageControl;
@property (nonatomic, strong)UILabel * tipLabel;
// 新家菜品的fodId
@property (nonatomic, assign)int foodId;

// 选中口味数组
@property (nonatomic, strong)NSMutableArray * tasteDetaileArray;

- (void)returnPropertyValue:(ReturnValueBlock)valueBlock;

@end
