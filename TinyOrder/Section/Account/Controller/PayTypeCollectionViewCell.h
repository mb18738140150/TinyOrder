//
//  PayTypeCollectionViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 16/6/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView * backView;
@property (nonatomic, strong)UIImageView * backImageview;
@property (nonatomic, strong)UILabel * nameLabel;
- (void)createSubview;
@end
