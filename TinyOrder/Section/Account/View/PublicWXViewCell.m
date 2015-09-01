//
//  PublicWXViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/31.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PublicWXViewCell.h"


#define LEFT_SPACE 10
#define TOP_SPACE 10


#define BUTTON_WIDTH 90

#define CENTER_LB_WIDTH 50

#define TEXT_COLOR [UIColor colorWithWhite:0.3 alpha:1]

//#define VIEW_COLOR [UIColor greenColor]
#define VIEW_COLOR [UIColor clearColor]

#define TEXT_FONT [UIFont systemFontOfSize:14]

@interface PublicWXViewCell ()


@property (nonatomic, strong)UILabel * nameLB;

@property (nonatomic, strong)UILabel * commissionLB;

@property (nonatomic, strong)UIButton * applyBT;


@end



@implementation PublicWXViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:247 / 255.0 blue:242 / 255.0 alpha:1];
        [self createSubview];
    }
    return self;
}


- (void)createSubview
{
    if (!_nameLB) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, WINDOW_WIDHT, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, WINDOW_WIDHT - 4 * LEFT_SPACE - CENTER_LB_WIDTH - BUTTON_WIDTH, 30)];
        _nameLB.text = @"一世情缘婚恋网";
        _nameLB.textColor = TEXT_COLOR;
//        _nameLB.backgroundColor = [UIColor redColor];
        _nameLB.font = TEXT_FONT;
        _nameLB.backgroundColor = VIEW_COLOR;
        [view addSubview:_nameLB];
        
        
        self.commissionLB = [[UILabel alloc] initWithFrame:CGRectMake(WINDOW_WIDHT - 2 * LEFT_SPACE - BUTTON_WIDTH - CENTER_LB_WIDTH, TOP_SPACE, CENTER_LB_WIDTH, _nameLB.height)];
        _commissionLB.text = @"23%";
        _commissionLB.textColor = TEXT_COLOR;
        _commissionLB.font = TEXT_FONT;
        _commissionLB.textAlignment = NSTextAlignmentRight;
        _commissionLB.backgroundColor = VIEW_COLOR;
        [view addSubview:_commissionLB];
        
        
        self.applyBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBT.frame = CGRectMake(_commissionLB.right + LEFT_SPACE, _commissionLB.top, BUTTON_WIDTH, _nameLB.height);
        _applyBT.backgroundColor = VIEW_COLOR;
        [_applyBT setTitle:@"申请入住" forState:UIControlStateNormal];
        [_applyBT setTitleColor:[UIColor colorWithRed:35 / 255.0 green:210 / 255.0 blue:134 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_applyBT setImage:[UIImage imageNamed:@"checkInWX_n.png"] forState:UIControlStateNormal];
        _applyBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _applyBT.titleLabel.font = TEXT_FONT;
        [view addSubview:_applyBT];
        
        
    }
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
