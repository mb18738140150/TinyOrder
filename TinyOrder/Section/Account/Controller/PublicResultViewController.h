//
//  PublicResultViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/8/31.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicResultViewController : UITableViewController<UISearchResultsUpdating>


@property (nonatomic, assign) id target;
@property (nonatomic, assign)SEL action;


@end
