//
//  OrderDetailsView.h
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsView.h"

@interface OrderDetailsView : UIView

@property (nonatomic, strong)DetailsView * nameAndPhoneview;
@property (nonatomic, strong)DetailsView * addressView;
@property (nonatomic, strong)DetailsView * remarkView;
@property (nonatomic, strong)DetailsView * giftView;

@property (nonatomic, strong)UILabel * payTypeLabel;
@property (nonatomic, strong)UIButton * phoneBT;

@end
