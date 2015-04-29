//
//  AccountViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AccountViewCell.h"
#import "UIViewAdditions.h"
#import "AccountModel.h"


#define SPACE 10
#define IMAGEVIEW_WIDTH 40
#define DETAILLB_WIDTH 100
#define VIEW_COLOR [UIColor clearColor]
//#define VIEW_COLOR [UIColor orangeColor]

@interface AccountViewCell ()


@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic, strong)UILabel * titleLable;
@property (nonatomic, strong)UILabel * detailLabel;


@end



@implementation AccountViewCell


- (void)createSubView:(CGRect)frame
{
    if (!_titleLable) {
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
        _titleImageView.backgroundColor = VIEW_COLOR;
        [self addSubview:_titleImageView];
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_titleImageView.right + SPACE, _titleImageView.top, frame.size.width - 3 * SPACE - IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
        _titleLable.backgroundColor = VIEW_COLOR;
        [self addSubview:_titleLable];
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - DETAILLB_WIDTH - SPACE, SPACE, DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
//        _detailLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:_detailLabel];
        
    }
    
}


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
