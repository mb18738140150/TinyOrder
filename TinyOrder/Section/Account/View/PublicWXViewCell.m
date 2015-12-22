//
//  PublicWXViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/31.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PublicWXViewCell.h"
#import "PublicNumModel.h"

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

@property (nonatomic, strong)UILabel * isDeliveryLabel;

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
        
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, WINDOW_WIDHT - 4 * LEFT_SPACE - CENTER_LB_WIDTH - BUTTON_WIDTH - 60, 30)];
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
        
        self.isDeliveryLabel = [[UILabel alloc]initWithFrame:CGRectMake(_commissionLB.left - 60, _commissionLB.top, 40, _commissionLB.height)];
        _isDeliveryLabel.text = @"是";
        _isDeliveryLabel.textAlignment = NSTextAlignmentCenter;
        _isDeliveryLabel.font = TEXT_FONT;
        _isDeliveryLabel.textColor = TEXT_COLOR;
        [view addSubview:_isDeliveryLabel];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(_commissionLB.right + 9, _commissionLB.top, 1, _commissionLB.height)];
        line.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        [view addSubview:line];
        
        self.applyBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBT.frame = CGRectMake(line.right, _commissionLB.top, BUTTON_WIDTH, _nameLB.height);
        _applyBT.backgroundColor = VIEW_COLOR;
        [_applyBT setTitle:@"申请入驻" forState:UIControlStateNormal];
        [_applyBT setTitleColor:[UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1] forState:UIControlStateNormal];
//        [_applyBT setImage:[UIImage imageNamed:@"checkInWX_n.png"] forState:UIControlStateNormal];
        _applyBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _applyBT.titleLabel.font = TEXT_FONT;
        [view addSubview:_applyBT];
        
        
    }
}

- (void)setPublicNumMD:(PublicNumModel *)publicNumMD
{
    _publicNumMD = publicNumMD;
    
    self.nameLB.text = publicNumMD.numName;
    self.commissionLB.text = [NSString stringWithFormat:@"%@%%", publicNumMD.numCommission];
    
    if (publicNumMD.isDelivery == 0) {
        self.isDeliveryLabel.text = @"否";
    }else
    {
        self.isDeliveryLabel.text = @"是";
    }
    
    if ([publicNumMD.isApply isEqualToNumber:@1]) {
        if ([publicNumMD.numState isEqual:[NSNull null]]) {
            [_applyBT setTitle:@"申请入驻" forState:UIControlStateNormal];
            [_applyBT setTitleColor:[UIColor colorWithRed:35 / 255.0 green:210 / 255.0 blue:134 / 255.0 alpha:1] forState:UIControlStateNormal];
            [_applyBT setImage:[UIImage imageNamed:@"checkInWX_n.png"] forState:UIControlStateNormal];
        }else if ([publicNumMD.numState isEqualToNumber:@0])
        {
            [_applyBT setTitle:@"退出申请" forState:UIControlStateNormal];
            [_applyBT setTitleColor:[UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1] forState:UIControlStateNormal];
            [_applyBT setImage:[UIImage imageNamed:@"checkIn_i.png"] forState:UIControlStateNormal];
        }else if ([publicNumMD.numState isEqualToNumber:@1])
        {
            [_applyBT setTitle:@"退出加盟" forState:UIControlStateNormal];
            [_applyBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_applyBT setImage:[UIImage imageNamed:@"checkInWX_d.png"] forState:UIControlStateNormal];
        }else if ([publicNumMD.numState isEqualToNumber:@2])
        {
            [_applyBT setTitle:@"查看原因" forState:UIControlStateNormal];
            [_applyBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_applyBT setImage:[UIImage imageNamed:@"checkInWX_d.png"] forState:UIControlStateNormal];
        }
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
