//
//  StatisticalFigureViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/16.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "StatisticalFigureViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface StatisticalFigureViewController ()<UIWebViewDelegate>
{
    UIWebView * myWebView;
}
@end

@implementation StatisticalFigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    myWebView.delegate = self;
    [self.view addSubview:myWebView];
    
    NSString * httpStr = @"https://www.baidu.com";
    NSURL * httpUrl = [NSURL URLWithString:httpStr];
    NSURLRequest * httprequest = [NSURLRequest requestWithURL:httpUrl];
    [myWebView loadRequest:httprequest];
    
}
#pragma mark - WebView的代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 网页加载之前会调用此方法
    // return YES 表示正常加载网页 返回NO 将停止网页加载
    
    NSString * str= [[request URL]absoluteString];
    NSLog(@"str = %@", str);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 开始加载网页调用此方法
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 网页加载完成调用此方法
    // 首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext * context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString * alertJS = @"alert('test js OC')";// 准备执行的js代码
    [context evaluateScript:alertJS];// 通过OC方法调用js的alert
    
    
    // 想要知道目前的网页位置
//    NSString * location = [[webView window]valueForKeyPath:@"location.href"];
//    NSLog(@"location = %@", location);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // 网页加载失败 调用此方法
    
    NSLog(@"加载失败");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
