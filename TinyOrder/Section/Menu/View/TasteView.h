//
//  TasteView.h
//  TinyOrder
//
//  Created by 仙林 on 15/10/30.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasteView : UIView

@property (nonatomic, strong)UIButton * nameButton;
@property (nonatomic, strong)UIImageView * stateImageview;
@property (nonatomic, assign)int attId;

- (void)createSubviews;

@end
