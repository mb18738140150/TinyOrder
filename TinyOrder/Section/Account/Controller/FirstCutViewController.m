//
//  FirstCutViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "FirstCutViewController.h"
#import "FooterCollectionView.h"
#import "HeaderCollectionView.h"
#import "MenuActivityMD.h"

#define CELL_INDENTIFIER @"cell"
#define HEADER_INDENTIFIER @"header"
#define FOOTER_INDENTIFIER @"footer"


#define BUTTON_WIDHT ((_allMenusV.width - 4 * LEFT_SPACE) / 3)
#define BUTTON_HEIGHT 30
#define TOP_SPACE 15
#define LEFT_SPACE 20



@interface FirstCutViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UITextField * jPriceTF;
@property (nonatomic, strong)UIScrollView * menusView;
@property (nonatomic, strong)UIView * allMenusV;
@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)NSMutableArray * selectArray;


@end

@implementation FirstCutViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        self.selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 75, 30)];
    titleLB.text = @"首单立减";
    [view1 addSubview:titleLB];

    
    self.jPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(titleLB.right, titleLB.top, 60, titleLB.height)];
    _jPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    _jPriceTF.borderStyle = UITextBorderStyleRoundedRect;
    [view1 addSubview:_jPriceTF];
    UILabel * jPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_jPriceTF.right, 15, 25, 30)];
    jPriceLB.text = @"元";
    [view1 addSubview:jPriceLB];
    
    //    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    //    line.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    //    [view1 addSubview:line];
    /*
    UIButton * changeMBT = [UIButton buttonWithType:UIButtonTypeCustom];
    changeMBT.frame = CGRectMake(0, view1.bottom + 1, view1.width, view1.height);
    changeMBT.backgroundColor = [UIColor whiteColor];
    [changeMBT addTarget:self action:@selector(createMenusView:) forControlEvents:UIControlEventTouchUpInside];
    changeMBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    changeMBT.imageEdgeInsets = UIEdgeInsetsMake(0, changeMBT.width - 48, 0, 0);
    changeMBT.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [changeMBT setImage:[UIImage imageNamed:@"arrowDown.png"] forState:UIControlStateNormal];
    [changeMBT setTitle:@"选择不享受活动的菜" forState:UIControlStateNormal];
    changeMBT.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [changeMBT setImage:[UIImage imageNamed:@"arrowUp.png"] forState:UIControlStateSelected];
    [changeMBT setTitle:@"选择不享受活动的菜" forState:UIControlStateNormal];
    [changeMBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeMBT.titleEdgeInsets = UIEdgeInsetsMake(0, -28, 0, 0);
    [self.view addSubview:changeMBT];
    */
    
    UIButton * createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.frame = CGRectMake(15, 40, self.view.width - 30, 40);
    createButton.centerY = self.view.height / 2;
    createButton.backgroundColor = [UIColor orangeColor];
    createButton.layer.cornerRadius = 5;
    [createButton setTitle:@"生产活动" forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createButton];
    
    /*
    self.menusView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, changeMBT.bottom, self.view.width, self.view.height - changeMBT.bottom - self.navigationController.navigationBar.bottom)];
    _menusView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    
    //    self.selectMenuV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menusView.width, 1)];
    //    _selectMenuV.backgroundColor = [UIColor whiteColor];
    //    [_menusView addSubview:_selectMenuV];
    
    
    self.allMenusV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menusView.width, 10)];
    _allMenusV.backgroundColor = [UIColor whiteColor];
    [_menusView addSubview:_allMenusV];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@31
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"更新数据..." maskType:SVProgressHUDMaskTypeBlack];
    */
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)createMenusView:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.view addSubview:_menusView];
    }else
    {
        [_menusView removeFromSuperview];
    }
    //    NSLog(@"加载菜品列表");
}
*/

- (void)createActivity:(UIButton *)button
{
    NSLog(@"生产活动");
    if (self.jPriceTF.text.length != 0) {
        NSDictionary * jsonDic = @{
                                   @"Command":@30,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"ActionType":@2,
                                   @"ReduceMoney":[NSNumber numberWithDouble:[self.jPriceTF.text doubleValue]],
                                   @"FullMoney":@0,
                                   @"TlimitType":@0,
                                   @"StartDate":@"",
                                   @"EndDate":@"",
                                   @"ZoneTimeType":@0,
                                   @"Time":@0,
                                   @"FoodList":@[]
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入减免价" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
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
        if ([command isEqualToNumber:@10030])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }else
    {
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
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









/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
