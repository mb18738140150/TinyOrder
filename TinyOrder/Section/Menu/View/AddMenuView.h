//
//  AddMenuView.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMenuView : UIView

//@property (nonatomic, strong)UIButton * mealPropertyBT;
@property (nonatomic, strong)UIButton * submitButton;
@property (nonatomic, strong)UITextField * nameTF;
@property (nonatomic, strong)UITextField * paceTF;
@property (nonatomic, strong)UITextField * integralTF;
@property (nonatomic, strong)UITextField * numberTF;
@property (nonatomic, strong)UIButton * photoButton;
@property (nonatomic, strong)UIImageView * photoView;

@property (nonatomic, strong)UITextField * unitTF;
@property (nonatomic, strong)UITextField * markTF;
@property (nonatomic, strong)UITextView * describeTFview;
// 排序
@property (nonatomic, strong)UITextField * sortCodeTF;

@property (nonatomic, strong)UITableView * propertyTableView;
@property (nonatomic, strong)UIButton * addPropertyButton;
// 同步按钮
@property (nonatomic, strong)UILabel * synchronousLabel;
@property (nonatomic, strong)UIButton * synchronousBT;
-(id)initWithFrame:(CGRect)frame andIsfromwaimaiOrTangshi:(int)iswhere isAddOrEdit:(int)isAddOrEdit;

@end
