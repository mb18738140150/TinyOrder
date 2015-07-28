//
//  CommentModel.h
//  vlifree
//
//  Created by 仙林 on 15/7/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject


@property (nonatomic, strong)NSNumber * commentId;
@property (nonatomic, copy)NSString * commentName;
@property (nonatomic, copy)NSString * commentContent;
@property (nonatomic, strong)NSNumber * starCount;
@property (nonatomic, copy)NSString * commentTime;
@property (nonatomic, copy)NSString * reply;
@property (nonatomic, strong)NSNumber * anonymous;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
