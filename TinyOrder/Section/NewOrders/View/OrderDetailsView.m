//
//  OrderDetailsView.m
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "OrderDetailsView.h"

#define LETF_SPACE 10
#define TOP_SPACE 10
#define LABEL_HEIGHT 30
@implementation OrderDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    self.nameAndPhoneview = [[DetailsView alloc]initWithFrame:CGRectMake(0, TOP_SPACE, self.width - 90, LABEL_HEIGHT)];
    [self addSubview:_nameAndPhoneview];
    
    self.addressView = [[DetailsView alloc]initWithFrame:CGRectMake(0, _nameAndPhoneview.bottom, self.width, LABEL_HEIGHT)];
    [self addSubview:_addressView];
    
    self.openTimeview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _addressView.bottom, self.width, LABEL_HEIGHT)];
    _openTimeview.hidden = YES;
    [self addSubview:_openTimeview];
    
    self.remarkView = [[DetailsView alloc]initWithFrame:CGRectMake(0, _addressView.bottom, self.width, LABEL_HEIGHT)];
    [self addSubview:_remarkView];
    
    self.giftView = [[DetailsView alloc]initWithFrame:CGRectMake(0, _remarkView.bottom, self.width, LABEL_HEIGHT)];
    _giftView.hidden = YES;
    [self addSubview:_giftView];
    
    self.payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameAndPhoneview.right, _nameAndPhoneview.top, 80, LABEL_HEIGHT)];
    _payTypeLabel.textAlignment = NSTextAlignmentCenter;
    _payTypeLabel.textColor = BACKGROUNDCOLOR;
    _payTypeLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_payTypeLabel];
    
    self.phoneBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneBT.frame = CGRectMake(_nameAndPhoneview.right + 30, TOP_SPACE, 30, 30);
    [_phoneBT setBackgroundImage:[[UIImage imageNamed:@"tel_detail_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _phoneBT.hidden = YES;
    [self addSubview:_phoneBT];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
