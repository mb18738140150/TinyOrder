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

@interface AddMenuViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HTTPPostDelegate>

@property (nonatomic, copy)ReturnValueBlock returnValueBlock;

@property (nonatomic, strong)AddMenuView * addMenuView;
@property (nonatomic, strong)NSString * submitImageName;

@end

@implementation AddMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addMenuView = [[AddMenuView alloc] initWithFrame:self.view.bounds];
    [_addMenuView.submitButton addTarget:self action:@selector(submitNewMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addMenuView.photoButton addTarget:self action:@selector(getPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    _addMenuView.nameTF.delegate = self;
    _addMenuView.paceTF.delegate = self;
    _addMenuView.numberTF.delegate = self;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [_addMenuView addGestureRecognizer:tapGesture];
    [self.view addSubview:_addMenuView];
    
    
    if (self.detailMD) {
        self.addMenuView.nameTF.text = self.detailMD.name;
        self.addMenuView.paceTF.text = [NSString stringWithFormat:@"%@", self.detailMD.money];
        self.addMenuView.numberTF.text = [NSString stringWithFormat:@"%@", self.detailMD.count];
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    // Do any additional setup after loading the view.
}

- (void)getPhotoAction:(UIButton *)button
{
    UIImagePickerController * imagePC = [[UIImagePickerController alloc] init];
    imagePC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePC.allowsEditing = YES;
    imagePC.delegate = self;
    [self presentViewController:imagePC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.addMenuView.photoView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapGestureAction{
    [self animateFrame];
    [self.addMenuView.nameTF resignFirstResponder];
    [self.addMenuView.paceTF resignFirstResponder];
    [self.addMenuView.numberTF resignFirstResponder];
}

- (void)animateFrame
{
    [UIView animateWithDuration:1 animations:^{
        _addMenuView.frame = self.view.bounds;
    }];
}


- (void)submitNewMenuAction:(UIButton *)button
{
    NSLog(@"%@", [self imageName]);
    NSString * urlString = @"http:d\\web\\image.vlifee.com\\imgupload\\business\\";
    [self uploadImageWithUrlString:urlString];
    /*
    if (self.addMenuView.nameTF.text.length != 0 && self.addMenuView.paceTF.text.length != 0 && self.addMenuView.numberTF.text.length != 0) {
//        [self.navigationController popViewControllerAnimated:YES];
//        self.returnValueBlock(self.addMenuView.nameTF.text);
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
    }else
    {
        UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"菜名,价格,份数都不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
     */
}

- (void)uploadImageWithUrlString:(NSString *)urlString
{
    NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL * url = [NSURL URLWithString:urlString];
    UIImage * image = self.addMenuView.photoView.image;
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    NSString * imageName = [self imageName];
    NSString * imagePath = [[self getLibarayCachePath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagePath atomically:YES];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagePath mimeType:@"image/jpg/file"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
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
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
}


- (void)returnMenuValue:(ReturnValueBlock)valueBlock
{
    _returnValueBlock = valueBlock;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _returnValueBlock();
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:1.0 animations:^{
        self.addMenuView.frame = CGRectMake(0, -160, self.view.frame.size.width, self.view.frame.size.height);
    }];
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
