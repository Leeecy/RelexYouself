//
//  CLLoginRegisterViewController.m
//  轻松一刻
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  电量条的问题处理 View controller-based status bar appearance在info。plist设置为YES 则View controller对status bar的设置优先级高于application的设置。为NO则以application的设置为准，view controller的prefersStatusBarHidden方法无效，是根本不会被调用的。
 *
 *
 */
#import "CLLoginRegisterViewController.h"

@interface CLLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
/** 登录框距离控制器view左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@end

@implementation CLLoginRegisterViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
    
}
#pragma mark -
#pragma mark 初始化UI
-(void)configUI{
    
    
    /** 方法1  修改文本框文字的颜色
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];

    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // NSAttributedString : 带有属性的文字(富文本技术)
    
    NSAttributedString *placeholder = [[NSAttributedString alloc]initWithString:@"手机号" attributes:attrs];
    self.phoneField.attributedPlaceholder = placeholder;
     ***/
    
//    指定范围内的文字颜色
    //    NSMutableAttributedString *placehoder = [[NSMutableAttributedString alloc] initWithString:@"手机号"];
    //    [placehoder setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, 1)];
    //    [placehoder setAttributes:@{
    //                                NSForegroundColorAttributeName : [UIColor yellowColor],
    //                                NSFontAttributeName : [UIFont systemFontOfSize:30]
    //                                } range:NSMakeRange(1, 1)];
    //    [placehoder setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(2, 1)];
    //    self.phoneField.attributedPlaceholder = placehoder;

}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
//注册账号
- (IBAction)showLoginOrRegister:(UIButton *)button {
    // 退出键盘
    [self.view endEditing:YES];
    if (self.loginViewLeftMargin.constant == 0) {// 显示注册界面
        self.loginViewLeftMargin.constant = - self.view.width;
         button.selected = YES;
    }else { // 显示登录界面
        self.loginViewLeftMargin.constant = 0;
        button.selected = NO;
        //        [button setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];


    

}
- (IBAction)back {
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
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
