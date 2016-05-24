//
//  CLRecommendUser.h
//  轻松一刻
//
//  Created by chenl on 16/3/23.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLRecommendUser : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *header;
/** 粉丝数(有多少人关注这个用户) */
@property (nonatomic, assign) NSInteger fans_count;
/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;
@end
