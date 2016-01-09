//
//  MyTabBarController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MyTabBarController.h"
#import "AccountViewController.h"
#import "NewOrdersViewController.h"
#import "ProcessedViewController.h"
#import "AppDelegate.h"
#import "MenuClassifyViewController.h"
#import "MenuViewController.h"

@interface MyTabBarController ()

@property (nonatomic, strong)UITabBarItem * lastSeleteBarItem;

@property (nonatomic, strong)MenuViewController *menuVC;
@property (nonatomic, strong)NewOrdersViewController *nOrderVC;
@property (nonatomic, strong)ProcessedViewController *processedVC;
@property (nonatomic, strong)AccountViewController *accountVC;

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabBar.tintColor = [UIColor orangeColor];
    self.tabBar.translucent = NO;
    self.menuVC = [[MenuViewController alloc] init];
    _menuVC.title = @"商品";
    UINavigationController * menuNav = [[UINavigationController alloc] initWithRootViewController:_menuVC];
    menuNav.navigationBar.barTintColor = MAINCOLOR;
    self.nOrderVC = [[NewOrdersViewController alloc] init];
    _nOrderVC.title = @"新订单";
    UINavigationController * newOrderNav = [[UINavigationController alloc] initWithRootViewController:_nOrderVC];
    newOrderNav.navigationBar.barTintColor = MAINCOLOR;
    self.processedVC = [[ProcessedViewController alloc] init];
    _processedVC.title = @"已处理订单";
    UINavigationController * processedNav = [[UINavigationController alloc] initWithRootViewController:_processedVC];
    processedNav.navigationBar.barTintColor = MAINCOLOR;
    
    self.accountVC = [[AccountViewController alloc] init];
    _accountVC.title = @"商家中心";
    UINavigationController * accountNav = [[UINavigationController alloc] initWithRootViewController:_accountVC];
    
    accountNav.navigationBar.barTintColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0];
    //    accountNav.navigationBar.barTintColor =[UIColor orangeColor];
    self.viewControllers = @[newOrderNav, processedNav, menuNav, accountNav];
    for (int i = 0; i < self.viewControllers.count; i++) {
        UINavigationController * nav = [self.viewControllers objectAtIndex:i];
        nav.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_n_%d.png", i]] ;
        nav.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_s_%d.png", i]] ;
    }
    self.selectedViewController = [self.viewControllers firstObject];
    // Do any additional setup after loading the view.
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    UINavigationController * seleteNVC = (UINavigationController *)self.selectedViewController;
//    if (self.selectedIndex == 2) {
//        MenuViewController * tableVC = (MenuViewController *)seleteNVC.topViewController;
//        if (tableVC.tableView.isHeaderRefreshing) {
//            if (![item isEqual:self.lastSeleteBarItem]) {
//                //            [tableVC.tableView headerEndRefreshing];
//            }
//            return;
//        }
//        if ([item isEqual:self.lastSeleteBarItem]) {
//            [tableVC.tableView headerBeginRefreshing];
//        }
//    }else if (self.selectedIndex == 3)
//    {
//        
//    }
//    
//    else
//    {
//        UITableViewController * tableVC = (UITableViewController *)seleteNVC.topViewController;
//        if (tableVC.tableView.isHeaderRefreshing) {
//            if (![item isEqual:self.lastSeleteBarItem]) {
//                //            [tableVC.tableView headerEndRefreshing];
//            }
//            return;
//        }
//        if ([item isEqual:self.lastSeleteBarItem]) {
//            [tableVC.tableView headerBeginRefreshing];
//        }
//    }

    /*
    switch (self.selectedIndex) {
        
        case 0:
        {
            NewOrdersViewController * newOrdersVC = (NewOrdersViewController *)seleteNVC.topViewController;
            [newOrdersVC                                                                                                                                                                           .tableView headerBeginRefreshing];
        }
            break;
        case 1:
        {
            ProcessedViewController * processedVC = (ProcessedViewController *)seleteNVC.topViewController;
            [processedVC.tableView headerBeginRefreshing];
        }
            break;
        case 2:
        {
            MenuViewController * menuVC = (MenuViewController *)seleteNVC.topViewController;
            [menuVC.tableView headerBeginRefreshing];
        }
            break;
        case 3:
        {
            AccountViewController * accountVC = (AccountViewController *)seleteNVC.topViewController;
            [accountVC.tableView headerBeginRefreshing];
        }
            break;
            
        default:
            break;
    }
     */
    self.lastSeleteBarItem = item;
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
