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
#define LEFTSPACE 10
#define ICONVIEW_WIDTH 60
#define ICON_WIDTH 30
#define VIEW_COLOR [UIColor clearColor]
#define VIEW_COLOR_2 [UIColor clearColor]
#define RIGHTLB_WIDTH 60
#define LABEL_HEIGHT 20


@interface RevenueViewCell ()

@property (nonatomic, copy)DetailesBlock detailesBlock;

@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * dataLabel;
@property (nonatomic, strong)UILabel * rmbLabel;
@property (nonatomic, strong)UILabel * stateLabel;

@property (nonatomic, strong)UIButton * detailesBT;

@end


@implementation RevenueViewCell


- (void)createSubView:(CGRect)frame
{
    if (!_iconView) {
        UIView * photoView = [[UIView alloc] initWithFrame:CGRectMake(LEFTSPACE , SPACE, ICONVIEW_WIDTH, ICONVIEW_WIDTH)];
        photoView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.7];
        [self addSubview:photoView];
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICONVIEW_WIDTH, ICONVIEW_WIDTH)];
        _iconView.center = CGPointMake(ICONVIEW_WIDTH / 2, ICONVIEW_WIDTH / 2);
        _iconView.backgroundColor = VIEW_COLOR;
        [photoView addSubview:_iconView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView.right + LEFTSPACE, SPACE, frame.size.width - ICONVIEW_WIDTH - 3 * LEFTSPACE - RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _titleLabel.backgroundColor = VIEW_COLOR;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView.right + LEFTSPACE, _titleLabel.bottom, frame.size.width - ICONVIEW_WIDTH - 3 * LEFTSPACE - RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _dataLabel.backgroundColor = VIEW_COLOR_2;
        _dataLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_dataLabel];
        
        self.rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 5, SPACE, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _rmbLabel.backgroundColor = VIEW_COLOR_2;
        _rmbLabel.adjustsFontSizeToFitWidth = YES;
//        _rmbLabel.text = @"+¥2000.55";
        _rmbLabel.textAlignment = NSTextAlignmentRight;
        _rmbLabel.textColor = BACKGROUNDCOLOR;
        [self addSubview:_rmbLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 5, _titleLabel.bottom, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _stateLabel.backgroundColor = VIEW_COLOR;
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_stateLabel];
        
        self.detailesBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailesBT.frame = CGRectMake(photoView.right + LEFTSPACE, _dataLabel.bottom, 80, LABEL_HEIGHT);
        [_detailesBT setTitle:@"查看详情" forState:UIControlStateNormal];
        _detailesBT.titleLabel.font = [UIFont systemFontOfSize:14];
//        _detailesBT.titleLabel.textAlignment = NSTextAlignmentLeft;
        _detailesBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 四个参数为距离上左下右边界的距离
        _detailesBT.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_detailesBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_detailesBT addTarget:self action:@selector(detailsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_detailesBT];
        _detailesBT.hidden = YES;
        
    }
}


- (void)setRevewnueMD:(RevewnueModel *)revewnueMD
{
    _revewnueMD = revewnueMD;
    
    if (revewnueMD.orderId.length != 0) {
        
        NSString *string = [revewnueMD.orderId substringToIndex:1];
        string = [string lowercaseString];
//        NSLog(@"first = %@", string);
        
        
        if ([string isEqualToString:@"v"]) {
            self.iconView.image = [UIImage imageNamed:@"vpay_log_icon.png"];
            _detailesBT.hidden = NO;
        }else if ([string isEqualToString:@"z"])
        {
            self.iconView.image = [UIImage imageNamed:@"takeout_log_icon.png"];
            _detailesBT.hidden = NO;
        }else if ([string isEqualToString:@"e"])
        {
            self.iconView.image = [UIImage imageNamed:@"tangshi_log_icon.png"];
            _detailesBT.hidden = NO;
        }else if ([string isEqualToString:@"m"])
        {
            self.iconView.image = [UIImage imageNamed:@"vip.png"];
            _detailesBT.hidden = YES;
        }else if ([string isEqualToString:@"h"])
        {
            self.iconView.image = [UIImage imageNamed:@"hotel.png"];
            _detailesBT.hidden = YES;
        }else
        {
            self.iconView.image = [UIImage imageNamed:@"bank_money_log.png"];
            _detailesBT.hidden = YES;
        }
    }else
    {
            self.iconView.image = [UIImage imageNamed:@"bank_money_log.png"];
        _detailesBT.hidden = YES;
    }
    
    
//    if ([revewnueMD.type intValue] == 1) {
//        self.iconView.image = [UIImage imageNamed:@"account_1.png"];
//    }else if([revewnueMD.type intValue] == 0)
//    {
//        self.iconView.image = [UIImage imageNamed:@"bank.png"];
//    }
    self.titleLabel.text = revewnueMD.actionName;
    self.dataLabel.text = revewnueMD.date;
    
    if (revewnueMD.orderId.length != 0) {
        NSString * moneystr = [NSString stringWithFormat:@"%@", revewnueMD.money];
        if ([moneystr containsString:@"."]) {
            
            NSArray * monerArr = [moneystr componentsSeparatedByString:@"."];
            NSString * monryStr1 = [monerArr objectAtIndex:0];
            NSString * moneyStr2 = [monerArr objectAtIndex:1];
            
            if (moneyStr2.length > 2) {
                NSString * moneyStr3 = [moneyStr2 substringToIndex:2];
                self.rmbLabel.text = [NSString stringWithFormat:@"+¥%@.%@", monryStr1, moneyStr3];
            }else
            {
                self.rmbLabel.text = [NSString stringWithFormat:@"+¥%@.%@", monryStr1, moneyStr2];
            }
        }else
        {
            self.rmbLabel.text = [NSString stringWithFormat:@"+¥%@", revewnueMD.money];
        }
    }else
    {
        if (revewnueMD.type.intValue == 0 || revewnueMD.type.intValue == 2) {
            NSString * moneystr = [NSString stringWithFormat:@"%@", revewnueMD.money];
            if ([moneystr containsString:@"."]) {
                
                NSArray * monerArr = [moneystr componentsSeparatedByString:@"."];
                NSString * monryStr1 = [monerArr objectAtIndex:0];
                NSString * moneyStr2 = [monerArr objectAtIndex:1];
                
                if (moneyStr2.length > 2) {
                    NSString * moneyStr3 = [moneyStr2 substringToIndex:2];
                    self.rmbLabel.text = [NSString stringWithFormat:@"-¥%@.%@", monryStr1, moneyStr3];
                }else
                {
                    self.rmbLabel.text = [NSString stringWithFormat:@"-¥%@.%@", monryStr1, moneyStr2];
                }
            }else
            {
                self.rmbLabel.text = [NSString stringWithFormat:@"-¥%@", revewnueMD.money];
            }
        }else
        {
            NSString * moneystr = [NSString stringWithFormat:@"%@", revewnueMD.money];
            if ([moneystr containsString:@"."]) {
                
                NSArray * monerArr = [moneystr componentsSeparatedByString:@"."];
                NSString * monryStr1 = [monerArr objectAtIndex:0];
                NSString * moneyStr2 = [monerArr objectAtIndex:1];
                
                if (moneyStr2.length > 2) {
                    NSString * moneyStr3 = [moneyStr2 substringToIndex:2];
                    self.rmbLabel.text = [NSString stringWithFormat:@"+¥%@.%@", monryStr1, moneyStr3];
                }else
                {
                    self.rmbLabel.text = [NSString stringWithFormat:@"+¥%@.%@", monryStr1, moneyStr2];
                }
            }else
            {
                self.rmbLabel.text = [NSString stringWithFormat:@"+¥%@", revewnueMD.money];
            }
        }
    }
    
    
    
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

- (void)orderdetailes:(DetailesBlock)detailesBlock
{
    _detailesBlock = [detailesBlock copy];
}

- (void)detailsAction:(UIButton *)button
{
    NSString *string = [_revewnueMD.orderId substringToIndex:1];
    string = [string lowercaseString];
    NSLog(@"first = %@", string);
    
    if ([string isEqualToString:@"z"])
    {
        _detailesBlock(@"z");
    }else if ([string isEqualToString:@"e"])
    {
        _detailesBlock(@"e");
    }else if ([string isEqualToString:@"v"]) {
        _detailesBlock(@"v");
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
