//
//  PeripheralViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeripheralViewCell : UITableViewCell



@property (nonatomic, strong)UILabel * periheralName;
@property (nonatomic, strong)UILabel * periheralID;

- (void)createSubView:(CGRect)frame;


@end
