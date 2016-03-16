//
//  BankCarController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "BankCarController.h"
#import "BankViewCell.h"
#import "AddBankViewController.h"
#import "WithdrawalViewController.h"
#import "SetPayPasswordViewController.h"
#import "BankCarModel.h"

#define CELL_INDENTIFIER @"CELL"

@interface BankCarController ()<HTTPPostDelegate, UIAlertViewDelegate>

@property (nonatomic, copy)NSString * verifyName;

@property (nonatomic, strong)NSMutableArray * dataArray;

// 弹出框
@property (nonatomic, strong)UIView * tanchuView;

// 添加口味视图
@property (nonatomic, strong)UIView * addTasteView;
@property (nonatomic, strong)UITextField * payPasswordTF;
@property (nonatomic, strong)BankCarModel * bankModel;
@end

@implementation BankCarController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BankViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 120)];
    footView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton * addBankCarBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addBankCarBT.frame = CGRectMake(10, 15, footView.width - 20, 40);
    [addBankCarBT setImage:[UIImage imageNamed:@"addBank.png"] forState:UIControlStateNormal];
    [addBankCarBT setTitle:@"添加银行卡" forState:UIControlStateNormal];
    addBankCarBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    addBankCarBT.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    addBankCarBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [addBankCarBT addTarget:self action:@selector(addBankCarAciton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:addBankCarBT];
    
    UIButton * setpayPasswordBT = [UIButton buttonWithType:UIButtonTypeCustom];
    setpayPasswordBT.frame = CGRectMake(10, addBankCarBT.bottom + 10, footView.width - 20, 40);
    [setpayPasswordBT setTitle:@"设置支付密码" forState:UIControlStateNormal];
    setpayPasswordBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    setpayPasswordBT.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    setpayPasswordBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [setpayPasswordBT addTarget:self action:@selector(setpayPasswordAciton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:setpayPasswordBT];
    
//    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, setpayPasswordBT.bottom + 10, footView.width - 20, 40)];
//    tipLabel.backgroundColor = [UIColor clearColor];
//    tipLabel.textColor = [UIColor orangeColor];
//    tipLabel.font = [UIFont systemFontOfSize:14];
//    tipLabel.text = @"初始支付密码为账户登录密码";
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    tipLabel.numberOfLines = 0;
//    [footView addSubview:tipLabel];
    
    self.tableView.tableFooterView = footView;
    
    self.tanchuView = [[UIView alloc]initWithFrame:self.view.bounds];
    _tanchuView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary * jsonDic = @{
                               @"Command":@35,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBankCarAciton:(UIButton *)button
{
    [self tanchuPassWordView];
}

- (void)tanchuPassWordView
{
    
    [self.view addSubview:_tanchuView];
    
    [_tanchuView removeAllSubviews];
    
    
    UIView * backView = [[UIView alloc]init];
    backView.frame = _tanchuView.frame;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = .5;
    [_tanchuView addSubview:backView];
    
    UIView *payPasswordView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 20, 150)];
    payPasswordView.center = _tanchuView.center;
    payPasswordView.backgroundColor = [UIColor whiteColor];
    [_tanchuView addSubview:payPasswordView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width / 2 - 50, 20, 100, 30)];
    titleLabel.text = @"支付密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [payPasswordView addSubview:titleLabel];
    
    self.payPasswordTF = [[UITextField alloc]initWithFrame:CGRectMake(20, titleLabel.bottom + 10, payPasswordView.width - 40, 30)];
    _payPasswordTF.placeholder = @"6-16字符,区分大小写";
    _payPasswordTF.borderStyle = UITextBorderStyleNone;
    _payPasswordTF.secureTextEntry = YES;
    [payPasswordView addSubview:_payPasswordTF];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, _payPasswordTF.bottom, payPasswordView.width - 40, 1)];
    lineView2.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [payPasswordView addSubview:lineView2];
    
    
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(40, lineView2.bottom + 9, 80, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleTastepriceAction) forControlEvents:UIControlEventTouchUpInside];
    [payPasswordView addSubview:cancleButton];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(payPasswordView.width - 40 - 80, cancleButton.top, cancleButton.width, cancleButton.height);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureTasteprice:) forControlEvents:UIControlEventTouchUpInside];
    [payPasswordView addSubview:sureButton];
    
    [self animateIn];
    
}
- (void)animateIn
{
    self.tanchuView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.tanchuView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.tanchuView.alpha = 1;
        self.tanchuView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)cancleTastepriceAction
{
    [self.tanchuView removeFromSuperview];
}

- (void)sureTasteprice:(UIButton *)button
{
    
    [self.tanchuView removeFromSuperview];
    
    if (self.payPasswordTF.text.length != 0) {
        NSDictionary * jsonDic = @{
                                   @"Command":@67,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"PeyPassword":self.payPasswordTF.text
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


- (void)setpayPasswordAciton:(UIButton *)button
{
    SetPayPasswordViewController * setVC = [[SetPayPasswordViewController alloc]init];
    setVC.title = @"sdkjfb";
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    cell.bankCarMD = [self.dataArray objectAtIndex:indexPath.row];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteBankCardAction:)];
    [cell addGestureRecognizer:longPress];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BankViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WithdrawalViewController * withdrawalVC = [[WithdrawalViewController alloc] init];
    withdrawalVC.bankCarMD = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:withdrawalVC animated:YES];
}


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
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10035]) {
            self.verifyName = [data objectForKey:@"VerifyName"];
            NSArray * array = [data objectForKey:@"BankCardList"];
            self.dataArray = nil;
            for (NSDictionary * dic in array) {
                BankCarModel * bankCarMD  = [[BankCarModel alloc] initWithDictionary:dic];
                NSLog(@"carNum = %@", bankCarMD.bankCardNumber);
                [self.dataArray addObject:bankCarMD];
            }
            [self.tableView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10067])
        {
            if (self.bankModel) {
                NSDictionary * jsonDic = @{
                                           @"Command":@70,
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"BankCardId":self.bankModel.bankCardId
                                           };
                [self playPostWithDictionary:jsonDic];
                self.bankModel = nil;
            }else
            {
                
                AddBankViewController * addBankVC = [[AddBankViewController alloc] init];
                addBankVC.verifyName = self.verifyName;
                [self.navigationController pushViewController:addBankVC animated:YES];
            }

        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10070])
        {
            NSDictionary * jsonDic = @{
                                       @"Command":@35,
                                       @"UserId":[UserInfo shareUserInfo].userId
                                       };
            [self playPostWithDictionary:jsonDic];
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
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
}
#pragma mark 长安删除
- (void)deleteBankCardAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        BankViewCell * cell = (BankViewCell *)sender.view;
        self.bankModel = cell.bankCarMD;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSLog(@"%@", self.bankModel);
        [self tanchuPassWordView];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
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
}
*/

@end
