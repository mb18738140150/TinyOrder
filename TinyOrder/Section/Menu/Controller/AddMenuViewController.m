//
//  AddMenuViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddMenuViewController.h"
#import "AddMenuView.h"
#import "DetailModel.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>

@interface AddMenuViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HTTPPostDelegate, UIActionSheetDelegate>
{
    BOOL _isSeleteImage;
}
@property (nonatomic, copy)ReturnValueBlock returnValueBlock;

@property (nonatomic, strong)AddMenuView * addMenuView;
@property (nonatomic, strong)NSString * submitImageName;
@property (nonatomic, strong)UIImagePickerController * imagePC;

@end

@implementation AddMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addMenuView = [[AddMenuView alloc] initWithFrame:self.view.bounds];
    [_addMenuView.submitButton addTarget:self action:@selector(submitNewMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addMenuView.photoButton addTarget:self action:@selector(getPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    _addMenuView.nameTF.delegate = self;
    _addMenuView.paceTF.delegate = self;
//    _addMenuView.numberTF.delegate = self;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [_addMenuView addGestureRecognizer:tapGesture];
    [self.view addSubview:_addMenuView];
    
    _isSeleteImage = NO;
    if (self.detailMD) {
        self.addMenuView.nameTF.text = self.detailMD.name;
        self.addMenuView.paceTF.text = [NSString stringWithFormat:@"%@", self.detailMD.money];
        [self.addMenuView.photoView sd_setImageWithURL:[NSURL URLWithString:self.detailMD.icon] placeholderImage:[UIImage imageNamed:@"PHOTO.png"]];
//        self.addMenuView.numberTF.text = [NSString stringWithFormat:@"%@", self.detailMD.count];
    }
    self.imagePC = [[UIImagePickerController alloc] init];
    _imagePC.allowsEditing = YES;
    _imagePC.delegate = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    // Do any additional setup after loading the view.
}

- (void)getPhotoAction:(UIButton *)button
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中获取", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    /*
    UIImagePickerController * imagePC = [[UIImagePickerController alloc] init];
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeCamera;
    imagePC.allowsEditing = YES;
    imagePC.delegate = self;
    [self presentViewController:imagePC animated:YES completion:nil];
     */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePC animated:YES completion:nil];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相机,请你选择图库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
        case 1:
        {
            self.imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePC animated:YES completion:nil];
//            NSLog(@"相册");
        }
            break;
            
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    self.addMenuView.photoView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _isSeleteImage = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapGestureAction{
    [self animateFrame];
    [self.addMenuView.nameTF resignFirstResponder];
    [self.addMenuView.paceTF resignFirstResponder];
//    [self.addMenuView.numberTF resignFirstResponder];
}

- (void)animateFrame
{
//    [UIView animateWithDuration:1 animations:^{
//        _addMenuView.frame = self.view.bounds;
//    }];
}


- (void)submitNewMenuAction:(UIButton *)button
{
    if (self.addMenuView.nameTF.text.length != 0 && self.addMenuView.paceTF.text.length != 0) {
        if (self.detailMD != nil && _isSeleteImage == NO) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@12,
                                       @"Name":self.addMenuView.nameTF.text,
                                       @"Money":[NSNumber numberWithDouble:[self.addMenuView.paceTF.text doubleValue]],
                                       @"MealId":self.detailMD.mealId,
                                       @"Icon":self.detailMD.icon
                                       };
            [self playPostWithDictionary:jsonDic];
        }else
        {
            NSString * urlString = @"http://p.vlifee.com/uploadimg.aspx?savetype=1";
            [self uploadImageWithUrlString:urlString];
        }
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
//        [self.navigationController popViewControllerAnimated:YES];
//        self.returnValueBlock(self.addMenuView.nameTF.text);
        /*
        if (self.detailMD) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Name":self.addMenuView.nameTF.text,
                                       @"Count":[NSNumber numberWithInt:[self.addMenuView.numberTF.text intValue]],
                                       @"Money":[NSNumber numberWithDouble:[self.addMenuView.paceTF.text doubleValue]],
                                       @"MealId":self.detailMD.mealId
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (self.classifyId)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Name":self.addMenuView.nameTF.text,
                                       @"Count":[NSNumber numberWithInt:[self.addMenuView.numberTF.text intValue]],
                                       @"Money":[NSNumber numberWithDouble:[self.addMenuView.paceTF.text doubleValue]],
                                       @"ClassifyId":self.classifyId
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        */
    }else
    {
        UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"菜名,价格,图片都不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
}

- (void)uploadImageWithUrlString:(NSString *)urlString
{
    
    NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL * url = [NSURL URLWithString:urlString];
    UIImage * image = self.addMenuView.photoView.image;
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString * imageName = [self imageName];
    NSString * imagePath = [[self getLibarayCachePath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagePath atomically:YES];
//    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
//    [httpPost post:url HTTPBody:[@"3444" dataUsingEncoding:NSUTF8StringEncoding]];
//    httpPost.delegate = self;
    __weak AddMenuViewController * addMenuVC = self;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagePath mimeType:@"image/jpg/file"];
//        [formData appendPartWithFormData:imageData name:imageName];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"Result"] integerValue] == 1) {
            NSDictionary * jsonDic = nil;
            if (addMenuVC.classifyId) {
                jsonDic = @{
                            @"UserId":[UserInfo shareUserInfo].userId,
                            @"Command":@11,
                            @"Name":addMenuVC.addMenuView.nameTF.text,
                            @"Money":[NSNumber numberWithDouble:[addMenuVC.addMenuView.paceTF.text doubleValue]],
                            @"ClassifyId":addMenuVC.classifyId,
                            @"Icon":[responseObject objectForKey:@"ImgPath"]
                            };
            }else if (addMenuVC.detailMD)
            {
                jsonDic = @{
                            @"UserId":[UserInfo shareUserInfo].userId,
                            @"Command":@12,
                            @"Name":addMenuVC.addMenuView.nameTF.text,
                            @"Money":[NSNumber numberWithDouble:[addMenuVC.addMenuView.paceTF.text doubleValue]],
                            @"MealId":addMenuVC.detailMD.mealId,
                            @"Icon":[responseObject objectForKey:@"ImgPath"]
                            };
            }
            [addMenuVC playPostWithDictionary:jsonDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    NSString * name = [NSString stringWithFormat:@"t%@%@%lld%@.png", [UserInfo shareUserInfo].userId, strTime, arc4random() % 9000000000 + 1000000000, [UserInfo shareUserInfo].userName];
//    NSLog(@"%lld", arc4random() % 9000000000 + 1000000000);
    return name;
}

- (NSString *)getLibarayCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", [paths firstObject]);
    return [paths firstObject];
}



- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    //    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}



- (void)refresh:(id)data
{
    NSLog(@"data==%@", data);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    [SVProgressHUD dismiss];
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"error = %@", error);
}


- (void)returnMenuValue:(ReturnValueBlock)valueBlock
{
    _returnValueBlock = valueBlock;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _returnValueBlock();
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:1.0 animations:^{
//        self.addMenuView.frame = CGRectMake(0, -160, self.view.frame.size.width, self.view.frame.size.height);
//    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animateFrame];
    [textField resignFirstResponder];
    return YES;
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
