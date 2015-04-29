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
#define BACKVIEW_FRAME CGRectMake(0, 0, frame.size.width, [ProcessedViewCell cellHeightWithMealCount:mealCount] - IMAGEVIEW_TOP_SPACE)
#define NULLIYBUTTON_WIDTH 100


#define MEALPRICEVIEW_TAG 5000


@interface ProcessedViewCell ()

@property (nonatomic, strong)NumberView * numberView;
@property (nonatomic, strong)AddressView * addressView;
@property (nonatomic, strong)TotalPriceView * totalPriceView;
@property (nonatomic, strong)PriceView * priceView;
@property (nonatomic, strong)UILabel * remarkLabel;

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
    if (!_numberView) {
        UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [ProcessedViewCell cellHeightWithMealCount:mealCount] - IMAGEVIEW_TOP_SPACE)];
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
        _remarkLabel.text = @"备注: 本订单测试数据";
        //        _remarkLabel.backgroundColor = [UIColor orangeColor];
        [labelView addSubview:_remarkLabel];
        UIView * grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelView.bottom, labelView.width, 1.5)];
        grayLineView.tag = 1001;
        grayLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
        [self addSubview:grayLineView];
        UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, labelView.bottom + TOP_SPACE, VIEW_WIDTH, BUTTONVIEW_HEIGHT)];
        buttonView.backgroundColor = VIEW_COLOR;
        buttonView.tag = 1002;
        [self addSubview:buttonView];
        self.nulliyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nulliyButton.frame = CGRectMake(LEFT_SPACE, (buttonView.height - BUTTON_HEIGHT) / 2, NULLIYBUTTON_WIDTH, BUTTON_HEIGHT);
        [_nulliyButton setBackgroundImage:[UIImage imageNamed:@"nulliy.png"] forState:UIControlStateNormal];
//        _nulliyButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
//        [_nulliyButton setTitle:@"无效" forState:UIControlStateNormal];
//        _nulliyButton.tintColor = [UIColor blackColor];
        [buttonView addSubview:_nulliyButton];
        
        self.dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dealButton.frame = CGRectMake(buttonView.width - DEALBUTTON_WIDTH - LEFT_SPACE, _nulliyButton.top, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
//        _dealButton.frame = CGRectMake(buttonView.width / 2 - DEALBUTTON_WIDTH / 2, (buttonView.height - BUTTON_HEIGHT) / 2, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
//        _dealButton.backgroundColor = [UIColor redColor];
//        [_dealButton setTitle:@"标记餐已送出" forState:UIControlStateNormal];
        [_dealButton setBackgroundImage:[UIImage imageNamed:@"dealDelivery_n.png"] forState:UIControlStateNormal];
        [_dealButton setBackgroundImage:[UIImage imageNamed:@"dealDelivery_e.png"] forState:UIControlStateDisabled];
//        _dealButton.tintColor = [UIColor blackColor];
        [buttonView addSubview:_dealButton];
    }
}

- (void)hiddenSubView:(CGRect)frame mealCount:(int)mealCount
{
    self.addressView.hidden = YES;
    self.priceView.hidden = YES;
    self.totalPriceView.hidden = YES;
    [self viewWithTag:1000].hidden = YES;
    [self viewWithTag:1001].hidden = YES;
    [self viewWithTag:1002].hidden = YES;
    self.numberView.stateLabel.text = @"已配送";
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
    [self viewWithTag:1002].hidden = NO;
    for (int i = 0; i < mealCount; i++) {
        MealPriceView * mealPriceV = (MealPriceView *)[self viewWithTag:MEALPRICEVIEW_TAG + i];
        mealPriceV.hidden = NO;
    }
    [self viewWithTag:2000].frame = BACKVIEW_FRAME;
    self.numberView.stateImageView.image = [UIImage imageNamed:@"flod.png"];
    self.numberView.stateImageView.hidden = hidden;
    self.dealButton.enabled = hidden;
    if (hidden) {
        self.numberView.stateLabel.text = @"待配送";
        _nulliyButton.hidden = NO;
        _nulliyButton.frame = CGRectMake(LEFT_SPACE, (BUTTONVIEW_HEIGHT - BUTTON_HEIGHT) / 2, NULLIYBUTTON_WIDTH, BUTTON_HEIGHT);
        _dealButton.frame = CGRectMake(VIEW_WIDTH - DEALBUTTON_WIDTH - LEFT_SPACE, _nulliyButton.top, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    }else
    {
        self.numberView.stateLabel.text = @"已配送";
        _nulliyButton.hidden = YES;
        _dealButton.frame = CGRectMake((VIEW_WIDTH / 2) - (DEALBUTTON_WIDTH / 2), (BUTTONVIEW_HEIGHT - BUTTON_HEIGHT) / 2, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    }
}




-(void)setDealOrder:(DealOrderModel *)dealOrder
{
    _dealOrder = dealOrder;
    self.numberView.numberLabel.text = [NSString stringWithFormat:@"%@", dealOrder.orderNumber];
//    self.numberView.stateLabel.text = dealOrder.dealState;
    self.numberView.dateLabel.text = dealOrder.orderTime;
    self.addressView.addressLabel.text = dealOrder.address;
    self.addressView.contactLabel.text = dealOrder.contect;
    self.addressView.phoneLabel.text = dealOrder.tel;
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
}

+ (CGFloat)didDeliveryCellHeight
{
    return NUMBERVIEW_HEIGHT + IMAGEVIEW_TOP_SPACE * 2;
}

+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return NUMBERVIEW_HEIGHT + ADDRESSVIEW_HEIGHT + PRICEVIEW_HEIGHT + TOTALPRICEVIEW_HEIGHT + BUTTONVIEW_HEIGHT + 2 * 6 + LABEL_HEIGHT + IMAGEVIEW_TOP_SPACE + MEALPRICEVIEW_HEIGHT * mealCount;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
