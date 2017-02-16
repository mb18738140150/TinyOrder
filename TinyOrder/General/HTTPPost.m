//
//  HTTPPost.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/15.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "HTTPPost.h"
#import "AppDelegate.h"
static HTTPPost * httpPost = nil;


@interface HTTPPost ()

@property (nonatomic, retain) NSMutableData * data;
@property (nonatomic, retain) NSMutableArray * dataArray;

@end


@implementation HTTPPost


+ (HTTPPost *)shareHTTPPost
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpPost = [[HTTPPost alloc] init];
        httpPost.ishaveNet = YES;
    });
    return httpPost;
}

- (void)post:(NSString *)urlString HTTPBody:(NSData *)body
{
//    NSString * str = nil;
//        str = @"有网络";
//        //为了请求接口的正确性
//        NSString * newUrlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        //    NSString * newUrlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        NSLog(@"%@", newUrlStr);
//        NSURL * url = [NSURL URLWithString:newUrlStr];
//        //    NSLog(@"%@", url);
//        //根据URL创建一个请求
//        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:body];
//        //和服务器建立异步连接
//        [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSString * newUrlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:newUrlStr];
    NSLog(@"urlStr = %@", urlString);
    // 创建请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
            if (error.code == -1009) {
                ;
            }
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSError * error1 = [NSError errorWithDomain:@"" code:10000 userInfo:@{@"Reason":@"服务器连接失败"}];
                [self.delegate failWithError:error1];
                
                
            });
            NSLog(@"++++++=%@", error);
            
        }else
        {
           
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //            NSLog(@"*****%@", [dic description]);
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (dic == nil) {
                    
                    NSError * error = [NSError errorWithDomain:@"" code:10000 userInfo:@{@"Reason":@"服务器处理失败"}];
                    [self.delegate failWithError:error];
                    
                }else
                {
                    [self.delegate refresh:dic];
                }
            });
        }
    }];
    
    [task resume];
    
}


//收到服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.data = nil;
//        NSLog(@"收到服务器的响应didReceiveResponse");
}


//传输数据(可能会调用多次,每次回来一个data片段)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //把传回来的data片段拼到一起
    [self.data appendData:data];
    
//        NSLog(@"传输数据didReceiveData");
}

//数据传输完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"++%@", [[NSString alloc] initWithData:self.data encoding:0]);
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
    NSArray * array = [dic objectForKey:@"OrderDetailList"];
    NSLog(@"%@", dic);
    NSLog(@"dic.OrderDetailList.count = %d",array.count);
    NSLog(@"dic class = ", [dic class]);
    if (dic == nil) {
        NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"Reason":@"服务器处理失败"}];
        [self.delegate failWithError:error];
    }else
    {
        [self.delegate refresh:dic];
    }
}

//请求失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate failWithError:error];
}

- (NSMutableData *)data
{
    if (_data == nil) {
        self.data = [NSMutableData data];
    }
    return _data;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

@end
