//
//  VerifyOrderViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyOrderViewController.h"
#import "QRCodeScanViewController.h"
#import "ChooseTimeViewController.h"

@interface VerifyOrderViewController ()<HTTPPostDelegate, UITextFieldDelegate>

//@property (nonatomic, strong)UITextField *verifyTF;
//@property (nonatomic, strong)UIButton * scanButton;
//@property (nonatomic, strong)UIButton * verifyListButton;
//@property (strong, nonatomic) IBOutlet UIView *headView;
//@property (strong, nonatomic) IBOutlet UIView *verifycodeView;
//
//@property (strong, nonatomic) IBOutlet UITextField *verifyTF;
//
//@property (strong, nonatomic) IBOutlet UIButton *deleteBT;
//@property (strong, nonatomic) IBOutlet UIButton *scanButton;
//@property (strong, nonatomic) IBOutlet UIButton *verifyListButton;
//
//@property (strong, nonatomic) IBOutlet UIButton *BT1;
//@property (strong, nonatomic) IBOutlet UIButton *BT2;
//@property (strong, nonatomic) IBOutlet UIButton *BT3;
//@property (strong, nonatomic) IBOutlet UIButton *BT4;
//@property (strong, nonatomic) IBOutlet UIButton *BT7;
//@property (strong, nonatomic) IBOutlet UIButton *BT0;
//@property (strong, nonatomic) IBOutlet UIButton *BT5;
//@property (strong, nonatomic) IBOutlet UIButton *BT6;
//@property (strong, nonatomic) IBOutlet UIButton *BT8;
//@property (strong, nonatomic) IBOutlet UIButton *BT9;

@property (strong, nonatomic)  UIView *headView;
@property (strong, nonatomic)  UIView *verifycodeView;

@property (strong, nonatomic)  UITextField *verifyTF;

@property (strong, nonatomic)  UIButton *deleteBT;
@property (strong, nonatomic)  UIButton *scanButton;
@property (strong, nonatomic)  UIButton *verifyListButton;

@property (strong, nonatomic)  UIButton *BT1;
@property (strong, nonatomic)  UIButton *BT2;
@property (strong, nonatomic)  UIButton *BT3;
@property (strong, nonatomic)  UIButton *BT4;
@property (strong, nonatomic)  UIButton *BT7;
@property (strong, nonatomic)  UIButton *BT0;
@property (strong, nonatomic)  UIButton *BT5;
@property (strong, nonatomic)  UIButton *BT6;
@property (strong, nonatomic)  UIButton *BT8;
@property (strong, nonatomic)  UIButton *BT9;

@property (nonatomic, assign)int a;

@end

@implementation VerifyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证";
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"account_left_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
//    NSLog(@"%f", self.navigationController.navigationBar.height);
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
//    if (self.isfrome == 1) {
//        self.headView.frame = CGRectMake(0, 64, self.view.width, 150);
//    }
    self.headView.backgroundColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0];
    [self.view addSubview:self.headView];
    
    self.verifycodeView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, self.headView.width - 40, 60)];
    self.verifycodeView.backgroundColor = [UIColor redColor];
    self.verifycodeView.layer.cornerRadius = 30;
    self.verifycodeView.layer.masksToBounds = YES;
    [self.headView addSubview:_verifycodeView];
    
    self.verifyTF = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, self.verifycodeView.width - 60 - 30, _verifycodeView.height)];
    self.verifyTF.borderStyle = UITextBorderStyleNone;
    self.verifyTF.backgroundColor = [UIColor clearColor];
    self.verifyTF.delegate = self;
    self.verifyTF.placeholder = @"";
    _verifyTF.enabled = NO;
    [self.verifycodeView addSubview:self.verifyTF];
    
    self.deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBT.frame = CGRectMake(_verifyTF.right , 15, 30, 30);
    [_deleteBT setImage:[[UIImage imageNamed:@"clear_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_deleteBT setImage:[[UIImage imageNamed:@"clear_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [_deleteBT addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBT.hidden = YES;
    [self.verifycodeView addSubview:_deleteBT];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(self.headView.width / 2, _verifycodeView.bottom + 20, 1, 40)];
    lineView.backgroundColor = [UIColor redColor];
    [self.headView addSubview:lineView];
    
    self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(lineView.left - self.headView.width / 2 + 20, lineView.top, self.headView.width / 2 - 40, lineView.height);
    _scanButton.backgroundColor = [UIColor clearColor];
    [_scanButton setImage:[UIImage imageNamed:@"scan_code_img_icon"] forState:UIControlStateNormal];
    _scanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_scanButton setTitle:@"扫描验证" forState:UIControlStateNormal];
    
    _scanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(startScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:_scanButton];
    
    self.verifyListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyListButton.frame = CGRectMake(lineView.right + 20, lineView.top, _scanButton.width, lineView.height);
    [_verifyListButton setImage:[UIImage imageNamed:@"scan_code_log_img_icon"] forState:UIControlStateNormal];
    _verifyListButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [_verifyListButton setTitle:@"验证记录" forState:UIControlStateNormal];
    _verifyListButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_verifyListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verifyListButton addTarget:self action:@selector(verifyListAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:_verifyListButton];
    
    int j = 0;
    for (int i = 0; i < 10; i++) {
        int k = i ;
        j++;
        if (k == 9) {
            UIView * backview = [[UIView alloc]initWithFrame:CGRectMake(self.view.width / 3 , _headView.bottom + (self.view.height - _headView.height - 64)/4 * (k / 3), self.view.width / 3, (self.view.height - _headView.height- 64)/4)];
            backview.backgroundColor = [UIColor clearColor];
            [self.view addSubview:backview];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 60, 60);
            [button setTitle:[NSString stringWithFormat:@"%d", 0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.tintColor = [UIColor whiteColor];
            button.layer.cornerRadius = 30;
            button.layer.masksToBounds = YES;
            button.center = backview.center;
            [self.view addSubview:button];
            [button addTarget:self action:@selector(wordAction:) forControlEvents:UIControlEventTouchUpInside];

        }else
        {
            
            UIView * backview = [[UIView alloc]initWithFrame:CGRectMake(self.view.width / 3 * (j - 1), _headView.bottom + ((self.view.height - _headView.height- 64)/4) * (k / 3), self.view.width / 3, (self.view.height - _headView.height- 64)/4)];
//            backview.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 + 1)/255.0 green:(arc4random() % 255 + 1)/255.0 blue:(arc4random() % 255 + 1)/255.0 alpha:1];
            backview.backgroundColor = [UIColor clearColor];
            [self.view addSubview:backview];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 60, 60);
            [button setTitle:[NSString stringWithFormat:@"%d", k + 1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.tintColor = [UIColor whiteColor];
            button.layer.cornerRadius = 30;
            button.layer.masksToBounds = YES;
            button.center = backview.center;
            [self.view addSubview:button];
            [button addTarget:self action:@selector(wordAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if (j==3) {
//            NSLog(@"%d", j);
            j = 0;
        }
    }
    
    [self addObserver:self forKeyPath:@"self.verifyTF.text" options:NSKeyValueObservingOptionNew context:NULL];
    self.a = 1;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"orange.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"orange.png"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.isfrome = 0;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 扫描验证
- (void)startScan:(UIButton *)button
{
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc]init];
    __weak VerifyOrderViewController * verifyVC = self;
    [qrVC returnData:^(NSString *str) {
        
//        verifyVC.verifyTF.text = str;
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@72,
                                   @"AutoCode":str
                                   };
        [verifyVC playPostWithDictionary:jsonDic];
        
        
    }];
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark - 验证记录
- (void)verifyListAction:(UIButton *)button
{
    ChooseTimeViewController * chooseVC = [[ChooseTimeViewController alloc]init];
    
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (void)verifyAction:(UIButton *)button
{
    if (self.verifyTF.text.length != 0) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@72,
                                   @"AutoCode":self.verifyTF.text
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空" delegate:self cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
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
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10072]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}
- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
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
#pragma mark - 输入验证码
- (void)wordAction:(UIButton *)button
{
    NSString * str = button.titleLabel.text;
    self.verifyTF.text = [self.verifyTF.text stringByAppendingString:str];
    if (self.verifyTF.text.length > 11) {
        self.verifyTF.text = [self.verifyTF.text substringToIndex:11];
    }
//    NSLog(@"%@", self.verifyTF.text);
}
- (void)deleteAction:(UIButton *)button
{
    NSLog(@"清空");
    self.verifyTF.text = nil;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

#pragma mark - 输入框观察方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id str = [change objectForKey:@"new"];
//    NSLog(@"%@", str);
    if (![str isKindOfClass:[NSNull class]]) {
        NSString * str1 = str;
        if (str1.length == 11) {
            NSLog(@"发起请求");
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@72,
                                       @"AutoCode":self.verifyTF.text
                                       };
            [self playPostWithDictionary:jsonDic];
            self.deleteBT.hidden = NO;
        }else if (str1.length == 0)
        {
            self.deleteBT.hidden = YES;
        }else
        {
            self.deleteBT.hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    if (self.a == 1) {
        [self removeObserver:self forKeyPath:@"self.verifyTF.text"];
    }
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
