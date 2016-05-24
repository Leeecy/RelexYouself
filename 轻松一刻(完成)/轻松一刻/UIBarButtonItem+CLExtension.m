//
//  UIBarButtonItem+CLExtension.m
//  轻松一刻
//
//  Created by chenl on 16/3/19.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "UIBarButtonItem+CLExtension.h"

@implementation UIBarButtonItem (CLExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc]initWithCustomView:button];
}
@end
