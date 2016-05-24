//
//  CLNewViewController.m
//  轻松一刻
//
//  Created by chenl on 16/5/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLNewViewController.h"

@interface CLNewViewController ()

@end

@implementation CLNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    // 设置背景色
    self.view.backgroundColor = CLGlobalBg;
//    [self configUI];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)configUI{
//   
//}
- (void)tagClick
{
    CLLogFunc;
}

@end
