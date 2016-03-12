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
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:lineView];
    
//    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 2*DEALBUTTON_WIDTH - PRICELABEL_WIDTH - 40 , TOP_SPACE, 40, LABEL_HEIGHT)];
//    _totalLabel.text = @"总¥";
//    _totalLabel.textAlignment = NSTextAlignmentRight;
//    _totalLabel.font = [UIFont systemFontOfSize:14];
//    _totalLabel.textColor = [UIColor grayColor];
//    [self addSubview:_totalLabel];
    self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, TOP_SPACE, self.width - 2 * DEALBUTTON_WIDTH - 40 - 5 + 10, LABEL_HEIGHT)];
    _totalPriceLabel.text = @"¥24";
    _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
    _totalPriceLabel.textColor = [UIColor grayColor];
    _totalPriceLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_totalPriceLabel];
    
    self.dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dealButton.frame = CGRectMake(_totalPriceLabel.right + 90, 0, DEALBUTTON_WIDTH, self.height);
//    [_dealButton setBackgroundImage:[UIImage imageNamed:@"deal_print_normal(1).png"] forState:UIControlStateNormal];
    [_dealButton setTitle:@"标记餐已送出" forState:UIControlStateNormal];
//    _dealButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _dealButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _dealButton.backgroundColor = BACKGROUNDCOLOR;
    [_dealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_dealButton setBackgroundImage:[UIImage imageNamed:@"deal_print_press(1).png"] forState:UIControlStateHighlighted];
    [self addSubview:_dealButton];
    
    self.printButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _printButton.frame = CGRectMake(_dealButton.left - 90, 0, 90, self.height);
//    [_printButton setBackgroundImage:[UIImage imageNamed:@"deal_print_normal(1).png"] forState:UIControlStateNormal];
    [_printButton setTitle:@"打印订单" forState:UIControlStateNormal];
//    _printButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _printButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _printButton.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [_printButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_printButton setBackgroundImage:[UIImage imageNamed:@"deal_print_press(1).png"] forState:UIControlStateHighlighted];
    [self addSubview:_printButton];
    
    self.detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailsButton.frame = CGRectMake(_dealButton.right , 0, 40, self.height);
    [_detailsButton setTitle:@"详情" forState:UIControlStateNormal];
    [_detailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _detailsButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _detailsButton.backgroundColor = [UIColor redColor];
    [self addSubview:_detailsButton];
    
}

- (void)setMoneyStr:(NSString *)moneyStr
{
    NSString * moneyString = moneyStr;
    if ([moneyString containsString:@"."]) {
        NSArray * monerArr = [moneyString componentsSeparatedByString:@"."];
        NSString * monryStr1 = [monerArr objectAtIndex:0];
        NSString * moneyStr2 = [monerArr objectAtIndex:1];
        if (moneyStr2.length > 2) {
            NSString * moneyStr3 = [moneyStr2 substringToIndex:2];
            NSString * moneyString1 = [NSString stringWithFormat:@"总¥%@.%@", monryStr1, moneyStr3];
            NSString * moneyString2 = [NSString stringWithFormat:@"%@.%@", monryStr1, moneyStr3];
            NSMutableAttributedString * moneyStrmt = [[NSMutableAttributedString alloc]initWithString:moneyString1];
            [moneyStrmt addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:BACKGROUNDCOLOR} range:NSMakeRange(2, moneyString2.length)];
            self.totalPriceLabel.attributedText = moneyStrmt;
        }else
        {
            NSString * moneyString1 = [NSString stringWithFormat:@"总¥%@", moneyStr];
            NSMutableAttributedString * moneyStrmt = [[NSMutableAttributedString alloc]initWithString:moneyString1];
            [moneyStrmt addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:BACKGROUNDCOLOR} range:NSMakeRange(2, moneyString.length)];
            self.totalPriceLabel.attributedText = moneyStrmt;
        }
    }else
    {
        NSString * str = [NSString stringWithFormat:@"总¥%@", moneyStr];
        NSMutableAttributedString * moneyStrmt = [[NSMutableAttributedString alloc]initWithString:str];
        [moneyStrmt addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:BACKGROUNDCOLOR} range:NSMakeRange(2, moneyString.length)];
        self.totalPriceLabel.attributedText = moneyStrmt;
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
