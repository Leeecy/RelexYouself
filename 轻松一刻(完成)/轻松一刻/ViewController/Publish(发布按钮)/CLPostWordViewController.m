//
//  CLPostWordViewController.m
//  轻松一刻
//
//  Created by chenl on 16/5/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLPostWordViewController.h"

@interface CLPostWordViewController ()

@end

@implementation CLPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNav
{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 默认不能点击
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

#pragma mark -
#pragma mark 初始化UI

#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{
    CLLogFunc;
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
