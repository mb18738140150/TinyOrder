//
//  DetailsView.h
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsView : UIView

@property (nonatomic, strong)UILabel * detailesLabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * phonenumber;

@end
