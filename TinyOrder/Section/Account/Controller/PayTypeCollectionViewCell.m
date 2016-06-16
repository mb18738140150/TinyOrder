//
//  PayTypeCollectionViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PayTypeCollectionViewCell.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@implementation PayTypeCollectionViewCell
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
    
    self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 10, 5, 5, 5)];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.image = [UIImage imageNamed:@"att_price_icon.png"];
    self.backView.hidden = YES;
    [self.contentView addSubview:_backView];
    
    self.backImageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.width / 4, 10, self.width / 2, self.width / 2)];
    [self.contentView addSubview:_backImageview];
    self.backImageview.image = [UIImage imageNamed:@""];
    self.backImageview.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _backImageview.bottom + 10, self.width - 20, 12)];
    self.nameLabel.textColor = RGBCOLOR(102, 102, 102);
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameLabel];
    
}
@end
