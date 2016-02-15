//
//  EquipmentInformationViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "EquipmentInformationViewController.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10
#define LB_WIDTH 100
#define LB_HEIGHT 40

#define LINE_COLOR [UIColor colorWithWhite:0.9 alpha:1]

@interface EquipmentInformationViewController ()<HTTPPostDelegate>

@property (nonatomic, strong) UILabel *printNumLB;
@property (nonatomic, strong) UILabel *printSecretLB;
@property (nonatomic, strong) UILabel *printNameLB;
@property (nonatomic, strong) UILabel *phoneLB;

@property (nonatomic, strong) UITextField *printNumTF;
@property (nonatomic, strong) UITextField *printSecretTF;
@property (nonatomic, strong) UITextField *printNameTF;
@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UILabel * printNumberLabel;
@property (nonatomic, strong) UITextField * printNumberTF;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation EquipmentInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"设备信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    [self createSubviews];
    
}

- (void)backLastVC:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubviews
{
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
    
    self.printNumLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
    _printNumLB.text = @"终端编号:";
    _printNumLB.textAlignment = NSTextAlignmentRight;
    [scroller addSubview:_printNumLB];
    
    self.printNumTF = [[UITextField alloc]initWithFrame:CGRectMake(_printNumLB.right + LEFT_SPACE, _printNumLB.top, self.view.width - _printNumLB.width - 3 * LEFT_SPACE, _printNumLB.height)];
    [scroller addSubview:_printNumTF];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _printNumLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 0.6)];
    line1.backgroundColor = LINE_COLOR;
    [scroller addSubview:line1];
    
    self.printSecretLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE,line1.bottom + TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
    _printSecretLB.text = @"终端密匙:";
    _printSecretLB.textAlignment = NSTextAlignmentRight;
    [scroller addSubview:_printSecretLB];
    
    self.printSecretTF = [[UITextField alloc]initWithFrame:CGRectMake(_printSecretLB.right + LEFT_SPACE, _printSecretLB.top, self.view.width - _printSecretLB.width - 3 * LEFT_SPACE, _printSecretLB.height)];
    [scroller addSubview:_printSecretTF];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _printSecretLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 0.6)];
    line2.backgroundColor = LINE_COLOR;
    [scroller addSubview:line2];

    self.printNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE,line2.bottom + TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
    _printNumberLabel.text = @"打印份数:";
    _printNumberLabel.textAlignment = NSTextAlignmentRight;
    [scroller addSubview:_printNumberLabel];
    
    self.printNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(_printNumberLabel.right + LEFT_SPACE, _printNumberLabel.top, self.view.width - _printNumberLabel.width - 3 * LEFT_SPACE, _printNumberLabel.height)];
    _printNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    [scroller addSubview:_printNumberTF];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _printNumberLabel.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 0.6)];
    line3.backgroundColor = LINE_COLOR;
    [scroller addSubview:line3];
    
    
//    self.printNameLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE,line2.bottom + TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
//    _printNameLB.text = @"终端名称:";
//    _printNameLB.textAlignment = NSTextAlignmentRight;
//    [scroller addSubview:_printNameLB];
//    
//    self.printNameTF = [[UITextField alloc]initWithFrame:CGRectMake(_printNameLB.right + LEFT_SPACE, _printNameLB.top, self.view.width - _printNameLB.width - 3 * LEFT_SPACE, _printNameLB.height)];
//    [scroller addSubview:_printNameTF];
//    
//    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _printNameLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 0.6)];
//    line3.backgroundColor = LINE_COLOR;
//    [scroller addSubview:line3];
    
//
//    self.phoneLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE,line3.bottom + TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
//    _phoneLB.text = @"手机号:";
//    _phoneLB.textAlignment = NSTextAlignmentRight;
//    [scroller addSubview:_phoneLB];
//    
//    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(_phoneLB.right + LEFT_SPACE, _phoneLB.top, self.view.width - _phoneLB.width - 3 * LEFT_SPACE, _phoneLB.height)];
//    [scroller addSubview:_phoneTF];
//    
//    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _phoneLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 0.6)];
//    line4.backgroundColor = LINE_COLOR;
//    [scroller addSubview:line4];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _saveButton.frame = CGRectMake(LEFT_SPACE, line3.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, LB_HEIGHT);
    _saveButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 5;
    _saveButton.layer.masksToBounds = YES;
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_saveButton addTarget:self action:@selector(saveEquipmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:_saveButton];
    
    scroller.contentSize =  CGSizeMake(self.view.width, _saveButton.bottom + TOP_SPACE);
    
    [self.view addSubview:scroller];
}

- (void)saveEquipmentAction:(UIButton *)button
{
    
    if ([self.printNumberTF.text intValue] < 0) {
        self.printNumberTF.text = @"0";
    }
    
    if (self.printNumTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"终端编号不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else if (self.printSecretTF.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"终端密匙不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
//    else if (self.printNameTF.text.length == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"终端名称不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }else if (self.phoneLB.text.length == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
    else
    {
        NSDictionary *jsondic = @{
                                  @"Command":@51,
                                  @"UserId":[UserInfo shareUserInfo].userId,
                                  @"PrintNum":self.printNumTF.text,
                                  @"PrintSecret":self.printSecretTF.text,
                                  @"PrintCount":@([self.printNumberTF.text intValue])
                                  };
        [self playPostWithDictionary:jsondic];
        [SVProgressHUD showInfoWithStatus:@"正在添加" maskType:SVProgressHUDMaskTypeBlack];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
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
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"%@", error);
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
