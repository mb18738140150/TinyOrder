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
//#define LABEL_HEIGHT (self.height - SPACE * 7 - _photoView.height - 80) / 5
#define LABEL_HEIGHT 30
#define ANNOTATIONLB_HEIGTH 25
#define VIEWBORDER_COLOR [UIColor colorWithWhite:0.7 alpha:1].CGColor
#define LABEL_COLOR [UIColor clearColor]
#define LEFT_SPACE 10
#define TOP_SPACE 10
#define BUTTON_WIDTH 100
@interface AddMenuView ()

@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * paceLable;
@property (nonatomic, strong)UILabel * rmbLabel;
@property (nonatomic, strong)UILabel * integralLB;
@property (nonatomic, strong)UILabel * numberLabel;

@property (nonatomic, strong)UILabel * unitLabel;
@property (nonatomic, strong)UILabel * markTLabel;
@property (nonatomic, strong)UILabel * describeLabel;
//@property (nonatomic, strong)UILabel * annotationLable;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, assign)int isWhere;
@property (nonatomic, assign)int isAddOrEdit;

@end


@implementation AddMenuView



- (id)initWithFrame:(CGRect)frame andIsfromwaimaiOrTangshi:(int)iswhere isAddOrEdit:(int)isAddOrEdit
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isWhere = iswhere;
        self.isAddOrEdit = isAddOrEdit;
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    
    self.scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = self.frame;
    [self addSubview:_scrollView];
    
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width , 100)];
        nameView.backgroundColor = [UIColor whiteColor];
//        nameView.layer.cornerRadius = 5;
//        nameView.layer.borderColor = VIEWBORDER_COLOR;
        [_scrollView addSubview:nameView];
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE , 80, 80)];
    _photoView.image = [UIImage imageNamed:@"PHOTO.png"];
    [_scrollView addSubview:_photoView];
    self.photoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _photoButton.frame = _photoView.frame;
    [_scrollView addSubview:_photoButton];
//    UIView * nameView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, _photoView.bottom + SPACE, self.width - 2 * SPACE, LABEL_HEIGHT)];
//    nameView.backgroundColor = [UIColor whiteColor];
//    nameView.layer.cornerRadius = 5;
//    nameView.layer.borderColor = VIEWBORDER_COLOR;
//    [self addSubview:nameView];
//    UIView * priceView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, nameView.bottom + SPACE, self.width - 2 * SPACE, LABEL_HEIGHT)];
//    priceView.backgroundColor = [UIColor whiteColor];
//    priceView.layer.cornerRadius = 5;
//    priceView.layer.borderColor = VIEWBORDER_COLOR;
//    [self addSubview:priceView];
//    
//    UIView * integratedlView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, priceView.bottom + SPACE, self.width - 2 * SPACE, LABEL_HEIGHT)];
//    integratedlView.backgroundColor = [UIColor whiteColor];
//    integratedlView.layer.cornerRadius = 5;
//    integratedlView.layer.borderColor = VIEWBORDER_COLOR;
//    [self addSubview:integratedlView];
//    
//    UIView * numberView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, integratedlView.bottom + SPACE, self.width - 2 * SPACE, LABEL_HEIGHT)];
//    numberView.backgroundColor = [UIColor whiteColor];
//    numberView.layer.cornerRadius = 5;
//    numberView.layer.borderColor = VIEWBORDER_COLOR;
//    [self addSubview:numberView];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, nameView.bottom , self.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line1];
    
    UIView * priceView = [[UIView alloc] initWithFrame:CGRectMake(0, line1.bottom , self.width , 50)];
    priceView.backgroundColor = [UIColor whiteColor];
//    priceView.layer.cornerRadius = 5;
//    priceView.layer.borderColor = VIEWBORDER_COLOR;
    [_scrollView addSubview:priceView];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, priceView.bottom , self.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line2];
    
    UIView * integratedlView = [[UIView alloc] initWithFrame:CGRectMake(0, line2.bottom, self.width , 50)];
    integratedlView.backgroundColor = [UIColor whiteColor];
//    integratedlView.layer.cornerRadius = 5;
//    integratedlView.layer.borderColor = VIEWBORDER_COLOR;
    [_scrollView addSubview:integratedlView];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, integratedlView.bottom , self.width, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line3];
    
    UIView * numberView = [[UIView alloc] initWithFrame:CGRectMake(0, line3.bottom , self.width, 50)];
    numberView.backgroundColor = [UIColor whiteColor];
//    numberView.layer.cornerRadius = 5;
//    numberView.layer.borderColor = VIEWBORDER_COLOR;
    [_scrollView addSubview:numberView];
    
    
    
//    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE + VIEW_LB_SPACE, _photoView.bottom + SPACE, LETFLABEL_WIDTH, LABEL_HEIGHT)];
//    _nameLabel.text = @"名称:";
//    _nameLabel.backgroundColor = LABEL_COLOR;
//    [self addSubview:_nameLabel];
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(_photoView.right, nameView.top + 35, self.width - _photoView.right - LEFT_SPACE, LABEL_HEIGHT)];
    _nameTF.textAlignment = NSTextAlignmentRight;
    _nameTF.borderStyle = UITextBorderStyleNone;
    _nameTF.placeholder = @"请输入商品名称";
    [_scrollView addSubview:_nameTF];
    
    
    
    self.paceLable = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, priceView.top + TOP_SPACE, LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _paceLable.text = @"价格:";
    _paceLable.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_paceLable];
    self.paceTF = [[UITextField alloc] initWithFrame:CGRectMake(_paceLable.right, _paceLable.top, self.width - _paceLable.width * 2 - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    _paceTF.borderStyle = UITextBorderStyleNone;
    _paceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _paceTF.textAlignment = NSTextAlignmentRight;
    _paceTF.placeholder = @"请输入价格";
    [_scrollView addSubview:_paceTF];
    self.rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(_paceTF.right, _paceTF.top, LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _rmbLabel.text = @"元";
    _rmbLabel.textAlignment = NSTextAlignmentCenter;
    _rmbLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_rmbLabel];
    
    UILabel * integralLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, integratedlView.top + TOP_SPACE, LETFLABEL_WIDTH, LABEL_HEIGHT)];
    integralLB.text = @"积分:";
    integralLB.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:integralLB];
    
    self.integralTF = [[UITextField alloc] initWithFrame:CGRectMake(integralLB.right, integralLB.top, self.width - 2 * LEFT_SPACE - 2 * LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _integralTF.textAlignment = NSTextAlignmentRight;
    _integralTF.placeholder = @"请输入赠送积分";
    _integralTF.borderStyle = UITextBorderStyleNone;
    _integralTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [_scrollView addSubview:_integralTF];
    
    self.integralLB = [[UILabel alloc] initWithFrame:CGRectMake(_integralTF.right, _integralTF.top, LETFLABEL_WIDTH, _integralTF.height)];
    _integralLB.text = @"分";
    _integralLB.textAlignment = NSTextAlignmentCenter;
    _integralLB.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_integralLB];

    
    
    UILabel * boxPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, numberView.top + TOP_SPACE, 60, LABEL_HEIGHT)];
    boxPriceLB.text = @"餐盒费:";
    boxPriceLB.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:boxPriceLB];
    
    
    self.numberTF = [[UITextField alloc] initWithFrame:CGRectMake(boxPriceLB.right, boxPriceLB.top, self.width - 2 * LEFT_SPACE - boxPriceLB.width - LETFLABEL_WIDTH, LABEL_HEIGHT)];
    _numberTF.text = @"0";
    _numberTF.textAlignment = NSTextAlignmentRight;
    _numberTF.borderStyle = UITextBorderStyleNone;
    _numberTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

    [_scrollView addSubview:_numberTF];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_numberTF.right, _numberTF.top, LETFLABEL_WIDTH, _numberTF.height)];
    _numberLabel.text = @"元";
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_numberLabel];

    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, numberView.bottom , self.width, 1)];
    line4.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line4];
    
    if (self.isWhere == 2) {
        boxPriceLB.hidden = YES;
        _numberLabel.hidden = YES;
        _numberTF.hidden = YES;
        line4.hidden = YES;
        numberView.frame = CGRectMake(0, line3.bottom , self.width, 0);
        boxPriceLB.frame = CGRectMake(LEFT_SPACE, numberView.top + TOP_SPACE, 60, 0);
        _numberTF.frame = CGRectMake(boxPriceLB.right, boxPriceLB.top, self.width - 2 * LEFT_SPACE - boxPriceLB.width - LETFLABEL_WIDTH, 0);
        self.numberLabel.frame = CGRectMake(_numberTF.right, _numberTF.top, LETFLABEL_WIDTH, 0);
        line4.frame = CGRectMake(0, numberView.bottom , self.width, 0);
    }
    
    UIView * sortCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, line4.bottom , self.width, 50)];
    sortCodeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:sortCodeView];
    
    UILabel * sortCodeLb = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, sortCodeView.top + TOP_SPACE, 80, LABEL_HEIGHT)];
    sortCodeLb.text = @"商品序号:";
    sortCodeLb.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:sortCodeLb];
    
    
    self.sortCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(sortCodeLb.right, sortCodeLb.top, self.width - 2 * LEFT_SPACE - sortCodeLb.width , LABEL_HEIGHT)];
    _sortCodeTF.placeholder = @"请输入商品序号，越小越靠前(选填)";
    _sortCodeTF.adjustsFontSizeToFitWidth = YES;
    _sortCodeTF.textAlignment = NSTextAlignmentRight;
    _sortCodeTF.borderStyle = UITextBorderStyleNone;
    _sortCodeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_scrollView addSubview:_sortCodeTF];
    
    UIView * sortCodeline = [[UIView alloc]initWithFrame:CGRectMake(0, sortCodeView.bottom , self.width, 1)];
    sortCodeline.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:sortCodeline];

    
    
    UIView * unitView = [[UIView alloc] initWithFrame:CGRectMake(0, sortCodeline.bottom , self.width, 50)];
    unitView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:unitView];
    
    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, unitView.top + TOP_SPACE, 80, LABEL_HEIGHT)];
    _unitLabel.text = @"商品单位:";
    _unitLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_unitLabel];
    
    
    self.unitTF = [[UITextField alloc] initWithFrame:CGRectMake(_unitLabel.right, _unitLabel.top, self.width - 2 * LEFT_SPACE - _unitLabel.width , LABEL_HEIGHT)];
    _unitTF.placeholder = @"请输入商品单位(选填)";
    _unitTF.textAlignment = NSTextAlignmentRight;
    _unitTF.borderStyle = UITextBorderStyleNone;
    [_scrollView addSubview:_unitTF];
    
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, unitView.bottom , self.width, 1)];
    line5.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line5];
    
    UIView * markView = [[UIView alloc] initWithFrame:CGRectMake(0, line5.bottom , self.width, 50)];
    markView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:markView];
    
    self.markTLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, markView.top + TOP_SPACE, 80, LABEL_HEIGHT)];
    _markTLabel.text = @"商品标签:";
    _markTLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_markTLabel];
    
    
    self.markTF = [[UITextField alloc] initWithFrame:CGRectMake(_markTLabel.right, _markTLabel.top, self.width - 2 * LEFT_SPACE - _markTLabel.width , LABEL_HEIGHT)];
    _markTF.placeholder = @"请输入商品标签(选填)";
    _markTF.textAlignment = NSTextAlignmentRight;
    _markTF.borderStyle = UITextBorderStyleNone;
    [_scrollView addSubview:_markTF];
    
    
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(0, markView.bottom , self.width, 1)];
    line6.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line6];
    
    UIView * describeView = [[UIView alloc] initWithFrame:CGRectMake(0, line6.bottom , self.width, 70)];
    describeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:describeView];
    
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, describeView.top + TOP_SPACE, 80, LABEL_HEIGHT)];
    _describeLabel.text = @"商品描述:";
    _describeLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_describeLabel];
    
    
    self.describeTFview = [[UITextView alloc] initWithFrame:CGRectMake(_describeLabel.right, _describeLabel.top, self.width -  LEFT_SPACE * 2 - _markTLabel.width , LABEL_HEIGHT + 20)];
    _describeTFview.textColor = [UIColor colorWithWhite:0.75 alpha:1];
    _describeTFview.text = @"请填入商品描述(选填)";
    _describeTFview.font = [UIFont systemFontOfSize:14];
    _describeTFview.layer.cornerRadius = 5;
    _describeTFview.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    _describeTFview.layer.borderWidth = .7;
    [_scrollView addSubview:_describeTFview];
    
    UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(0, describeView.bottom , self.width, 1)];
    line7.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line7];
    
    UIView * synchronousView = [[UIView alloc]initWithFrame:CGRectMake(0, line7.bottom, self.width, 50)];
    synchronousView.backgroundColor = [UIColor whiteColor];
    synchronousView.tag = 8000;
    [_scrollView addSubview:synchronousView];
    
    self.synchronousLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, synchronousView.top + TOP_SPACE, self.width - 2 * LEFT_SPACE - BUTTON_WIDTH, LABEL_HEIGHT)];
    self.synchronousLabel.text = @"是否同步到堂食";
    _synchronousLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_synchronousLabel];
    
    self.synchronousBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _synchronousBT.frame = CGRectMake(_synchronousLabel.right, _synchronousLabel.top, BUTTON_WIDTH, LABEL_HEIGHT);
    _synchronousBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [_synchronousBT setTitle:@"否" forState:UIControlStateNormal];
    [_synchronousBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_scrollView addSubview:_synchronousBT];
    
    if (self.isAddOrEdit == 0) {
//         _scrollView.frame = self.frame;
        synchronousView.hidden = YES;
        _synchronousBT.hidden = YES;
        _synchronousLabel.hidden = YES;
        synchronousView.frame = CGRectMake(0, line7.bottom, self.width, 0);
        _synchronousLabel.frame = CGRectMake(LEFT_SPACE, synchronousView.top + TOP_SPACE, 180, 0);
        _synchronousBT.frame = CGRectMake(_synchronousLabel.right, _synchronousLabel.top, LETFLABEL_WIDTH, 0);
    }
    
    
    self.propertyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, synchronousView.bottom + TOP_SPACE, self.width, 150) style:UITableViewStylePlain];
    _propertyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_scrollView addSubview:_propertyTableView];
    
//    _propertyTableView.hidden = YES;
//    self.annotationLable = [[UILabel alloc] initWithFrame:CGRectMake(SPACE, _numberTF.bottom, self.width - 2 * SPACE, ANNOTATIONLB_HEIGTH)];
////    _annotationLable.text = @"注:0份就是不限量";
//    [self addSubview:_annotationLable];
    
//    self.mealPropertyBT = [UIButton buttonWithType:UIButtonTypeSystem];
//    _mealPropertyBT.frame = CGRectMake(SPACE, _numberLabel.bottom + SPACE, self.width - SPACE * 2, _paceLable.height);
//    [_mealPropertyBT setTitle:@"添加商品属性" forState:UIControlStateNormal];
//    [_mealPropertyBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _mealPropertyBT.layer.cornerRadius = 5;
//    _mealPropertyBT.layer.masksToBounds = YES;
//    _mealPropertyBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
//    [self addSubview:_mealPropertyBT];
    
    self.addPropertyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addPropertyButton.frame = CGRectMake(SPACE, _propertyTableView.bottom + TOP_SPACE, self.width - SPACE * 2, LABEL_HEIGHT);
    [_addPropertyButton setTitle:@"添加商品属性" forState:UIControlStateNormal];
    _addPropertyButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [_addPropertyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addPropertyButton.layer.cornerRadius = 5;
    _addPropertyButton.layer.masksToBounds = YES;
    [_scrollView addSubview:_addPropertyButton];
    
//    _addPropertyButton.hidden = YES;
    
    _scrollView.contentSize = CGSizeMake(self.width, _addPropertyButton.bottom + TOP_SPACE);
    
//    NSLog(@"_addPropertyButton.frame.y = %f*******_scrollView.contentSize.height = %f", CGRectGetMaxY(_addPropertyButton.frame), _scrollView.bottom);
//    NSLog(@"_scrollView.frame = ***%@******%@", NSStringFromCGRect(_scrollView.frame), NSStringFromCGRect([UIScreen mainScreen].bounds));
    
}

- (void)removeSynchronoView
{
    UIView * synoroView = [_scrollView viewWithTag:8000];
    synoroView.hidden = YES;
    _synchronousBT.hidden = YES;
    _synchronousLabel.hidden = YES;
    synoroView.frame = CGRectMake(0, synoroView.top, self.width, 0);
    _synchronousLabel.frame = CGRectMake(LEFT_SPACE, synoroView.top + TOP_SPACE, 180, 0);
    _synchronousBT.frame = CGRectMake(_synchronousLabel.right, _synchronousLabel.top, LETFLABEL_WIDTH, 0);
    
    self.propertyTableView.frame = CGRectMake(0, synoroView.bottom + TOP_SPACE, self.width, 150);
    _addPropertyButton.frame = CGRectMake(SPACE, _propertyTableView.bottom + TOP_SPACE, self.width - SPACE * 2, LABEL_HEIGHT);
    
    _scrollView.contentSize = CGSizeMake(self.width, _addPropertyButton.bottom + TOP_SPACE);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
