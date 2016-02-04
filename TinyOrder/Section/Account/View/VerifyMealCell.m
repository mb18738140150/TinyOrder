//
//  VerifyMealCell.m
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyMealCell.h"
#import "VerifyMealModel.h"
#import <UIImageView+WebCache.h>

#define TOP_SPACE 10
#define LEFT_SPACE 10
#define LABEL_HEIGHT 30


@interface VerifyMealCell ()

@property (nonatomic, strong)UIImageView * iconImageview;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * countLabel;

@end

@implementation VerifyMealCell

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
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 80, 60)];
    [self addSubview:self.iconImageview];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageview.right + 10, _iconImageview.top, self.width - 2 * LEFT_SPACE - _iconImageview.width - 50, LABEL_HEIGHT)];
    [self addSubview:_nameLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 5, _nameLabel.width, LABEL_HEIGHT - 5)];
    self.priceLabel.textColor = [UIColor grayColor];
    [self addSubview:_priceLabel];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - LEFT_SPACE - 40, 25, 40, LABEL_HEIGHT)];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.textColor = [UIColor redColor];
    [self addSubview:_countLabel];
    
}

- (void)setVerifymealModel:(VerifyMealModel *)verifymealModel
{
    [self.iconImageview sd_setImageWithURL:[NSURL URLWithString:verifymealModel.foodIcon] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.iconImageview.image = image;
            NSLog(@"请求图片成功");
        }
    }];
    
    self.nameLabel.text = verifymealModel.foodName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", verifymealModel.foodPrice];
    self.countLabel.text = [NSString stringWithFormat:@"%d份", verifymealModel.foodCount];
    
    NSLog(@"verifymealModel.foodName = %@", verifymealModel.foodName);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
