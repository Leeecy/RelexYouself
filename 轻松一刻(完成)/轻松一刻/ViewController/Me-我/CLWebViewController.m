//
//  CLWebViewController.m
//  轻松一刻
//
//  Created by chenl on 16/5/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLWebViewController.h"
#import <NJKWebViewProgress.h>
@interface CLWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
/** 进度代理对象 */
@property (nonatomic, strong) NJKWebViewProgress *progress;
@end

@implementation CLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progress = [[NJKWebViewProgress alloc]init];
//    设置代理 为进度
    self.webView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
//        加载完成之后隐藏
        weakSelf.progressView.hidden = (progress == 1.0);
        
    };
//    再将控制器设置为进度的代理
    self.progress.webViewProxyDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.goBackItem.enabled = webView.canGoBack;
//    self.goForwardItem.enabled = webView.canGoForward;
}

@end
