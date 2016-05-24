//
//  CLRecommendTag.h
//  轻松一刻
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLRecommendTag : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
@end
