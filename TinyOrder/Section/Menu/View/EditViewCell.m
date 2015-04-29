//
//  EditViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "EditViewCell.h"
#import "MenuModel.h"
#import "UIViewAdditions.h"

//#define LABEL_COLOR [UIColor magentaColor]
#define LABEL_COLOR [UIColor clearColor]
#define LABEL_HEIGHT 30
#define SPACE 20//左边间距
#define TOP_SPACE 10
#define BUTTON_WIDTH 40

//#define LABEL_WIDTH (CELL_WIDTH - SPACE * 4) / 2
#define LABEL_WIDTH frame.size.width - SPACE * 4 - 2 * BUTTON_WIDTH

@interface EditViewCell ()


@property (nonatomic, strong)UILabel * menuNameLB;
@property (nonatomic, strong)UILabel * activityTitilLB;



@end


@implementation EditViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self createSubViews];
    }
    return self;
}



- (void)createSubViews:(CGRect)frame
{
    if (!_menuNameLB) {
        self.menuNameLB = [[UILabel alloc] initWithFrame:CGRectMake(SPACE, TOP_SPACE, LABEL_WIDTH, LABEL_HEIGHT)];
        
        _menuNameLB.backgroundColor = LABEL_COLOR;
        [self addSubview:_menuNameLB];
        self.activityTitilLB = [[UILabel alloc] initWithFrame:CGRectMake(_menuNameLB.left, _menuNameLB.bottom + TOP_SPACE, _menuNameLB.width, LABEL_HEIGHT)];
        _activityTitilLB.backgroundColor = LABEL_COLOR;
        [self addSubview:_activityTitilLB];
        self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _editButton.frame = CGRectMake(_menuNameLB.right + SPACE, TOP_SPACE, BUTTON_WIDTH, _activityTitilLB.bottom - _menuNameLB.top);
        _editButton.backgroundColor = LABEL_COLOR;
        _editButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.4];
        _editButton.layer.borderWidth = 0.5;
        _editButton.layer.cornerRadius = 5;
        _editButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.7].CGColor;
//        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self addSubview:_editButton];
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteButton.backgroundColor = LABEL_COLOR;
        _deleteButton.frame = CGRectMake(_editButton.right + SPACE, _editButton.top, _editButton.width, _editButton.height);
        _deleteButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.4];
        _deleteButton.layer.borderWidth = 0.5;
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.7].CGColor;
//        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        UIImageView * deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, _editButton.height / 2)];
        deleteImageView.image = [UIImage imageNamed:@"delete.png"];
        [_deleteButton addSubview:deleteImageView];
        UILabel * deleteLB = [[UILabel alloc] initWithFrame:CGRectMake(0, deleteImageView.bottom, BUTTON_WIDTH, _editButton.height / 2)];
        deleteLB.text = @"删除";
        deleteLB.textAlignment = NSTextAlignmentCenter;
//        deleteLB.font = [UIFont systemFontOfSize:14];
        [_deleteButton addSubview:deleteLB];
        UIImageView * editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, _editButton.height / 2)];
        editImageView.image = [UIImage imageNamed:@"edit.png"];
        [_editButton addSubview:editImageView];
        UILabel * editLB = [[UILabel alloc] initWithFrame:CGRectMake(0, editImageView.bottom, BUTTON_WIDTH, _editButton.height / 2)];
        editLB.text = @"编辑";
        editLB.textAlignment = NSTextAlignmentCenter;
//        editLB.font = [UIFont systemFontOfSize:14];
        [_editButton addSubview:editLB];
    }
}

+ (CGFloat)cellHeight
{
    return TOP_SPACE * 3 + LABEL_HEIGHT * 2;
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
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _editButton.frame = CGRectMake(_menuNameLB.right + SPACE, SPACE, (_menuNameLB.width - 3 * SPACE) / 2, _activityTitilLB.bottom - _menuNameLB.top);
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self addSubview:_editButton];
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteButton.frame = CGRectMake(_editButton.right + SPACE, _editButton.top, _editButton.width, _editButton.height);
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    NSLog(@"%g", CELL_WIDTH);

//    CGRect rect = [[UIScreen mainScreen] bounds];
//    NSLog(@"%@", rect.size.width);
}
*/

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
