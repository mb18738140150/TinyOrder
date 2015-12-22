//
//  OutSendPriceView.m
//  TinyOrder
//
//  Created by 仙林 on 15/11/13.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "OutSendPriceView.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10
#define TFHEIGHT 30
#define TFWIDTH (self.width - 5 * LEFT_SPACE) / 3
#define BUTTONWIDTH 30
@implementation OutSendPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    self.startdistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, TFWIDTH, TFHEIGHT)];
    _startdistanceLabel.layer.cornerRadius = 5;
    _startdistanceLabel.layer.masksToBounds = YES;
//    _startdistanceLabel.backgroundColor = [UIColor whiteColor];
//    _startdistanceLabel.textAlignment = NSTextAlignmentCenter;
    _startdistanceLabel.tag = 9001;
    [self addSubview:_startdistanceLabel];
    
//    UILabel *jiangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_startdistanceTF.right, TOP_SPACE, 30, TFHEIGHT)];
//    jiangeLabel.text = @"~";
//    jiangeLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:jiangeLabel];
    
    self.spaceDeliveryLabel = [[UILabel alloc]initWithFrame:CGRectMake(_startdistanceLabel.right, TOP_SPACE, TFWIDTH, TFHEIGHT)];
    _spaceDeliveryLabel.layer.cornerRadius = 5;
    _spaceDeliveryLabel.layer.masksToBounds = YES;
//    _spaceDeliveryLabel.backgroundColor = [UIColor whiteColor];
//    _spaceDeliveryLabel.textAlignment = NSTextAlignmentCenter;
    _spaceDeliveryLabel.tag = 9002;
    [self addSubview:_spaceDeliveryLabel];
    
//    UILabel * distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_endDistanceTF.right, TOP_SPACE, 30, TFHEIGHT)];
//    distanceLabel.text = @"km";
//    distanceLabel.textAlignment = NSTextAlignmentCenter;
//    distanceLabel.textColor = [UIColor blackColor];
//    [self addSubview:distanceLabel];
    
    self.spaceSendPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_spaceDeliveryLabel.right, TOP_SPACE, TFWIDTH , TFHEIGHT)];
    _spaceSendPriceLabel.layer.cornerRadius = 5;
    _spaceSendPriceLabel.layer.masksToBounds = YES;
//    _spaceSendPriceLabel.backgroundColor = [UIColor whiteColor];
//    _spaceSendPriceLabel.textAlignment = NSTextAlignmentCenter;
    _spaceSendPriceLabel.tag = 9003;
    [self addSubview:_spaceSendPriceLabel];
    
//    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_priceTF.right, TOP_SPACE, 20, TFHEIGHT)];
//    priceLabel.textAlignment = NSTextAlignmentCenter;
//    priceLabel.text = @"元";
//    [self addSubview:priceLabel];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteButton.frame = CGRectMake(_spaceSendPriceLabel.right , TOP_SPACE, BUTTONWIDTH, TFHEIGHT);
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _deleteButton.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    [self addSubview:_deleteButton];
    
}

@end
