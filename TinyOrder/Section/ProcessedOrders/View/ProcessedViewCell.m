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
#import "PriceView.h"

#import "DealOrderModel.h"
#import "MealPriceView.h"
#import "Meal.h"
#import "PreferentialView.h"

#define IMAGEVIEW_TOP_SPACE 10
#define LEFT_SPACE 15
#define TOP_SPACE 2
#define NUMBERVIEW_HEIGHT 50
#define VIEW_WIDTH (self.frame.size.width - 2 * LEFT_SPACE)
#define ADDRESSVIEW_HEIGHT 140
#define PRICEVIEW_HEIGHT 31
#define MEALPRICEVIEW_HEIGHT 30
#define TOTALPRICEVIEW_HEIGHT 60
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

static int count = 0;
@interface ProcessedViewCell ()

@property (nonatomic, strong)NumberView * numberView;
@property (nonatomic, strong)AddressView * addressView;

@property (nonatomic, strong)PriceView * priceView;
@property (nonatomic, strong)UILabel * remarkLabel;
@property (nonatomic, strong)UIView * menuView;


@property (nonatomic, strong)PreferentialView * delivery;
@property (nonatomic, strong)PreferentialView * foodBox;
@property (nonatomic, strong)PreferentialView * otherMoney;
@property (nonatomic, strong)PreferentialView * firstRduce;
@property (nonatomic, strong)PreferentialView * fullRduce;
@property (nonatomic, strong)PreferentialView * reduceCardview;

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
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, [ProcessedViewCell cellHeightWithMealCount:mealCount] - IMAGEVIEW_TOP_SPACE)];
    _backView.image = [UIImage imageNamed:@"processedBack.png"];
    _backView.tag = 2000;
    [self addSubview:_backView];
    self.numberView = [[NumberView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _backView.top , VIEW_WIDTH, NUMBERVIEW_HEIGHT)];
    [self addSubview:_numberView];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _numberView.bottom, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    lineView.tag = 100001;
    [self addSubview:lineView];
    
    
    self.addressView = [[AddressView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _numberView.bottom + TOP_SPACE, VIEW_WIDTH, ADDRESSVIEW_HEIGHT)];
    _addressView.backgroundColor = VIEW_COLOR;
    [_addressView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addressView];
    
    self.lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _addressView.bottom, self.width, 1)];
    _lineView1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _lineView1.tag = 100003;
    [self addSubview:_lineView1];
    

    
    self.reduceCardview = [[PreferentialView alloc]initWithFrame:CGRectMake(0, _lineView1.bottom, self.width, 40)];
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
    
    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, _fullRduce.bottom, self.width, num * 30 + 10 * (num - 1) + 30)];
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
    menuline.tag = 100002;
    [_menuView addSubview:menuline];
    
    self.totalPriceView = [[TotalPriceView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _menuView.bottom , VIEW_WIDTH, TOTALPRICEVIEW_HEIGHT)];
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
    self.otherMoney.hidden = NO;
    self.menuView.hidden = NO;
    [self viewWithTag:100002].hidden = NO;
    self.totalPriceView.hidden = NO;
    
}




-(void)setDealOrder:(DealOrderModel *)dealOrder
{
    _dealOrder = dealOrder;
    self.numberView.numberLabel.text = [NSString stringWithFormat:@"%@号", dealOrder.orderNum];
    self.numberView.arriveTimeLabel.text = dealOrder.hopeTime;
    switch (dealOrder.dealState.intValue) {
        case 2:
        {
            self.numberView.stateLabel.text = @"待配送";
        }
            break;
        case 3:
        {
            self.numberView.stateLabel.text = @"已配送";
        }
            break;
        case 4:
        {
            self.numberView.stateLabel.text = @"已取消";
        }
            break;
        case 6:
        {
            self.numberView.stateLabel.text = @"退款成功";
        }
            break;
        case 7:
        {
            self.numberView.stateLabel.text = @"已完成";
        }
            break;
            
        default:
            break;
    }

    self.numberView.dateLabel.text = dealOrder.orderTime;
    self.addressView.addressLabel.text = [NSString stringWithFormat:@"%@", dealOrder.address];
    self.addressView.contactLabel.text = [NSString stringWithFormat:@"%@", dealOrder.contect];
    self.addressView.phoneLabel.text = [NSString stringWithFormat:@"%@", dealOrder.tel];
    self.addressView.remarkLabel.text = [NSString stringWithFormat:@"备注:%@",dealOrder.remark ];
    
    if (dealOrder.gift.length != 0) {
        self.addressView.giftLabel.text = [NSString stringWithFormat:@"奖品:%@", dealOrder.gift];
    }else
    {
        self.addressView.giftLabel.text = @"奖品:无";
    }
    
    self.addressView.orderLabel.text = dealOrder.orderId;
    if ([dealOrder.payMath isEqualToNumber:@3]) {
        self.addressView.payTypeLabel.text = @"餐到付款";
    }else
    {
        self.addressView.payTypeLabel.text = @"已付款";
    }
    
    
    for (int i = 0; i < dealOrder.mealArray.count; i++) {
        Meal * meal = [dealOrder.mealArray objectAtIndex:i];
        MealPriceView * mealPriceV = (MealPriceView *)[self.menuView viewWithTag:MEALPRICEVIEW_TAG + i];
        mealPriceV.menuLabel.text = meal.name;
        mealPriceV.menuPriceLB.text = [NSString stringWithFormat:@"¥%@", meal.money];
        mealPriceV.numberLabel.text = [NSString stringWithFormat:@"X%@", meal.count];
    }
    
    
    
    self.a = 6;
    if ([dealOrder.reduceCard doubleValue] != 0) {
        self.reduceCardview.title.text = @"优惠券";
        self.reduceCardview.detailLabel.text = @"1张";
        self.reduceCardview.titleLable.text = [NSString stringWithFormat:@"-%.2f元", [dealOrder.reduceCard doubleValue]];
    }else
    {
        self.a--;
        self.reduceCardview.hidden = YES;
        self.reduceCardview.frame = CGRectMake(0, _lineView1.bottom , self.width, 0);
    }
    
    if ([dealOrder.delivery doubleValue] != 0) {
        self.delivery.frame = CGRectMake(0, _reduceCardview.bottom , self.width, LABEL_HEIGHT);
        self.delivery.title.text = @"配送费";
        self.delivery.titleLable.text = [NSString stringWithFormat:@"+%.2f元", [dealOrder.delivery doubleValue]];
    }else
    {
        _a--;
        self.delivery.hidden = YES;
        self.delivery.frame = CGRectMake(0, _reduceCardview.bottom , self.width, 0);
        self.foodBox.frame = CGRectMake(0, _delivery.bottom , self.width, LABEL_HEIGHT);
    }
    
    if ([dealOrder.foodBox doubleValue] != 0) {
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.width, LABEL_HEIGHT);
        self.foodBox.title.text = @"餐盒费";
        self.foodBox.titleLable.text = [NSString stringWithFormat:@"+%.2f元", [dealOrder.foodBox doubleValue]];
    }else
    {
        _a--;
        self.foodBox.hidden = YES;
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.width, 0);
    }
    
    if ([dealOrder.otherMoney doubleValue] != 0) {
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, LABEL_HEIGHT);
        self.otherMoney.title.text = @"其他费用";
        self.otherMoney.titleLable.text = [NSString stringWithFormat:@"+%.2f元", [dealOrder.otherMoney doubleValue]];
    }else
    {
        _a--;
        self.otherMoney.hidden = YES;
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.width, 0);
    }
    
    if ([dealOrder.firstReduce doubleValue] != 0) {
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, LABEL_HEIGHT);
        self.firstRduce.title.text = @"首单立减";
        self.firstRduce.titleLable.text = [NSString stringWithFormat:@"-%.2f元", [dealOrder.firstReduce doubleValue]];
    }else
    {
        self.a--;
        self.firstRduce.hidden = YES;
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.width, 0);
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, LABEL_HEIGHT);
    }
    
    if ([dealOrder.fullReduce doubleValue] != 0) {
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, LABEL_HEIGHT);
        self.fullRduce.title.text = @"满减优惠";
        self.fullRduce.titleLable.text =[NSString stringWithFormat:@"-%.2f元", [dealOrder.fullReduce doubleValue]];;
    }else
    {
        self.a--;
        self.fullRduce.hidden = YES;
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.width, 0);
    }
    
    
    int num = 0;
    num = _a ;
    
    
    count = self.a ;
    
    self.menuView.frame = CGRectMake(0, _fullRduce.bottom, self.width, _menuView.height);
    
    self.totalPriceView.frame = CGRectMake(LEFT_SPACE, _menuView.bottom , VIEW_WIDTH, TOTALPRICEVIEW_HEIGHT);


    self.totalPriceView.totalPriceLabel.text = [NSString stringWithFormat:@"%@", dealOrder.allMoney];

    
    self.backView.frame = CGRectMake(0, 10, self.frame.size.width, [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count] - IMAGEVIEW_TOP_SPACE);
    
}

+ (CGFloat)didDeliveryCellHeight
{
    return NUMBERVIEW_HEIGHT + IMAGEVIEW_TOP_SPACE * 2;
}

+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return NUMBERVIEW_HEIGHT + ADDRESSVIEW_HEIGHT  + TOTALPRICEVIEW_HEIGHT + IMAGEVIEW_TOP_SPACE + MEALPRICEVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10  + 30 + 5 + count * 40;
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
