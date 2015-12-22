//
//  AddMenuViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailModel;
typedef void(^ReturnValueBlock)();
@interface AddMenuViewController : UIViewController

@property (nonatomic, strong)DetailModel * detailMD;
@property (nonatomic, strong)NSNumber * classifyId;
@property (nonatomic, assign)int isFromeWaimaiOrTangshi;

@property (nonatomic, assign)int foodId;

- (void)returnMenuValue:(ReturnValueBlock)valueBlock;


@end
