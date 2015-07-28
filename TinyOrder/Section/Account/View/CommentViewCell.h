//
//  CommentViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;
@interface CommentViewCell : UITableViewCell

@property (nonatomic, strong)UIButton * replyBT;


@property (nonatomic, strong)CommentModel * commentMD;
+ (CGFloat)cellHeightWithCommentMD:(CommentModel *)commentMD;


@end
