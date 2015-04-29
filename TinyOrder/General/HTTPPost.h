//
//  HTTPPost.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/15.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>




@protocol HTTPPostDelegate <NSObject>

- (void)refresh:(id)data;

@optional
- (void)failWithError:(NSError *)error;


@end

@interface HTTPPost : NSObject<NSURLConnectionDelegate>

@property (nonatomic, assign) id<HTTPPostDelegate> delegate;
+ (HTTPPost *)shareHTTPPost;
- (void)post:(NSString *)urlString HTTPBody:(NSData *)body;







@end
