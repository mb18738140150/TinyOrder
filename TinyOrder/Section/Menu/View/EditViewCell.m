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
#define LABEL_HEIGHT 50
#define SPACE 20//左边间距
#define TOP_SPACE 10
#define BUTTON_WIDTH 80
#define BUTTON_HEIGHT 70
//#define LABEL_WIDTH (CELL_WIDTH - SPACE * 4) / 2
#define LABEL_WIDTH frame.size.width - SPACE * 2 - 2 * BUTTON_WIDTH

@interface EditViewCell ()


@property (nonatomic, strong)UILabel * menuNameLB;
@property (nonatomic, strong)UILabel * activityTitilLB;



@end


@implementation EditViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        [self createSubViews];
    }
    return self;
}



- (void)createSubViews:(CGRect)frame withIsEdit:(BOOL)isEdit
{
    if (!_menuNameLB) {
        self.menuNameLB = [[UILabel alloc] initWithFrame:CGRectMake(SPACE, TOP_SPACE, LABEL_WIDTH, LABEL_HEIGHT)];
        _menuNameLB.font = [UIFont systemFontOfSize:24];
        _menuNameLB.backgroundColor = LABEL_COLOR;
        [self addSubview:_menuNameLB];
        self.activityTitilLB = [[UILabel alloc] initWithFrame:CGRectMake(_menuNameLB.left, _menuNameLB.bottom + TOP_SPACE, _menuNameLB.width, LABEL_HEIGHT)];
        _activityTitilLB.backgroundColor = LABEL_COLOR;
//        [self addSubview:_activityTitilLB];
        
        self.foodCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 180, _menuNameLB.top, 120, LABEL_HEIGHT)];
        _foodCountLabel.textAlignment = NSTextAlignmentRight;
        _foodCountLabel.textColor = [UIColor grayColor];
        [self addSubview:_foodCountLabel];
        
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _editButton.frame = CGRectMake(_menuNameLB.right + SPACE , 0, BUTTON_WIDTH, BUTTON_HEIGHT);
        _editButton.backgroundColor = [UIColor greenColor];

        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:_editButton];
        
        
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteButton.backgroundColor = [UIColor redColor];
        _deleteButton.frame = CGRectMake(_editButton.right , _editButton.top, _editButton.width, _editButton.height);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:_deleteButton];
        /*
        UIImageView * deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, _editButton.height / 5 * 3)];
        deleteImageView.image = [UIImage imageNamed:@"delete.png"];
        [_deleteButton addSubview:deleteImageView];
        UILabel * deleteLB = [[UILabel alloc] initWithFrame:CGRectMake(0, deleteImageView.bottom, BUTTON_WIDTH, _editButton.height / 5 * 2)];
        deleteLB.text = @"删除";
        deleteLB.textAlignment = NSTextAlignmentCenter;
//        deleteLB.font = [UIFont systemFontOfSize:14];
        [_deleteButton addSubview:deleteLB];
        UIImageView * editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, _editButton.height / 5 * 3)];
        editImageView.image = [UIImage imageNamed:@"edit.png"];
        [_editButton addSubview:editImageView];
        UILabel * editLB = [[UILabel alloc] initWithFrame:CGRectMake(0, editImageView.bottom, BUTTON_WIDTH, _editButton.height / 5 * 2)];
        editLB.text = @"编辑";
        editLB.textAlignment = NSTextAlignmentCenter;
//        editLB.font = [UIFont systemFontOfSize:14];
        [_editButton addSubview:editLB];
         */
    }
    self.deleteButton.hidden = !isEdit;
    self.editButton.hidden = !isEdit;
    self.foodCountLabel.hidden = isEdit;
}

+ (CGFloat)cellHeight
{
    return TOP_SPACE * 2 + LABEL_HEIGHT;
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
    _foodCountLabel.text = [NSString stringWithFormat:@"全部共%d个", menuModel.foodCount];
    if (menuModel.describe.length) {
        _activityTitilLB.text = menuModel.describe;
    }else
    {
        _activityTitilLB.text = @"暂无描述";
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 5, 69);
    CGContextAddLineToPoint(context, self.width - 5, 69);
    CGContextStrokePath(context);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
