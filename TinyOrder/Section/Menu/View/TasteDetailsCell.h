//
//  TasteDetailsCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/10/31.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TasteDetailsView.h"

@interface TasteDetailsCell : UITableViewCell

@property (nonatomic, strong)TasteDetailsView * tasteDetailsView;
@property (nonatomic, assign)BOOL isEdit;
- (void)creatSubviews:(CGRect)frame;

@end
