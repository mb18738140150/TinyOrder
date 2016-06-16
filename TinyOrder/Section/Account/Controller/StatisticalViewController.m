//
//  StatisticalViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/16.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "StatisticalViewController.h"

#import "StatisticalFigureViewController.h"
#import "StatisticalReportsViewController.h"

@interface StatisticalViewController ()<HTTPPostDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollview;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIImageView *storeIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *storeNameLB;

@property (strong, nonatomic) IBOutlet UILabel *storeDescribLB;
@property (strong, nonatomic) IBOutlet UILabel *yestordaybrowseLB;
@property (strong, nonatomic) IBOutlet UILabel *yestordaybrowseLabel;

@property (strong, nonatomic) IBOutlet UILabel *yetordayVisitorCountLB;
@property (strong, nonatomic) IBOutlet UILabel *yetordayVisitorCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *waimaiYeMoneyLB;
@property (strong, nonatomic) IBOutlet UILabel *waimaiYeMoneyLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalOrderCountLB;
@property (strong, nonatomic) IBOutlet UILabel *totalOrderCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalBrowseLB;
@property (strong, nonatomic) IBOutlet UILabel *totalBrowseLabel;

@property (strong, nonatomic) IBOutlet UILabel *tangshiYeMonryLB;
@property (strong, nonatomic) IBOutlet UILabel *tangshiYeMonryLabel;

@property (strong, nonatomic) IBOutlet UIButton *statisticalFigureBT;
@property (strong, nonatomic) IBOutlet UIButton *statisticalOrderBT;

@end

@implementation StatisticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"统计";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.backView.height = self.statisticalOrderBT.bottom;
    self.myScrollview.contentSize = CGSizeMake(self.myScrollview.width, self.backView.bottom);
    
    self.storeIconImageView.layer.cornerRadius = 60;
    self.storeIconImageView.layer.masksToBounds = YES;
    self.storeIconImageView.image = self.image;
    
    self.statisticalOrderBT.tag = 1000;
    [self.statisticalOrderBT addTarget:self action:@selector(statisticalAction:) forControlEvents:UIControlEventTouchUpInside];
    self.statisticalFigureBT.tag = 2000;
    [self.statisticalFigureBT addTarget:self action:@selector(statisticalAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@89
                               };
    [self playPostWithDictionary:jsonDic];
    
    [SVProgressHUD showWithStatus:@"更新数据..." maskType:SVProgressHUDMaskTypeBlack];
    
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 数据请求
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
    NSLog(@"——————%@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10089])
        {
            [self updataImterfaceWithDic:data];
        }
    }else
    {
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    }
}
- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerV show];
}

- (void)updataImterfaceWithDic:(NSDictionary * )dic
{
    self.storeNameLB.text = [dic objectForKey:@"StoreName"];
    self.storeDescribLB.text = [dic objectForKey:@"StoreIntroduce"];
    CGSize describsize = [self.storeDescribLB.text boundingRectWithSize:CGSizeMake(self.storeDescribLB.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    self.storeDescribLB.height = describsize.height;
    
    self.yetordayVisitorCountLB.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"YesterdayVisitor"]];
    self.yetordayVisitorCountLB.width = [self calculateWodth:self.yestordaybrowseLB.text];
    self.yetordayVisitorCountLB.centerX = self.yetordayVisitorCountLabel.center.x;
    
    self.totalBrowseLB.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"TotalBrowse"]];
    self.totalBrowseLB.width = [self calculateWodth:self.yestordaybrowseLB.text];
    self.totalBrowseLB.centerX = self.totalBrowseLabel.center.x;
    
    self.yestordaybrowseLB.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"YesterdayBrowse"]];
    self.yestordaybrowseLB.width = [self calculateWodth:self.yestordaybrowseLB.text];
    self.yestordaybrowseLB.centerX = self.yestordaybrowseLabel.center.x;
    
    self.totalOrderCountLB.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"TotalOrder"]];
    self.totalOrderCountLB.width = [self calculateWodth:self.yestordaybrowseLB.text];
    self.totalOrderCountLB.centerX = self.totalOrderCountLabel.center.x;
    
    self.waimaiYeMoneyLB.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"YTakeoutMoney"]];
    self.waimaiYeMoneyLB.width = [self calculateWodth:self.yestordaybrowseLB.text];
    self.waimaiYeMoneyLB.centerX = self.waimaiYeMoneyLabel.center.x;
    
    self.tangshiYeMonryLB.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"YTangshiMoney"]];
    self.tangshiYeMonryLB.width = [self calculateWodth:self.yestordaybrowseLB.text];
    self.tangshiYeMonryLB.centerX = self.tangshiYeMonryLabel.center.x;
    
}

- (CGFloat)calculateWodth:(NSString *)str
{
    CGSize size = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    return size.width;
}

- (void)statisticalAction:(UIButton *)button
{
    if (button.tag == 1000) {
        StatisticalReportsViewController * vc = [[StatisticalReportsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        StatisticalFigureViewController * vc = [[StatisticalFigureViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
