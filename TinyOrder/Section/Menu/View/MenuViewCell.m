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
    if (!_menuNameLB) {
        self.menuNameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LABEL_WIDTH, LABEL_HEIGHT)];
        
        _menuNameLB.backgroundColor = LABEL_COLOR;
        [self addSubview:_menuNameLB];
        self.activityTitilLB = [[UILabel alloc] initWithFrame:CGRectMake(_menuNameLB.left, _menuNameLB.bottom, _menuNameLB.width, LABEL_HEIGHT)];
        _activityTitilLB.backgroundColor = LABEL_COLOR;
        [self addSubview:_activityTitilLB];
    }
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
    _activityTitilLB.text = menuModel.describe;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
