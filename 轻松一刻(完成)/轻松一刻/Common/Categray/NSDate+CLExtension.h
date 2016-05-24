//
//  NSDate+CLExtension.h
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CLExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;
/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
