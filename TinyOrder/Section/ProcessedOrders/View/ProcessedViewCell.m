//
//  ProcessedViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ProcessedViewCell.h"
#import "NumberView.h"
#import "AddressView.h"
#import "UIViewAdditions.h"

#import "DealOrderModel.h"
#import "MealPriceView.h"
#import "Meal.h"
#import "PreferentialView.h"


#import "HeadView.h"
#import "OrderDetailsView.h"
#import "DetailsView.h"

#define HEADVIEW_HEIGHT 50
#define DETAILSVIEW_HEIGHT 110
#define DETAILSLABEL_HEIGHT 30

#define IMAGEVIEW_TOP_SPACE 10
#define LEFT_SPACE 15
#define TOP_SPACE 2
#define NUMBERVIEW_HEIGHT 50
#define VIEW_WIDTH (self.frame.size.width - 2 * LEFT_SPACE)
#define ADDRESSVIEW_HEIGHT 140
#define PRICEVIEW_HEIGHT 31
#define MEALPRICEVIEW_HEIGHT 30
#define TOTALPRICEVIEW_HEIGHT 50
#define BUTTONVIEW_HEIGHT 60
#define BUTTON_HEIGHT 40
#define DEALBUTTON_WIDTH 146
#define BUTTON_SPACE 30
#define BUTTON_LEFT_SPACE 10
#define VIEW_COLOR [UIColor whiteColor]
#define LABEL_HEIGHT 40
#define LINEVIEW_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0]
#define BACKVIEW_FRAME CGRectMake(0, 0, frame.size.width, [ProcessedViewCell cellHeightWithMealCount:mealCount] - IMAGEVIEW_TOP_SPACE)
#define NULLIYBUTTON_WIDTH 100


#define MEALPRICEVIEW_TAG 5000
static int ishavetotleView = 1;
static int count = 0;
@interface ProcessedViewCell ()

@property (nonatomic, strong)NumberView * numberView;
@property (nonatomic, strong)AddressView * addressView;

@property (nonatomic, strong)UILabel * remarkLabel;
@property (nonatomic, strong)UIView * menuView;

@property (nonatomic, strong)HeadView * headView;
@property (nonatomic, strong)OrderDetailsView * orderDetailsView;

@property (nonatomic, strong)DetailsView * delivery;
@property (nonatomic, strong)DetailsView * foodBox;
@property (nonatomic, strong)DetailsView * otherMoney;
@property (nonatomic, strong)DetailsView * firstRduce;
@property (nonatomic, strong)DetailsView * fullRduce;
@property (nonatomic, strong)DetailsView * reduceCardview;
@property (nonatomic, strong)DetailsView * discountview;
// 积分
@property (nonatomic, strong)DetailsView * integralview;

@property (nonatomic, strong)DetailsView * deliveryUserID;
@property (nonatomic, strong)DetailsView * deliveryUserName;
@property (nonatomic, strong)DetailsView * deliveryUserPhone;

@property (nonatomic, strong)UIView *linereduce;
@property (nonatomic, strong)UIView *lineOtherView;
@property (nonatomic, strong)UIView *grayLineView;
@property (nonatomic, strong)UIView *labelView;
@property (nonatomic, strong)UIView *buttonView;
@property (nonatomic, assign)int a;
@property (nonatomic, assign)int b;
@property (nonatomic, assign)int mealNum;

@property (nonatomic, strong)UIView * lineView1;

@property (nonatomic, strong)UIImageView *backView;

@end



@implementation ProcessedViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)createSubView:(CGRect)frame mealCount:(int)mealCount
{
    self.mealNum = mealCount;
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10 , frame.size.width, [ProcessedViewCell cellHeightWithMealCount:mealCount] - IMAGEVIEW_TOP_SPACE)];
    _backView.image = [UIImage imageNamed:@"processedBack.png"];
    _backView.tag = 2000;
    [self addSubview:_backView];
    
    
    self.headView = [[HeadView alloc]initWithFrame:CGRectMake(0 , 10, self.width, 50)];
    [self addSubview:_headView];
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom, self.width, 1)];
    separateLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1 ];
    [self addSubview:separateLine];
    
    self.orderDetailsView = [[OrderDetailsView alloc]initWithFrame:CGRectMake(0, separateLine.bottom, self.width, 110)];
    [self addSubview:_orderDetailsView];
    
    //    self.numberView = [[NumberView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _backView.top , VIEW_WIDTH, NUMBERVIEW_HEIGHT)];
    //    [self addSubview:_numberView];
    //
    //
    //    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _numberView.bottom, self.width, 1)];
    //    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    //    [self addSubview:lineView];
    //
    //
    //    self.addressView = [[AddressView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _numberView.bottom + TOP_SPACE, VIEW_WIDTH, ADDRESSVIEW_HEIGHT)];
    //    _addressView.backgroundColor = VIEW_COLOR;
    //    [_addressView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:_addressView];
    //
    //    self.lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _addressView.bottom, self.width, 1)];
    //    _lineView1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    //    [self addSubview:_lineView1];
    
    self.reduceCardview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _orderDetailsView.bottom, self.width, DETAILSLABEL_HEIGHT)];
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
    
    self.deliveryUserID = [[DetailsView alloc]initWithFrame:CGRectMake(0, _discountview.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_deliveryUserID];
    self.deliveryUserName = [[DetailsView alloc]initWithFrame:CGRectMake(0, _deliveryUserID.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_deliveryUserName];
    self.deliveryUserPhone = [[DetailsView alloc]initWithFrame:CGRectMake(0, _deliveryUserName.bottom, self.width, DETAILSLABEL_HEIGHT)];
    [self addSubview:_deliveryUserPhone];
    
    self.deliveryUserPhone.hidden = YES;
     self.deliveryUserName.hidden = YES;
     self.deliveryUserID.hidden = YES;
    //    int num = 0;
    //    num = mealCount / 2 + mealCount % 2;
    //
    //    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, _discountview.bottom, self.width, num * 30 + 10 * (num - 1) + 30)];
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
    //    menuline.tag = 100002;
    //    [_menuView addSubview:menuline];
    
    self.totalPriceView = [[TotalPriceView alloc] initWithFrame:CGRectMake(0, _discountview.bottom , VIEW_WIDTH + 2 * LEFT_SPACE, TOTALPRICEVIEW_HEIGHT)];
    _totalPriceView.backgroundColor = VIEW_COLOR;
    [self addSubview:_totalPriceView];
}

- (void)hiddenSubView:(CGRect)frame mealCount:(int)mealCount
{
    self.addressView.hidden = YES;
    self.lineView1.hidden = YES;
    self.delivery.hidden = YES;
    self.foodBox.hidden = YES;
    self.firstRduce.hidden = YES;
    self.fullRduce.hidden = YES;
    self.reduceCardview.hidden = YES;
    self.discountview.hidden = YES;
    self.integralview.hidden = YES;
    self.otherMoney.hidden = YES;
    self.menuView.hidden = YES;
    self.totalPriceView.hidden = YES;

    [self viewWithTag:100002].hidden = YES;
    
     self.backView.frame = CGRectMake(0, 10, self.frame.size.width, [ProcessedViewCell didDeliveryCellHeight] - IMAGEVIEW_TOP_SPACE);
//    CGRect rect = BACKVIEW_FRAME;
//    rect.size.height = NUMBERVIEW_HEIGHT + IMAGEVIEW_TOP_SPACE;
}



- (void)disHiddenSubView:(CGRect)frame mealCount:(int)mealCount andHiddenImage:(BOOL)hidden
{
    self.numberView.hidden = NO;
    [self viewWithTag:100001].hidden = NO;
    self.addressView.hidden = NO;
    self.lineView1.hidden = NO;
    self.delivery.hidden = NO;
    self.foodBox.hidden = NO;
    self.firstRduce.hidden = NO;
    self.fullRduce.hidden = NO;
    self.reduceCardview.hidden = NO;
    self.discountview.hidden = NO;
    self.integralview.hidden = NO;
    self.otherMoney.hidden = NO;
    self.menuView.hidden = NO;
    [self viewWithTag:100002].hidden = NO;
    self.totalPriceView.hidden = NO;
    
}

-(void)setDealOrder:(DealOrderModel *)dealOrder
{
    _dealOrder = dealOrder;
    self.headView.numberLabel.text = [NSString stringWithFormat:@"%@号", dealOrder.orderNum];
//    self.numberView.arriveTimeLabel.text = dealOrder.hopeTime;
    switch (dealOrder.dealState.intValue) {
        case 2:
        {
            self.headView.stateLabel.text = @"待配送";
        }
            break;
        case 3:
        {
            self.headView.stateLabel.text = @"已配送";
            self.deliveryUserPhone.hidden = NO;
            self.deliveryUserName.hidden = NO;
            self.deliveryUserID.hidden = NO;
           
            
            self.totalPriceView.frame = CGRectMake(0, _deliveryUserPhone.bottom , VIEW_WIDTH + 2 * LEFT_SPACE, TOTALPRICEVIEW_HEIGHT);

        }
            break;
        case 4:
        {
            self.headView.stateLabel.text = @"已取消";
        }
            break;
        case 6:
        {
            self.headView.stateLabel.text = @"退款成功";
        }
            break;
        case 7:
        {
            self.headView.stateLabel.text = @"已完成";
        }
            break;
            
        default:
            break;
    }

//    self.numberView.dateLabel.text = dealOrder.orderTime;
//    self.addressView.addressLabel.text = [NSString stringWithFormat:@"%@", dealOrder.address];
//    self.addressView.contactLabel.text = [NSString stringWithFormat:@"%@", dealOrder.contect];
//    self.addressView.phoneLabel.text = [NSString stringWithFormat:@"%@", dealOrder.tel];
//    self.addressView.remarkLabel.text = [NSString stringWithFormat:@"备注:%@",dealOrder.remark ];
//    
//    if (dealOrder.gift.length != 0) {
//        self.addressView.giftLabel.text = [NSString stringWithFormat:@"奖品:%@", dealOrder.gift];
//    }else
//    {
//        self.addressView.giftLabel.text = @"奖品:无";
//    }
//    
//    self.addressView.orderLabel.text = dealOrder.orderId;
//    if ([dealOrder.payMath isEqualToNumber:@3]) {
//        self.addressView.payTypeLabel.text = @"现金支付";
//    }else
//    {
//        self.addressView.payTypeLabel.text = @"已付款";
//    }
    
    
    
    // 拿到时间
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate * date = [fomatter dateFromString:dealOrder.orderTime];
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
    
    NSString *string = [dealOrder.orderId substringToIndex:1];
    string = [string lowercaseString];
    
    if ([string isEqualToString:@"z"]) {
        self.headView.orderStyleLabel.text = @"外卖";
    }else
    {
        self.headView.orderStyleLabel.text = @"堂食";
    }
    
//    self.orderDetailsView.nameAndPhoneview.detailesLabel.text = [NSString stringWithFormat:@"%@ | %@", dealOrder.contect, dealOrder.tel];
    
    self.orderDetailsView.nameAndPhoneview.name = [NSString stringWithFormat:@"%@", dealOrder.contect];
    self.orderDetailsView.nameAndPhoneview.phonenumber = [NSString stringWithFormat:@"%@", dealOrder.tel];
    self.orderDetailsView.addressView.detailesLabel.text = [NSString stringWithFormat:@"%@", dealOrder.address];
    self.orderDetailsView.remarkView.detailesLabel.text = [NSString stringWithFormat:@"备注:%@", dealOrder.remark];
    
    if ([dealOrder.payMath isEqualToNumber:@3]) {
        self.orderDetailsView.payTypeLabel.text = @"现金支付";
    }else
    {
        self.orderDetailsView.payTypeLabel.text = @"已付款";
    }
    
//    for (int i = 0; i < dealOrder.mealArray.count; i++) {
//        Meal * meal = [dealOrder.mealArray objectAtIndex:i];
//        MealPriceView * mealPriceV = (MealPriceView *)[self.menuView viewWithTag:MEALPRICEVIEW_TAG + i];
//        mealPriceV.menuLabel.text = meal.name;
//        mealPriceV.menuPriceLB.text = [NSString stringWithFormat:@"¥%@", meal.money];
//        mealPriceV.numberLabel.text = [NSString stringWithFormat:@"X%@", meal.count];
//    }
    
    
    
    self.a = 8;
    if ([dealOrder.reduceCard doubleValue] != 0) {
//        self.reduceCardview.title.text = @"优惠券";
//        self.reduceCardview.detailLabel.text = @"1张";
        self.reduceCardview.detailesLabel.text = [NSString stringWithFormat:@"优惠券: -%.2f元", [dealOrder.reduceCard doubleValue]];
    }else
    {
        self.a--;
        self.reduceCardview.hidden = YES;
//        self.reduceCardview.detailLabel.text = nil;
        self.reduceCardview.frame = CGRectMake(0, _orderDetailsView.bottom , self.width, 0);
    }
    
    if ([dealOrder.internal intValue] != 0) {
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.width, DETAILSLABEL_HEIGHT);
        double integral = dealOrder.internal.doubleValue / 100;
//        self.integralview.title.text = @"积分";
//        self.integralview.detailLabel.text = nil;
//        self.integralview.detailLabel.text = [NSString stringWithFormat:@"%@", dealOrder.internal];
        self.integralview.detailesLabel.text = [NSString stringWithFormat:@"积分: -%.2f元", integral];
    }else
    {
        _a--;
        self.integralview.hidden = YES;
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.width, 0);
    }

    
    if ([dealOrder.delivery doubleValue] != 0) {
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.width, DETAILSLABEL_HEIGHT);
//        self.delivery.title.text = @"配送费";
        self.delivery.detailesLabel.text = [NSString stringWithFormat:@"配送费: +%.2f元", [dealOrder.delivery doubleValue]];
    }else
    {
        _a--;
        self.delivery.hidden = YES;
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.width, 0);
        self.foodBox.frame = CGRectMake(0, _delivery.bottom , self.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([dealOrder.foodBox doubleValue] != 0) {
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.width, DETAILSLABEL_HEIGHT);
//        self.foodBox.title.text = @"餐盒费";
        self.foodBox.detailesLabel.text = [NSString stringWithFormat:@"餐盒费: +%.2f元", [dealOrder.foodBox doubleValue]];
    }else
    {
        _a--;
        self.foodBox.hidden = YES;
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.width, 0);
    }
    
    if ([dealOrder.otherMoney doubleValue] != 0) {
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.otherMoney.title.text = @"其他费用";
        self.otherMoney.detailesLabel.text = [NSString stringWithFormat:@"其他费用: +%.2f元", [dealOrder.otherMoney doubleValue]];
    }else
    {
        _a--;
        self.otherMoney.hidden = YES;
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, 0);
    }
    
    if ([dealOrder.firstReduce doubleValue] != 0) {
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.firstRduce.title.text = @"首单立减";
        self.firstRduce.detailesLabel.text = [NSString stringWithFormat:@"首单立减: -%.2f元", [dealOrder.firstReduce doubleValue]];
    }else
    {
        self.a--;
        self.firstRduce.hidden = YES;
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, 0);
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([dealOrder.fullReduce doubleValue] != 0) {
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.fullRduce.title.text = @"满减优惠";
        self.fullRduce.detailesLabel.text =[NSString stringWithFormat:@"满减优惠: -%.2f元", [dealOrder.fullReduce doubleValue]];;
    }else
    {
        self.a--;
        self.fullRduce.hidden = YES;
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, 0);
    }
    if (dealOrder.discount != 0) {
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.width, DETAILSLABEL_HEIGHT);
//        self.discountview.title.text = @"打折优惠";
        self.discountview.detailesLabel.text = [NSString stringWithFormat:@"打折优惠: %.1f折", dealOrder.discount];
    }else
    {
        self.a--;
        self.discountview.hidden = YES;
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.width, 0);
    }

    int num = 0;
    num = _a ;
    
    self.totalPriceView.frame = CGRectMake(0, _discountview.bottom , VIEW_WIDTH * 2 * LEFT_SPACE, TOTALPRICEVIEW_HEIGHT);
    if (dealOrder.dealState.intValue == 3) {
        self.a += 3;
        self.deliveryUserID.frame = CGRectMake(0, _discountview.bottom, self.width, DETAILSLABEL_HEIGHT);
        self.deliveryUserName.frame = CGRectMake(0, _deliveryUserID.bottom, self.width, DETAILSLABEL_HEIGHT);
        self.deliveryUserPhone.frame = CGRectMake(0, _deliveryUserName.bottom, self.width, DETAILSLABEL_HEIGHT);

        self.deliveryUserID.detailesLabel.text = [NSString stringWithFormat:@"配送员编号:%@", dealOrder.deliveryUserId];
        self.deliveryUserName.detailesLabel.text = [NSString stringWithFormat:@"配送员姓名:%@", dealOrder.deliveryRealName];
        self.deliveryUserPhone.detailesLabel.text = [NSString stringWithFormat:@"配送员电话:%@", dealOrder.deliveryPhoneNo];
        self.deliveryUserPhone.haveDelivery = dealOrder.deliveryPhoneNo;
        self.totalPriceView.frame = CGRectMake(0, _deliveryUserPhone.bottom , VIEW_WIDTH * 2 * LEFT_SPACE, TOTALPRICEVIEW_HEIGHT);
    }
    
    count = self.a ;


//    self.totalPriceView.totalPriceLabel.text = [NSString stringWithFormat:@"%@", dealOrder.allMoney];
    
    if (dealOrder.dealState.intValue == 3 || dealOrder.dealState.intValue == 7) {
//        self.totalPriceView.hidden = YES;
        self.totalPriceView.dealButton.hidden = YES;
        self.totalPriceView.printButton.hidden = YES;
        self.totalPriceView.moneyStr = [NSString stringWithFormat:@"%@", dealOrder.allMoney];
        ishavetotleView = 1;
    }else
    {
        self.totalPriceView.hidden = NO;
        self.totalPriceView.moneyStr = [NSString stringWithFormat:@"%@", dealOrder.allMoney];
        ishavetotleView = 1;
    }
    
    
    
    self.backView.frame = CGRectMake(0, 10, self.frame.size.width, [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count] - IMAGEVIEW_TOP_SPACE);
    
}

+ (CGFloat)didDeliveryCellHeight
{
    return NUMBERVIEW_HEIGHT + IMAGEVIEW_TOP_SPACE * 2;
}

+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return HEADVIEW_HEIGHT  + DETAILSVIEW_HEIGHT + 10 + 30 * count + TOTALPRICEVIEW_HEIGHT * ishavetotleView ;
}


- (void)telToOrderTelNumber:(UIButton *)button
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.dealOrder.tel]];
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
