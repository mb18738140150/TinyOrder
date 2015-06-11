//
//  DetailsViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsViewCell.h"
#import "UIViewAdditions.h"
#import "DetailModel.h"
#import <UIImageView+WebCache.h>

#define SPACE 10
#define IMAGE_WIDTH 60
#define LABEL_HEIGHT 30
#define RIGHTLB_WIDTH 90
#define STATEIMAGE_WIDTH 60
#define STATEIMAGE_HEIGHT 30
//#define VIEW_COLOR [UIColor colorWithWhite:arc4random() % 256 / 255.0 alpha:1.0]
#define VIEW_COLOR [UIColor clearColor];

@interface DetailsViewCell ()

@property (nonatomic, strong)UIImageView * photoView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * paceLabel;
@property (nonatomic, strong)UILabel * stockNumLabel;
@property (nonatomic, strong)UILabel * saleNumLabel;
@property (nonatomic, strong)UIImageView * stateImageView;


@end


@implementation DetailsViewCell


- (void)createSubView:(CGRect)frame
{
    if (!_nameLabel) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, IMAGE_WIDTH, IMAGE_WIDTH)];
        self.photoView.backgroundColor = VIEW_COLOR;
        [self addSubview:_photoView];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoView.right + SPACE, SPACE, frame.size.width - IMAGE_WIDTH - 3 * SPACE - RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _nameLabel.backgroundColor = VIEW_COLOR;
        [self addSubview:_nameLabel];
        self.paceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, LABEL_HEIGHT)];
        _paceLabel.backgroundColor = VIEW_COLOR;
        [self addSubview:_paceLabel];
        self.stockNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right, SPACE, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _stockNumLabel.backgroundColor = VIEW_COLOR;
//        [self addSubview:_stockNumLabel];
        
        self.saleNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stockNumLabel.left, _stockNumLabel.bottom, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _saleNumLabel.backgroundColor = VIEW_COLOR;
        [self addSubview:_saleNumLabel];
        self.stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.right, SPACE, STATEIMAGE_WIDTH, STATEIMAGE_HEIGHT)];
        _stateImageView.image = [UIImage imageNamed:@"soldout.png"];
        _stateImageView.hidden = YES;
        [self addSubview:_stateImageView];
    }
}

- (void)setDetailModel:(DetailModel *)detailModel
{
    _detailModel = detailModel;
    self.nameLabel.text = detailModel.name;
    self.paceLabel.text = [NSString stringWithFormat:@"价格:¥%@", detailModel.money];
    self.stockNumLabel.text = [NSString stringWithFormat:@"库存:%@份", detailModel.count];
    self.saleNumLabel.text = [NSString stringWithFormat:@"卖出:%@份", detailModel.soldCount];
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:detailModel.icon] placeholderImage:[UIImage imageNamed:@"Icon.png"]];
    if ([detailModel.mealState isEqual:@2]) {
        self.stateImageView.hidden = YES;
    }else
    {
        self.stateImageView.hidden = NO;
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
