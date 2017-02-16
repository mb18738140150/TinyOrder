//
//  TasteDetailsView.h
//  TinyOrder
//
//  Created by 仙林 on 15/10/31.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditPropertyBlock)();

@interface TasteDetailsView : UIView

@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * integralLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UIButton * modifyBT;
@property (nonatomic, copy)EditPropertyBlock editBlock;

- (instancetype)initWithFrame:(CGRect)frame withEdit:(BOOL)isEdit;
- (void)editPropertyAction:(EditPropertyBlock)block;
@end
