//
//  FlowListModel.h
//  TinyOrder
//
//  Created by 仙林 on 16/1/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowListModel : NSObject

@property (nonatomic, assign)int type;
@property (nonatomic, copy)NSString * actionName;
@property (nonatomic, assign)double money;
@property (nonatomic, copy)NSString * date;
@property (nonatomic, assign)int state;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
