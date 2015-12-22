//
//  TotalPriceView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TotalPriceView.h"
#import "UIViewAdditions.h"

#define PRICELABEL_WIDTH 80
#define TOP_SPACE 15
#define LABEL_HEIGHT 30
#define LEFT_SPACE 10
#define BUTTON_HEIGHT 40
//#define DEALBUTTON_WIDTH 146
#define DEALBUTTON_WIDTH 100

@implementation TotalPriceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - DEALBUTTON_WIDTH - PRICELABEL_WIDTH - 40 - 90, TOP_SPACE, 40, LABEL_HEIGHT)];
    _totalLabel.text = @"总¥";
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.textColor = [UIColor grayColor];
    [self addSubview:_totalLabel];
    self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_totalLabel.right, TOP_SPACE, PRICELABEL_WIDTH, LABEL_HEIGHT)];
    _totalPriceLabel.text = @"¥24";
    _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
    _totalPriceLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    _totalPriceLabel.font = [UIFont systemFontOfSize:24];
    _totalPriceLabel.textColor = [UIColor redColor];
    [self addSubview:_totalPriceLabel];
    
    self.dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dealButton.frame = CGRectMake(_totalPriceLabel.right + 90, TOP_SPACE - 5, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    [_dealButton setBackgroundImage:[UIImage imageNamed:@"deal_print_normal(1).png"] forState:UIControlStateNormal];
    [_dealButton setTitle:@"标记餐已送出" forState:UIControlStateNormal];
    _dealButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_dealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dealButton setBackgroundImage:[UIImage imageNamed:@"deal_print_press(1).png"] forState:UIControlStateHighlighted];
    [self addSubview:_dealButton];
    
    self.printButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _printButton.frame = CGRectMake(_dealButton.left - 90, TOP_SPACE - 5, 80, BUTTON_HEIGHT);
    [_printButton setBackgroundImage:[UIImage imageNamed:@"deal_print_normal(1).png"] forState:UIControlStateNormal];
    [_printButton setTitle:@"打印订单" forState:UIControlStateNormal];
    _printButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_printButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_printButton setBackgroundImage:[UIImage imageNamed:@"deal_print_press(1).png"] forState:UIControlStateHighlighted];
    [self addSubview:_printButton];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
