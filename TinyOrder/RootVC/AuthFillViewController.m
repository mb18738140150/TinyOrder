//
//  AuthFillViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/24.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AuthFillViewController.h"
#import <AFNetworking.h>
#import "LoginViewController.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10


@interface AuthFillViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, HTTPPostDelegate>

/**
 *  真是姓名输入框
 */
@property (nonatomic, strong)UITextField * nameTF;
/**
 *  身份证号输入框
 */
@property (nonatomic, strong)UITextField * idcardNumTF;
/**
 *  身份证照片
 */
@property (nonatomic, strong)UIImage * cardImage;
/**
 *  选择身份证照片按钮
 */
@property (nonatomic, strong)UIButton * cardButton;


@end

@implementation AuthFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    UILabel * nameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 100, 30)];
    nameLB.text = @"用户名:";
    [self.view addSubview:nameLB];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameLB.left, nameLB.bottom, self.view.width - nameLB.left * 2, 40)];
    _nameTF.borderStyle = UITextBorderStyleRoundedRect;
    _nameTF.placeholder = @"请输入真实姓名";
//    _nameTF.keyboardType = UIKeyboardTypeASCIICapable;
//    _nameTF.delegate = self;
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_nameTF];
    
    
    UILabel * NumLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _nameTF.bottom, 100, 30)];
    NumLB.text = @"身份证号:";
    [self.view addSubview:NumLB];
    
    self.idcardNumTF = [[UITextField alloc] initWithFrame:CGRectMake(NumLB.left, NumLB.bottom, self.view.width - NumLB.left * 2, 40)];
    _idcardNumTF.borderStyle = UITextBorderStyleRoundedRect;
    _idcardNumTF.placeholder = @"请输入身份证号";
    _idcardNumTF.keyboardType = UIKeyboardTypeASCIICapable;
    _idcardNumTF.delegate = self;
    _idcardNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_idcardNumTF];
    
    UILabel * cardLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _idcardNumTF.bottom, 100, 30)];
    cardLB.text = @"证件照:";
    [self.view addSubview:cardLB];
    
    self.cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cardButton.frame = CGRectMake(cardLB.left, cardLB.bottom, self.view.width - cardLB.left * 2, 150);
//    _cardButton.layer.cornerRadius = 5;
    [_cardButton setBackgroundImage:[UIImage imageNamed:@"cardUp.png"] forState:UIControlStateNormal];
    [_cardButton addTarget:self action:@selector(changeIDCardImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cardButton];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(cardLB.left, _cardButton.bottom + TOP_SPACE, self.view.width - cardLB.left * 2, 30);
    button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    button.layer.cornerRadius = 3;
    [button addTarget:self action:@selector(confirmAuth:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    
    // Do any additional setup after loading the view.
}


- (void)backLastVC:(id)sender
{
    LoginViewController * loginVC = (LoginViewController *)[self.navigationController.viewControllers firstObject];
    [loginVC pushTabBarVC];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)changeIDCardImage:(UIButton *)button
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中获取", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)confirmAuth:(UIButton *)button
{
    if (self.nameTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入真实姓名" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.idcardNumTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入身份证号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.cardImage == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请上传身份证照片" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else
    {
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
        [self uploadImageWithUrlString:@"http://p3o1r7t.vlifee.com/uploadimg.aspx?savetype=1" image:self.cardImage];
    }
}



#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * imagePC = [[UIImagePickerController alloc] init];
                imagePC.delegate = self;
                imagePC.allowsEditing = YES;
                imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePC animated:YES completion:nil];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相机,请你选择图库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController * imagePC = [[UIImagePickerController alloc] init];
            imagePC.delegate = self;
            imagePC.allowsEditing = YES;
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePC animated:YES completion:nil];
            //            NSLog(@"相册");
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.cardImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.cardButton setBackgroundImage:self.cardImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TxetField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * text = textField.text;
    if (text.length >= 18) {
        return NO;
    }
    if ([textField isEqual:self.idcardNumTF]) {
        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_\b"] invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        BOOL a = [string isEqualToString:filtered];
        return a;
    }
    return YES;
}




#pragma mark - 数据请求 图片上传

- (void)uploadImageWithUrlString:(NSString *)urlString image:(UIImage *)image
{
    NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString * imageName = [self imageName];
    NSString * imagePath = [[self getLibarayCachePath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagePath atomically:YES];
    __weak AuthFillViewController * authFillVC = self;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagePath mimeType:@"image/jpg/file"];
        //        [formData appendPartWithFormData:imageData name:imageName];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"Result"] integerValue] == 1) {
            NSDictionary * jsonDic = @{
                                       @"Command":@43,
                                       @"UserId":authFillVC.userId,
                                       @"AuthName":authFillVC.nameTF.text,
                                       @"AuthIdCardNum":authFillVC.idcardNumTF.text,
                                       @"AuthIdCard":[responseObject objectForKey:@"ImgPath"]
                                       };
            [authFillVC playPostWithDictionary:jsonDic];
        }else
        {
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片添加失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"%@", error);
    }];
    
}


- (NSString *)imageName
{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * strTime = [myFormatter stringFromDate:[NSDate date]];
    NSString * name = [NSString stringWithFormat:@"tcard%@%@%lld%@.png", [UserInfo shareUserInfo].userId, strTime, arc4random() % 9000000000 + 1000000000, [UserInfo shareUserInfo].userName];
    //    NSLog(@"%lld", arc4random() % 9000000000 + 1000000000);
    return name;
}

- (NSString *)getLibarayCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", [paths firstObject]);
    return [paths firstObject];
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
        if ([command isEqualToNumber:@10043]) {
            LoginViewController * loginVC = (LoginViewController *)[self.navigationController.viewControllers firstObject];
            [loginVC pushTabBarVC];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
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
