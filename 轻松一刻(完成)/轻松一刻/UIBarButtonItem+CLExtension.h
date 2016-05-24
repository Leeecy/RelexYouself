//
//  UIBarButtonItem+CLExtension.h
//  轻松一刻
//
//  Created by chenl on 16/3/19.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CLExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
