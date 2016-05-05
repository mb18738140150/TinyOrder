//
//  ItemCollectionViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 16/4/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@implementation ItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.contentView.subviews.count != 0) {
        [self.contentView removeAllSubviews];
    }
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(9, 9, self.width - 18, self.height - 18)];
    self.backView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_backView];
    self.backImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.width - 20, self.height - 20)];
    [self.contentView addSubview:_backImageview];
    self.backImageview.image = [UIImage imageNamed:@""];
//    _backImageview.layer.borderColor = [UIColor grayColor].CGColor;
//    _backImageview.layer.borderWidth = 1;
//    _backImageview.layer.cornerRadius = 5;
//    _backImageview.layer.masksToBounds = YES;
    self.backImageview.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_backImageview.left + 10, _backImageview.height / 2 - 10 + _backImageview.top, _backImageview.width - 30, 20)];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameLabel];
    
}

//- (UIImageView *)backImageview
//{
//    if (!_backImageview) {
//        self.backImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.width - 20, self.height - 20)];
//        [self.contentView addSubview:_backImageview];
//        _backImageview.layer.borderColor = [UIColor grayColor].CGColor;
//        _backImageview.layer.borderWidth = 1;
//        _backImageview.layer.cornerRadius = 5;
//        _backImageview.layer.masksToBounds = YES;
//        self.backImageview.backgroundColor = [UIColor whiteColor];
//    }
//    return _backImageview;
//}
//- (UILabel *)nameLabel
//{
//    if (!_nameLabel) {
//        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_backImageview.left - 10, _backImageview.height / 2 - 20, _backImageview.width - 30, 20)];
//        self.nameLabel.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:_nameLabel];
//    }
//    return _nameLabel;
//}

@end
