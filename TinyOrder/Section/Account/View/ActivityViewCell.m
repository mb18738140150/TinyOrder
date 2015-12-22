//
//  ActivityViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ActivityViewCell.h"
#import "ActivityModel.h"

#define LEFT_SPACE 10
#define TOP_SPACE 15
#define LABEL_HEIGHT 20

static int height;

@interface ActivityViewCell ()

@property (nonatomic, assign)int t;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UILabel * sloganLabel;
@property (nonatomic, strong)UILabel * typeLabel;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * actionTimeLabel;
@property (nonatomic, strong)UILabel * noActionFoodLabel;
@property (nonatomic, strong)UILabel * noActionFood;

@property (nonatomic, strong)UIImageView * backView;

@end

static int num = 0;

@implementation ActivityViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{

    [self removeAllSubviews];
    
    
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_SPACE, [UIScreen mainScreen].bounds.size.width, [ActivityViewCell cellHeight] - TOP_SPACE * 2)];
    _backView.image = [UIImage imageNamed:@"processedBack.png"];
    _backView.tag = 2000;
    [self addSubview:_backView];
    
    self.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width - 2 * LEFT_SPACE - 55, 30)];
    self.titleLabel.font = [UIFont systemFontOfSize:23];
    [self addSubview:_titleLabel];
    
    self.deleteBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteBT.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - LEFT_SPACE - 55, TOP_SPACE, 40, 30);
    [_deleteBT setBackgroundImage:[UIImage imageNamed:@"delete_action_icon.png"] forState:UIControlStateNormal];
    [self addSubview:_deleteBT];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _titleLabel.bottom, self.width, 20)];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_timeLabel];
    
    self.sloganLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _timeLabel.bottom + TOP_SPACE, self.width, 20)];
    [self addSubview:_sloganLabel];
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _sloganLabel.bottom + TOP_SPACE, self.width, 20)];
    [self addSubview:_typeLabel];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _typeLabel.bottom, self.width, 20)];
    [self addSubview:_nameLabel];
    
    self.actionTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _nameLabel.bottom, self.width, 20)];
    [self addSubview:_actionTimeLabel];
    
    self.noActionFoodLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _actionTimeLabel.bottom + TOP_SPACE, self.width, 20)];
    _noActionFoodLabel.textColor = [UIColor grayColor];
    _noActionFoodLabel.text = @"不享受此次活动的菜品名称:";
    [self addSubview:_noActionFoodLabel];
    
    self.noActionFood = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _noActionFoodLabel.bottom, self.width - 2 * LEFT_SPACE, 40)];
    _noActionFood.numberOfLines = 0;
//    _noActionFood.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_noActionFood];
    
    self.noActionFoodLabel.hidden = NO;
    self.noActionFood.hidden = NO;
}


- (void)setActivityMD:(ActivityModel *)activityMD
{
    height = 0;
    _activityMD = activityMD;
    
    self.t = 1;
    
    NSString * str = nil;
    NSString * actionSort = nil;
    if ([_activityMD.actionType intValue] == 1) {
        str = @"满减";
    }else
    {
        str = @"首单立减";
    }
    if ([_activityMD.actionSort intValue] == 1) {
        actionSort = @"外卖";
    }else
    {
        actionSort = @"堂食";
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@活动  (%@)", str,actionSort ];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", _activityMD.createTime];
    self.sloganLabel.text = [NSString stringWithFormat:@"您发起了一个%@活动", str];
    self.typeLabel.text = [NSString stringWithFormat:@"活动类型:%@", str];
    self.nameLabel.text = [NSString stringWithFormat:@"活动详情:%@", _activityMD.actionName];
    if (_activityMD.actionTime) {
        self.actionTimeLabel.text = [NSString stringWithFormat:@"活动起止时间:%@", _activityMD.actionTime];
    }else
    {
        self.actionTimeLabel.text = @"活动起止时间:长期";
    }
    if (_activityMD.noActionFood.length != 0) {
        self.noActionFood.text = [NSString stringWithFormat:@"%@", _activityMD.noActionFood];
        self.noActionFoodLabel.frame = CGRectMake(LEFT_SPACE, _actionTimeLabel.bottom + TOP_SPACE, self.width, 20);
        self.noActionFoodLabel.hidden = NO;
        
        // 计算字符串高度
        NSString * contentText = _activityMD.noActionFood;
        CGSize maxSize = CGSizeMake(self.noActionFood.width, 1000);
        CGRect textRect = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        height = textRect.size.height - 40;
        
        self.noActionFood.frame = CGRectMake(LEFT_SPACE, _noActionFoodLabel.bottom, self.width - 2 * LEFT_SPACE, textRect.size.height);
        self.noActionFood.hidden = NO;
    }else
    {
        self.noActionFoodLabel.frame = CGRectMake(LEFT_SPACE, _actionTimeLabel.bottom + TOP_SPACE, self.width, 0);
        self.noActionFoodLabel.hidden = YES;
        self.noActionFood.frame = CGRectMake(LEFT_SPACE, _noActionFoodLabel.bottom, self.width - 2 * LEFT_SPACE, 0);
        self.noActionFood.hidden = YES;
        _t = 0;
    }
    
    num = _t;
    
    self.backView.frame = CGRectMake(0, TOP_SPACE, [UIScreen mainScreen].bounds.size.width, [ActivityViewCell cellHeight] - TOP_SPACE );
    
    
}

- (CGFloat)cellheightof
{
    int a = 0;
    if (num == 1) {
        a = 260;
    }else
    {
        a =  185;
    }
    self.backView.frame = CGRectMake(0, TOP_SPACE, self.frame.size.width, a - 2 * 10);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, a);
    return self.height;
}

+ (CGFloat)cellHeight
{
    if (num == 1) {
        return 260 + height;
    }else
    {
        return 185;
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
