//
//  NewOrdersiewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "NewOrdersiewCell.h"

#import "MenuView.h"
#import "UIViewAdditions.h"
#import "OtherPaceView.h"
#import "NewOrderModel.h"
#import "Meal.h"
#import "PreferentialView.h"
#import "MealPriceView.h"

#import "HeadView.h"
#import "OrderDetailsView.h"
#import "DetailsView.h"

#define HEADVIEW_HEIGHT 50
#define DETAILSVIEW_HEIGHT 110
#define DETAILSLABEL_HEIGHT 30

#define SPACE 15
#define TOP_SPACE 10
#define ORDWEVIEW_HEIGHT 191
#define MENUVIEW_HEIGHT 30
#define VIEW_WIDTH self.frame.size.width - 2 * SPACE
#define OTHERVIEW_HEIGHT 45
#define TOTALVIEW_HEIGHT 50
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
static int remarkNum = 0;
@interface NewOrdersiewCell ()

{
    int c;
}

@property (nonatomic, strong)UIImageView *backView;


@property (nonatomic, strong)UILabel * remarkLabel;

@property (nonatomic, strong)HeadView * headView;
@property (nonatomic, strong)OrderDetailsView * orderDetailsView;
// 配送费
@property (nonatomic, strong)DetailsView * delivery;
// 餐盒费
@property (nonatomic, strong)DetailsView * foodBox;
// 其他费用
@property (nonatomic, strong)DetailsView * otherMoney;
// 首单立减
@property (nonatomic, strong)DetailsView * firstRduce;
// 满减
@property (nonatomic, strong)DetailsView * fullRduce;
// 优惠券
@property (nonatomic, strong)DetailsView * reduceCardview;
// 打折
@property (nonatomic, strong)DetailsView * discountview;
// 积分
@property (nonatomic, strong)DetailsView * integralview;


@property (nonatomic, strong)UIView * menuView;

@property (nonatomic, strong)UIView *lineOtherView;
@property (nonatomic, strong)UIView * linereduce;
@property (nonatomic, strong)UIView * lineView;

//@property (nonatomic, assign)int b;
//@property (nonatomic, assign)int a;
@property (nonatomic, assign)int mealNum;
@end


@implementation NewOrdersiewCell




- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount
{
    self.mealNum = mealCount;
    [self removeAllSubviews];
    
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_SPACE, frame.size.width, [NewOrdersiewCell cellHeightWithMealCount:mealCount] - TOP_SPACE * 2)];
    
    _backView.image = [UIImage imageNamed:@"processedBack.png"];
    _backView.tag = 2000;
    [self addSubview:_backView];
    
    self.headView = [[HeadView alloc]initWithFrame:CGRectMake(0 , TOP_SPACE, self.width, 50)];
    [self addSubview:_headView];
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom, self.width, 1)];
    separateLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1 ];
    [self addSubview:separateLine];
    
    self.orderDetailsView = [[OrderDetailsView alloc]initWithFrame:CGRectMake(0, separateLine.bottom, self.width, 110)];
    [self addSubview:_orderDetailsView];
    
//    self.orderView = [[OrderView alloc] initWithFrame:CGRectMake(SPACE, TOP_SPACE, VIEW_WIDTH, ORDWEVIEW_HEIGHT)];
//    [_orderView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_orderView];
    
    self.reduceCardview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _orderDetailsView.bottom, self.width, DETAILSLABEL_HEIGHT)];
//    _reduceCardview.backgroundColor = [UIColor cyanColor];
    [self addSubview:_reduceCardview];
    self.integralview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _reduceCardview.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_integralview];
    
    self.delivery = [[DetailsView alloc]initWithFrame:CGRectMake(0, _integralview.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_delivery];
    
    self.foodBox = [[DetailsView alloc]initWithFrame:CGRectMake(0, _delivery.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_foodBox];
    self.otherMoney = [[DetailsView alloc]initWithFrame:CGRectMake(0, _foodBox.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_otherMoney];
    self.firstRduce = [[DetailsView alloc]initWithFrame:CGRectMake(0, _otherMoney.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_firstRduce];
    self.fullRduce = [[DetailsView alloc]initWithFrame:CGRectMake(0, _firstRduce.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_fullRduce];
    self.discountview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _fullRduce.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_discountview];
    
    /*
     //    int num = 0;
     //    num = mealCount / 2 + mealCount % 2;
     //
     //    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, _discountview.bottom , self.width, num * 30 + 10 * (num - 1) + 30)];
     //    self.menuView.backgroundColor = [UIColor whiteColor];
     //    [self addSubview:_menuView];
     //
     //    int k = 0;
     //    for (int i = 0; i < mealCount; i++) {
     //
     //        MealPriceView * mealPriceV = [[MealPriceView alloc] initWithFrame:CGRectMake(LEFT_SPACE + (self.width - 3 * LEFT_SPACE) / 2 * k + LEFT_SPACE * k, 15 + (i) / 2 * 40, (self.width - 3 * LEFT_SPACE) / 2, 30)];
     //        k++;
     //
     //        if ((i + 1) % 2 == 0) {
     //            k = 0;
     //        }
     //
     //        mealPriceV.tag = MEALPRICEVIEW_TAG + i;
     //        [_menuView addSubview:mealPriceV];
     //    }
     //
     //    UIView * menuline = [[UIView alloc]initWithFrame:CGRectMake(0, _menuView.height - 1, _menuView.width, 1)];
     //    menuline.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
     //    [_menuView addSubview:menuline];
     
     */
    
    self.totalView = [[TotalViw alloc] initWithFrame:CGRectMake(0, _discountview.bottom + TOP_SPACE, VIEW_WIDTH + 2 * SPACE, TOTALVIEW_HEIGHT)];
    [self addSubview:_totalView];


}
- (void)calculateHeightwithcount:(int)count
{
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,ORDWEVIEW_HEIGHT + MENUVIEW_HEIGHT * count  + TOTALVIEW_HEIGHT + LABEL_HEIGHT + BUTTON_SPACE + TOP_SPACE * 6 + 10 + 20 * acount);
    self.backView.frame = CGRectMake(0, TOP_SPACE, self.frame.size.width, self.frame.size.height - 2 * SPACE);
    
}

//+ (CGFloat)cellHeightWithMealCount:(int)mealCount
//{
//        return ORDWEVIEW_HEIGHT  + MENUVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10  + 30  + TOTALVIEW_HEIGHT + 10 + 40 * acount + TOP_SPACE ;
//}
+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return HEADVIEW_HEIGHT  + DETAILSVIEW_HEIGHT + 10 + 30 * acount + TOTALVIEW_HEIGHT ;
}

- (void)setOrderModel:(NewOrderModel *)orderModel
{
    _orderModel = orderModel;
    self.headView.numberLabel.text = [NSString stringWithFormat:@"%d号", orderModel.orderNum];
    NSLog(@"dealState = %@", orderModel.dealState);
    self.dealButton.hidden = NO;
    if (orderModel.dealState.intValue == 1) {
        self.headView.stateLabel.text = @"等待处理";
        [_nulliyButton setTitle:@"拒绝接单" forState:UIControlStateNormal];
    }else if (orderModel.dealState.intValue == 5)
    {
        self.headView.stateLabel.text = @"申请退款";
        [_nulliyButton setTitle:@"同意退款" forState:UIControlStateNormal];
        self.dealButton.hidden = YES;
    }else if (orderModel.dealState.intValue == 4)
    {
        self.headView.stateLabel.text = @"已取消订单";
        [_nulliyButton setTitle:@"无效" forState:UIControlStateNormal];
        self.dealButton.hidden = YES;
    }
    
    // 拿到时间
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate * date = [fomatter dateFromString:orderModel.orderTime];
    NSLog(@"%@", date);
    
    // 转换成日期
    NSDateFormatter * dayDateFM = [[NSDateFormatter alloc]init];
    dayDateFM.dateFormat = @"MM-dd";
    NSString *dayStr = [dayDateFM stringFromDate:date];
    
    NSDate *nowDate = [NSDate date];
    nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString * nowStr = [dayDateFM stringFromDate:nowDate];
    
//    NSLog(@"***%@**%@", nowStr, dayStr);
    
    // 比较看是否是今天的订单
    if (![nowStr isEqualToString:dayStr]) {
        self.headView.dateLabel.text = dayStr;
    }else
    {
        NSDateFormatter * houreDateFM = [[NSDateFormatter alloc]init];
        houreDateFM.dateFormat = @"HH:mm";
        NSString *houreStr = [houreDateFM stringFromDate:date];
        self.headView.dateLabel.text = houreStr;
    }

    
    NSString *string = [orderModel.orderId substringToIndex:1];
    string = [string lowercaseString];
    
    if ([string isEqualToString:@"z"]) {
        self.headView.orderStyleLabel.text = @"外卖";
    }else
    {
        self.headView.orderStyleLabel.text = @"堂食";
    }
    
//    self.orderDetailsView.nameAndPhoneview.detailesLabel.text = [NSString stringWithFormat:@"%@ | %@", orderModel.contect, orderModel.tel];
    self.orderDetailsView.nameAndPhoneview.name = [NSString stringWithFormat:@"%@", orderModel.contect];
    self.orderDetailsView.nameAndPhoneview.phonenumber = [NSString stringWithFormat:@"%@", orderModel.tel];
    
    self.orderDetailsView.addressView.detailesLabel.text = [NSString stringWithFormat:@"%@", orderModel.address];
    self.orderDetailsView.remarkView.detailesLabel.text = [NSString stringWithFormat:@"备注:%@", orderModel.remark];
    
//    self.orderView.addressLabel.text = [NSString stringWithFormat:@"地址%@", orderModel.address];
//    self.orderView.phoneLabel.text = [NSString stringWithFormat:@"%@", orderModel.tel];
//    self.orderView.contactLabel.text = [NSString stringWithFormat:@"%@", orderModel.contect];
//    self.orderView.remarkLabel.text = [NSString stringWithFormat:@"备注:%@", orderModel.remark];

    
//    if (orderModel.gift.length != 0) {
//        self.orderView.giftLabel.text = [NSString stringWithFormat:@"奖品:%@", orderModel.gift];
//    }else
//    {
//        self.orderView.giftLabel.text = @"奖品:无";
//    }

    
    if ([orderModel.PayMath intValue] == 3) {
        self.orderDetailsView.payTypeLabel.text = @"现金支付";
    }else
    {
        self.orderDetailsView.payTypeLabel.text = @"已支付";
    }
    
    
//    for (int i = 0; i < orderModel.mealArray.count; i++) {
//        Meal * meal = [orderModel.mealArray objectAtIndex:i];
//        MealPriceView * mealPriceV = (MealPriceView *)[self.menuView viewWithTag:MEALPRICEVIEW_TAG + i];
//        mealPriceV.menuLabel.text = meal.name;
//        mealPriceV.menuPriceLB.text = [NSString stringWithFormat:@"¥%@", meal.money];
//        mealPriceV.numberLabel.text = [NSString stringWithFormat:@"X%@", meal.count];
//    }
    
    self.a = 8;
    if ([orderModel.reduceCard doubleValue] != 0) {
//        self.reduceCardview.title.text = @"优惠券";
//        self.reduceCardview.detailLabel.text = @"1张";
        self.reduceCardview.detailesLabel.text = [NSString stringWithFormat:@"优惠券: -%.2f元", [orderModel.reduceCard doubleValue]];
    }else
    {
        self.a--;
        self.reduceCardview.hidden = YES;
        self.reduceCardview.frame = CGRectMake(0, _orderDetailsView.bottom , self.width, 0);
    }
    
    if ([orderModel.internal intValue] != 0) {
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.width, DETAILSLABEL_HEIGHT);
        double integral = orderModel.internal.doubleValue / 100;
//        self.integralview.title.text = @"积分";
        self.integralview.detailesLabel.text = [NSString stringWithFormat:@"积分: -%.2f元", integral];
//        self.integralview.titleLable.text = [NSString stringWithFormat:@"-%.2f元", integral];
    }else
    {
        _a--;
        self.integralview.hidden = YES;
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.width, 0);
    }
    
    if ([orderModel.delivery doubleValue] != 0) {
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.width, DETAILSLABEL_HEIGHT);
//        self.delivery.title.text = @"配送费";
        self.delivery.detailesLabel.text = [NSString stringWithFormat:@"配送费: +%.2f元", [orderModel.delivery doubleValue]];
    }else
    {
        _a--;
        self.delivery.hidden = YES;
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.width, 0);
        self.foodBox.frame = CGRectMake(0, _delivery.bottom , self.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([orderModel.foodBox doubleValue] != 0) {
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.width, DETAILSLABEL_HEIGHT);
//        self.foodBox.title.text = @"餐盒费";
        self.foodBox.detailesLabel.text = [NSString stringWithFormat:@"餐盒费: +%.2f元", [orderModel.foodBox doubleValue]];
    }else
    {
        _a--;
        self.foodBox.hidden = YES;
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.width, 0);
    }
    
    if ([orderModel.otherMoney doubleValue] != 0) {
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.otherMoney.title.text = @"其他费用";
        self.otherMoney.detailesLabel.text = [NSString stringWithFormat:@"其他费用: +%.2f元", [orderModel.otherMoney doubleValue]];
    }else
    {
        _a--;
        self.otherMoney.hidden = YES;
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, 0);
    }
    
    if ([orderModel.firstReduce doubleValue] != 0) {
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.firstRduce.title.text = @"首单立减";
        self.firstRduce.detailesLabel.text = [NSString stringWithFormat:@"首单立减: -%.2f元", [orderModel.firstReduce doubleValue]];
    }else
    {
        self.a--;
        self.firstRduce.hidden = YES;
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, 0);
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([orderModel.fullReduce doubleValue] != 0) {
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.fullRduce.title.text = @"满减优惠";
        self.fullRduce.detailesLabel.text =[NSString stringWithFormat:@"满减优惠: -%.2f元", [orderModel.fullReduce doubleValue]];;
    }else
    {
        self.a--;
        self.fullRduce.hidden = YES;
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, 0);
    }
    if (orderModel.discount != 0) {
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.discountview.title.text = @"打折优惠";
        self.discountview.detailesLabel.text = [NSString stringWithFormat:@"打折优惠: %.1f折", orderModel.discount];
    }else
    {
        self.a--;
        self.discountview.hidden = YES;
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.width, 0);
    }

    
    int num = 0;
    num = _a ;
    
    
    acount = self.a ;
    
//    self.menuView.frame = CGRectMake(0, _discountview.bottom , self.width, _menuView.height);
    
    self.totalView.frame = CGRectMake(0, _discountview.bottom , VIEW_WIDTH + 2 * SPACE, TOTALVIEW_HEIGHT);

    NSString * moneyString = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    if ([moneyString containsString:@"."]) {
        NSArray * monerArr = [moneyString componentsSeparatedByString:@"."];
        NSString * monryStr1 = [monerArr objectAtIndex:0];
        NSString * moneyStr2 = [monerArr objectAtIndex:1];
        if (moneyStr2.length > 2) {
            NSString * moneyStr3 = [moneyStr2 substringToIndex:2];
            NSString * moneyString1 = [NSString stringWithFormat:@"总¥%@.%@", monryStr1, moneyStr3];
            NSString * moneyString2 = [NSString stringWithFormat:@"%@.%@", monryStr1, moneyStr3];
            NSMutableAttributedString * moneyStr = [[NSMutableAttributedString alloc]initWithString:moneyString1];
            [moneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:BACKGROUNDCOLOR} range:NSMakeRange(2, moneyString2.length)];
            self.totalView.totalPriceLabel.attributedText = moneyStr;
        }else
        {
            NSString * moneyString1 = [NSString stringWithFormat:@"总¥%@", orderModel.allMoney];
            NSMutableAttributedString * moneyStr = [[NSMutableAttributedString alloc]initWithString:moneyString1];
            [moneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:BACKGROUNDCOLOR} range:NSMakeRange(2, moneyString.length)];
            self.totalView.totalPriceLabel.attributedText = moneyStr;
        }
    }else
    {
        NSString * str = [NSString stringWithFormat:@"总¥%@", orderModel.allMoney];
        NSMutableAttributedString * moneyStr = [[NSMutableAttributedString alloc]initWithString:str];
        [moneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:BACKGROUNDCOLOR} range:NSMakeRange(2, moneyString.length)];
        self.totalView.totalPriceLabel.attributedText = moneyStr;
    }
    
//    self.totalView.totalPriceLabel.text = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    
    self.backView.frame = CGRectMake(0, TOP_SPACE, self.frame.size.width, [NewOrdersiewCell cellHeightWithMealCount:orderModel.mealArray.count] - TOP_SPACE );
    
    if (orderModel.isOrNo) {
        self.orderView.isOrNOBT.backgroundColor = [UIColor redColor];
    }
    
}


- (NSString *)getPrintStringWithMealCount:(int)mealCount
{
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%@\r    <<本单由微生活外卖提供>>\r", self.orderView.numberLabel.text];
    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    [str appendFormat:@"下单日期:%@\r%@", self.orderView.dateLabel.text, lineStr];
//    [str appendFormat:@"%@\r", self.orderView.expectLabel.text];
    [str appendFormat:@"地址:%@\r", self.orderView.addressLabel.text];
    [str appendFormat:@"联系人:%@\r", self.orderView.contactLabel.text];
    [str appendFormat:@"电话:%@\r%@", self.orderView.phoneLabel.text, lineStr];
//    [str appendFormat:@"%@\r", self.menuView.numMenuLabel.text];
//    NSLog(@"...%ld", mealCount);
//    for (int i = 0; i < mealCount; i++) {
//        MenuView * menuView = (MenuView *)[self viewWithTag:MENUVIEW_TAG + i];
//        [str appendFormat:@"%@  X%@  %@元\r", menuView.comboLabel.text, menuView.numLabel.text, menuView.paceLabel.text];
//    }
    [str appendString:lineStr];
    [str appendFormat:@"%@           %@\r%@", self.delivery.detailesLabel.text, self.delivery.detailesLabel.text, lineStr];
    [str appendFormat:@"总计     %@元     \r%@", self.totalView.totalPriceLabel.text, lineStr];
    [str appendFormat:@"%@\n\n\n", self.remarkLabel.text];
//    NSLog(@"+====%@", self.remarkLabel.text);
    return [str copy];
}


- (void)telToOrderTelNumber:(UIButton *)button
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.orderModel.tel]];
    //    [[UIApplication sharedApplication] openURL:telURL];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.window addSubview:callWebView];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
