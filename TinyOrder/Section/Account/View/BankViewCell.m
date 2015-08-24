//
//  BankViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "BankViewCell.h"
#import "BankCarModel.h"


#define LEFT_SPACE 20
#define TOP_SPACE 10
#define LABEL_HEIGHT 20
#define RIGHT_LB_WIDTH 60
#define NAME_LB_WIDTH 200

@interface BankViewCell ()

@property (nonatomic, strong)UILabel * bankNameLB;
@property (nonatomic, strong)UILabel * tailNumberLB;
@property (nonatomic, strong)UILabel * carTypyLB;


@end


@implementation BankViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubview];
    }
    return self;
}


- (void)createSubview
{
    self.bankNameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, NAME_LB_WIDTH, LABEL_HEIGHT)];
    _bankNameLB.text = @"中国工商银行";
    [self.contentView addSubview:_bankNameLB];
    
    self.tailNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(_bankNameLB.left, _bankNameLB.bottom, _bankNameLB.width - LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _tailNumberLB.text = @"尾号0834";
    _tailNumberLB.font = [UIFont systemFontOfSize:14];
    _tailNumberLB.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.contentView addSubview:_tailNumberLB];
    
//    self.carTypyLB = [[UILabel alloc] initWithFrame:CGRectMake(_tailNumberLB.right + LEFT_SPACE, _tailNumberLB.top, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
//    _carTypyLB.textColor = [UIColor colorWithWhite:0.8 alpha:1];
//    _carTypyLB.font = [UIFont systemFontOfSize:14];
//    _carTypyLB.text = @"储蓄卡";
//    [self.contentView addSubview:_carTypyLB];
}


+ (CGFloat)cellHeight
{
    return 2 * TOP_SPACE + 2 * LABEL_HEIGHT;
}


- (void)setBankCarMD:(BankCarModel *)bankCarMD
{
    _bankCarMD = bankCarMD;
    self.bankNameLB.text = bankCarMD.bankCardName;
    self.tailNumberLB.text = [NSString stringWithFormat:@"尾号%@", [bankCarMD.bankCardNumber substringFromIndex:bankCarMD.bankCardNumber.length - 4]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
