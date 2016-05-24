//
//  CLTextField.m
//  轻松一刻
//
//  Created by chenl on 16/5/18.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 运行时(Runtime):
 * 苹果官方一套C语言库
 * 能做很多底层操作(比如访问隐藏的一些成员变量\成员方法....)
 */

#import "CLTextField.h"

#import <objc/runtime.h>
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation CLTextField
+ (void)initialize
{
    [self getIvars];
}

+ (void)getProperties
{
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出属性
        objc_property_t property = properties[i];
        
        // 打印属性名字
//        CLLog(@"%s   <---->   %s", property_getName(property), property_getAttributes(property));
    }
    
    free(properties);
}

+ (void)getIvars
{
    unsigned int count = 0;
    
    // 拷贝出所有的成员变量列表
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出成员变量
        //        Ivar ivar = *(ivars + i);
        Ivar ivar = ivars[i];
        
        // 打印成员变量名字
//        CLLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    
    // 释放
    free(ivars);
}

-(void)awakeFromNib{
    //    UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
    //    placeholderLabel.textColor = [UIColor redColor];
    
    //    // 修改占位文字颜色
    //    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者
    [self resignFirstResponder];

}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:XMGPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}
/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:XMGPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}


/**方法二 修改站位文字的属性
-(void)drawPlaceholderInRect:(CGRect)rect{
    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, 25)
                  withAttributes:@{
                                                      NSForegroundColorAttributeName : [UIColor grayColor],
                                                      NSFontAttributeName : self.font}];
}
*/
@end
