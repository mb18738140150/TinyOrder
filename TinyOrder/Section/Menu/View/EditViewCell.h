//
//  EditViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuModel;
@interface EditViewCell : UITableViewCell

@property (nonatomic, strong)MenuModel * menuModel;
@property (nonatomic, strong)UIButton * editButton;
@property (nonatomic, strong)UIButton * deleteButton;


- (void)createSubViews:(CGRect)frame;
+ (CGFloat)cellHeight;
@end
