//
//  GPRSprintViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GPRSprintViewCell.h"

#define LEFT_SPACE 10
#define TOP_SOPACE 10
#define BUTTON_WIDTH 50
#define LB_WIDTH 50
#define LB_HEIGHT 30

@implementation GPRSprintViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.printNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SOPACE, 200, LB_HEIGHT)];
    [self addSubview:_printNameLabel];
    
    self.printNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _printNameLabel.top, 200, _printNameLabel.height)];
    _printNumLabel.numberOfLines = 0;
    [self addSubview:_printNumLabel];
    
    self.isEnableBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _isEnableBT.frame = CGRectMake(self.right - 101, _printNumLabel.top, BUTTON_WIDTH, _printNumLabel.height);
//    [self.isEnableBT setTitle:@"启用" forState:UIControlStateNormal];
//    [_isEnableBT setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [_isEnableBT setTitle:@"禁止" forState:UIControlStateSelected];
    [self addSubview:_isEnableBT];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_isEnableBT.right, _isEnableBT.top, 1, _isEnableBT.height)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line1];
    
    self.deleteBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteBT.frame = CGRectMake(line1.right , _isEnableBT.top, BUTTON_WIDTH, _isEnableBT.height);
    [_deleteBT setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBT.tintColor = [UIColor redColor];
    [self addSubview:_deleteBT];
    
    
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _printNameLabel.bottom + TOP_SOPACE, self.width - 2 * LEFT_SPACE, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:lineView];
    
    self.printCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, lineView.bottom + TOP_SOPACE, self.width - 51 - LEFT_SPACE, LB_HEIGHT)];
    [self addSubview:_printCountLabel];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_printCountLabel.right, _printCountLabel.top, 1, _printCountLabel.height)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line2];
    
    self.setUpCountBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _setUpCountBT.frame = CGRectMake(line2.right, line2.top, BUTTON_WIDTH, LB_HEIGHT);
    [_setUpCountBT setTitle:@"编辑" forState:UIControlStateNormal];
    [_setUpCountBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:_setUpCountBT];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
