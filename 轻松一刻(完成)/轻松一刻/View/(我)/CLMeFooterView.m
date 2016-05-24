//
//  CLMeFooterView.m
//  轻松一刻
//
//  Created by chenl on 16/5/22.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**1.这里的方块由于是正方形 所以不能调用之前的垂直button那个类 自定义一个圆形的button类
 2.计算方块总行数的方法  总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    NSUInteger rows = (square.count + maxCols -1)/ maxCols;
 
 */
#import "CLMeFooterView.h"
#import <AFNetworking.h>
#import "CLSquareModel.h"
#import <MJExtension.h>
#import "CLSquareButton.h"
#import "CLWebViewController.h"
@implementation CLMeFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *square = [CLSquareModel mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 创建方块
            [self createSquares:square];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
     return self;
}
-(void)createSquares:(NSArray*)square{
    // 一行最多4列
    int maxCols = 4;
    
    // 宽度和高度
    CGFloat buttonW = SCREEN_WIDTH / maxCols;
    CGFloat buttonH = buttonW;
    for (int i = 0; i < square.count; i++) {
        CLSquareButton *button = [CLSquareButton buttonWithType:(UIButtonTypeCustom)];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        传递模型  给每一个点击的button传一个模型
        button.square = square[i];
        [self addSubview:button];
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
        
    }
    // 总行数
    //    NSUInteger rows = sqaures.count / maxCols;
    //    if (sqaures.count % maxCols) { // 不能整除, + 1
    //        rows++;
    //    }

    
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    NSUInteger rows = (square.count + maxCols -1)/ maxCols;
    self.height = rows * buttonH;
    //    重绘 setNeedsDisplay会调用自动调用drawRect方法
    [self setNeedsDisplay];
    
}
- (void)buttonClick:(CLSquareButton *)button{
    CLLogFunc;
    if (![button.square.url hasPrefix:@"http"]) return;
    
    CLWebViewController *web = [[CLWebViewController alloc] init];
    web.url = button.square.url;
    web.title = button.square.name;
     // 取出当前的导航控制器
    UITabBarController *tabVC = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController*)tabVC.selectedViewController;
    [nav pushViewController:web animated:YES];
}
@end











