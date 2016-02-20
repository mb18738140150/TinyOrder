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
#import "NoActionFoodView.h"

#define CELL_INDENTIFIER @"cell"
#define HEADER_INDENTIFIER @"header"
#define FOOTER_INDENTIFIER @"footer"


#define BUTTON_WIDHT ((_allMenusV.width - 4 * LEFT_SPACE) / 3)
#define BUTTON_HEIGHT 30
#define TOP_SPACE 15
#define LEFT_SPACE 15



@interface FirstCutViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UIScrollView * myScrollView;
@property (nonatomic, strong)UIScrollView * menusView;
@property (nonatomic, strong)UIView *changeView;
@property (nonatomic, strong)UIView * allMenusV;
@property (nonatomic, strong)UIView * helpView;
@property (nonatomic, strong)NSMutableArray *noActionFoodArray;

@property (nonatomic, strong)UITextField * jPriceTF;
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
- (NSMutableArray *)noActionFoodArray
{
    if (!_noActionFoodArray) {
        self.noActionFoodArray = [NSMutableArray array];
    }
    return _noActionFoodArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
    [self.view addSubview:_myScrollView];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:view1];
    
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
    
    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(0, view1.bottom + 30, view1.width, view1.height)];
    _changeView.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:_changeView];
    
    UIButton * changeMBT = [UIButton buttonWithType:UIButtonTypeCustom];
    changeMBT.frame = CGRectMake(0, 0, view1.width, view1.height);
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
    [_changeView addSubview:changeMBT];
    
//    self.menusView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _changeView.bottom, self.view.width, 120)];
//    
//    _menusView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    
    
    
//    UIButton * createButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    createButton.frame = CGRectMake(15, 40, self.view.width - 30, 40);
//    createButton.centerY = self.view.height / 2;
//    createButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
//    createButton.layer.cornerRadius = 5;
//    [createButton setTitle:@"生产活动" forState:UIControlStateNormal];
//    [createButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:createButton];
    
   
    self.menusView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _changeView.bottom, self.view.width, self.view.height - changeMBT.bottom - self.navigationController.navigationBar.bottom)];
    _menusView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    
    //    self.selectMenuV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menusView.width, 1)];
    //    _selectMenuV.backgroundColor = [UIColor whiteColor];
    //    [_menusView addSubview:_selectMenuV];
    
    
    self.allMenusV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menusView.width, 10)];
    _allMenusV.backgroundColor = [UIColor whiteColor];
    [_menusView addSubview:_allMenusV];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@31,
                               @"Type":@(self.actionSort),
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"更新数据..." maskType:SVProgressHUDMaskTypeBlack];
    
    self.helpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 60)];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(createActivity:)];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
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
    //    NSLog(@"加载商品列表");
}
*/

- (void)createActivity:(UIButton *)button
{
    NSLog(@"生产活动");
    NSMutableArray * menusArray = [NSMutableArray array];
    for (MenuActivityMD * menu in self.selectArray) {
        [menusArray addObject:menu.mealId];
    }
    
    NSMutableArray * arrar2 = [NSMutableArray array];
    
    NSComparisonResult (^compareBlock)(id, id) = ^NSComparisonResult(id obj1, id obj2){
        
        return [obj1 compare:obj2];
    };
    
    arrar2 = [[menusArray sortedArrayUsingComparator:compareBlock] mutableCopy];
    

    
    
//    NSLog(@"****array2 = %@", arrar2);
    
    if (self.jPriceTF.text.length != 0) {
        NSDictionary * jsonDic = @{
                                   @"Command":@30,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"ActionSort":@(self.actionSort),
                                   @"ActionType":@2,
                                   @"ReduceMoney":[NSNumber numberWithDouble:[self.jPriceTF.text doubleValue]],
                                   @"FullMoney":@0,
                                   @"TlimitType":@0,
                                   @"StartDate":@"",
                                   @"EndDate":@"",
                                   @"ZoneTimeType":@0,
                                   @"Time":@0,
                                   @"FoodList":arrar2
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
    NSLog(@"%@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10030])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else if ([command isEqualToNumber:@10031])
        {
            NSArray * array = [data objectForKey:@"FoodList"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary * dic in array) {
                    MenuActivityMD * menu = [[MenuActivityMD alloc] initWithDictionary:dic];
                    [self.dataArray addObject:menu];
                }
                [self addmenuButtonFromAllMenuView];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"暂无数据"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
            
            //            NSLog(@"array = %@", self.dataArray);
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

- (void)createMenusView:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.myScrollView addSubview:_menusView];
    }else
    {
        [_menusView removeFromSuperview];
    }
}
#pragma mark - 添加所有菜品view
- (void)addmenuButtonFromAllMenuView
{
    for (int i = 0; i < self.dataArray.count; i++) {
        CGFloat height = BUTTON_HEIGHT;
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
        if (size.height > button.height && size.height < button.height + TOP_SPACE) {
            button.height = size.height;
            height = size.height;
        }
        if (size.height > button.height + TOP_SPACE) {
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.height = button.height + 12;
        }
        
        [_allMenusV addSubview:button];
        _allMenusV.height = button.bottom + TOP_SPACE;
    }
    self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, 200);
    _menusView.contentSize = CGSizeMake(_menusView.width, _allMenusV.height);
}
#pragma mark - 加减不享受活动菜品
- (void)didchangeMenu:(UIButton *)button
{
    MenuActivityMD * menu = [self.dataArray objectAtIndex:button.tag - 1000];
    //    NSLog(@"%@", menu.name);
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
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
        
        int i = -1;
        i = (_helpView.bottom - 60 ) / 40;
        
        
        NoActionFoodView * view = [[NoActionFoodView alloc]initWithFrame:CGRectMake(_helpView.right + LEFT_SPACE, 60, button.width, 30)];
        [view.deleteButton addTarget:self action:@selector(deleteNoActionFood:) forControlEvents:UIControlEventTouchUpInside];
        
        for (int j = 0; j<1000; j++) {
            if (j == i) {
                view.frame =CGRectMake(_helpView.right + LEFT_SPACE, 60 + 40 * j, button.width, 30);
            }
        }
        view.tag = button.tag;
        self.helpView.frame = view.frame;
        
        view.nameLabel.text = button.titleLabel.text;
        
        if (_helpView.right > self.view.width) {
            view.frame = CGRectMake(5 + LEFT_SPACE, _helpView.bottom + 10, button.width, 30);
            
            self.helpView.frame = view.frame;
            
        }
        /*
         大意是：当你设置图层的frame属性的时候，position根据锚点（anchorPoint）的值来确定，而当你设置图层的position属性的时候，bounds会根据锚点（anchorPoint）来确定
         positionNew.x = positionOld.x + (anchorPointNew.x - anchorPointOld.x)  * bounds.size.width
         positionNew.y = positionOld.y + (anchorPointNew.y - anchorPointOld.y)  * bounds.size.height
        
         */
        view.transform = CGAffineTransformMakeScale(.1, .1);
        view.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            view.alpha = 1;
            view.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
        self.changeView.frame = CGRectMake(0, 91, self.view.width, _helpView.bottom + 10);
        
        [self.changeView addSubview:view];
        [self.noActionFoodArray addObject:view];
        
//        self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, self.view.height - _changeView.bottom - self.navigationController.navigationBar.bottom);
        self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, 200);
        self.allMenusV.frame = CGRectMake(_menusView.frame.origin.x, 0, _menusView.width, self.allMenusV.height);
        
        
        self.myScrollView.contentSize = CGSizeMake(self.view.width, _menusView.bottom + 20);
        
        button.enabled = NO;
        
    }else
    {
        button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        //        UIButton * selectBT = (UIButton *)[self.selectMenuV viewWithTag:2000 + [self.selectArray indexOfObject:menu]];
        //        [selectBT removeFromSuperview];
        [self.selectArray removeObject:menu];
    }
}

- (void)deleteNoActionFood:(UIButton *)button
{
    UIView *view = [button superview];
    
    UIButton *view2 = (UIButton *)[_allMenusV viewWithTag:view.tag];
    
    view2.enabled = YES;
    view2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    int i = -1;
    for (int j = 0;j < self.noActionFoodArray.count; j++) {
        NoActionFoodView *viewi = [self.noActionFoodArray objectAtIndex:j];
        if ([view isEqual:viewi]) {
            i = j;
            break;
        }
    }
    
    
    for (int k = self.noActionFoodArray.count - 1; k > i; k--) {
        NoActionFoodView *view1 = [self.noActionFoodArray objectAtIndex:k];
        NoActionFoodView * view2 = [self.noActionFoodArray objectAtIndex:k - 1];
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1];
        view1.frame = view2.frame;
        [UIView commitAnimations];
    }
    [view removeFromSuperview];
    [self.noActionFoodArray removeObjectAtIndex:i];
    [self.selectArray removeObjectAtIndex:i];
    
    if (self.noActionFoodArray.count == 0) {
        _helpView.frame = CGRectMake(0, 0, 5, 60);
    }else
    {
        UIView *lastView = [self.noActionFoodArray lastObject];
        _helpView.frame = lastView.frame;
        
    }
    
    
    self.changeView.frame = CGRectMake(0, 91, self.view.width, _helpView.bottom + 10);
    
//    self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, self.view.height - _changeView.bottom - self.navigationController.navigationBar.bottom);
    self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, 200);
    self.allMenusV.frame = CGRectMake(_menusView.frame.origin.x, 0, _menusView.width, self.allMenusV.height);
    
    self.myScrollView.contentSize = CGSizeMake(self.view.width, _menusView.bottom);
    
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
