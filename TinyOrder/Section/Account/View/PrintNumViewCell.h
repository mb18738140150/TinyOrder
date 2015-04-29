//
//  PrintNumViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintNumViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * numberLabel;

- (void)createSubView:(CGRect)frame;
@end
