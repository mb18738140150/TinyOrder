//
//  ReplyViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyViewCell : UITableViewCell


@property (nonatomic, strong)UITextView * replyContentV;
@property (nonatomic, strong)UIButton * ensureBT;
@property (nonatomic, strong)UIButton * cancelBT;


+ (CGFloat)cellHeigth;

@end
