//
//  AddBankViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddBankViewController.h"
#import "CarInfoViewController.h"

@interface AddBankViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField * carNumTF;
@property (nonatomic, strong)UITextField * personTF;


@end

@implementation AddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 100)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    
    UILabel * personLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 55, 20)];
    personLB.text = @"持卡人";
    [aView addSubview:personLB];
    
    self.personTF = [[UITextField alloc] initWithFrame:CGRectMake(personLB.right + 5, personLB.top, self.view.width - personLB.left - personLB.right - 5, personLB.height)];
    _personTF.placeholder = @"请输入持卡人姓名";
    _personTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [aView addSubview:_personTF];
    
    if(![self.verifyName isEqual:[NSNull null]] && self.verifyName.length > 0)
    {
        _personTF.text = self.verifyName;
        _personTF.enabled = NO;
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(personLB.left, personLB.bottom + 9, self.view.width - personLB.left * 2, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:lineView];
    
    UILabel * carNumLB = [[UILabel alloc] initWithFrame:CGRectMake(personLB.left, 10 + lineView.bottom, personLB.width, personLB.height)];
    carNumLB.text = @"卡号";
    [aView addSubview:carNumLB];
    
    self.carNumTF = [[UITextField alloc] initWithFrame:CGRectMake(carNumLB.right + 5, carNumLB.top, self.view.width - carNumLB.left - carNumLB.right - 5, carNumLB.height)];
    _carNumTF.placeholder = @"请输入银行卡号";
    _carNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _carNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _carNumTF.delegate = self;
    [aView addSubview:_carNumTF];
    
    aView.height = _carNumTF.bottom + 10;
    
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(10, aView.bottom + 20, self.view.width - 20, 40);
    nextButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    nextButton.layer.cornerRadius = 5;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(AddCardNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    
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

- (void)AddCardNextAction:(UIButton *)button
{
    
//    CarInfoViewController * carInfoVC = [[CarInfoViewController alloc] init];
//    [self.navigationController pushViewController:carInfoVC animated:YES];
    
    if (self.personTF.text.length != 0 && self.carNumTF.text.length != 0) {
        NSString * carNumStr = [self.carNumTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self checkCardNo:carNumStr]) {
            CarInfoViewController * carInfoVC = [[CarInfoViewController alloc] init];
            carInfoVC.carNum = carNumStr;
            carInfoVC.personName = self.personTF.text;
            [self.navigationController pushViewController:carInfoVC animated:YES];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的银行卡号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
    }else if (self.personTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入持卡人姓名" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.carNumTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入银行卡号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
     
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField text];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 24) {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}

- (BOOL) checkCardNo:(NSString*)cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
    {
        return YES;
    }
    else
        return NO;
}

/*
+ (BOOL) isValidCreditNumber:(NSString*)value {
    BOOL result = NO;
    NSInteger length = [value length];
    if (length >= 13) {
        result = [WTCreditCard isValidNumber:value];
        if (result)
        {
            NSInteger twoDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 2)] integerValue];
            //VISA
            if([WTCreditCard isStartWith:value Str:@"4"]) {
                if (13 == length||16 == length) {
                    result = TRUE;
                }else {
                    result = NO;
                }
            }
            //MasterCard
            else if(twoDigitBeginValue >= 51 && twoDigitBeginValue <= 55 && length == 16) {
                result = TRUE;
            }
            //American Express
            else if(([WTCreditCard isStartWith:value Str:@"34"]||[WTCreditCard isStartWith:value Str:@"37"]) && length == 15){
                result = TRUE;
            }
            //Discover
            else if([WTCreditCard isStartWith:value Str:@"6011"] && length == 16) {
                result = TRUE;
            }else {
                result = FALSE;
            }
        }
        if (result)
        {
            NSInteger digitValue;
            NSInteger checkSum = 0;
            NSInteger index = 0;
            NSInteger leftIndex;
            //even length, odd index
            if (0 == length%2) {
                index = 0;
                leftIndex = 1;
            }
            //odd length, even index
            else {
                index = 1;
                leftIndex = 0;
            }
            while (index < length) {
                digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
                digitValue = digitValue*2;
                if (digitValue >= 10)
                {
                    checkSum += digitValue/10 + digitValue%10;
                }
                else
                {
                    checkSum += digitValue;
                }
                digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
                checkSum += digitValue;
                index += 2;
                leftIndex += 2;
            }
            result = (0 == checkSum%10) ? TRUE:FALSE;
        }
    }else {
        result = NO;
    }
    return result;
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
