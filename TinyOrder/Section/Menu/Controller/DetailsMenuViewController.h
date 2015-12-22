//
//  DetailsMenuViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsMenuViewController : UIViewController
@property (nonatomic, assign)int isFromeWaimaiOrTangshi;
@property (nonatomic, strong)NSNumber * classifyId;
@property (nonatomic, strong)UITableView * tableView;
@end
