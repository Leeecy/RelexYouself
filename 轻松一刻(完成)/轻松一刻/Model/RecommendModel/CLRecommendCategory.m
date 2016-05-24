//
//  CLRecommendCategory.m
//  轻松一刻
//
//  Created by chenl on 16/3/21.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLRecommendCategory.h"

@implementation CLRecommendCategory
- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
