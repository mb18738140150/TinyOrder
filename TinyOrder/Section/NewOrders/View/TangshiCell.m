//
//  TangshiCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/12/10.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "TangshiCell.h"
#import "OrderView.h"
#import "MenuView.h"
#import "UIViewAdditions.h"
#import "OtherPaceView.h"
#import "NewOrderModel.h"
#import "Meal.h"
#import "PreferentialView.h"
#import "MealPriceView.h"

#define SPACE 15
#define TOP_SPACE 10
#define HEADVIEW_HEIGHT 60
#define customerInformationView_height 145
#define MENUVIEW_HEIGHT 30
#define VIEW_WIDTH self.frame.size.width - 2 * SPACE
#define OTHERVIEW_HEIGHT 45
#define TOTALPRICEVIEW_HEIGHT 60
#define LABEL_HEIGHT 40
#define BUTTON_SPACE 40
#define BUTTON_HEIGHT 40
#define DEALBUTTON_WIDTH 142
#define NULLIYBUTTON_WIDTH 100
#define BUTTON_WIDTH_BAD 40
#define LEFT_SPACE 15
#define MEALPRICEVIEW_TAG 5000

#define MENUVIEW_TAG 1000
#define LINE_WIDTH 1

static int acount = 0;

@interface TangshiCell ()

@property (nonatomic, strong)UIImageView * backView;
@property (nonatomic, strong)UILabel * orderNumLabel;
@property (nonatomic, strong)UILabel * orderTimeLabel;
@property (nonatomic, strong)UIView * customerInformationView;
@property (nonatomic, strong)UILabel * orderIdLabel;
@property (nonatomic, strong)UILabel * eatLocationLB;
@property (nonatomic, strong)UILabel * customerCountLB;
@property (nonatomic, strong)UILabel * remarkLB;
@property (nonatomic, strong)UILabel * giftLabel;

@property (nonatomic, strong)PreferentialView * delivery;
@property (nonatomic, strong)PreferentialView * foodBox;
@property (nonatomic, strong)PreferentialView * otherMoney;
@property (nonatomic, strong)PreferentialView * firstRduce;
@property (nonatomic, strong)PreferentialView * fullRduce;
@property (nonatomic, strong)PreferentialView * reduceCardview;

@property (nonatomic, strong)UIView * menuView;

@property (nonatomic, assign)int a;
@end

@implementation TangshiCell

- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount
{
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_SPACE, frame.size.width, [TangshiCell cellHeightWithMealCount:mealCount] - TOP_SPACE * 2)];
    _backView.image = [UIImage imageNamed:@"processedBack.png"];
    _backView.tag = 2000;
    [self addSubview:_backView];
    
    self.orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, TOP_SPACE, 80, LABEL_HEIGHT)];
    self.orderNumLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview:_orderNumLabel];
    self.orderTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLabel.right, SPACE, frame.size.width - 2 * SPACE - 80, 30)];
    self.orderTimeLabel.textColor = [UIColor orangeColor];
    self.orderTimeLabel.font = [UIFont systemFontOfSize:14];
    self.orderTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_orderTimeLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _orderNumLabel.bottom + TOP_SPACE - 1, frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];
    
    self.customerInformationView =[[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE + line.bottom, frame.size.width, customerInformationView_height)];
    _customerInformationView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_customerInformationView];
    
    self.orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, TOP_SPACE, _customerInformationView.width - 2 * SPACE, 25)];
    _orderIdLabel.textColor = [UIColor orangeColor];
    _orderIdLabel.font = [UIFont systemFontOfSize:14];
    [_customerInformationView addSubview:_orderIdLabel];
    
    self.eatLocationLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE + 20, _orderIdLabel.bottom, _customerInformationView.width - 2 * SPACE, 25)];
    _eatLocationLB.font = [UIFont systemFontOfSize:15];
    [_customerInformationView addSubview:_eatLocationLB];
    
    UIImageView * eatLocationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE, _eatLocationLB.top + 7, 10, 10)];
    eatLocationImageView.image = [UIImage imageNamed:@"start_tangshi_icon.png"];
    [_customerInformationView addSubview:eatLocationImageView];
    
    self.customerCountLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE + 20, _eatLocationLB.bottom, _eatLocationLB.width, _eatLocationLB.height)];
    _customerCountLB.font = [UIFont systemFontOfSize:15];
    [_customerInformationView addSubview:_customerCountLB];
    
    UIImageView * customerCountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE, _customerCountLB.top + 7, 10, 10)];
    customerCountImageView.image = [UIImage imageNamed:@"start_tangshi_icon.png"];
    [_customerInformationView addSubview:customerCountImageView];
    
    self.remarkLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE + 20, _customerCountLB.bottom, _customerCountLB.width, _customerCountLB.height)];
    _remarkLB.font = [UIFont systemFontOfSize:15];
    [_customerInformationView addSubview:_remarkLB];
    
    UIImageView * remarkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE, _remarkLB.top + 7, 10, 10)];
    remarkImageView.image = [UIImage imageNamed:@"start_tangshi_icon.png"];
    [_customerInformationView addSubview:remarkImageView];
    
    self.giftLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPACE + 20, _remarkLB.bottom, _customerCountLB.width, _customerCountLB.height)];
    _giftLabel.font = [UIFont systemFontOfSize:15];
    [_customerInformationView addSubview:_giftLabel];
    
    UIImageView * giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE, _giftLabel.top + 7, 10, 10)];
    giftImageView.image = [UIImage imageNamed:@"start_tangshi_icon.png"];
    [_customerInformationView addSubview:giftImageView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _customerInformationView.bottom, frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:lineView];
    
    self.reduceCardview = [[PreferentialView alloc]initWithFrame:CGRectMake(0, _customerInformationView.bottom + 1, self.width, 40)];
    [self addSubview:_reduceCardview];
    
    self.delivery = [[PreferentialView alloc]initWithFrame:CGRectMake(0, _reduceCardview.bottom, self.width, 40)];
    [self addSubview:_delivery];
    
    self.foodBox = [[PreferentialView alloc]initWithFrame:CGRectMake(0, _delivery.bottom, self.width, 40)];
    [self addSubview:_foodBox];
    self.otherMoney = [[PreferentialView alloc]initWithFrame:CGRectMake(0, _foodBox.bottom, self.width, 40)];
    [self addSubview:_otherMoney];
    self.firstRduce = [[PreferentialView alloc]initWithFrame:CGRectMake(0, _otherMoney.bottom, self.width, 40)];
    [self addSubview:_firstRduce];
    self.fullRduce = [[PreferentialView alloc]initWithFrame:CGRectMake(0, _firstRduce.bottom, self.width, 40)];
    [self addSubview:_fullRduce];
    
    int num = 0;
    num = mealCount / 2 + mealCount % 2;
    
    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, _fullRduce.bottom , self.width, num * 30 + 10 * (num - 1) + 30)];
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_menuView];
    
    int k = 0;
    for (int i = 0; i < mealCount; i++) {
        
        MealPriceView * mealPriceV = [[MealPriceView alloc] initWithFrame:CGRectMake(LEFT_SPACE + (self.width - 3 * LEFT_SPACE) / 2 * k + LEFT_SPACE * k, 15 + (i) / 2 * 40, (self.width - 3 * LEFT_SPACE) / 2, 30)];
        k++;
        
        if ((i + 1) % 2 == 0) {
            k = 0;
        }
        
        mealPriceV.tag = MEALPRICEVIEW_TAG + i;
        [_menuView addSubview:mealPriceV];
    }
    UIView * menuline = [[UIView alloc]initWithFrame:CGRectMake(0, _menuView.height - 1, _menuView.width, 1)];
    menuline.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_menuView addSubview:menuline];
    
    self.totalPriceView = [[TotalPriceView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _menuView.bottom , VIEW_WIDTH, TOTALPRICEVIEW_HEIGHT)];
    _totalPriceView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_totalPriceView];
    
}

- (void)setOrderModel:(NewOrderModel *)orderModel
{
    self.orderNumLabel.text = [NSString stringWithFormat:@"%d号",orderModel.orderNum ];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"%@", orderModel.orderTime];
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@", orderModel.orderId];
    self.eatLocationLB.text = [NSString stringWithFormat:@"用餐位置:%@", orderModel.eatLocation];
    self.customerCountLB.text = [NSString stringWithFormat:@"用餐人数:%d", orderModel.customerCount];
    if (orderModel.remark.length != 0) {
        self.remarkLB.text = [NSString stringWithFormat:@"备注:%@", orderModel.remark];
    }else
    {
        self.remarkLB.text = @"备注:无";
    }
    if (orderModel.gift.length != 0) {
        self.giftLabel.text = [NSString stringWithFormat:@"赠品:%@", orderModel.gift];
    }else
    {
        self.giftLabel.text = @"赠品:无";
    }
    
    self.a = 6;
    if ([orderModel.reduceCard doubleValue] != 0) {
        self.reduceCardview.title.text = @"优惠券";
        self.reduceCardview.detailLabel.text = @"1张";
        self.reduceCardview.titleLable.text = [NSString stringWithFormat:@"-%.2f元", [orderModel.reduceCard doubleValue]];
    }else
    {
        self.a--;
        self.reduceCardview.hidden = YES;
        self.reduceCardview.frame = CGRectMake(0, _customerInformationView.bottom +1, self.width, 0);
    }
    
    if ([orderModel.delivery doubleValue] != 0) {
        self.delivery.frame = CGRectMake(0, _reduceCardview.bottom , self.width, LABEL_HEIGHT);
        self.delivery.title.text = @"配送费";
        self.delivery.titleLable.text = [NSString stringWithFormat:@"+%.2f元", [orderModel.delivery doubleValue]];
    }else
    {
        _a--;
        self.delivery.hidden = YES;
        self.delivery.frame = CGRectMake(0, _reduceCardview.bottom , self.width, 0);
        self.foodBox.frame = CGRectMake(0, _delivery.bottom , self.width, LABEL_HEIGHT);
    }
    
    if ([orderModel.foodBox doubleValue] != 0) {
        self.foodBox.title.text = @"餐盒费";
        self.foodBox.titleLable.text = [NSString stringWithFormat:@"+%.2f元", [orderModel.foodBox doubleValue]];
    }else
    {
        _a--;
        self.foodBox.hidden = YES;
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.width, 0);
    }
    
    if ([orderModel.otherMoney doubleValue] != 0) {
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, LABEL_HEIGHT);
        self.otherMoney.title.text = @"其他费用";
        self.otherMoney.titleLable.text = [NSString stringWithFormat:@"+%.2f元", [orderModel.otherMoney doubleValue]];
    }else
    {
        _a--;
        self.otherMoney.hidden = YES;
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, 0);
    }
    
    if ([orderModel.firstReduce doubleValue] != 0) {
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, LABEL_HEIGHT);
        self.firstRduce.title.text = @"首单立减";
        self.firstRduce.titleLable.text = [NSString stringWithFormat:@"-%.2f元", [orderModel.firstReduce doubleValue]];
    }else
    {
        self.a--;
        self.firstRduce.hidden = YES;
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, 0);
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, LABEL_HEIGHT);
    }
    
    if ([orderModel.fullReduce doubleValue] != 0) {
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, LABEL_HEIGHT);
        self.fullRduce.title.text = @"满减优惠";
        self.fullRduce.titleLable.text =[NSString stringWithFormat:@"-%.2f元", [orderModel.fullReduce doubleValue]];;
    }else
    {
        self.a--;
        self.fullRduce.hidden = YES;
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, 0);
    }
    
    
    int num = 0;
    num = _a ;
    
    
    acount = self.a ;

    for (int i = 0; i < orderModel.mealArray.count; i++) {
        Meal * meal = [orderModel.mealArray objectAtIndex:i];
        MealPriceView * mealPriceV = (MealPriceView *)[self.menuView viewWithTag:MEALPRICEVIEW_TAG + i];
        mealPriceV.menuLabel.text = meal.name;
        mealPriceV.menuPriceLB.text = [NSString stringWithFormat:@"¥%@", meal.money];
        mealPriceV.numberLabel.text = [NSString stringWithFormat:@"X%@", meal.count];
    }
    
    self.menuView.frame = CGRectMake(0, _fullRduce.bottom , self.width, _menuView.height);
    
    self.totalPriceView.frame = CGRectMake(LEFT_SPACE, _menuView.bottom , VIEW_WIDTH, TOTALPRICEVIEW_HEIGHT);
    [self.totalPriceView.dealButton setTitle:@"打印并处理" forState:UIControlStateNormal];
    
    self.totalPriceView.printButton.backgroundColor = MAINCOLOR;
    [self.totalPriceView.printButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.totalPriceView.printButton.layer.cornerRadius = 5;
    self.totalPriceView.printButton.layer.borderWidth = 1;
    self.totalPriceView.printButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.totalPriceView.printButton.layer.masksToBounds = YES;
    [self.totalPriceView.printButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.totalPriceView.printButton.frame = CGRectMake(self.totalPriceView.dealButton.left - 90, TOP_SPACE + 5 , 80, BUTTON_HEIGHT - 10);
    
//    NSLog(@"***orderModel.pay = %d", orderModel.pay);
    if (orderModel.pays == 0) {
        [self.totalPriceView.printButton setTitle:@"未付款" forState:UIControlStateNormal];
    }else
    {
        [self.totalPriceView.printButton setTitle:@"已付款" forState:UIControlStateNormal];
    }
    self.totalPriceView.totalPriceLabel.text = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    self.backView.frame = CGRectMake(0, TOP_SPACE, self.frame.size.width, [TangshiCell cellHeightWithMealCount:(int)orderModel.mealArray.count] - TOP_SPACE * 2);
}

+(CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return HEADVIEW_HEIGHT + customerInformationView_height + 1 + 40 * acount + MENUVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10 + 30 +TOTALPRICEVIEW_HEIGHT + 2 * TOP_SPACE;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
