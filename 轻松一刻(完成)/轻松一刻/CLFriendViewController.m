//
//  CLFriendViewController.m
//  轻松一刻
//
//  Created by chenl on 16/3/18.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLFriendViewController.h"
#import "CLRecommendViewController.h"
#import "CLLoginRegisterViewController.h"
@interface CLFriendViewController ()

@end

@implementation CLFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark 初始化UI

-(void)configUI{
    self.navigationItem.title = @"我的关注";
    // 设置导航栏左边的按钮 (封装为类)
//    UIButton *friendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [friendButton setBackgroundImage:[UIImage imageNamed:@"friendsRecommentIcon"] forState:(UIControlStateNormal)];
//    [friendButton setBackgroundImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] forState:(UIControlStateHighlighted)];
//    friendButton.size = friendButton.currentBackgroundImage.size;
//    [friendButton addTarget:self action:@selector(friendsClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick:)];
    self.view.backgroundColor = CLGlobalBg;
    
}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
-(IBAction)friendsClick:(id)sender{
    CLRecommendViewController *vc = [[CLRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)loginRegister {
    CLLoginRegisterViewController *login = [[CLLoginRegisterViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}
#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理

#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁

@end
