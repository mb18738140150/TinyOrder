//
//  ShopDescribViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ShopDescribViewController.h"


#define LEFT_SPACE 10
#define TOP_SPACE 10
#define LEFT_LB_WIDTH 100
#define LABEL_HEIGHT 30


#define LINE_COLOR [UIColor colorWithWhite:0.9 alpha:1]

@interface ShopDescribViewController ()<UITextFieldDelegate, HTTPPostDelegate, UIAlertViewDelegate>


@property (nonatomic, strong)UILabel *nameLB;
@property (nonatomic, strong)UITextField * commissionTF;
@property (nonatomic, strong)UISwitch * isDeliverySwitch;
//@property (nonatomic, strong)UILabel *CommissionLB;
@property (nonatomic, strong)UILabel *publicNumLB;
@property (nonatomic, strong)UILabel *numType;
@property (nonatomic, strong)UILabel *autoTypeLB;
@property (nonatomic, strong)UILabel *infoLB;

@property (nonatomic, strong)UIButton *applyButton;

@end

@implementation ShopDescribViewController

- (PublicNumModel *)publicNumModel
{
    if (!_publicNumModel) {
        self.publicNumModel = [[PublicNumModel alloc]init];
    }
    return _publicNumModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UIScrollView * bigView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - 50)];
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    
    
    UILabel * nameTitelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    nameTitelLB.text = @"商家名称";
    [bigView addSubview:nameTitelLB];
    
    
    self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(nameTitelLB.right + LEFT_SPACE, TOP_SPACE, bigView.width - LEFT_LB_WIDTH - 3 * LEFT_SPACE, LABEL_HEIGHT)];
    _nameLB.text = [NSString stringWithFormat:@"%@" , self.publicNumModel.numName];
    _nameLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_nameLB];
    
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, nameTitelLB.bottom + TOP_SPACE, bigView.width - 2 * LEFT_SPACE, 0.6)];
    line1.backgroundColor = LINE_COLOR;
    [bigView addSubview:line1];
    
    
    
    UILabel * commissionTitelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line1.bottom, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    commissionTitelLB.text = @"佣金比例:";
    [bigView addSubview:commissionTitelLB];
    
    
    self.commissionTF = [[UITextField alloc] initWithFrame:CGRectMake(bigView.width - LEFT_SPACE - 80, commissionTitelLB.top, 60, LABEL_HEIGHT)];
    _commissionTF.borderStyle = UITextBorderStyleRoundedRect;
    _commissionTF.text = [NSString stringWithFormat:@"%@", self.publicNumModel.numCommission];
//    _commissionTF.delegate = self;
    _commissionTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [bigView addSubview:_commissionTF];
    
    UILabel * perLB = [[UILabel alloc] initWithFrame:CGRectMake(bigView.width - LEFT_SPACE - 20, commissionTitelLB.top, 20, LABEL_HEIGHT)];
    perLB.text = @"%";
    [bigView addSubview:perLB];
    
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, commissionTitelLB.bottom + TOP_SPACE, bigView.width - 2 * LEFT_SPACE, 0.6)];
    line2.backgroundColor = LINE_COLOR;
    [bigView addSubview:line2];
    
    UIView * isDeliveryView = [[UIView alloc]init];
    [bigView addSubview:isDeliveryView];
    
    UILabel * isDeliveryLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    isDeliveryLB.text = @"是否配送:";
    [isDeliveryView addSubview:isDeliveryLB];
    
    UIView * isLine = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, isDeliveryView.bottom, bigView.width - 2 * LEFT_SPACE, 1)];
    isLine.backgroundColor = LINE_COLOR;
    [bigView addSubview:isLine];
    
    self.isDeliverySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(bigView.width - LEFT_SPACE - 60, isDeliveryLB.top, 60, LABEL_HEIGHT)];
    [_isDeliverySwitch addTarget:self action:@selector(isDeliveryAction:) forControlEvents:UIControlEventTouchUpInside];
    [isDeliveryView addSubview:_isDeliverySwitch];
    
    if (self.publicNumModel.isDelivery == 1) {
        isDeliveryView.frame = CGRectMake(0, line2.bottom, self.view.width, LABEL_HEIGHT + 2 * TOP_SPACE);
        isLine.frame = CGRectMake(LEFT_SPACE, isDeliveryView.bottom, bigView.width - 2 * LEFT_SPACE, 1);
        _isDeliverySwitch.on = YES;
    }else
    {
        isDeliveryView.frame = CGRectMake(0, line2.bottom, self.view.width, 0);
        isDeliveryLB.hidden = YES;
        _isDeliverySwitch.hidden = YES;
        _isDeliverySwitch.on = NO;
        isLine.frame = CGRectMake(LEFT_SPACE, isDeliveryView.bottom, bigView.width - 2 * LEFT_SPACE, 0);
    }
    
//    NSLog(@"^^^^^^%d^^^^^", self.isDeliverySwitch.on);
    
    UILabel * numTitelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + isLine.bottom, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numTitelLB.text = @"公众号:";
    [bigView addSubview:numTitelLB];
    
    
    self.publicNumLB = [[UILabel alloc] initWithFrame:CGRectMake(numTitelLB.right + LEFT_SPACE, numTitelLB.top, bigView.width - LEFT_LB_WIDTH - 3 * LEFT_SPACE, LABEL_HEIGHT)];
    _publicNumLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.num];
    _publicNumLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_publicNumLB];
    
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, numTitelLB.bottom + TOP_SPACE, bigView.width - 2 * LEFT_SPACE, 0.6)];
    line3.backgroundColor = LINE_COLOR;
    [bigView addSubview:line3];
    
    UILabel * numTypeTitelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line3.bottom, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numTypeTitelLB.text = @"账号类型:";
    [bigView addSubview:numTypeTitelLB];
    
    
    self.numType = [[UILabel alloc] initWithFrame:CGRectMake(numTypeTitelLB.right + LEFT_SPACE, numTypeTitelLB.top, bigView.width - LEFT_LB_WIDTH - 3 * LEFT_SPACE, LABEL_HEIGHT)];
    _numType.text = [NSString stringWithFormat:@"%@" , self.publicNumModel.numType];
    _numType.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_numType];
    
    
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, numTypeTitelLB.bottom + TOP_SPACE, bigView.width - 2 * LEFT_SPACE, 0.6)];
    line4.backgroundColor = LINE_COLOR;
    [bigView addSubview:line4];
    
    UILabel * autoTypeTitelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line4.bottom, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    autoTypeTitelLB.text = @"认证类型:";
    [bigView addSubview:autoTypeTitelLB];
    
    
    self.autoTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(autoTypeTitelLB.right + LEFT_SPACE, autoTypeTitelLB.top, bigView.width - LEFT_LB_WIDTH - 3 * LEFT_SPACE, LABEL_HEIGHT)];
    _autoTypeLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.autoType];
    _autoTypeLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_autoTypeLB];
    
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, autoTypeTitelLB.bottom + TOP_SPACE, bigView.width - 2 * LEFT_SPACE, 0.6)];
    line5.backgroundColor = LINE_COLOR;
    [bigView addSubview:line5];
    
    
    UILabel * infoTitelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line5.bottom, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    infoTitelLB.text = @"公众号描述:";
    [bigView addSubview:infoTitelLB];
    
    
    self.infoLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, infoTitelLB.bottom, bigView.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    _infoLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.numInfo];
//    _infoLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_infoLB];
    
    
    
    self.applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.applyButton setTitle:@"申请入驻" forState:UIControlStateNormal];
    self.applyButton.frame = CGRectMake(LEFT_SPACE, _infoLB.bottom + 2 * TOP_SPACE, self.view.frame.size.width - 2 * LEFT_SPACE, 40);
    self.applyButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    self.applyButton.tintColor = [UIColor whiteColor];
    self.applyButton.layer.cornerRadius = 5;
    self.applyButton.layer.masksToBounds = YES;
    self.applyButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.applyButton addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bigView addSubview:self.applyButton];
    bigView.contentSize = CGSizeMake(bigView.width, _applyButton.bottom + 2 * TOP_SPACE);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 申请入住
- (void)applyAction:(UIButton *)button
{
    double commission = 0;
    int isCustom = 0;
    int isDelivery = -1;
    if (self.commissionTF.text.length) {
        commission = [self.commissionTF.text doubleValue];
        if (![self.publicNumModel.numCommission isEqualToNumber:@(commission)]) {
            isCustom = 1;
        }
        
        if (self.isDeliverySwitch.on) {
            isDelivery = 1;
        }else
        {
            isDelivery = 0;
        }
        
        NSDictionary *jsonDic = @{
                                  @"Command":@47,
                                  @"UserId":[UserInfo shareUserInfo].userId,
                                  @"NumId":self.publicNumModel.numId,
                                  @"NumCommission":@(commission),
                                  @"IsDelivery":@(isDelivery),
                                  @"IsCustom":@(isCustom)
                                  };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入佣金比例" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
}

#pragma mark -- 数据请求
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"--%@", jsonStr);
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

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"申请成功"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    UIViewController * vc = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:vc animated:YES];

}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
    //    [self.tableView headerEndRefreshing];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败%@" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"%@", error);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 2) {
        return NO;
    }
    
    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL a = [string isEqualToString:filtered];
    return a;
}

#pragma mark - 是否配送
- (void)isDeliveryAction:(UISwitch * )sender
{
//    NSLog(@"*****%d*", self.isDeliverySwitch.on);
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
