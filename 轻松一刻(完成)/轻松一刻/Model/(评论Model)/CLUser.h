//
//  CLUser.h
//  轻松一刻
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUser : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
@end
