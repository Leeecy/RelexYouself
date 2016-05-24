//
//  CLTabBar.m
//  轻松一刻
//
//  Created by chenl on 16/3/18.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLTabBar.h"
#import "CLPublishViewController.h"
@interface CLTabBar()
/** 发布按钮 */
@property (nonatomic, weak) UIButton *publishButton;
@end
@implementation CLTabBar
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
//        自定义＋ 号按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}
- (IBAction)publishClick:(id)sender
{
    CLPublishViewController *publish = [[CLPublishViewController alloc] init];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    // 标记按钮是否已经添加过监听器
    static BOOL added = NO;
    //    设置 ＋ 号按钮的frame
//    self.publishButton.bounds = CGRectMake(0, 0, self.publishButton.currentBackgroundImage.size.width, self.publishButton.currentBackgroundImage.size.height);
    self.publishButton.size = self.publishButton.currentBackgroundImage.size;
    self.publishButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
   
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = self.width / 5;
    CGFloat buttonH = self.height;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        if (added == NO) {
            // 监听按钮点击
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }

        
        // 增加索引
        index++;
    }
    
//    
    added = YES;
}
- (void)buttonClick
{
    // 发出一个通知
    [CLNoteCenter postNotificationName:CLTabBarDidSelectNotification object:nil userInfo:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
