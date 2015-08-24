//
//  TJHoursView.h
//  picker
//
//  Created by 仙林 on 15/8/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SelectComplete)(NSNumber * date);
@interface TJHoursView : UIView


- (instancetype)initWithDataArray:(NSArray *)array;

- (void)finishSelectComplete:(SelectComplete)selectBlock;

@end
