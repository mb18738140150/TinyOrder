//
//  DetailEditViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailEditViewCell : UITableViewCell


@property (nonatomic, strong)UIButton * editButton;
@property (nonatomic, strong)UIButton * clearButton;
@property (nonatomic, strong)UIButton * deleteButton;

- (void)createSubView:(CGRect)frame;


@end
