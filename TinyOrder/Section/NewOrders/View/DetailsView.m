//
//  DetailsView.m
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "DetailsView.h"

#define LETF_SPACE 10
#define TOP_SPACE 10

#define LINEVIEW_TAG 1000

@implementation DetailsView


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
//    self.backgroundColor = [UIColor colorWithRed:(arc4random() % (1 + 254) + 1 ) / 255.0 green:(arc4random() % (1 + 254) + 1 ) / 255.0 blue:(arc4random() % (1 + 254) + 1 ) / 255.0 alpha:1];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(LETF_SPACE, TOP_SPACE, 10, 10)];
    imageView.image = [UIImage imageNamed:@"start_tangshi_icon.png"];
    [self addSubview:imageView];
    
    self.detailesLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + LETF_SPACE, 0, self.width - 2 * LETF_SPACE - imageView.width, self.height)];
    self.detailesLabel.textColor = [UIColor grayColor];
    self.detailesLabel.text = @"总计:";
    _detailesLabel.numberOfLines = 0;
//    _detailesLabel.backgroundColor = [UIColor colorWithRed:(arc4random()%254 + 1) / 255.0 green:(arc4random()%254 + 1) / 255.0 blue:(arc4random()%254 + 1) / 255.0 alpha:.6];
    [self addSubview:_detailesLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_detailesLabel.right + 2, _detailesLabel.top + 8, 1, _detailesLabel.height - 16)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.tag = LINEVIEW_TAG;
    lineView.hidden = YES;
    [self addSubview:lineView];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.right + 2, _detailesLabel.top, _detailesLabel.width, _detailesLabel.height)];
    self.phoneLabel.textColor = [UIColor grayColor];
    self.phoneLabel.text = @"18734980150";
    _phoneLabel.hidden = YES;
    [self addSubview:_phoneLabel];
}

- (void)setName:(NSString *)name
{
    self.detailesLabel.text = name;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect nameRect = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, self.detailesLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.detailesLabel.frame = CGRectMake(_detailesLabel.left, 0, nameRect.size.width, self.detailesLabel.height);
    UIView * lineView = [self viewWithTag:LINEVIEW_TAG];
    lineView.hidden = NO;
    _phoneLabel.hidden = NO;
    lineView.frame = CGRectMake(_detailesLabel.right + 4, _detailesLabel.top + 7, 1, _detailesLabel.height - 14);
    self.phoneLabel.frame = CGRectMake(lineView.right + 4, _detailesLabel.top, _detailesLabel.width, _detailesLabel.height);
    
}

- (void)setPhonenumber:(NSString *)phonenumber
{
    self.phoneLabel.text = phonenumber;
    UIView * lineView = [self viewWithTag:LINEVIEW_TAG];
    lineView.hidden = NO;
    _phoneLabel.hidden = NO;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect phoneRect = [phonenumber boundingRectWithSize:CGSizeMake(MAXFLOAT, self.detailesLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.phoneLabel.frame = CGRectMake(_phoneLabel.left, _detailesLabel.top, phoneRect.size.width, _detailesLabel.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
