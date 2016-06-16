//
//  PersonInformationViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/9.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "PersonInformationViewController.h"
#import "TextCheckViewController.h"
#import "AFNetworking.h"

#define ICON_WITH 80
#define SPACE  15
//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]
#define BUTTON_WIDTH 60

@interface PersonInformationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIImagePickerController * imagePic;


@end

@implementation PersonInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"个人信息";
    
    self.imagePic = [[UIImagePickerController alloc]init];
    self.imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = self.view.frame;
    bigView.backgroundColor = [UIColor colorWithWhite:.9 alpha:.7];
    [self.view addSubview:bigView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *iconLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, SPACE, 100, ICON_WITH)];
    iconLB.text = @"头像";
    iconLB.backgroundColor = [UIColor clearColor];
    [view addSubview:iconLB];
    
    self.iconview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - SPACE - ICON_WITH, iconLB.top, ICON_WITH, ICON_WITH)];
    _iconview.image = self.iconImage;
    _iconview.userInteractionEnabled = YES;
    [view addSubview:_iconview];
    
//    UITapGestureRecognizer * changeIconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIconTapAction:)];
//    [_iconview addGestureRecognizer:changeIconTap];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(SPACE, iconLB.bottom + SPACE, self.view.width - 2 * SPACE, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:.7];
    [view addSubview:line1];
    
    UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, line1.bottom + SPACE, 100, 30)];
    nameLB.text = @"姓名";
    nameLB.backgroundColor = [UIColor clearColor];
    [view addSubview:nameLB];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - SPACE - 150, nameLB.top, 150, nameLB.height)];
    name.textColor = [UIColor grayColor];
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentRight;
    name.text = [UserInfo shareUserInfo].userName;
    [view addSubview:name];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SPACE, nameLB.bottom + SPACE, self.view.width - 2 * SPACE, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:.7];
    [view addSubview:line2];
    
    UILabel * phoneLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, line2.bottom + SPACE, 100, 30)];
    phoneLB.text = @"电话";
    phoneLB.backgroundColor = [UIColor clearColor];
    [view addSubview:phoneLB];
    
    UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(name.right - 150, phoneLB.top, 150, phoneLB.height)];
    phone.textColor = [UIColor grayColor];
    phone.backgroundColor = [UIColor clearColor];
    phone.text = [UserInfo shareUserInfo].phoneNumber;
    phone.textAlignment = NSTextAlignmentRight;
    phone.tag = 3000;
    [view addSubview:phone];
    
    UIButton * changephoneNumberBT = [UIButton buttonWithType:UIButtonTypeCustom];
    changephoneNumberBT.frame = phone.frame;
    changephoneNumberBT.backgroundColor = [UIColor clearColor];
    [changephoneNumberBT addTarget:self action:@selector(changephoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:changephoneNumberBT];
    
    view.height = phoneLB.bottom + SPACE;
    [bigView addSubview:view];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view.bottom + 20, self.view.width, 121)];
    view2.backgroundColor = [UIColor whiteColor];
    
    UILabel *changePasswordLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, SPACE, 100, 30)];
    changePasswordLB.text = @"修改密码";
    changePasswordLB.backgroundColor = [UIColor clearColor];
    [view2 addSubview:changePasswordLB];
    
    UIButton *changePasswordBT = [UIButton buttonWithType:UIButtonTypeSystem];
    changePasswordBT.frame = CGRectMake(self.view.width - SPACE - 30, changePasswordLB.top, 30, 30);
    [changePasswordBT setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [changePasswordBT addTarget:self action:@selector(changePasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    changePasswordBT.backgroundColor = [UIColor whiteColor];
//    changePasswordBT.selected = YES;
    [view2 addSubview:changePasswordBT];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SPACE, changePasswordLB.bottom + SPACE, self.view.width - 2 * SPACE, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:.9 alpha:.7];
    [view2 addSubview:line3];
    
    UILabel *exitLogin = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, line3.bottom + SPACE, line3.width, 30)];
    exitLogin.text = @"退出登录";
    exitLogin.backgroundColor = [UIColor clearColor];
    [view2 addSubview:exitLogin];
    
    UIButton *exitBT = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBT.frame = CGRectMake(SPACE, line3.bottom + SPACE, line3.width, 30);
    exitBT.backgroundColor = [UIColor clearColor];
    [exitBT addTarget:self action:@selector(exitLogin:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:exitBT];
    
    [bigView addSubview:view2];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    UILabel * phone = (UILabel *)[self.view viewWithTag:3000];
    phone.text = [UserInfo shareUserInfo].phoneNumber;
}
#pragma mark - 修改头像
- (void)changeIconTapAction:(UITapGestureRecognizer *)tap
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePic animated:YES completion:nil];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有相机，请选择图库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
        }
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:cameraAction];
    [alertController addAction:libraryAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.iconview.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    NSString * urlString = @"http://p3o1r7t.vlifee.com/uploadimg.aspx?savetype=4";
    [self uploadImageWithUrlString:urlString];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 上传图片
- (void)uploadImageWithUrlString:(NSString * )urlString
{
    NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage * image = self.iconview.image;
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString * imageName = [self imageName];
    NSString * imagPath = [[self getLibraryCachePath]stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagPath atomically:YES];
    __weak PersonInformationViewController * personVC = self;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagPath mimeType:@"image/jpg/file"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"Result"]integerValue] == 1) {
            NSLog(@"图片上传成功");
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
    NSDateFormatter * myFomatter = [[NSDateFormatter alloc]init];
    [myFomatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * strTime = [myFomatter stringFromDate:[NSDate date]];
    NSString * name = [NSString stringWithFormat:@"t%@%@%lld%@.png", [UserInfo shareUserInfo].userId, strTime, arc4random() % 9000000000 + 1000000000, [UserInfo shareUserInfo].userName];
    return name;
}

- (NSString *)getLibraryCachePath
{
    NSArray * array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [array firstObject];
}

#pragma mark - 修改电话
- (void)changephoneAction:(UIButton *)button
{
    TextCheckViewController *textCheckVC = [[TextCheckViewController alloc]init];
    textCheckVC.phoneNumber = self.phoneNumber;
    textCheckVC.ischangeohonenumber = 1;
    [self.navigationController pushViewController:textCheckVC animated:YES];
}
- (void)changePasswordAction:(UIButton *)sender
{
    NSLog(@"修改密码");
    TextCheckViewController *textCheckVC = [[TextCheckViewController alloc]init];
    textCheckVC.phoneNumber = self.phoneNumber;
    textCheckVC.ischangeohonenumber = 0;
    [self.navigationController pushViewController:textCheckVC animated:YES];
}

- (void)exitLogin:(UIButton *)sender
{
    NSLog(@"*****退出***");
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //    LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //    loginNav.navigationBar.translucent = NO;
    
    [self.navigationController.tabBarController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
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
