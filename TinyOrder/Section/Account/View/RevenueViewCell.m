//
//  RevenueViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "RevenueViewCell.h"
#import "UIViewAdditions.h"
#import "RevewnueModel.h"

#define SPACE 15
#define ICONVIEW_WIDTH 60
#define ICON_WIDTH 30
#define VIEW_COLOR [UIColor clearColor]
#define VIEW_COLOR_2 [UIColor clearColor]
#define RIGHTLB_WIDTH 50
#define LABEL_HEIGHT 30


@interface RevenueViewCell ()

@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * dataLabel;
@property (nonatomic, strong)UILabel * rmbLabel;
@property (nonatomic, strong)UILabel * stateLabel;

@end


@implementation RevenueViewCell


- (void)createSubView:(CGRect)frame
{
    if (!_iconView) {
        UIView * photoView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, SPACE, ICONVIEW_WIDTH, ICONVIEW_WIDTH)];
        photoView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.7];
        [self addSubview:photoView];
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICONVIEW_WIDTH, ICONVIEW_WIDTH)];
        _iconView.center = CGPointMake(ICONVIEW_WIDTH / 2, ICONVIEW_WIDTH / 2);
        _iconView.backgroundColor = VIEW_COLOR;
        [photoView addSubview:_iconView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView.right + SPACE, SPACE, frame.size.width - ICONVIEW_WIDTH - 3 * SPACE - RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _titleLabel.backgroundColor = VIEW_COLOR;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView.right + SPACE, _titleLabel.bottom, frame.size.width - ICONVIEW_WIDTH - 3 * SPACE - RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _dataLabel.backgroundColor = VIEW_COLOR_2;
        _dataLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_dataLabel];
        
        self.rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + SPACE, SPACE, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _rmbLabel.backgroundColor = VIEW_COLOR_2;
        [self addSubview:_rmbLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + SPACE, _titleLabel.bottom, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _stateLabel.backgroundColor = VIEW_COLOR;
        _stateLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_stateLabel];
    }
}


- (void)setRevewnueMD:(RevewnueModel *)revewnueMD
{
    _revewnueMD = revewnueMD;
    
    NSString *string = [revewnueMD.orderId substringToIndex:1];
    string = [string lowercaseString];
    NSLog(@"first = %@", string);
    
    
    if ([string isEqualToString:@"v"]) {
        self.iconView.image = [UIImage imageNamed:@"vpay_log_icon.png"];
    }else if ([string isEqualToString:@"z"])
    {
        self.iconView.image = [UIImage imageNamed:@"takeout_log_icon.png"];
    }else if ([string isEqualToString:@"e"])
    {
        self.iconView.image = [UIImage imageNamed:@"tangshi_log_icon.png"];
    }else if ([string isEqualToString:@"m"])
    {
        self.iconView.image = [UIImage imageNamed:@"vip.png"];
    }else if ([string isEqualToString:@"h"])
    {
        self.iconView.image = [UIImage imageNamed:@"hotel.png"];
    }else
    {
        self.iconView.image = [UIImage imageNamed:@"bank_money_log.png"];
    }
    
//    if ([revewnueMD.type intValue] == 1) {
//        self.iconView.image = [UIImage imageNamed:@"account_1.png"];
//    }else if([revewnueMD.type intValue] == 0)
//    {
//        self.iconView.image = [UIImage imageNamed:@"bank.png"];
//    }
    self.titleLabel.text = revewnueMD.actionName;
    self.dataLabel.text = revewnueMD.date;
    self.rmbLabel.text = [NSString stringWithFormat:@"¥%@", revewnueMD.money];
    switch ([revewnueMD.state intValue]) {
        case 0:
        {
            self.stateLabel.text = @"未到账";
        }
            break;
        case 1:
        {
            self.stateLabel.text = @"已到账";
        }
            break;
        case 2:
        {
            self.stateLabel.text = @"失败";
        }
            break;
            
        default:
            break;
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
