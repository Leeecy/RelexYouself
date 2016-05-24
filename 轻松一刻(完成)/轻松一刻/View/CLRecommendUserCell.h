//
//  CLRecommendUserCell.h
//  轻松一刻
//
//  Created by chenl on 16/3/23.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLRecommendUser;
@interface CLRecommendUserCell : UITableViewCell
/** 用户模型 */
@property (nonatomic, strong) CLRecommendUser *user;
@end
