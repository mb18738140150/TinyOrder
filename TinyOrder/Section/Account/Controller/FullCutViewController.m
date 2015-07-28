//
//  FullCutViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "FullCutViewController.h"
#import "MenuActivityMD.h"
#import "TimeViewController.h"

#define BUTTON_WIDHT ((_allMenusV.width - 4 * LEFT_SPACE) / 3)
#define BUTTON_HEIGHT 30
#define TOP_SPACE 15
#define LEFT_SPACE 20


@interface FullCutViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UITextField * mPriceTF;
@property (nonatomic, strong)UITextField * jPriceTF;
//@property (nonatomic, strong)UIImageView * isSeleteIMV;

@property (nonatomic, strong)UIScrollView * menusView;

@property (nonatomic, strong)UIView * allMenusV;
//@property (nonatomic, strong)UIView * selectMenuV;

@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)NSMutableArray * selectArray;


@property (nonatomic, strong)NSDictionary * dateDic;

@end

@implementation FullCutViewController


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
    
    UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 25, 30)];
    titleLB.text = @"满";
    [view1 addSubview:titleLB];
    self.mPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(titleLB.right, titleLB.top, 60, titleLB.height)];
    _mPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    _mPriceTF.borderStyle = UITextBorderStyleRoundedRect;
    [view1 addSubview:_mPriceTF];
    UILabel * mPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_mPriceTF.right, 15, 25, 30)];
    mPriceLB.text = @"元";
    [view1 addSubview:mPriceLB];
    
    
    UILabel * jtitleLB = [[UILabel alloc] initWithFrame:CGRectMake(mPriceLB.right + 20, 15, 25, 30)];
    jtitleLB.text = @"减";
    [view1 addSubview:jtitleLB];
    self.jPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(jtitleLB.right, titleLB.top, 60, titleLB.height)];
    _jPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    _jPriceTF.borderStyle = UITextBorderStyleRoundedRect;
    [view1 addSubview:_jPriceTF];
    UILabel * jPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_jPriceTF.right, 15, 25, 30)];
    jPriceLB.text = @"元";
    [view1 addSubview:jPriceLB];
    
//    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
//    line.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
//    [view1 addSubview:line];
    
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
    
    UIButton * timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(0, changeMBT.bottom + 30, changeMBT.width, changeMBT.height);
    timeButton.backgroundColor = [UIColor whiteColor];
    [timeButton setTitle:@"活动时间" forState:UIControlStateNormal];
    [timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    timeButton.titleLabel.numberOfLines = 0;
    timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    timeButton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [timeButton addTarget:self action:@selector(changeActivityTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeButton];
    
    
    UIButton * createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.frame = CGRectMake(15, timeButton.bottom + 40, self.view.width - 30, 40);
    createButton.backgroundColor = [UIColor orangeColor];
    createButton.layer.cornerRadius = 5;
    [createButton setTitle:@"生产活动" forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createButton];
    
    
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


- (void)changeActivityTime:(UIButton *)button
{
    NSLog(@"设置时间");
    __weak FullCutViewController * fullCutVC = self;
    TimeViewController * timeVC = [[TimeViewController alloc] init];
    [timeVC returnDate:^(NSDictionary *dateDic) {
        NSLog(@"%@", dateDic);
        fullCutVC.dateDic = dateDic;
        if ([[dateDic objectForKey:@"TlimitType"] isEqualToNumber:@1]) {
            NSString * string = [NSString stringWithFormat:@"%@ \n开始时间%@   结束时间%@", button.currentTitle, [dateDic objectForKey:@"StartDate"], [dateDic objectForKey:@"EndDate"]];
//            [button setTitle:string forState:UIControlStateNormal];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, str.length - 4)];
            [button setAttributedTitle:str forState:UIControlStateNormal];
        }else if ([[dateDic objectForKey:@"TlimitType"] isEqualToNumber:@2])
        {
            NSMutableString * string = [NSMutableString stringWithFormat:@"%@ \n", button.currentTitle];
            if ([[dateDic objectForKey:@"ZoneTimeType"] isEqualToNumber:@1]) {
                [string appendFormat:@"周一到周五 %@点前", [dateDic objectForKey:@"Time"]];
            }else
            {
                [string appendFormat:@"周六、周日 %@点前", [dateDic objectForKey:@"Time"]];
            }
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, str.length - 4)];
            [button setAttributedTitle:str forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:timeVC animated:YES];
}


- (void)createActivity:(UIButton *)button
{
    NSLog(@"生产活动");
    
    if (self.jPriceTF.text.length != 0 && self.mPriceTF.text.length != 0 && self.dateDic != nil) {
        NSDictionary * jsonDic = nil;
        NSMutableArray * menusArray = [NSMutableArray array];
        for (MenuActivityMD * menu in self.selectArray) {
            [menusArray addObject:menu.mealId];
        }
        if ([[self.dateDic objectForKey:@"TlimitType"] isEqualToNumber:@1]) {
            jsonDic = @{
                        @"Command":@30,
                        @"UserId":[UserInfo shareUserInfo].userId,
                        @"ActionType":@1,
                        @"ReduceMoney":[NSNumber numberWithDouble:[self.jPriceTF.text doubleValue]],
                        @"FullMoney":[NSNumber numberWithDouble:[self.mPriceTF.text doubleValue]],
                        @"TlimitType":[self.dateDic objectForKey:@"TlimitType"],
                        @"StartDate":[self.dateDic objectForKey:@"StartDate"],
                        @"EndDate":[self.dateDic objectForKey:@"EndDate"],
                        @"ZoneTimeType":@0,
                        @"Time":@0,
                        @"FoodList":menusArray
                        };
        }else if ([[self.dateDic objectForKey:@"TlimitType"] isEqualToNumber:@2])
        {
            jsonDic = @{
                        @"Command":@30,
                        @"UserId":[UserInfo shareUserInfo].userId,
                        @"ActionType":@1,
                        @"ReduceMoney":[NSNumber numberWithDouble:[self.jPriceTF.text doubleValue]],
                        @"FullMoney":[NSNumber numberWithDouble:[self.mPriceTF.text doubleValue]],
                        @"TlimitType":[self.dateDic objectForKey:@"TlimitType"],
                        @"StartDate":@"",
                        @"EndDate":@"",
                        @"ZoneTimeType":[self.dateDic objectForKey:@"ZoneTimeType"],
                        @"Time":[self.dateDic objectForKey:@"Time"],
                        @"FoodList":menusArray
                        };
        }
        NSLog(@"jsonDic = %@, dateDic = %@", jsonDic, self.dateDic);
        [self playPostWithDictionary:jsonDic];
    }else if(self.jPriceTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入减免价" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.mPriceTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入满价" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.dateDic == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择活动时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
    
}


#pragma mark - 数据请求


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
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10031])
        {
            NSArray * array = [data objectForKey:@"FoodList"];
            for (NSDictionary * dic in array) {
                MenuActivityMD * menu = [[MenuActivityMD alloc] initWithDictionary:dic];
                [self.dataArray addObject:menu];
            }
            [self addmenuButtonFromAllMenuView];
//            NSLog(@"array = %@", self.dataArray);
        }else if ([command isEqualToNumber:@10030])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"%@", error);
}

- (void)addmenuButtonFromAllMenuView
{
    CGFloat height = BUTTON_HEIGHT;
    for (int i = 0; i < self.dataArray.count; i++) {
        MenuActivityMD * menu = [self.dataArray objectAtIndex:i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        int j = i % 3;
        int k = i / 3;
        button.frame = CGRectMake(LEFT_SPACE + j * (BUTTON_WIDHT + LEFT_SPACE), TOP_SPACE + (TOP_SPACE + BUTTON_HEIGHT) * k, BUTTON_WIDHT, height);
        button.tag = 1000 + i;
        button.layer.cornerRadius = 3;
        button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [button setTitle:menu.name forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(didchangeMenu:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [menu.name boundingRectWithSize:CGSizeMake(BUTTON_WIDHT, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:nil].size;
        if (size.height > button.height) {
            button.height = size.height;
            height = size.height;
        }
        [_allMenusV addSubview:button];
        _allMenusV.height = button.bottom + TOP_SPACE;
    }
    _menusView.contentSize = CGSizeMake(_menusView.width, _allMenusV.bottom);
}


- (void)didchangeMenu:(UIButton *)button
{
    MenuActivityMD * menu = [self.dataArray objectAtIndex:button.tag - 1000];
//    NSLog(@"%@", menu.name);
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor orangeColor];
        [self.selectArray addObject:menu];
//        UIButton * selectBT = [UIButton buttonWithType:UIButtonTypeCustom];
//        int j = (self.selectArray.count - 1) % 3;
//        int k = (self.selectArray.count - 1) / 3;
//        selectBT.frame = CGRectMake(LEFT_SPACE + j * (BUTTON_WIDHT + LEFT_SPACE), TOP_SPACE + (TOP_SPACE + BUTTON_HEIGHT) * k, BUTTON_WIDHT, BUTTON_HEIGHT);
//        selectBT.tag = 2000 + (self.selectArray.count - 1);
//        selectBT.layer.cornerRadius = 3;
//        selectBT.backgroundColor = [UIColor orangeColor];
//        [selectBT setTitle:menu.foodName forState:UIControlStateNormal];
//        selectBT.titleLabel.numberOfLines = 0;
//        selectBT.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self.selectMenuV addSubview:selectBT];
//        self.selectMenuV.height = selectBT.bottom + TOP_SPACE;
//        self.allMenusV.top = self.selectMenuV.bottom + 1;
//        self.menusView.contentSize = CGSizeMake(_menusView.width, _allMenusV.bottom);
    }else
    {
        button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//        UIButton * selectBT = (UIButton *)[self.selectMenuV viewWithTag:2000 + [self.selectArray indexOfObject:menu]];
//        [selectBT removeFromSuperview];
        [self.selectArray removeObject:menu];
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
