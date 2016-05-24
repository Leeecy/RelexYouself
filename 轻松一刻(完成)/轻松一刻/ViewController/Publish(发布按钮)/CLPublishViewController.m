//
//  CLPublishViewController.m
//  轻松一刻
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLPublishViewController.h"
#import "CLVerticalButton.h"
#import <POP.h>
#import "CLPostWordViewController.h"
#import "CLAddTagViewController.h"
#import "CLNavigationController.h"
@interface CLPublishViewController ()

@end

static CGFloat const CLAnimationDelay = 0.1;
static CGFloat const CLSpringFactor = 10;
@implementation CLPublishViewController

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
    // 让控制器的view不能被点击   pop完成之后才能点击
    self.view.userInteractionEnabled = NO;
   
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    // 中间的6个按钮
    int maxCols = 3;

    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (SCREEN_HEIGHT- 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
//    按钮之间的间距
     CGFloat xMargin = (SCREEN_WIDTH - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i<images.count; i++) {
        CLVerticalButton *button = [[CLVerticalButton alloc]init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 设置frame  这两句不能写
//        button.width = buttonW;
//        button.height = buttonH;
//        行
        int row = i / maxCols;
//        
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
//        buttonBeginY为负数
         CGFloat buttonBeginY = buttonEndY - SCREEN_HEIGHT;
        
        // 按钮动画 改变frame  不用按钮设置宽高 pop自动修改
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//        开始的动画值
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
//        到达的动画值
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = CLSpringFactor;
        anim.springSpeed = CLSpringFactor;

//        0.1 *i s 之后执行下一个动画
          anim.beginTime = CACurrentMediaTime() + CLAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = SCREEN_WIDTH * 0.5;
    CGFloat centerEndY = SCREEN_HEIGHT * 0.2;
    CGFloat centerBeginY = centerEndY - SCREEN_HEIGHT;
//    sloganView.y = SCREEN_WIDTH * 0.2;
//    sloganView.centerX =SCREEN_WIDTH * 0.5;
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * CLAnimationDelay;
    anim.springBounciness = CLSpringFactor;
    anim.springSpeed = CLSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];

    [self.view addSubview:sloganView];
}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
- (IBAction)cancel {
//    [self dismissViewControllerAnimated:NO completion:nil];
//    仅仅只是调用取消  nil表示不传参数给block
    [self cancelWithCompletionBlock:nil];
}
- (void)buttonClick:(UIButton *)button{
    [self cancelWithCompletionBlock:^{
//        传值给block 调用
        if (button.tag == 0) {
            CLLog(@"发视频");
        } else if (button.tag == 1) {
            CLLog(@"发图片");
        }
    }];
}
#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
/**
 (void (^)())
 *  void block 没有返回值
    (^)block类型
 () 表示不传参
 *
 *  @param completionBlock
 */
-(void)cancelWithCompletionBlock:(void (^)())completionBlock{
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;
    
    int beginIndex = 2;
    
    for (int i = beginIndex; i<self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        
        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + SCREEN_HEIGHT;
        // 动画的执行节奏(一开始很慢, 后面很快)
        //        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * CLAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                // 执行传进来的completionBlock参数
                //                if (completionBlock) {
                //                    completionBlock();
                //                }
//            completionBlock不存在 不调用 存在 调用
                !completionBlock ? : completionBlock();
            }];
        }
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
}
#pragma mark -
#pragma mark 业务逻辑
/**
 pop和Core Animation的区别
 1.Core Animation的动画只能添加到layer上
 2.pop的动画能添加到任何对象
 3.pop的底层并非基于Core Animation, 是基于CADisplayLink
 4.Core Animation的动画仅仅是表象, 并不会真正修改对象的frame\size等值
 5.pop的动画实时修改对象的属性, 真正地修改了对象的属性
 */
#pragma mark -
#pragma mark 通知注册和销毁
@end

