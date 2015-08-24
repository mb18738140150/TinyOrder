//
//  SwithAccountViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "SwithAccountViewCell.h"
#import "AccountModel.h"

#define SPACE 10
#define IMAGEVIEW_WIDTH 40
#define DETAILLB_WIDTH 100
#define VIEW_COLOR [UIColor clearColor]
//#define VIEW_COLOR [UIColor orangeColor]

@interface SwithAccountViewCell ()

@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic, strong)UILabel * titleLable;
@property (nonatomic, strong)UILabel * detailLabel;

@end



@implementation SwithAccountViewCell





- (void)createSUbViewAndSwith:(CGRect)frame
{
    if (!_titleImageView) {
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
        _titleImageView.backgroundColor = VIEW_COLOR;
        [self addSubview:_titleImageView];
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_titleImageView.right + SPACE, _titleImageView.top, frame.size.width - 3 * SPACE - IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
        _titleLable.backgroundColor = VIEW_COLOR;
        [self addSubview:_titleLable];
        self.isBusinessSW = [[UISwitch alloc] initWithFrame:CGRectMake(frame.size.width -  DETAILLB_WIDTH / 4 * 3 - SPACE, SPACE + 5, DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
        _isBusinessSW.tintColor = [UIColor grayColor];
        _isBusinessSW.on = NO;
        [self addSubview:_isBusinessSW];
    }
}


- (void)setAccountModel:(AccountModel *)accountModel
{
    _accountModel = accountModel;
    _titleLable.text = accountModel.title;
    if (_detailLabel) {
        _detailLabel.text = accountModel.detail;
        NSLog(@"%@", _detailLabel.text);
    }
    if (_isBusinessSW) {
        if ([accountModel.state intValue] == 1) {
            _isBusinessSW.on = YES;
        }else
        {
            _isBusinessSW.on = NO;
        }
    }
    _titleImageView.image = [UIImage imageNamed:accountModel.iconName];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
