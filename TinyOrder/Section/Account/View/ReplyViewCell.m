//
//  ReplyViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ReplyViewCell.h"

#define LEFT_SPACE 10
#define TOP_SPACE 5

#define BUTTON_HEIGHT 15
#define TEXTVIEW_HEIGHT 50
#define BUTTON_WIDTH 35

@implementation ReplyViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    self.replyContentV = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, WINDOW_WIDHT - 2 * LEFT_SPACE, TEXTVIEW_HEIGHT)];
    _replyContentV.layer.cornerRadius = 5;
    _replyContentV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.contentView addSubview:_replyContentV];
    
    self.ensureBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _ensureBT.frame = CGRectMake(WINDOW_WIDHT - 2 * LEFT_SPACE - 2 * BUTTON_WIDTH, _replyContentV.bottom + TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
    [_ensureBT setBackgroundImage:[UIImage imageNamed:@"sure.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_ensureBT];
    
    self.cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBT.frame = CGRectMake(WINDOW_WIDHT - LEFT_SPACE - BUTTON_WIDTH, _replyContentV.bottom + TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
    [_cancelBT setBackgroundImage:[UIImage imageNamed:@"cancelBT.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_cancelBT];
    
    
}

+ (CGFloat)cellHeigth
{
    return 3 * TOP_SPACE + BUTTON_HEIGHT + TEXTVIEW_HEIGHT;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
