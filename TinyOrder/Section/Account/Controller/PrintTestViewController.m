//
//  PrintTestViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PrintTestViewController.h"
#import "PeripheralViewCell.h"
#import "PrintNumViewCell.h"
#import "BluetoothViewController.h"
#import "CustomIOSAlertView.h"
#import "UIViewAdditions.h"
#import "GeneralBlueTooth.h"

#define TOP_SPACE 20
#define LEFT_SPACE 20
#define BUTTON_WIDTH 40
#define BUTTON_HEIGHT 40
#define VIEW_HEIGT TOP_SPACE * 2 + BUTTON_HEIGHT
#define VIEW_WIDTH LEFT_SPACE * 2 + BUTTON_WIDTH * 3

@interface PrintTestViewController ()<CustomIOSAlertViewDelegate>


@property (nonatomic, strong)UITextField * numberTF;


@end

@implementation PrintTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 10, self.tableView.frame.size.width - 40, 40);
    [button setTitle:@"打印测试" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(printTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableFooterView addSubview:button];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)printTest:(UIButton *)button
{
    int printNum = [[self getPrintNumFromCell] intValue];
    if (printNum == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"如果需要测试打印机,请不要设置打印份数为0" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }else
    {
        NSString * lineStr = @"--------------------------------\r";
        NSString * str = [NSString stringWithFormat:@"1号  微生活外卖\r商家:%@\r%@下单时间:3/4 11:34:33\r%@\r预期送达时间12:10\r地址:上海浦东新区陆家嘴东路12号1204\r联系人:王先生\r电话:13388553308\r%@白菜肉丝+例汤+赠品  4份  24元\r%@其他费用\r配送费   0元\r%@总计 24元  已付款\r%@备注:本订单测试数据\n\n\n\n", [UserInfo shareUserInfo].userName,lineStr, lineStr, lineStr, lineStr, lineStr, lineStr];
        NSMutableArray * printArray = [NSMutableArray array];
        for (int i = 0; i < printNum; i++) {
            [printArray addObject:str];
        }
        [[GeneralBlueTooth shareGeneralBlueTooth] printWithArray:printArray];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
//    if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral) {
//        
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        static NSString * printCellIndentifier = @"printCell";
        PrintNumViewCell * printCell = [tableView dequeueReusableCellWithIdentifier:printCellIndentifier];
        if (!printCell) {
            printCell = [[PrintNumViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:printCellIndentifier];
            [printCell createSubView:self.tableView.bounds];
        }
        return printCell;
    }
    static NSString * cellIndentifier = @"cell";
    PeripheralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[PeripheralViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        [cell createSubView:self.tableView.bounds];
    }
    if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
        cell.periheralName.text = [GeneralBlueTooth shareGeneralBlueTooth].deviceName;
        cell.periheralID.text = @"已连接";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        BluetoothViewController * bluetoothVC = [[BluetoothViewController alloc] init];
        [self.navigationController pushViewController:bluetoothVC animated:YES];
    }else
    {
        [self createCustomAlertView];
    }
}


- (void)createCustomAlertView
{
    CustomIOSAlertView * cunstomAlert = [[CustomIOSAlertView alloc] init];
    cunstomAlert.containerView = [self createAlertSubview];
    [cunstomAlert setButtonTitles:@[@"取消", @"确定"]];
    cunstomAlert.delegate = self;
    cunstomAlert.useMotionEffects = YES;
    [cunstomAlert show];
}

- (UIView *)createAlertSubview
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGT)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    
    UIButton * subtractButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subtractButton.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
    [subtractButton addTarget:self action:@selector(subtractPrintNumber:) forControlEvents:UIControlEventTouchUpInside];
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"reduce_normal.png"] forState:UIControlStateNormal];
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"reduce_press.png"] forState:UIControlStateHighlighted];
//    subtractButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:subtractButton];
    
    self.numberTF = [[UITextField alloc] initWithFrame:CGRectMake(subtractButton.right, subtractButton.top, subtractButton.width, subtractButton.height)];
    _numberTF.keyboardType = UIKeyboardTypeNumberPad;
    _numberTF.borderStyle = UITextBorderStyleLine;
    _numberTF.textAlignment = NSTextAlignmentCenter;
    _numberTF.text = [self getPrintNumFromCell];
    [view addSubview:_numberTF];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(_numberTF.right, _numberTF.top, subtractButton.width, subtractButton.height);
    [addButton addTarget:self action:@selector(addPrintNumber:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_normal.png"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_press.png"] forState:UIControlStateHighlighted];
//    addButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:addButton];
    return view;
}

- (void)addPrintNumber:(UIButton *)button
{
    self.numberTF.text = [NSString stringWithFormat:@"%d", [self.numberTF.text intValue] + 1];
}

- (void)subtractPrintNumber:(UIButton *)button
{
    if ([self.numberTF.text intValue] != 0) {
        self.numberTF.text = [NSString stringWithFormat:@"%d", [self.numberTF.text intValue] - 1];
    }
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
//    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (buttonIndex == 1) {
        PrintNumViewCell * cell = (PrintNumViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if ([_numberTF.text intValue] < 0) {
            _numberTF.text = @"0";
        }
        cell.numberLabel.text = [NSString stringWithFormat:@"%@份", _numberTF.text];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:[_numberTF.text intValue]] forKey:@"printNum"];
    }
    [alertView close];
}

- (NSString *)getPrintNumFromCell
{
    PrintNumViewCell * cell = (PrintNumViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    return [NSString stringWithFormat:@"%ld", [cell.numberLabel.text integerValue]];
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
