//
//  ZNCitySelectView.h
//  CitySelector
//
//  Created by 开发_赵楠 on 15/6/8.
//  Copyright (c) 2015年 iOSMax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectComplete)(NSDictionary *provinceDic, NSDictionary *cityDic, NSDictionary *areaDic);
@interface ZNCitySelectView : UIView

@property (nonatomic, copy) NSString *m_title;

@property (nonatomic, copy) SelectComplete m_selectComplete;

- (void)show;

@end
