//
//  ItemCollectionViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 16/4/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * backImageview;
@property (nonatomic, strong)UILabel * nameLabel;
- (void)createSubview;

@end
