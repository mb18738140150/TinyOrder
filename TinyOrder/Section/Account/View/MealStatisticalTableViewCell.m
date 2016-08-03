//
//  MealStatisticalTableViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MealStatisticalTableViewCell.h"
#import "MealStatisticalModel.h"

#define LEFTSPACE 15
#define TOPSPACE 20
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface MealStatisticalTableViewCell ()

@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * saleCountLB;
@property (nonatomic, strong)UILabel * moneyLB;

@end

@implementation MealStatisticalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFTSPACE, TOPSPACE, self.width - 2 * LEFTSPACE, 15)];
    self.nameLabel.textColor = RGBCOLOR(102, 102, 102);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    
    self.saleCountLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFTSPACE, self.nameLabel.bottom + TOPSPACE / 2, 30, 13)];
    self.saleCountLB.textColor = RGBCOLOR(102, 102, 102);
    self.saleCountLB.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.saleCountLB];
    
    self.moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 2 * LEFTSPACE, self.nameLabel.bottom + TOPSPACE / 5, LEFTSPACE, 20)];
    self.moneyLB.textColor = RGBCOLOR(102, 102, 102);
    self.moneyLB.font = [UIFont systemFontOfSize:12];
    self.moneyLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.moneyLB];
}

- (void)setMealStatisticalModel:(MealStatisticalModel *)mealStatisticalModel
{
    self.nameLabel.text = mealStatisticalModel.mealName;
    self.saleCountLB.text = [NSString stringWithFormat:@"销量：%@", mealStatisticalModel.saleCount];
    CGSize saleLBsize = [self.saleCountLB.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.saleCountLB.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    self.saleCountLB.width = saleLBsize.width;
    
    NSDictionary * moneyDic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:BACKGROUNDCOLOR};
    NSString * moneyStr = [NSString stringWithFormat:@"总金额￥%@", mealStatisticalModel.money];
    CGSize moneyLBsize = [moneyStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.saleCountLB.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    self.moneyLB.frame = CGRectMake(self.width - LEFTSPACE - moneyLBsize.width, self.nameLabel.bottom + TOPSPACE / 5, moneyLBsize.width, 20);
    self.moneyLB.width = moneyLBsize.width;
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:moneyStr];
    [str setAttributes:moneyDic range:NSMakeRange(3, moneyStr.length - 3)];
    
    self.moneyLB.attributedText = str;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
