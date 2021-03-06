//
//  DetailEditViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailEditViewCell.h"
#import "UIViewAdditions.h"

#define LEFT_SPACE 30
#define TOP_SPACE 10
#define IMAGE_WIDTH 30
#define LABEL_HEIGHT 20
#define BUTTON_WIDTH 30
#define BUTTON_HEIGHT LABEL_HEIGHT + IMAGE_WIDTH
#define CENTER_SPACE (self.frame.size.width - LEFT_SPACE * 2 -  BUTTON_WIDTH * 4) / 3


@interface DetailEditViewCell ()



@end


@implementation DetailEditViewCell



- (void)createSubView
{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteButton.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
//            _deleteButton.backgroundColor = [UIColor orangeColor];
        
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"shanchu_n.png"] forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"shanchu_h.png"] forState:UIControlStateHighlighted];
        
        [self addSubview:_deleteButton];
        UIImageView * deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        deleteImageView.image = [UIImage imageNamed:@"delete.png"];
//        [_deleteButton addSubview:deleteImageView];
        UILabel * deleteLB = [[UILabel alloc] initWithFrame:CGRectMake(0, IMAGE_WIDTH, IMAGE_WIDTH, LABEL_HEIGHT)];
        deleteLB.text = @"删除";
        deleteLB.font = [UIFont systemFontOfSize:14];
//        [_deleteButton addSubview:deleteLB];
        
        
        self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(_deleteButton.right + CENTER_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
        //    _clearButton.backgroundColor = [UIColor orangeColor];
        
        [_clearButton setBackgroundImage:[UIImage imageNamed:@"guqing.png"] forState:UIControlStateNormal];
        [_clearButton setBackgroundImage:[UIImage imageNamed:@"shangjia.png"] forState:UIControlStateSelected];
        
        [self addSubview:_clearButton];
        UIImageView * clearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        clearImageView.image = [UIImage imageNamed:@"clear.png"];
//        [_clearButton addSubview:clearImageView];
        UILabel * clearLB = [[UILabel alloc] initWithFrame:CGRectMake(0, IMAGE_WIDTH, IMAGE_WIDTH, LABEL_HEIGHT)];
        clearLB.text = @"估清";
        clearLB.font = [UIFont systemFontOfSize:14];
//        [_clearButton addSubview:clearLB];
        
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(_clearButton.right + CENTER_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
        //    _editButton.backgroundColor = [UIColor orangeColor];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"bianji_n.png"] forState:UIControlStateNormal];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"bianji_h.png"] forState:UIControlStateHighlighted];
        [self addSubview:_editButton];
        UIImageView * editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        editImageView.image = [UIImage imageNamed:@"edit.png"];
//        [_editButton addSubview:editImageView];
        UILabel * editLB = [[UILabel alloc] initWithFrame:CGRectMake(0, IMAGE_WIDTH, IMAGE_WIDTH, LABEL_HEIGHT)];
        editLB.text = @"编辑";
        editLB.font = [UIFont systemFontOfSize:14];
//        [_editButton addSubview:editLB];
        
        self.propertyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _propertyButton.frame = CGRectMake(_editButton.right + CENTER_SPACE, TOP_SPACE, BUTTON_HEIGHT, BUTTON_HEIGHT);
        [_propertyButton setTitle:@"属性" forState:UIControlStateNormal];
        [self addSubview:_propertyButton];
        
        
    }
}

- (CGFloat)cellHeight
{
    return 2 * TOP_SPACE + BUTTON_HEIGHT;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
