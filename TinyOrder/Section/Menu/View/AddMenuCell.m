//
//  AddMenuCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddMenuCell.h"
#import "UIViewAdditions.h"

#define BUTTON_COLOR [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1]
#define CELL_WIDTH [UIScreen mainScreen].bounds.size.width


@implementation AddMenuCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _addButton.frame = CGRectMake(50, 10, self.width - 100, 40);
//        _addButton.center = self.center;
//        [_addButton setTitle:@"添加菜品" forState:UIControlStateNormal];
//        _addButton.backgroundColor = BUTTON_COLOR;
//        [self addSubview:_addButton];
    }
    return self;
}

- (void)createSubview:(CGRect)frame
{
    if (!_addButton) {
        self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addButton.frame = CGRectMake(50, 10, frame.size.width - 100, 40);
        [_addButton setTitle:@"添加菜品" forState:UIControlStateNormal];
        _addButton.backgroundColor = BUTTON_COLOR;
        [self addSubview:_addButton];
        NSLog(@"x%g, y%g, w%g, h%g", _addButton.frame.origin.x, _addButton.frame.origin.y, _addButton.width, _addButton.height);
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
