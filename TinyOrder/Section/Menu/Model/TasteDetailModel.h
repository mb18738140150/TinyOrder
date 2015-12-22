//
//  TasteDetailModel.h
//  TinyOrder
//
//  Created by 仙林 on 15/10/31.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasteDetailModel : NSObject

@property (nonatomic, assign)int attId;
@property (nonatomic, copy)NSString * attName;
@property (nonatomic, assign)double attPrice;
@property (nonatomic, assign)int attIntegral;

- (id)initWithDiationary:(NSDictionary *)dic;

@end
