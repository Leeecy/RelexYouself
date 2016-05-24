//
//  CLRecommendCategory.h
//  轻松一刻
//
//  Created by chenl on 16/3/21.
//  Copyright © 2016年 chenl. All rights reserved.
//  推荐关注 左边的数据模型

#import <Foundation/Foundation.h>

@interface CLRecommendCategory : NSObject
/** id */
@property (nonatomic, assign) NSInteger id;
/** 总数 */
@property (nonatomic, assign) NSInteger count;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *users;
/** 总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;
@end
