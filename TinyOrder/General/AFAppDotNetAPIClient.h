//
//  AFAppDotNetAPIClient.h
//  TinyOrder
//
//  Created by 仙林 on 16/3/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+ (instancetype)shareClientWithView:(UIView *)view;
@end
