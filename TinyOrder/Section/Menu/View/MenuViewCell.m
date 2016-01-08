//
//  MenuViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenuViewCell.h"
#import "UIViewAdditions.h"
#import "MenuModel.h"


//#define LABEL_COLOR [UIColor magentaColor]
#define LABEL_COLOR [UIColor clearColor]
#define LABEL_HEIGHT 30
#define LEFT_SPACE 20
#define TOP_SPACE 10
//#define LABEL_WIDTH self.frame.size.width / 2
#define LABEL_WIDTH (frame.size.width - LEFT_SPACE * 4) / 2
#define CELL_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MenuViewCell ()


@property (nonatomic, strong)UILabel * menuNameLB;
@property (nonatomic, strong)UILabel * activityTitilLB;
@property (nonatomic, strong)UILabel * foodCountLabel;


@end


@implementation MenuViewCell





- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        [self createSubViews];
    }
    return self;
}

- (void)createSubViews:(CGRect)frame
{
    [self removeAllSubviews];
    
        self.menuNameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LABEL_WIDTH, LABEL_HEIGHT)];
        _menuNameLB.font = [UIFont systemFontOfSize:24];
        _menuNameLB.backgroundColor = LABEL_COLOR;
        [self addSubview:_menuNameLB];
        
        self.foodCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 120, _menuNameLB.top , 80, LABEL_HEIGHT)];
        _foodCountLabel.font = [UIFont systemFontOfSize:20];
        _foodCountLabel.textColor = [UIColor grayColor];
        _foodCountLabel.backgroundColor = LABEL_COLOR;
        _foodCountLabel.alpha = .8;
        [self addSubview:_foodCountLabel];
        
        self.activityTitilLB = [[UILabel alloc] initWithFrame:CGRectMake(_menuNameLB.left, _menuNameLB.bottom, _menuNameLB.width, LABEL_HEIGHT)];
        _activityTitilLB.backgroundColor = LABEL_COLOR;
        [self addSubview:_activityTitilLB];
    

}

/*
- (void)createSubViews
{
    self.menuNameLB = [[UILabel alloc] initWithFrame:CGRectMake(SPACE, SPACE, LABEL_WIDTH, LABEL_HEIGHT)];
    _menuNameLB.backgroundColor = LABEL_COLOR;
    [self addSubview:_menuNameLB];
    self.activityTitilLB = [[UILabel alloc] initWithFrame:CGRectMake(_menuNameLB.left, _menuNameLB.bottom + SPACE, _menuNameLB.width, LABEL_HEIGHT)];
    _activityTitilLB.backgroundColor = LABEL_COLOR;
    [self addSubview:_activityTitilLB];
}
*/


+ (CGFloat)cellHeight
{
    return LABEL_HEIGHT * 2 + TOP_SPACE * 2;
}

- (void)setMenuModel:(MenuModel *)menuModel
{
    _menuModel = menuModel;
    _menuNameLB.text = menuModel.name;
    
    if (menuModel.foodCount == 0) {
        _foodCountLabel.text = @"暂无商品";
    }else
    {
        _foodCountLabel.text = [NSString stringWithFormat:@"全部共%d个", menuModel.foodCount];
    }
    
    if (menuModel.describe.length) {
        _activityTitilLB.text = menuModel.describe;
    }else
    {
        _activityTitilLB.text = @"暂无描述";
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
