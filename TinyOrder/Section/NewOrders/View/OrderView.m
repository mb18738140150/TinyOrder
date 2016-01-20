//
//  OrderView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "OrderView.h"
#import "UIViewAdditions.h"

#define NUMLABEL_WIDTH 40
#define NUMLABEL_HEIGHT 30
#define SPACE 20
#define TOP_SPACE 10
#define EXPECTLB_HEIGHT 30
#define LETF_SPACE 10

#define PHONE_WIDTH 200
#define LABEL_HEIGHT 25
#define IMAGE_WIDTH 25


#define NUMLB_TEXTCOLOR [UIColor orangeColor];

//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]


@implementation OrderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView:frame];
    }
    return self;
}

- (void)createSubView:(CGRect)frame
{
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, TOP_SPACE, NUMLABEL_WIDTH, NUMLABEL_HEIGHT)];
    _numberLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    _numberLabel.backgroundColor = ROMDOM_COLOR;
    _numberLabel.text = @"10号";
    _numberLabel.adjustsFontSizeToFitWidth = YES;
    _numberLabel.font = [UIFont systemFontOfSize:19];
    [self addSubview:_numberLabel];
    
    
    //    self.stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - IMAGE_WIDTH, 10, IMAGE_WIDTH, IMAGE_WIDTH)];
    //    _stateImageView.center = CGPointMake(_stateImageView.centerX, self.height / 2);
    //    _stateImageView.image = [UIImage imageNamed:@"proceState.png"];
    //    [self addSubview:_stateImageView];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(_numberLabel.right, TOP_SPACE, self.width / 2 - LETF_SPACE - NUMLABEL_WIDTH, _numberLabel.height)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.enabled = NO;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
//    textField.returnKeyType = UIReturnKeyDone;
//    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:textField];
    
    UILabel * arriveLB = [[UILabel alloc]initWithFrame:CGRectMake(textField.left + 1, TOP_SPACE + 1, textField.width / 2 - 1, textField.height - 2)];
    arriveLB.text = @"送达时间";
    arriveLB.adjustsFontSizeToFitWidth = YES;
//    arriveLB.backgroundColor = [UIColor orangeColor];
//    arriveLB.font = [UIFont systemFontOfSize:11];
    arriveLB.layer.cornerRadius = 5;
    arriveLB.layer.masksToBounds = YES;
    arriveLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:arriveLB];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(arriveLB.right - 1, arriveLB.top + 4, 1, 20)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];
    
    self.arriveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(line.right, arriveLB.top, textField.width / 2 - 1, arriveLB.height)];
    _arriveTimeLabel.text = @"00:00";
    _arriveTimeLabel.textAlignment = NSTextAlignmentCenter;
//    _arriveTimeLabel.font = [UIFont systemFontOfSize:13];
    _arriveTimeLabel.adjustsFontSizeToFitWidth = YES;
    _arriveTimeLabel.layer.cornerRadius = 5;
    _arriveTimeLabel.layer.masksToBounds = YES;
    self.arriveTimeLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [self addSubview:_arriveTimeLabel];
    
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, TOP_SPACE, 60, _numberLabel.height)];
    _stateLabel.textColor = [UIColor grayColor];
    _stateLabel.backgroundColor = ROMDOM_COLOR;
    _stateLabel.font = [UIFont systemFontOfSize:15];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_stateLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_stateLabel.right, _stateLabel.top + 5, 1, _stateLabel.height - 10)];
    line2.backgroundColor = [UIColor grayColor];
    [self addSubview:line2];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(line2.right, _stateLabel.top, self.width / 2 - _stateLabel.width - LETF_SPACE - 1, _stateLabel.height)];
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.backgroundColor = ROMDOM_COLOR;
    _dateLabel.numberOfLines = 0;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(-15, _numberLabel.bottom + 10, self.width + 30, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:lineView];

    
    UILabel * orderLB = [[UILabel alloc]initWithFrame:CGRectMake(0, lineView.bottom + 5, 60, LABEL_HEIGHT)];
    orderLB.text = @"订单号:";
    orderLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:orderLB];
    
    self.orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderLB.right, orderLB.top, self.width - 2 * LETF_SPACE - 30, LABEL_HEIGHT)];
    _orderLabel.textColor = [UIColor orangeColor];
    _orderLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_orderLabel];
    
    UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6 * TOP_SPACE  + lineView.bottom, IMAGE_WIDTH, IMAGE_WIDTH)];
    addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [self addSubview:addressImageView];
    
    self.noteimageView = [[UIImageView alloc]initWithFrame:CGRectMake(addressImageView.left, addressImageView.bottom , addressImageView.width, addressImageView.height)];
    _noteimageView.image = [UIImage imageNamed:@"remark_order.png"];
    [self addSubview:_noteimageView];
    
    self.isOrNOBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isOrNOBT.frame = CGRectMake(_noteimageView.left, _noteimageView.bottom, _noteimageView.width, _noteimageView.height);
    self.isOrNOBT.layer.cornerRadius = 12.5;
    self.isOrNOBT.layer.masksToBounds = YES;
    self.isOrNOBT.layer.borderWidth = 1;
    self.isOrNOBT.layer.borderColor = [UIColor blackColor].CGColor;
//    [self addSubview:_isOrNOBT];
    
    self.contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.right + LETF_SPACE,  _orderLabel.bottom, 60, LABEL_HEIGHT)];
    _contactLabel.text = @"王先生哈";
    _contactLabel.font = [UIFont systemFontOfSize:15];
    _contactLabel.textAlignment = NSTextAlignmentLeft;
    _contactLabel.backgroundColor = ROMDOM_COLOR;
    [self addSubview:_contactLabel];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(_contactLabel.right, _contactLabel.top + 5, 1, _contactLabel.height - 10)];
    line1.backgroundColor = [UIColor grayColor];
    [self addSubview:line1];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(line1.right, _contactLabel.top, 100, LABEL_HEIGHT)];
    _phoneLabel.backgroundColor = ROMDOM_COLOR;
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_phoneLabel];
    
    self.phoneBT = [UIButton buttonWithType:UIButtonTypeSystem];
    self.phoneBT.frame = _phoneLabel.frame;
    [self addSubview:_phoneBT];
    
    self.payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 80, _contactLabel.top, 80, _contactLabel.height)];
    _payTypeLabel.layer.cornerRadius = 5;
    _payTypeLabel.layer.masksToBounds = YES;
    _payTypeLabel.layer.borderWidth = 1;
    _payTypeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _payTypeLabel.textAlignment = NSTextAlignmentCenter;
    _payTypeLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [self addSubview:_payTypeLabel];
    
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contactLabel.left, _contactLabel.bottom, self.width - 3 * LETF_SPACE - 40, 30)];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _addressLabel.numberOfLines = 0;
    _addressLabel.adjustsFontSizeToFitWidth = YES;
    _addressLabel.textColor = [UIColor grayColor];
    [self addSubview:_addressLabel];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressLabel.left, _addressLabel.bottom, self.width - 3 * LETF_SPACE - 40, LABEL_HEIGHT)];
    _remarkLabel.font = [UIFont systemFontOfSize:15];
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.textColor = [UIColor grayColor];
    [self addSubview:_remarkLabel];
    
    self.giftLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressLabel.left, _remarkLabel.bottom, self.width - 3 * LETF_SPACE - 40, LABEL_HEIGHT)];
    _giftLabel.font = [UIFont systemFontOfSize:15];
    _giftLabel.textColor = [UIColor grayColor];
    [self addSubview:_giftLabel];
    
    self.lineView1 = [[UIView alloc] initWithFrame:CGRectMake(-15, _giftLabel.bottom + 4, self.width + 30, 1)];
    _lineView1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:_lineView1];
    
//    NSLog(@"%g", lineView.bottom);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
