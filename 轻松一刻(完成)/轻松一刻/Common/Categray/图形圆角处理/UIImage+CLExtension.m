//
//  UIImage+CLExtension.m
//  轻松一刻
//
//  Created by mac on 16/5/21.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  图形上下文默认黑色  需要设置透明
 *
 *
 */
#import "UIImage+CLExtension.h"

@implementation UIImage (CLExtension)
-(UIImage *)circleImage{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);//画一椭圆
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;

    
}
@end
