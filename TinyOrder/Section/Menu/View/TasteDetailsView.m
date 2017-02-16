//
//  TasteDetailsView.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/31.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "TasteDetailsView.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10
#define IMAGE_WIDTH 20
#define LABEL_WIDTH 60
#define LABEL_HEIGHT 30
#define BUTTON_WIDTH 40

@implementation TasteDetailsView

- (instancetype)initWithFrame:(CGRect)frame withEdit:(BOOL)isEdit
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews:isEdit];
    }
    return self;
}

- (void)createSubviews:(BOOL)isEdit
{
    
    UIView * view1 = [[UIView alloc]init];
    view1.frame = self.frame;
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    
    int number = 0;
    if (isEdit) {
        number = 1;
    }
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width - 2 * (LEFT_SPACE + IMAGE_WIDTH + LABEL_WIDTH) - number * (BUTTON_WIDTH + IMAGE_WIDTH), LABEL_HEIGHT)];
    self.nameLabel.numberOfLines = 0;
    [self addSubview:_nameLabel];
    
    UIImageView * integralImage = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.right, TOP_SPACE + 5, IMAGE_WIDTH, IMAGE_WIDTH)];
    integralImage.image = [UIImage imageNamed:@"att_integer_icon.png"];
    [self addSubview:integralImage];
    
    self.integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(integralImage.right, TOP_SPACE, LABEL_WIDTH, LABEL_HEIGHT)];
    _integralLabel.textAlignment = NSTextAlignmentCenter;
    _integralLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_integralLabel];
    
    UIImageView * priceImage = [[UIImageView alloc]initWithFrame:CGRectMake(_integralLabel.right, TOP_SPACE + 5, IMAGE_WIDTH, IMAGE_WIDTH)];
    priceImage.image = [UIImage imageNamed:@"att_price_icon.png"];
    [self addSubview:priceImage];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceImage.right, TOP_SPACE, LABEL_WIDTH, LABEL_HEIGHT)];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_priceLabel];
    
    if (isEdit) {
        UIImageView * modifyImage = [[UIImageView alloc]initWithFrame:CGRectMake(_priceLabel.right, TOP_SPACE + 5, IMAGE_WIDTH, IMAGE_WIDTH)];
        modifyImage.image = [UIImage imageNamed:@"editMealProperty"];
        [self addSubview:modifyImage];
        
        self.modifyBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyBT.frame = CGRectMake(modifyImage.right, TOP_SPACE, BUTTON_WIDTH, LABEL_HEIGHT);
        [_modifyBT setTitle:@"编辑" forState:UIControlStateNormal];
        [_modifyBT setTitleColor:[UIColor colorWithWhite:.6 alpha:1] forState:UIControlStateNormal];
        [_modifyBT addTarget:self action:@selector(editProperty) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_modifyBT];
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _nameLabel.bottom + 9, self.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];

}

- (void)editProperty
{
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)editPropertyAction:(EditPropertyBlock)block
{
    self.editBlock = [block copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
