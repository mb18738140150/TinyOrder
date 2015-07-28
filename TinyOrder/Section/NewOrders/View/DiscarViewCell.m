//
//  DiscarViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DiscarViewCell.h"
#import "NumberView.h"
#import "AddressView.h"
#import "UIViewAdditions.h"
#import "PriceView.h"
#import "TotalPriceView.h"
#import "DealOrderModel.h"
#import "MealPriceView.h"
#import "Meal.h"

#define IMAGEVIEW_TOP_SPACE 10
#define LEFT_SPACE 15
#define TOP_SPACE 2
#define NUMBERVIEW_HEIGHT 70
#define VIEW_WIDTH (frame.size.width - 2 * LEFT_SPACE)
#define ADDRESSVIEW_HEIGHT 60
#define PRICEVIEW_HEIGHT 30
#define MEALPRICEVIEW_HEIGHT 30
#define TOTALPRICEVIEW_HEIGHT 40
#define BUTTONVIEW_HEIGHT 60
#define BUTTON_HEIGHT 40
#define DEALBUTTON_WIDTH 146
#define BUTTON_SPACE 30
#define BUTTON_LEFT_SPACE 10
#define VIEW_COLOR [UIColor whiteColor]
#define LABEL_HEIGHT 30
#define LINEVIEW_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0]
#define BACKVIEW_FRAME CGRectMake(0, 5, frame.size.width, [DiscarViewCell cellHeightWithMealCount:mealCount] - IMAGEVIEW_TOP_SPACE)
#define NULLIYBUTTON_WIDTH 100


#define MEALPRICEVIEW_TAG 5000

@interface DiscarViewCell ()



@property (nonatomic, strong)NumberView * numberView;
@property (nonatomic, strong)AddressView * addressView;
@property (nonatomic, strong)TotalPriceView * totalPriceView;
@property (nonatomic, strong)PriceView * priceView;
@property (nonatomic, strong)UILabel * remarkLabel;


@end



@implementation DiscarViewCell





- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)createSubView:(CGRect)frame mealCount:(int)mealCount
{
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, [DiscarViewCell cellHeightWithMealCount:mealCount] - IMAGEVIEW_TOP_SPACE)];
    backView.image = [UIImage imageNamed:@"processedBack.png"];
    backView.tag = 2000;
    [self addSubview:backView];
    self.numberView = [[NumberView alloc] initWithFrame:CGRectMake(LEFT_SPACE, backView.top, VIEW_WIDTH, NUMBERVIEW_HEIGHT)];
    [self addSubview:_numberView];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(_numberView.left, _numberView.bottom, _numberView.width, 2)];
    lineView.backgroundColor = LINEVIEW_COLOR;
    [self addSubview:lineView];
    self.addressView = [[AddressView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _numberView.bottom + TOP_SPACE, VIEW_WIDTH, ADDRESSVIEW_HEIGHT)];
    _addressView.backgroundColor = VIEW_COLOR;
    [self addSubview:_addressView];
    
    for (int i = 0; i < mealCount; i++) {
        MealPriceView * mealPriceV = [[MealPriceView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _addressView.bottom + TOP_SPACE + i * MEALPRICEVIEW_HEIGHT, VIEW_WIDTH, MEALPRICEVIEW_HEIGHT)];
        mealPriceV.tag = MEALPRICEVIEW_TAG + i;
        [self addSubview:mealPriceV];
    }
    
    self.priceView = [[PriceView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _addressView.bottom + TOP_SPACE + MEALPRICEVIEW_HEIGHT * mealCount, VIEW_WIDTH, PRICEVIEW_HEIGHT)];
    _priceView.backgroundColor = VIEW_COLOR;
    [self addSubview:_priceView];
    self.totalPriceView = [[TotalPriceView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _priceView.bottom + TOP_SPACE, VIEW_WIDTH, TOTALPRICEVIEW_HEIGHT)];
    _totalPriceView.backgroundColor = VIEW_COLOR;
    [self addSubview:_totalPriceView];
    UIView * labelView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _totalPriceView.bottom + TOP_SPACE, VIEW_WIDTH, LABEL_HEIGHT)];
    labelView.backgroundColor = VIEW_COLOR;
    labelView.tag = 1000;
    [self addSubview:labelView];
    self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, labelView.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    _remarkLabel.text = @"备注: 无";
    //        _remarkLabel.backgroundColor = [UIColor orangeColor];
    [labelView addSubview:_remarkLabel];
    UIView * grayLineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, labelView.bottom, labelView.width, 1)];
    grayLineView.tag = 1001;
    grayLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:grayLineView];
//    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, labelView.bottom + TOP_SPACE, VIEW_WIDTH, BUTTONVIEW_HEIGHT)];
//    buttonView.backgroundColor = VIEW_COLOR;
//    buttonView.tag = 1002;
//    [self addSubview:buttonView];
}

- (void)hiddenSubView:(CGRect)frame mealCount:(int)mealCount
{
    self.addressView.hidden = YES;
    self.priceView.hidden = YES;
    self.totalPriceView.hidden = YES;
    [self viewWithTag:1000].hidden = YES;
    [self viewWithTag:1001].hidden = YES;
//    [self viewWithTag:1002].hidden = YES;
//    self.numberView.stateLabel.text = @"已配送";
    for (int i = 0; i < mealCount; i++) {
        MealPriceView * mealPriceV = (MealPriceView *)[self viewWithTag:MEALPRICEVIEW_TAG + i];
        mealPriceV.hidden = YES;
    }
    CGRect rect = BACKVIEW_FRAME;
    rect.size.height = NUMBERVIEW_HEIGHT + IMAGEVIEW_TOP_SPACE;
    [self viewWithTag:2000].frame = rect;
    self.numberView.stateImageView.image = [UIImage imageNamed:@"unfold.png"];
    self.numberView.stateImageView.hidden = NO;
}



- (void)disHiddenSubView:(CGRect)frame mealCount:(int)mealCount andHiddenImage:(BOOL)hidden
{
    self.addressView.hidden = NO;
    self.priceView.hidden = NO;
    self.totalPriceView.hidden = NO;
    [self viewWithTag:1000].hidden = NO;
    [self viewWithTag:1001].hidden = NO;
//    [self viewWithTag:1002].hidden = NO;
    for (int i = 0; i < mealCount; i++) {
        MealPriceView * mealPriceV = (MealPriceView *)[self viewWithTag:MEALPRICEVIEW_TAG + i];
        mealPriceV.hidden = NO;
    }
    [self viewWithTag:2000].frame = BACKVIEW_FRAME;
    self.numberView.stateImageView.image = [UIImage imageNamed:@"flod.png"];
    self.numberView.stateImageView.hidden = hidden;
}




-(void)setDealOrder:(DealOrderModel *)dealOrder
{
    _dealOrder = dealOrder;
    self.numberView.numberLabel.text = [NSString stringWithFormat:@"%@", dealOrder.orderNumber];
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
            self.numberView.stateLabel.text = @"已作废";
        }
            break;
        case 6:
        {
            self.numberView.stateLabel.text = @"已退款";
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
    self.addressView.addressLabel.text = [NSString stringWithFormat:@"地址:%@", dealOrder.address];
    self.addressView.contactLabel.text = [NSString stringWithFormat:@"联系人:%@", dealOrder.contect];
    self.addressView.phoneLabel.text = [NSString stringWithFormat:@"电话:%@", dealOrder.tel];
    for (int i = 0; i < dealOrder.mealArray.count; i++) {
        Meal * meal = [dealOrder.mealArray objectAtIndex:i];
        MealPriceView * mealPriceV = (MealPriceView *)[self viewWithTag:MEALPRICEVIEW_TAG + i];
        mealPriceV.menuLabel.text = meal.name;
        mealPriceV.menuPriceLB.text = [NSString stringWithFormat:@"¥%@", meal.money];
        mealPriceV.numberLabel.text = [NSString stringWithFormat:@"X%@", meal.count];
    }
    //    self.priceView.otherLael.text = @"其他费用";
    self.priceView.otherPriceLB.text = [NSString stringWithFormat:@"¥%@", dealOrder.otherMoney];
    self.totalPriceView.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", dealOrder.allMoney];
    self.remarkLabel.text = [NSString stringWithFormat:@"备注:%@",dealOrder.remark];
    
    if ([dealOrder.payMath isEqualToNumber:@3]) {
        self.totalPriceView.payTypeLB.text = @"餐到付款";
    }else if ([dealOrder.payMath isEqualToNumber:@1])
    {
        self.totalPriceView.payTypeLB.text = @"微信支付";
    }else if ([dealOrder.payMath isEqualToNumber:@2])
    {
        self.totalPriceView.payTypeLB.text = @"百度支付";
    }
    
}

+ (CGFloat)didDeliveryCellHeight
{
    return NUMBERVIEW_HEIGHT + IMAGEVIEW_TOP_SPACE * 2;
}

+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return NUMBERVIEW_HEIGHT + ADDRESSVIEW_HEIGHT + PRICEVIEW_HEIGHT + TOTALPRICEVIEW_HEIGHT + 2 * 6 + LABEL_HEIGHT + IMAGEVIEW_TOP_SPACE + MEALPRICEVIEW_HEIGHT * mealCount;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    self.dealOrder.isSelete = selected;

    // Configure the view for the selected state
}

@end
