//
//  CLMeViewController.m
//  轻松一刻
//
//  Created by chenl on 16/3/18.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 1. 下面的模块可以用一个自定义的view来表示
 
 */
#import "CLMeViewController.h"
#import "CLMeViewCell.h"
#import "CLMeFooterView.h"
@interface CLMeViewController ()

@end
static NSString *CLMeId = @"me";
@implementation CLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 初始化UI
-(void)configUI{
    self.navigationItem.title = @"我的";
    // 设置导航栏左边的按钮
//    UIButton *settingButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [settingButton setBackgroundImage:[UIImage imageNamed:@"mine-setting-icon"] forState:(UIControlStateNormal)];
//    [settingButton setBackgroundImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:(UIControlStateHighlighted)];
//    settingButton.size = settingButton.currentBackgroundImage.size;
//    [settingButton addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIButton *nightModeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [nightModeButton setBackgroundImage:[UIImage imageNamed:@"mine-moon-icon"] forState:(UIControlStateNormal)];
//    [nightModeButton setBackgroundImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:(UIControlStateHighlighted)];
//    nightModeButton.size = nightModeButton.currentBackgroundImage.size;
//    [nightModeButton addTarget:self action:@selector(nightModeClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:settingButton],[[UIBarButtonItem alloc]initWithCustomView:nightModeButton]];
   
   
}
- (void)setupTableView{
    // 设置背景色
    self.tableView.backgroundColor = CLGlobalBg;
    self.tableView.separatorColor  = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CLMeViewCell class] forCellReuseIdentifier:CLMeId];
    // 调整inset  group 默认 距离35
    self.tableView.contentInset = UIEdgeInsetsMake(CLTopicCellMargin - 35, 0, 0, 0);
    // 调整header和footer 自定义的cell默认会有一个header 和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = CLTopicCellMargin;
    
    self.tableView.tableFooterView = [[CLMeFooterView alloc]init];
}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
-(IBAction)settingClicked:(id)sender{
    CLLogFunc;
}

-(IBAction)moonClicked:(id)sender{

    CLLogFunc;
}
#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CLMeId];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}

#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁
@end
