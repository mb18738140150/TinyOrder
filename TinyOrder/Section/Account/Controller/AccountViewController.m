//
//  AccountViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountViewCell.h"
#import "AccountModel.h"
#import "HeaderView.h"
#import "UIViewAdditions.h"
#import "RevenueViewController.h"
#import "BulletinViewController.h"
#import "BulletinTypeViewController.h"
#import "PrintTypeViewController.h"
#import "LoginViewController.h"
#import <AFNetworking.h>
#import "ActivityViewController.h"
#import "CommentViewController.h"
#import "BankCarController.h"
#import "SwithAccountViewCell.h"
#import "PublicWXNumViewController.h"
#import "PersonInformationViewController.h"
#import "StoreCreateViewController.h"
#import <UIImageView+WebCache.h>
#import "VerifyOrderViewController.h"
#import "TodaySalesController.h"
#import "TangshiViewcontroller.h"
#import "RegisterLinkViewController.h"
#import "RealNameAuthenticationViewcontroller.h"
#import "StatisticalReportsViewController.h"
#import "StatisticalViewController.h"

//#import <AVFoundation/AVFoundation.h>

#import "ButtonView.h"
#define CELL_IDENTIFIER @"cell"
#define SWITH_CELL @"swithCell"
#define SPACE 10
#define IMAGEVIEW_WIDTH 30
#define DETAILLB_WIDTH 100
#define VIEW_COLOR [UIColor clearColor]
#define SWITH_TAG 3000
#define SCROLLView_tag 100
#define TANGSTATE_TAG 10000
@interface AccountViewController ()<HTTPPostDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)PrintTypeViewController *printTypeVC;

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * imageArray;

@property (nonatomic, strong)AccountModel *accountModel;

@property (nonatomic, strong)HeaderView * headerView;

@property (nonatomic, copy)NSString * logoURL;
@property (nonatomic, copy)NSString * barcodeURL;
@property (nonatomic)CLLocationCoordinate2D coordinate;

@property (nonatomic, strong)UILabel * titleLable;
@property (nonatomic, strong)UISwitch * isBusinessSW;
@property (nonatomic, strong)UIButton * isBusinessBT;
@property (nonatomic, copy)NSString * isBusinessStr;
@property (nonatomic, strong)UISwitch * tangStateSW;

@property (nonatomic, strong)UIView * tangshiautoStateView;
@property (nonatomic, strong)UISwitch * tangAutoStateSW;

@property (nonatomic, strong)UISwitch * helpTangshiSW;

@property (nonatomic, strong)UILabel * realNameautnenticationlabel;

@property (nonatomic, strong)ButtonView * realNameButtonView;

@property (nonatomic, strong)UISwitch * autoBusinessOrClosing;

@end

@implementation AccountViewController

//static SystemSoundID shake_sound_male_id = 0;

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    self.view.backgroundColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:17],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.tabBarController.tabBar.height - self.navigationController.navigationBar.height)];
    scrollview.tag = SCROLLView_tag;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:scrollview];
    // 取消导航栏模糊效果
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    
    UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(0, -scrollview.height, scrollview.width, scrollview.height)];
    colorView.backgroundColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0];
    [scrollview addSubview:colorView];
    
    self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 170 )];
    [_headerView.informationButton addTarget:self action:@selector(informationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bankAction:)];
    [_headerView.bankCardNum addGestureRecognizer:tapAction];
    UITapGestureRecognizer * tapAction1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bankAction:)];
    [_headerView.bankLB addGestureRecognizer:tapAction1];
    
    UITapGestureRecognizer * tapActionmoney = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moneyAction:)];
    [_headerView.moneyLB addGestureRecognizer:tapActionmoney];
    UITapGestureRecognizer * tapActionmoney1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moneyAction:)];
    [_headerView.todayMoney addGestureRecognizer:tapActionmoney1];
    
    [scrollview addSubview:_headerView];
    
    NSArray * imageArr = @[@"account_print_icon.png", @"account_store_icon.png", @"account_action_icon.png", @"account_log_money_icon.png", @"account_comment_icon.png", @"account_tangshi_auto_icon.png", @"account_notice_icon.png", @"realNameVerify.png", @"tangshishezhi.png", @"checkstand.png", @"", @""];
    NSArray * nameArr = @[@"配置打印机", @"门店信息", @"活动设置", @"交易明细", @"评论列表", @"消费验证", @"商家公告", @"实名认证", @"堂食设置",  @"收银台链接", @"", @""];
    for (int i = 0; i < imageArr.count; i++) {
        ButtonView * btn = [[ButtonView alloc]initWithFrame:CGRectMake(i * self.view.width / 4, 170, self.view.width / 4, self.view.width / 4)];
        btn.image.image = [UIImage imageNamed:imageArr[i]];
        btn.frame = CGRectMake(i * self.view.width / 4, 170, self.view.width / 4, self.view.width / 4);
        [btn.button addTarget:self action:@selector(Click:)
      forControlEvents:UIControlEventTouchUpInside];
        btn.name.text = nameArr[i];
        
        //设置tag值
        btn.button.tag = 100+i;
        if (btn.button.tag>103 && btn.button.tag < 108) {
            btn.frame = CGRectMake((i - 4) * self.view.width / 4, 170 + self.view.width / 4, self.view.width / 4, self.view.width / 4);
        }else if (btn.button.tag > 107){
            btn.frame = CGRectMake((i - 8) * self.view.width / 4, 170 + self.view.width / 2, self.view.width / 4, self.view.width / 4);
        }
        
        if (btn.button.tag == 108) {
            self.realNameButtonView = btn;
            btn.name.width = btn.width - 16;
            btn.stateImagev.frame = CGRectMake(btn.name.right, btn.name.top, 14, btn.name.height );
        }
        
        [scrollview addSubview:btn];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * self.view.width / 4, 170, self.view.width / 4, self.view.width / 4);
        button.layer.borderWidth = .5;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.backgroundColor = [UIColor whiteColor];
        
        [button setImage:[[UIImage imageNamed:imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 25, 10)];
        
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        button.titleLabel.backgroundColor = [UIColor redColor];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(50, -62, 0, -8)];
        if (i > 3) {
            button.frame = CGRectMake((i - 4) * self.view.width / 4, 170 + self.view.width / 4, self.view.width / 4, self.view.width / 4);
        }
//        [scrollview addSubview:button];
    }
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.bottom + self.view.width / 4 * 3 + 20, self.view.width, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:backView];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(SPACE, SPACE, self.view.frame.size.width - 3 * SPACE - DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
    _titleLable.text = @"营业状态";
    _titleLable.backgroundColor = VIEW_COLOR;
    [backView addSubview:_titleLable];
    self.isBusinessSW = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width -  DETAILLB_WIDTH / 4 * 3 - SPACE, SPACE , DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
    _isBusinessSW.tintColor = [UIColor grayColor];
    _isBusinessSW.on = NO;
    [_isBusinessSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
//    [backView addSubview:_isBusinessSW];
    self.isBusinessBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _isBusinessBT.frame = CGRectMake(self.view.frame.size.width -  DETAILLB_WIDTH / 4 * 3 - SPACE, SPACE , DETAILLB_WIDTH, IMAGEVIEW_WIDTH);
    _isBusinessBT.backgroundColor = [UIColor whiteColor];
    [_isBusinessBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _isBusinessBT.tintColor = [UIColor whiteColor];
    [_isBusinessBT addTarget:self action:@selector(businessStateAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_isBusinessBT];
    
    
    
    UIView * autobusinessStateView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom + 1, self.view.width, 50)];
    autobusinessStateView.backgroundColor = [UIColor whiteColor];
    autobusinessStateView.tag = TANGSTATE_TAG;
    [scrollview addSubview:autobusinessStateView];
    
    UILabel * autobusinessStateLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, SPACE, 150, IMAGEVIEW_WIDTH)];
    autobusinessStateLB.text = @"自动营业或打烊";
    autobusinessStateLB.backgroundColor = VIEW_COLOR;
    [autobusinessStateView addSubview:autobusinessStateLB];
    
    self.autoBusinessOrClosing = [[UISwitch alloc]initWithFrame:CGRectMake(autobusinessStateView.width - 70, 10, 50, 30)];
    [self.autoBusinessOrClosing addTarget:self action:@selector(changeAutoBusinessState:) forControlEvents:UIControlEventValueChanged];
    [autobusinessStateView addSubview:self.autoBusinessOrClosing];
    
    
    /*
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(tangStateView.width - 32, tangStateView.height / 2  - 8, 8, 15)];
    imageView.image = [UIImage imageNamed:@"arrowright.png"];
    [tangStateView addSubview:imageView];
    
    UIButton *personCenterBT = [UIButton buttonWithType:UIButtonTypeSystem];
    personCenterBT.frame = CGRectMake(tangStateView.width - 50, tangStateView.height / 2  - 20, 40, 40);
    //    [personCenterBT setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [personCenterBT addTarget:self action:@selector(personCenterAction:) forControlEvents:UIControlEventTouchUpInside];
    personCenterBT.backgroundColor = [UIColor clearColor];
    [tangStateView addSubview:personCenterBT];
    
//    self.tangStateSW = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width -  DETAILLB_WIDTH / 4 * 3 - SPACE, SPACE , DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
//    _tangStateSW.tintColor = [UIColor grayColor];
//    _tangStateSW.on = NO;
//    [_tangStateSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
//    [tangStateView addSubview:_tangStateSW];
    
    
    self.tangshiautoStateView = [[UIView alloc]initWithFrame:CGRectMake(0, tangStateView.bottom + 1, self.view.width, 50)];
    _tangshiautoStateView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:_tangshiautoStateView];
    
    UILabel * tangAutoStateLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, SPACE, self.view.frame.size.width - 3 * SPACE - DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
    tangAutoStateLB.backgroundColor = VIEW_COLOR;
    tangAutoStateLB.text = @"实名认证";
    [_tangshiautoStateView addSubview:tangAutoStateLB];
    
    
    
    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 32, tangStateView.height / 2  - 8, 8, 15)];
    imageView1.image = [UIImage imageNamed:@"arrowright.png"];
    [_tangshiautoStateView addSubview:imageView1];
    
    self.realNameautnenticationlabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.left - SPACE - 200, SPACE, 200, IMAGEVIEW_WIDTH)];
    _realNameautnenticationlabel.textAlignment = NSTextAlignmentRight;
    _realNameautnenticationlabel.textColor = [UIColor cyanColor];
    _realNameautnenticationlabel.text = @"去认证";
    [_tangshiautoStateView addSubview:_realNameautnenticationlabel];
    
    UIButton *certificationBT = [UIButton buttonWithType:UIButtonTypeSystem];
    certificationBT.frame = CGRectMake(self.view.width - 50, tangStateView.height / 2  - 20, 40, 40);
    //    [personCenterBT setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [certificationBT addTarget:self action:@selector(certificationAction:) forControlEvents:UIControlEventTouchUpInside];
    certificationBT.backgroundColor = [UIColor clearColor];
    [_tangshiautoStateView addSubview:certificationBT];
//    self.tangAutoStateSW = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width -  DETAILLB_WIDTH / 4 * 3 - SPACE, SPACE , DETAILLB_WIDTH, IMAGEVIEW_WIDTH)];
//    _tangAutoStateSW.tintColor = [UIColor grayColor];
//    _tangAutoStateSW.on = NO;
//    [_tangAutoStateSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
//    [_tangshiautoStateView addSubview:_tangAutoStateSW];
    
    
    */
    scrollview.contentSize = CGSizeMake(self.view.width, autobusinessStateView.bottom + 20);
    
    [self postData:nil];
    
//    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.tableView headerBeginRefreshing];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.printTypeVC = [[PrintTypeViewController alloc]init];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"验证" style:UIBarButtonItemStylePlain target:self action:@selector(verifyOrderAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tm.png"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
   
    [self downloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)informationAction:(UIButton *)button
{
//    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
////    LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
////    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
////    loginNav.navigationBar.translucent = NO;
//    [self.navigationController.tabBarController dismissViewControllerAnimated:YES completion:nil];
//    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
    
    PersonInformationViewController *personInformationVC = [[PersonInformationViewController alloc]init];
    personInformationVC.phoneNumber = self.accountModel.tel;
    [UserInfo shareUserInfo].phoneNumber = self.accountModel.tel;
    personInformationVC.iconImage= self.headerView.icon.image;
    personInformationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personInformationVC animated:YES];
    
}

- (void)downloadData
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@6
                               };
    [self playPostWithDictionary:jsonDic];
    
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
//        NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if (command == 10006) {
             __weak AccountViewController * accountVC = self;
            self.accountModel = [[AccountModel alloc]initWithDictionary:data];
            NSString * logostr = [NSString stringWithFormat:@"http://image.vlifee.com%@", _accountModel.StoreIcon];
            [_headerView.icon sd_setImageWithURL:[NSURL URLWithString:logostr] placeholderImage:[UIImage imageNamed:@"touxiang.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    accountVC.headerView.icon.image = image;
                }
            }];
            
            
            self.headerView.todayOrderNum.text = [NSString stringWithFormat:@"%d", _accountModel.todayOrder];
            self.headerView.todayMoney.text = [NSString stringWithFormat:@"%.2f", _accountModel.todayMoney];
            self.headerView.bankCardNum.text = [NSString stringWithFormat:@"%d", _accountModel.bankCardCount];
            self.headerView.phoneLabel.text = [NSString stringWithFormat:@"id:%@", [UserInfo shareUserInfo].userId];
            
            int state = [_accountModel.state intValue];
            if (state == 0) {
                self.headerView.storeStateLabel.text = @"休息中";
                [self.isBusinessBT setTitle:@"休息中" forState:UIControlStateNormal];
                _isBusinessSW.on = NO;
            }else if(state == 1)
            {
                self.headerView.storeStateLabel.text = @"营业中";
                [self.isBusinessBT setTitle:@"营业中" forState:UIControlStateNormal];
                _isBusinessSW.on = YES;
            }else
            {
                self.headerView.storeStateLabel.text = @"繁忙";
                [self.isBusinessBT setTitle:@"繁忙" forState:UIControlStateNormal];
            }
            
            int TangAutoState = [_accountModel.tangAutoState intValue];
            if (TangAutoState != 1) {
                _tangAutoStateSW.on = NO;
            }else
            {
                _tangAutoStateSW.on = YES;
            }
            
            if (self.accountModel.autoBusinessState.intValue != 1) {
                _autoBusinessOrClosing.on = NO;
            }else
            {
                _autoBusinessOrClosing.on = YES;
            }
            
//            int TangState = [_accountModel.tangState intValue];
//            if (TangState != 1) {
//                _tangStateSW.on = NO;
//                _tangAutoStateSW.on = NO;
//                _tangshiautoStateView.hidden = YES;
//                UIScrollView * scroll = [self.view viewWithTag:SCROLLView_tag];
//                UIView * tangStateView = [scroll viewWithTag:TANGSTATE_TAG];
//                
//                scroll.contentSize = CGSizeMake(self.view.width, tangStateView.bottom + 20);
//                
//            }else
//            {
//                _tangStateSW.on = YES;
//                _tangshiautoStateView.hidden = NO;
//                UIScrollView * scroll = [self.view viewWithTag:SCROLLView_tag];
//                
//                scroll.contentSize = CGSizeMake(self.view.width, _tangshiautoStateView.bottom + 120);
//            }
            if (_accountModel.realNameCertificationState) {
                int realnamestate = [_accountModel.realNameCertificationState intValue];
                switch (realnamestate) {
                    case 0:
                        self.realNameButtonView.stateImagev.image = [UIImage imageNamed:@"niVerify.png"];
                        self.realNameautnenticationlabel.text = @"去认证";
                        self.realNameautnenticationlabel.textColor = [UIColor cyanColor];
                        break;
                    case 1:
                        self.realNameButtonView.stateImagev.image = [UIImage imageNamed:@"verifing.png"];
                        self.realNameautnenticationlabel.text = @"认证中";
                        self.realNameautnenticationlabel.textColor = [UIColor cyanColor];
                        break;
                    case 2:
                        self.realNameButtonView.stateImagev.image = [UIImage imageNamed:@"verifysuccess.png"];
                        self.realNameautnenticationlabel.text = @"已认证";
                        self.realNameautnenticationlabel.textColor = [UIColor cyanColor];
                        break;
                    case 3:
                        self.realNameButtonView.stateImagev.image = [UIImage imageNamed:@"verifyFailed.png"];
                        self.realNameautnenticationlabel.text = @"认证失败";
                        self.realNameautnenticationlabel.textColor = [UIColor redColor];
                        break;
                    default:
                        break;
                }
            }
            
            
            
            AccountModel * accountMD0 = [self.dataArray objectAtIndex:0];
            accountMD0.state = [data objectForKey:@"State"];
            AccountModel * accountMD1 = [self.dataArray objectAtIndex:1];
//            accountMD1.detail = [NSString stringWithFormat:@"%@单", [data objectForKey:@"TodayOrder"]];
            AccountModel * accountMD2 = [self.dataArray objectAtIndex:2];
//            accountMD2.detail = [NSString stringWithFormat:@"%@元", [data objectForKey:@"TodayMoney"]];
            AccountModel * accountMD6 = [self.dataArray objectAtIndex:6];
            accountMD6.detail = [NSString stringWithFormat:@"总%@条评论", [data objectForKey:@"CommentCount"]];
//            [self.tableView reloadData];
            
            NSDictionary * jsonDic = @{
                                       @"Command":@64,
                                       @"UserId":[UserInfo shareUserInfo].userId
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (command == 10020)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"营业状态改变成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
//            if (self.isBusinessSW.on) {
//                self.headerView.storeStateLabel.text = @"营业中";
//            }else
//            {
//                self.headerView.storeStateLabel.text = @"休息中";
//            }
            
            [self.isBusinessBT setTitle:self.isBusinessStr forState:UIControlStateNormal];
            self.headerView.storeStateLabel.text = self.isBusinessStr;
            
        }else if (command == 10064)
        {
            self.logoURL = [data objectForKey:@"StoreIcon"];
            self.barcodeURL = [data objectForKey:@"StoreCodeIcon"];
            self.coordinate = (CLLocationCoordinate2D){[[data objectForKey:@"Lat"] doubleValue], [[data objectForKey:@"Lon"] doubleValue]};
        }else if (command == 10073)
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
            
        }else if (command == 10094)
        {
            
        }
    }else
    {
        if ([data objectForKey:@"ErrorMsg"]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }

//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alertView show];
//            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        
        if (command == 73)
        {
            UISwitch * isBusiness = _helpTangshiSW;
            [isBusiness setOn:!isBusiness.isOn animated:YES];
        }
        
        if (command == 94)
        {
            UISwitch * isBusiness = _autoBusinessOrClosing;
            [isBusiness setOn:!isBusiness.isOn animated:YES];
        }
        
//            AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
        
    }
//    [self.tableView headerEndRefreshing];
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
//    [self.tableView headerEndRefreshing];
//    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
//    [self.tableView headerEndRefreshing];
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
//    }
}



- (void)postData:(NSString *)urlString
{
    NSArray * array = @[@"营业状态", @"配置打印机",@"门店信息",  @"商家公告", @"收入流水", @"商家活动", @"查看评价", @"余额提现", @"入驻公众号"];
    for (int i = 0; i < array.count; i++) {
        AccountModel * accountModel = [[AccountModel alloc] init];
        accountModel.title = [array objectAtIndex:i];
        if (i == 1) {
//            accountModel.detail = @"88单";
        }
        if (i == 2) {
//            accountModel.detail = @"594.30元";
        }
//        if (i == array.count - 1) {
//            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//            NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
//            accountModel.detail = [NSString stringWithFormat:@"当前版本%@", appVersion];
//        }
        accountModel.StoreIcon = [NSString stringWithFormat:@"account_%d", i];
        [self.dataArray addObject:accountModel];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountModel * accountModel = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        SwithAccountViewCell * swithCell = [tableView dequeueReusableCellWithIdentifier:SWITH_CELL forIndexPath:indexPath];
//        [swithCell createSUbViewAndSwith:self.tableView.bounds];
        [swithCell.isBusinessSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
        swithCell.isBusinessSW.tag = SWITH_TAG;
        swithCell.backgroundColor = [UIColor whiteColor];
        swithCell.accountModel = accountModel;
        return swithCell;
    }
    AccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        [cell createSUbViewAndSwith:self.tableView.bounds];
//        [cell.isBusinessSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
//        cell.isBusinessSW.tag = SWITH_TAG;
//    }else
//    {
    
//        [cell createSubView:self.tableView.bounds];
//    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accountModel = accountModel;
    // Configure the cell...
    
    return cell;
}


- (void)Click:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            _printTypeVC.hidesBottomBarWhenPushed = YES;
            _printTypeVC.fromWitchController = 1;
            [self.navigationController pushViewController:_printTypeVC animated:YES];
        }
            break;
        case 101:
        {
            StoreCreateViewController * storVC = [[StoreCreateViewController alloc]init];
            storVC.hidesBottomBarWhenPushed = YES;
            storVC.changestore = 1;
            NSString * logostr = [NSString stringWithFormat:@"http://image.vlifee.com%@", self.logoURL];
            NSString * baStr = [NSString stringWithFormat:@"http://image.vlifee.com%@", self.barcodeURL];
            storVC.logoURL = logostr;
            storVC.barcodeURL = baStr;
            storVC.coor = self.coordinate;
            storVC.navigationItem.title = @"门店信息";
            [self.navigationController pushViewController:storVC animated:YES];
        }
            break;
        case 102:
        {
            ActivityViewController * activityVC = [[ActivityViewController alloc] init];
            activityVC.hidesBottomBarWhenPushed = YES;
            activityVC.navigationItem.title = @"活动设置";
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;
        case 103:
        {
            RevenueViewController * revenueVC = [[RevenueViewController alloc] init];
            revenueVC.hidesBottomBarWhenPushed = YES;
            revenueVC.navigationItem.title = @"交易明细";
            [self.navigationController pushViewController:revenueVC animated:YES];
        }
            break;
        case 104:
        {
            CommentViewController * commnetVC = [[CommentViewController alloc] init];
            commnetVC.hidesBottomBarWhenPushed = YES;
            commnetVC.navigationItem.title = @"评论列表";
            [self.navigationController pushViewController:commnetVC animated:YES];
        }
            break;
        case 111:
        {
            PublicWXNumViewController * publicWXVC = [[PublicWXNumViewController alloc] init];
            publicWXVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:publicWXVC animated:YES];
        }
            break;
        case 105:
        {
            NSLog(@"***%d", self.tangAutoStateSW.on);
            if (self.accountModel.tangAutoState.intValue == 1) {
                VerifyOrderViewController * verifyVC = [[VerifyOrderViewController alloc]init];
                
                verifyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:verifyVC animated:YES];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先开启堂食验证功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }
            break;
        case 106:
        {
            BulletinTypeViewController * bulletinVC = [[BulletinTypeViewController alloc] init];
            bulletinVC.hidesBottomBarWhenPushed = YES;
            //            bulletinVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:bulletinVC animated:YES];
        }
            break;
        case 107:
        {
            RealNameAuthenticationViewcontroller * realVC = [[RealNameAuthenticationViewcontroller alloc]init];
            realVC.model = self.accountModel;
            realVC.isfrom = 1;
            realVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:realVC animated:YES];
        }
            break;
        case 108:
        {
            TangshiViewcontroller * tangshiVC = [[TangshiViewcontroller alloc]init];
            tangshiVC.model = self.accountModel;
            tangshiVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tangshiVC animated:YES];
        }
            break;
        case 109:
        {
            RegisterLinkViewController  * registerVC = [[RegisterLinkViewController alloc] init];
            registerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:registerVC animated:YES];
            
//            StatisticalViewController * bulletinVC = [[StatisticalViewController alloc] initWithNibName:@"StatisticalViewController" bundle:nil];
//            bulletinVC.image = self.headerView.icon.image;
//            bulletinVC.hidesBottomBarWhenPushed = YES;
//            //            bulletinVC.navigationItem.title = accountModel.title;
//            [self.navigationController pushViewController:bulletinVC animated:YES];
        }
            break;
        case 110:
        {
//           RegisterLinkViewController  * registerVC = [[RegisterLinkViewController alloc] init];
//            registerVC.hidesBottomBarWhenPushed = YES;
//            //            bulletinVC.navigationItem.title = accountModel.title;
//            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 今日销售额
- (void)moneyAction:(UITapGestureRecognizer *)tap
{
    TodaySalesController * todaySVC = [[TodaySalesController alloc]init];
    todaySVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:todaySVC animated:YES];
}

#pragma mark - 银行卡
- (void)bankAction:(UITapGestureRecognizer *)tap
{
    BankCarController * bankCarVC = [[BankCarController alloc] init];
    bankCarVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bankCarVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AccountModel * accountModel = [self.dataArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 1:
        {
            _printTypeVC.hidesBottomBarWhenPushed = YES;
            _printTypeVC.fromWitchController = 1;
            [self.navigationController pushViewController:_printTypeVC animated:YES];
        }
            break;
        case 2:
        {
            StoreCreateViewController * storVC = [[StoreCreateViewController alloc]init];
            storVC.hidesBottomBarWhenPushed = YES;
            storVC.changestore = 1;
            NSString * logostr = [NSString stringWithFormat:@"http://image.vlifee.com%@", self.logoURL];
            NSString * baStr = [NSString stringWithFormat:@"http://image.vlifee.com%@", self.barcodeURL];
            storVC.logoURL = logostr;
            storVC.barcodeURL = baStr;
            storVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:storVC animated:YES];
        }
            break;
        case 3:
        {
            BulletinTypeViewController * bulletinVC = [[BulletinTypeViewController alloc] init];
            bulletinVC.hidesBottomBarWhenPushed = YES;
//            bulletinVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:bulletinVC animated:YES];
        }
            break;
        case 4:
        {
            RevenueViewController * revenueVC = [[RevenueViewController alloc] init];
            revenueVC.hidesBottomBarWhenPushed = YES;
            revenueVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:revenueVC animated:YES];
        }
            break;
        case 5:
        {
            ActivityViewController * activityVC = [[ActivityViewController alloc] init];
            activityVC.hidesBottomBarWhenPushed = YES;
            activityVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:activityVC animated:YES];
        }
        break;
        case 6:
        {
            CommentViewController * commnetVC = [[CommentViewController alloc] init];
            commnetVC.hidesBottomBarWhenPushed = YES;
            commnetVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:commnetVC animated:YES];
        }
            break;
        case 7:
        {
            BankCarController * bankCarVC = [[BankCarController alloc] init];
            bankCarVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bankCarVC animated:YES];
        }
            break;
        case 8:
        {
            PublicWXNumViewController * publicWXVC = [[PublicWXNumViewController alloc] init];
            publicWXVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:publicWXVC animated:YES];
        }
            break;
        default:
            break;
    }     
}


- (void)businessStateAction:(UIButton *)button
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"请选择营业状态" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * openAction = [UIAlertAction actionWithTitle:@"营业中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@20,
                                   @"State":@1
                                   };
        [self playPostWithDictionary:jsonDic];
        self.isBusinessStr = @"营业中";
    }];
    UIAlertAction * busyAction = [UIAlertAction actionWithTitle:@"繁忙" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@20,
                                   @"State":@2
                                   };
        [self playPostWithDictionary:jsonDic];
        self.isBusinessStr = @"繁忙";
    }];
    UIAlertAction * closeAction = [UIAlertAction actionWithTitle:@"休息中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@20,
                                   @"State":@0
                                   };
        [self playPostWithDictionary:jsonDic];
        self.isBusinessStr = @"休息中";
    }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    
    [alertVC addAction:openAction];
    [alertVC addAction:busyAction];
    [alertVC addAction:closeAction];
    [alertVC addAction:cancleAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)isDoBusiness:(UISwitch *)aSwitch
{
    if ([aSwitch isEqual:_isBusinessSW]) {
        self.helpTangshiSW = _isBusinessSW;
        if (aSwitch.isOn) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始营业" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 1000;
            [alertView show];
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始休息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 2000;
            [alertView show];
        }
    }else if ([aSwitch isEqual:_tangStateSW])
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [SVProgressHUD showWithStatus:@"正在修改营业状态..." maskType:SVProgressHUDMaskTypeBlack];
        if (alertView.tag == 1000) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@20,
                                       @"State":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (alertView.tag == 2000)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@20,
                                       @"State":@0
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (alertView.tag == 3001)
        {
            self.helpTangshiSW = self.tangStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@1,
                                       @"SwitchType":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (alertView.tag == 3002)
        {
             self.helpTangshiSW = self.tangStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@0,
                                       @"SwitchType":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (alertView.tag == 4001)
        {
             self.helpTangshiSW = self.tangAutoStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@1,
                                       @"SwitchType":@2
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (alertView.tag == 4002)
        {
             self.helpTangshiSW = self.tangAutoStateSW;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@73,
                                       @"State":@0,
                                       @"SwitchType":@2
                                       };
            [self playPostWithDictionary:jsonDic];
        }
    }else
    {
        if (alertView.tag == 1000 || alertView.tag == 2000) {
            UISwitch * isBusiness = _isBusinessSW;
            [isBusiness setOn:!isBusiness.isOn animated:YES];
        }else if (alertView.tag == 3001 || alertView.tag == 3002)
        {
            UISwitch * isBusiness = _tangStateSW;
            [isBusiness setOn:!isBusiness.isOn animated:YES];
        }else if (alertView.tag == 4001 || alertView.tag == 4002)
        {
            UISwitch * isBusiness = _tangAutoStateSW;
            [isBusiness setOn:!isBusiness.isOn animated:YES];
        }
    }
}

#pragma mark - 验证订单
- (void)verifyOrderAction:(UIBarButtonItem *)sender
{
    VerifyOrderViewController * verifyVC = [[VerifyOrderViewController alloc]init];
    
    verifyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:verifyVC animated:YES];
}

#pragma mark - 堂食设置
- (void)personCenterAction:(UIButton *)button
{
    TangshiViewcontroller * tangshiVC = [[TangshiViewcontroller alloc]init];
    tangshiVC.model = self.accountModel;
    tangshiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tangshiVC animated:YES];
    
}
#pragma mark - 实名认证
- (void)certificationAction:(UIButton *)button
{
    RealNameAuthenticationViewcontroller * realVC = [[RealNameAuthenticationViewcontroller alloc]init];
    realVC.model = self.accountModel;
    realVC.isfrom = 1;
    realVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:realVC animated:YES];
    
}

- (void)changeAutoBusinessState:(UISwitch *)sender
{
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeBlack];
    
    if (!sender.isOn) {
        NSLog(@"开启自动营业");
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@94,
                                   @"AutoBusinessState":@1
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        NSLog(@"关闭自动营业");
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@94,
                                   @"AutoBusinessState":@0
                                   };
        [self playPostWithDictionary:jsonDic];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}certificationAction
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
 query = AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding);
  [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
}
 
*/

@end
