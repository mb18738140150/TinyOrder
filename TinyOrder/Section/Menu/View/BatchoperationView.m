//
//  BatchoperationView.m
//  TinyOrder
//
//  Created by 仙林 on 16/12/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BatchoperationView.h"

@interface BatchoperationView()

@property (nonatomic, assign)int operationType;

@property (nonatomic, copy)AllOperationBlock myBlock;
@property (nonatomic, copy)DetailOperationBlock detailBlock;
@end

@implementation BatchoperationView

- (instancetype)initWithFrame:(CGRect)frame batchOperationType:(int )operationType
{
    if (self = [super initWithFrame:frame]) {
        self.operationType = operationType;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.allSelectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.height - 25) / 2, 25, 25)];
    _allSelectImageView.layer.borderWidth = .7;
    _allSelectImageView.layer.borderColor = [UIColor colorWithWhite:.7 alpha:1].CGColor;
    _allSelectImageView.layer.cornerRadius = 12.5;
    _allSelectImageView.layer.masksToBounds = YES;
    _allSelectImageView.userInteractionEnabled = YES;
    [self addSubview:_allSelectImageView];
    
    UITapGestureRecognizer * selectType = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeSelectType:)];
    [_allSelectImageView addGestureRecognizer:selectType];
    
    UILabel * allSelectLabel = [[UILabel alloc]initWithFrame:CGRectMake(_allSelectImageView.right + 15, _allSelectImageView.top, 50, 25)];
    allSelectLabel.text = @"全选";
    allSelectLabel.textColor = [UIColor colorWithWhite:.7 alpha:1];
    [self addSubview:allSelectLabel];
    
    self.operationBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _operationBT.frame = CGRectMake(self.width - 60, 0, 60, self.height);
    _operationBT.backgroundColor = BACKGROUNDCOLOR;
    if (self.operationType == 1) {
        [_operationBT setTitle:@"沽清" forState:UIControlStateNormal];
    }else
    {
        [_operationBT setTitle:@"上架" forState:UIControlStateNormal];
    }
    [_operationBT setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [_operationBT addTarget:self action:@selector(detaileOpertionAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_operationBT];
}

- (void)exchangeSelectType:(UITapGestureRecognizer *)sender
{
    if (self.selectType == 0) {
        NSLog(@"全选");
        self.selectType = 1;
        self.myBlock(self.selectType);
    }else
    {
        NSLog(@"取消全选");
        self.selectType = 0;
        self.myBlock(self.selectType);
    }
}

- (void)allOperationAction:(AllOperationBlock)block
{
    self.myBlock = [block copy];
}

- (void)setSelectType:(int)selectType
{
    _selectType = selectType;
    if (selectType == 0) {
        self.allSelectImageView.image = nil;
    }else
    {
        self.allSelectImageView.image = [UIImage imageNamed:@"batchOperationMeal_right"];
    }
}

- (void)detaileOpertionAction
{
    if (self.detailBlock) {
        self.detailBlock(self.operationType);
    }
}
- (void)detaileOperation:(DetailOperationBlock)block
{
    self.detailBlock = [block copy];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
