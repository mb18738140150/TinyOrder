//
//  PrintType.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PrintType.h"

@interface PrintType ()<HTTPPostDelegate>

@end

@implementation PrintType

+(PrintType *)sharePrintType
{
    static PrintType *printType = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        printType = [[PrintType alloc]init];
        printType.printType = 0;
        printType.isGPRS = NO;
        printType.isGPRSenable = YES;
        printType.isBlutooth = NO;
        printType.gprsPrintNum = 1;
        printType.printState = -1;
//        printType.gprsPrintCount = -1;
//        [printType getType];
    });
    return printType;
}

- (void)getType
{
    
    NSDictionary *jsondic = @{
                              @"Command":@50,
                              @"UserId":[UserInfo shareUserInfo].userId
                              };
    [self playPostWithDictionary:jsondic];
    
    
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",  POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
    
}

- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    //    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10050]) {
            
            int type = (int)[data objectForKey:@"IsEnable"];

            
            if (type == 1) {
                self.isGPRS = YES;
            }else
            {
                self.isGPRS = NO;
            }
            
            }
        
    }else
    {
        
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            [SVProgressHUD dismiss];
        
    }
}



@end
