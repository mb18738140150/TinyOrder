//
//  TotalViw.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TotalViw.h"
#import "UIViewAdditions.h"

//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]



#define PRICELABEL_WIDTH 80
#define TOP_SPACE 15
#define LABEL_HEIGHT 30
#define LEFT_SPACE 10
#define BUTTON_HEIGHT 40
#define DEALBUTTON_WIDTH 100


@implementation TotalViw


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
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 2 * DEALBUTTON_WIDTH - PRICELABEL_WIDTH - 40, TOP_SPACE, 40, LABEL_HEIGHT)];
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
    
    self.nulliyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nulliyButton.frame = CGRectMake(_totalPriceLabel.right,  TOP_SPACE - 5, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    _nulliyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nulliyButton setTitle:@"拒绝接单" forState:UIControlStateNormal];
    [_nulliyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _nulliyButton.layer.cornerRadius = 7;
//    _nulliyButton.layer.borderWidth = 0.6;
//    _nulliyButton.layer.borderColor = [UIColor grayColor].CGColor;
//    _nulliyButton.layer.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:239 / 255.0 blue:237 / 255.0 alpha:1].CGColor;
    [_nulliyButton setBackgroundImage:[UIImage imageNamed:@"refuse_btn_normal.png"] forState:UIControlStateNormal];
    [_nulliyButton setBackgroundImage:[UIImage imageNamed:@"refuse_btn_press.png"] forState:UIControlStateHighlighted];
    [self addSubview:_nulliyButton];
    
    self.dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dealButton.frame = CGRectMake(_nulliyButton.right + 10, TOP_SPACE - 5, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    [_dealButton setBackgroundImage:[UIImage imageNamed:@"deal_print_normal(1).png"] forState:UIControlStateNormal];
    [_dealButton setTitle:@"处理并打印" forState:UIControlStateNormal];
    [_dealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _dealButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_dealButton setBackgroundImage:[UIImage imageNamed:@"deal_print_press(1).png"] forState:UIControlStateHighlighted];
    [self addSubview:_dealButton];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
