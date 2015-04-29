//
//  AddMenuView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddMenuView.h"
#import "UIViewAdditions.h"

#define SPACE 20
#define VIEW_LB_SPACE 10
#define LETFLABEL_WIDTH 40
#define LABEL_HEIGHT (self.height - SPACE * 7 - _photoView.height - 80) / 5
#define ANNOTATIONLB_HEIGTH 25
#define VIEWBORDER_COLOR [UIColor colorWithWhite:0.7 alpha:1].CGColor
#define LABEL_COLOR [UIColor clearColor]


@interface AddMenuView ()

@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * paceLable;
@property (nonatomic, strong)UILabel * rmbLabel;
@property (nonatomic, strong)UILabel * numberLabel;
@property (nonatomic, strong)UILabel * annotationLable;




@end


@implementation AddMenuView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 4, SPACE, self.width / 2, self.width / 2)];
    _photoView.image = [UIImage imageNamed:@"PHOTO.png"];
    [self addSubview:_photoView];
    self.photoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _photoButton.frame = _photoView.frame;
    [self addSubview:_photoButton];
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, _photoView.bottom + SPACE, self.width - 2 * SPACE, LABEL_HEIGHT)];
    nameView.backgroundColor = [UIColor whiteColor];
    nameView.layer.cornerRadius = 5;
    nameView.layer.borderColor = VIEWBORDER_COLOR;
    [self addSubview:nameView];
    UIView * priceView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, nameView.bottom + SPACE, self.width - 2 * SPACE, LABEL_HEIGHT)];
    priceView.backgroundColor = [UIColor whiteColor];
    priceView.layer.cornerRadius = 5;
    priceView.layer.borderColor = VIEWBORDER_COLOR;
    [self addSubview:priceView];
    UIView * numberView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, priceView.bottom + SPACE, self.width - 2 * SPACE, LABEL_HEIGHT)];
    numberView.backgroundColor = [UIColor whiteColor];
    numberView.layer.cornerRadius = 5;
    numberView.layer.borderColor = VIEWBORDER_COLOR;
    [self addSubview:numberView];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE + VIEW_LB_SPACE, _photoView.bottom + SPACE, LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _nameLabel.text = @"名称";
    _nameLabel.backgroundColor = LABEL_COLOR;
    [self addSubview:_nameLabel];
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top, self.width - _nameLabel.right - SPACE, _nameLabel.height)];
    _nameTF.borderStyle = UITextBorderStyleNone;
    _nameTF.placeholder = @"请输出菜单名";
    [self addSubview:_nameTF];
    
    self.paceLable = [[UILabel alloc] initWithFrame:CGRectMake(SPACE + VIEW_LB_SPACE, _nameLabel.bottom + SPACE, LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _paceLable.text = @"价格";
    _paceLable.backgroundColor = LABEL_COLOR;
    [self addSubview:_paceLable];
    self.paceTF = [[UITextField alloc] initWithFrame:CGRectMake(_paceLable.right, _paceLable.top, self.width - _paceLable.width * 2 - 2 * SPACE, LABEL_HEIGHT)];
    _paceTF.borderStyle = UITextBorderStyleNone;
    _paceTF.keyboardType = UIKeyboardTypeNumberPad;
    _paceTF.placeholder = @"请输入价格";
    [self addSubview:_paceTF];
    self.rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(_paceTF.right, _paceTF.top, LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _rmbLabel.text = @"元";
    _rmbLabel.backgroundColor = LABEL_COLOR;
    [self addSubview:_rmbLabel];
    
    self.numberTF = [[UITextField alloc] initWithFrame:CGRectMake(SPACE + VIEW_LB_SPACE, _paceLable.bottom + SPACE, self.width - 2 * SPACE - LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _numberTF.text = @"0";
    _numberTF.borderStyle = UITextBorderStyleNone;
    _numberTF.keyboardType = UIKeyboardTypeNumberPad;

    [self addSubview:_numberTF];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_numberTF.right, _numberTF.top, self.width - _numberTF.right - SPACE, _numberTF.height)];
    _numberLabel.text = @"份";

    _numberLabel.backgroundColor = LABEL_COLOR;
    [self addSubview:_numberLabel];
    
    self.annotationLable = [[UILabel alloc] initWithFrame:CGRectMake(SPACE, _numberTF.bottom, self.width - 2 * SPACE, ANNOTATIONLB_HEIGTH)];
//    _annotationLable.text = @"注:0份就是不限量";
    [self addSubview:_annotationLable];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _submitButton.frame = CGRectMake(SPACE, _annotationLable.bottom + SPACE, self.width - SPACE * 2, _numberLabel.height);
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor redColor];
    [self addSubview:_submitButton];
    
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
