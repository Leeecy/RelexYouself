//
//  CLTabBarController.m
//  轻松一刻
//
//  Created by chenl on 16/3/18.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLTabBarController.h"
#import "CLFriendViewController.h"
#import "CLMeViewController.h"
#import "CLNewViewController.h"
#import "CLEssenceViewController.h"
#import "CLTabBar.h"
#import "CLNavigationController.h"
@interface CLTabBarController ()

@end

@implementation CLTabBarController
+(void)initialize{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedAttrs forState:(UIControlStateNormal)];

}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 添加子控制器
    [self setupChildVc:[CLEssenceViewController new] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupChildVc:[CLNewViewController new] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupChildVc:[[CLFriendViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self setupChildVc:[[CLMeViewController alloc] initWithStyle:(UITableViewStyleGrouped)] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    
    // 更换tabBar
    //    self.tabBar = [[XMGTabBar alloc] init];
    [self setValue:[[CLTabBar alloc] init] forKeyPath:@"tabBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 初始化UI
/**
 * 初始化子控制器
 */
-(void)setupChildVc:(UIViewController*)vc title:(NSString*)title image:(NSString*)image selectedImage:(NSString*)selectedImage{
    // 设置文字和图片
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器, 为了拦截所有导航控制器，这里自定义导航控制器
    CLNavigationController *nav = [[CLNavigationController alloc]initWithRootViewController:vc];
    // 添加为子控制器
    [self addChildViewController:nav];
}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件

#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理

#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁



@end












