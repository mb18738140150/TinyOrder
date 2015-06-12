//
//  NewOrdersiewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "NewOrdersiewCell.h"
#import "OrderView.h"
#import "MenuView.h"
#import "UIViewAdditions.h"
#import "OtherPaceView.h"
#import "TotalViw.h"
#import "NewOrderModel.h"
#import "Meal.h"

#define SPACE 20
#define TOP_SPACE 10
#define ORDWEVIEW_HEIGHT 172
#define MENUVIEW_HEIGHT 30
#define VIEW_WIDTH frame.size.width - 2 * SPACE
#define OTHERVIEW_HEIGHT 32
#define TOTALVIEW_HEIGHT 32
#define LABEL_HEIGHT 30
#define BUTTON_SPACE 40
#define BUTTON_HEIGHT 40
#define DEALBUTTON_WIDTH 142
#define NULLIYBUTTON_WIDTH 100
#define BUTTON_WIDTH_BAD 40

#define MENUVIEW_TAG 1000
#define LINE_WIDTH 1

@interface NewOrdersiewCell ()


@property (nonatomic, strong)OrderView * orderView;
@property (nonatomic, strong)UILabel * remarkLabel;
//@property (nonatomic, strong)MenuView * menuView;
@property (nonatomic, strong)OtherPaceView * otherPaceView;
@property (nonatomic, strong)TotalViw * totalView;


@end


@implementation NewOrdersiewCell


- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount
{
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_SPACE, frame.size.width, [NewOrdersiewCell cellHeightWithMealCount:mealCount] - TOP_SPACE * 2)];
    backView.image = [UIImage imageNamed:@"processedBack.png"];
    backView.tag = 2000;
    [self addSubview:backView];
    self.orderView = [[OrderView alloc] initWithFrame:CGRectMake(SPACE, SPACE, VIEW_WIDTH, ORDWEVIEW_HEIGHT)];
    [self addSubview:_orderView];
    for (int i = 0; i < mealCount; i++) {
        MenuView * menuView = [[MenuView alloc] initWithFrame:CGRectMake(SPACE, _orderView.bottom + i * MENUVIEW_HEIGHT, VIEW_WIDTH, MENUVIEW_HEIGHT)];
        menuView.tag = MENUVIEW_TAG + i;
        [self addSubview:menuView];
    }
    UIView * menuLineView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, _orderView.bottom + MENUVIEW_HEIGHT * mealCount, VIEW_WIDTH, LINE_WIDTH)];
    menuLineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:menuLineView];
    self.otherPaceView = [[OtherPaceView alloc] initWithFrame:CGRectMake(SPACE, menuLineView.bottom + TOP_SPACE, VIEW_WIDTH, OTHERVIEW_HEIGHT)];
    [self addSubview:_otherPaceView];
    self.totalView = [[TotalViw alloc] initWithFrame:CGRectMake(SPACE, _otherPaceView.bottom, VIEW_WIDTH, TOTALVIEW_HEIGHT)];
    //        totalView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_totalView];
    self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE, _totalView.bottom, self.width - 2 * SPACE, LABEL_HEIGHT)];
    _remarkLabel.text = @"备注: 无";
    _remarkLabel.textColor = [UIColor grayColor];
    //        _remarkLabel.backgroundColor = [UIColor orangeColor];
    [self addSubview:_remarkLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, _remarkLabel.bottom, _remarkLabel.width, LINE_WIDTH)];
    lineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:lineView];
    //        NSLog(@"%g", lineView.bottom);
    self.nulliyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nulliyButton.frame = CGRectMake(SPACE, lineView.bottom + TOP_SPACE, NULLIYBUTTON_WIDTH, BUTTON_HEIGHT);
    [_nulliyButton setBackgroundImage:[UIImage imageNamed:@"nulliy.png"] forState:UIControlStateNormal];
    //        _nulliyButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    //        [_nulliyButton setTitle:@"无效" forState:UIControlStateNormal];
    //        _nulliyButton.tintColor = [UIColor blackColor];
//    [self addSubview:_nulliyButton];
    
    self.dealButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _dealButton.frame = CGRectMake(self.width - DEALBUTTON_WIDTH - SPACE, lineView.bottom + TOP_SPACE, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    _dealButton.centerX = frame.size.width / 2;
    [_dealButton setBackgroundImage:[UIImage imageNamed:@"dealprint.png"] forState:UIControlStateNormal];
    //        _dealButton.backgroundColor = [UIColor redColor];
    //        [_dealButton setTitle:@"处理并打印" forState:UIControlStateNormal];
    //        _dealButton.tintColor = [UIColor blackColor];
    [self addSubview:_dealButton];

}

+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return ORDWEVIEW_HEIGHT + MENUVIEW_HEIGHT * mealCount + OTHERVIEW_HEIGHT + TOTALVIEW_HEIGHT + LABEL_HEIGHT + BUTTON_SPACE + TOP_SPACE * 6 + 2;
}


- (void)setOrderModel:(NewOrderModel *)orderModel
{
    _orderModel = orderModel;
    self.orderView.numLabel.text = [NSString stringWithFormat:@"%@号", orderModel.orderNum];
    self.orderView.stateLabel.text = @"等待处理";
    self.orderView.dateLabel.text = orderModel.orderTime;
    self.orderView.expectLabel.text = [NSString stringWithFormat:@"预订单:期望送达时间%@", orderModel.hopeTime];
    self.orderView.addressLabel.text = [NSString stringWithFormat:@"地址:%@", orderModel.address];
    self.orderView.telLabel.text = [NSString stringWithFormat:@"电话:%@", orderModel.tel];
    self.orderView.contactsLabel.text = [NSString stringWithFormat:@"联系人:%@", orderModel.contect];
    for (int i = 0; i < orderModel.mealArray.count; i++) {
        MenuView * menuView = (MenuView *)[self viewWithTag:MENUVIEW_TAG + i];
        Meal * meal = [orderModel.mealArray objectAtIndex:i];
        menuView.comboLabel.text = meal.name;
        menuView.numLabel.text = [NSString stringWithFormat:@"X%@", meal.count];
        menuView.paceLabel.text = [NSString stringWithFormat:@"¥%@", meal.money];
    }
//    NSLog(@"model %d", orderModel.mealArray.count);
    self.otherPaceView.paceLabel.text = [NSString stringWithFormat:@"¥%@", orderModel.otherMoney];
    self.totalView.paceLabel.text = [NSString stringWithFormat:@"¥%@", orderModel.allMoney];
    if ([orderModel.PayMath intValue] == 1) {
        self.totalView.stateLabel.text = @"已支付";
        self.totalView.stateImageV.image = [UIImage imageNamed:@"state@2x.png"];
    }else if([orderModel.PayMath intValue] == 2)
    {
        self.totalView.stateLabel.text = @"已支付";
        self.totalView.stateImageV.image = [UIImage imageNamed:@"state@2x.png"];
    }else
    {
        self.totalView.stateLabel.text = @"餐到付款";
        self.totalView.stateImageV.image = [UIImage imageNamed:@"nopay.png"];
    }
    self.remarkLabel.text = [NSString stringWithFormat:@"备注:%@", orderModel.remark];
}


- (NSString *)getPrintStringWithMealCount:(int)mealCount
{
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%@\r    <<本单由微生活外卖提供>>\r", self.orderView.numLabel.text];
    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    [str appendFormat:@"下单日期:%@\r%@", self.orderView.dateLabel.text, lineStr];
//    [str appendFormat:@"%@\r", self.orderView.expectLabel.text];
    [str appendFormat:@"地址:%@\r", self.orderView.addressLabel.text];
    [str appendFormat:@"联系人:%@\r", self.orderView.contactsLabel.text];
    [str appendFormat:@"电话:%@\r%@", self.orderView.telLabel.text, lineStr];
//    [str appendFormat:@"%@\r", self.menuView.numMenuLabel.text];
//    NSLog(@"...%ld", mealCount);
    for (int i = 0; i < mealCount; i++) {
        MenuView * menuView = (MenuView *)[self viewWithTag:MENUVIEW_TAG + i];
        [str appendFormat:@"%@  X%@  %@元\r", menuView.comboLabel.text, menuView.numLabel.text, menuView.paceLabel.text];
    }
    [str appendString:lineStr];
    [str appendFormat:@"%@           %@元\r%@", self.otherPaceView.titleLable.text, self.otherPaceView.paceLabel.text, lineStr];
    [str appendFormat:@"总计     %@元     %@\r%@", self.totalView.paceLabel.text, self.totalView.stateLabel.text, lineStr];
    [str appendFormat:@"%@\n\n\n", self.remarkLabel.text];
//    NSLog(@"+====%@", self.remarkLabel.text);
    return [str copy];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
