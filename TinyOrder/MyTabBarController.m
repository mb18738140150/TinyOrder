//
//  MyTabBarController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MyTabBarController.h"
#import "AccountViewController.h"
#import "MenuViewController.h"
#import "NewOrdersViewController.h"
#import "ProcessedViewController.h"
#import "AppDelegate.h"

@interface MyTabBarController ()

@property (nonatomic, strong)UITabBarItem * lastSeleteBarItem;


@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabBar.tintColor = [UIColor orangeColor];
    self.tabBar.translucent = NO;
    MenuViewController * menuVC = [[MenuViewController alloc] init];
    menuVC.title = @"菜品";
    UINavigationController * menuNav = [[UINavigationController alloc] initWithRootViewController:menuVC];
    menuNav.navigationBar.barTintColor = [UIColor orangeColor];
    NewOrdersViewController * newOrderVC = [[NewOrdersViewController alloc] init];
    newOrderVC.title = @"新订单";
    UINavigationController * newOrderNav = [[UINavigationController alloc] initWithRootViewController:newOrderVC];
    newOrderNav.navigationBar.barTintColor = [UIColor orangeColor];
    ProcessedViewController * processedVC = [[ProcessedViewController alloc] initWithStyle:UITableViewStylePlain];
    processedVC.title = @"已处理订单";
    UINavigationController * processedNav = [[UINavigationController alloc] initWithRootViewController:processedVC];
    processedNav.navigationBar.barTintColor = [UIColor orangeColor];

    AccountViewController * accountVC = [[AccountViewController alloc] init];
    accountVC.title = @"账户";
    UINavigationController * accountNav = [[UINavigationController alloc] initWithRootViewController:accountVC];

    accountNav.navigationBar.barTintColor = [UIColor orangeColor];
    self.viewControllers = @[newOrderNav, processedNav, menuNav, accountNav];
    for (int i = 0; i < self.viewControllers.count; i++) {
        UINavigationController * nav = [self.viewControllers objectAtIndex:i];
        nav.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_n_%d.png", i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_s_%d.png", i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];        
    }
    // Do any additional setup after loading the view.
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    UINavigationController * seleteNVC = (UINavigationController *)self.selectedViewController;
    UITableViewController * tableVC = (UITableViewController *)seleteNVC.topViewController;
    if (tableVC.tableView.isHeaderRefreshing) {
        if (![item isEqual:self.lastSeleteBarItem]) {
//            [tableVC.tableView headerEndRefreshing];
        }
        return;
    }
    if ([item isEqual:self.lastSeleteBarItem]) {
        [tableVC.tableView headerBeginRefreshing];
    }
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
