//
//  CLTopWindow.m
//  轻松一刻
//
//  Created by mac on 16/5/21.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1.新建一个类LXBTopWindow,我们要在里面控制window的创建,显示和隐藏,我们并不会用到系统自带的一个UIWindow的方法或者属性,因此继承自NSObject就够了,为了调用方便,过设计为类方法
 2.由于在iOS9中,所有的window都必须要有一个rootViewController,因此我们新建一个类LXBTopViewController让他作为window的rootViewController
 

 */
#import "CLTopWindow.h"
#import "CLTopWindowController.h"
@implementation CLTopWindow
static UIWindow *window_;

+ (void)initialize{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
    window_.rootViewController = [[CLTopWindowController alloc]init];
}

+ (void)show
{
    window_.hidden = NO;
}
/**
 * 监听窗口点击
 */
+ (void)windowClick
{   CLLogFunc;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}
+ (void)searchScrollViewInView:(UIView *)superview{
    for (UIScrollView *subview in superview.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]&& subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
           
        }
        // 继续查找子控件
        [self searchScrollViewInView:subview];

    }
}
+(void)hide{
    window_.hidden = YES;
}
@end
