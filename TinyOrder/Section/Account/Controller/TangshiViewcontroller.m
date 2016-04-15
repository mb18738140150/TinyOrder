//
//  TangshiViewcontroller.m
//  TinyOrder
//
//  Created by 仙林 on 16/4/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TangshiViewcontroller.h"
#import "AccountModel.h"

#define SPACE 10
#define IMAGEVIEW_WIDTH 30
#define DETAILLB_WIDTH 100
#define VIEW_COLOR [UIColor clearColor]
#define SWITH_TAG 3000
#define SCROLLView_tag 100
#define TANGSTATE_TAG 10000

@interface TangshiViewcontroller ()<HTTPPostDelegate>
@property (nonatomic, strong)UISwitch * tangStateSW;

@property (nonatomic, strong)UIView * tangshiautoStateView;
@property (nonatomic, strong)UISwitch * tangAutoStateSW;
@property (nonatomic, strong)UISwitch * helpTangshiSW;
@end

@implementation TangshiViewcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:scrollview];

    
    UIView * tangStateView = [[UIView alloc]initWithFrame:CGRectMake(0, SPACE, self.view.width, 50)];
    tangStateView.backgroundColor = [UIColor whiteColor];
    tangStateView.tag = TANGSTATE_TAG;
    [scrollview addSubview:tangStateView];
    
    UILabel * tangStateLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, SPACE, self.view.frame.size.width - 3 * SPACE - DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
    tangStateLB.text = @"是否开通堂食";
    tangStateLB.backgroundColor = VIEW_COLOR;
    [tangStateView addSubview:tangStateLB];
    self.tangStateSW = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width -  DETAILLB_WIDTH / 4 * 3 - SPACE, SPACE , DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
    _tangStateSW.tintColor = [UIColor grayColor];
    _tangStateSW.on = NO;
    [_tangStateSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
    [tangStateView addSubview:_tangStateSW];
    
    self.tangshiautoStateView = [[UIView alloc]initWithFrame:CGRectMake(0, tangStateView.bottom + 1, self.view.width, 50)];
    _tangshiautoStateView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:_tangshiautoStateView];
    
    UILabel * tangAutoStateLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, SPACE, self.view.frame.size.width - 3 * SPACE - DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
    tangAutoStateLB.backgroundColor = VIEW_COLOR;
    tangAutoStateLB.text = @"堂食验证";
    [_tangshiautoStateView addSubview:tangAutoStateLB];
    
    self.tangAutoStateSW = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width -  DETAILLB_WIDTH / 4 * 3 - SPACE, SPACE , DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
    _tangAutoStateSW.tintColor = [UIColor grayColor];
    _tangAutoStateSW.on = NO;
    [_tangAutoStateSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
    [_tangshiautoStateView addSubview:_tangAutoStateSW];
    scrollview.contentSize = CGSizeMake(self.view.width, _tangshiautoStateView.bottom + 20);
    
    int TangState = [self.model.tangState intValue];
    if (TangState != 1) {
        _tangStateSW.on = NO;
        _tangAutoStateSW.on = NO;
        _tangshiautoStateView.hidden = YES;
        
        scrollview.contentSize = CGSizeMake(self.view.width, tangStateView.bottom + 20);
        
    }else
    {
        _tangStateSW.on = YES;
        _tangshiautoStateView.hidden = NO;
        int TangautoState = [self.model.tangAutoState intValue];
        if (TangautoState == 1) {
            _tangAutoStateSW.on = YES;
        }
        UIScrollView * scroll = [self.view viewWithTag:SCROLLView_tag];
        
        scroll.contentSize = CGSizeMake(self.view.width, _tangshiautoStateView.bottom + 120);
    }
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)isDoBusiness:(UISwitch *)aSwitch
{
    if ([aSwitch isEqual:_tangStateSW])
    {
        if (aSwitch.isOn) {
            //            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开通堂食" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //            alertView.tag = 3001;
            //            [alertView show];
            self.helpTangshiSW = self.tangStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@1,
                                       @"SwitchType":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }else
        {
            //            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭堂食" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //            alertView.tag = 3002;
            //            [alertView show];
            self.helpTangshiSW = self.tangStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@0,
                                       @"SwitchType":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }
    }else
    {
        if (aSwitch.isOn) {
            //            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开启堂食验证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //            alertView.tag = 4001;
            //            [alertView show];
            self.helpTangshiSW = self.tangAutoStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@1,
                                       @"SwitchType":@2
                                       };
            [self playPostWithDictionary:jsonDic];
        }else
        {
            //            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭堂食验证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //            alertView.tag = 4002;
            //            [alertView show];
            self.helpTangshiSW = self.tangAutoStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@0,
                                       @"SwitchType":@2
                                       };
            [self playPostWithDictionary:jsonDic];
        }
    }
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    //        NSLog(@"%@", jsonStr);
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
    NSLog(@"++%@", [data description]);
    int command = [[data objectForKey:@"Command"] intValue];
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if (command == 10073)
        {
            if ([_helpTangshiSW isEqual:_tangStateSW]) {
                if (_tangStateSW.on) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开通成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
                }else
                {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
                }
            }else
            {
                if (_tangAutoStateSW.on) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开启成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
                }else
                {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
                }
            }
            
            if (!_tangStateSW.on) {
                _tangAutoStateSW.on = NO;
                _tangshiautoStateView.hidden = YES;
                UIScrollView * scroll = [self.view viewWithTag:SCROLLView_tag];
                UIView * tangStateView = [scroll viewWithTag:TANGSTATE_TAG];
                
                scroll.contentSize = CGSizeMake(self.view.width, tangStateView.bottom + 20);
            }else
            {
                _tangshiautoStateView.hidden = NO;
                UIScrollView * scroll = [self.view viewWithTag:SCROLLView_tag];
                scroll.contentSize = CGSizeMake(self.view.width, _tangshiautoStateView.bottom + 120);
            }
            
        }
    }else
    {
        if ([data objectForKey:@"ErrorMsg"]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
        

        if (command == 73)
        {
            UISwitch * isBusiness = _helpTangshiSW;
            [isBusiness setOn:!isBusiness.isOn animated:YES];
        }
        
        
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];

    UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerV show];
}


@end
