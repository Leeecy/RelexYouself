//
//  CLPushGuideView.m
//  轻松一刻
//
//  Created by chenl on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLPushGuideView.h"

@implementation CLPushGuideView

+ (instancetype)guideView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (void)show{
    NSString *key = @"CFBundleShortVersionString";
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CLPushGuideView *guideView = [CLPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        // 存储版本号
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

@end
