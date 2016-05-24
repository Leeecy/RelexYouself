//
//  CLRecommendCategoryTableViewCell.h
//  轻松一刻
//
//  Created by chenl on 16/3/21.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLRecommendCategory;
@interface CLRecommendCategoryTableViewCell : UITableViewCell
/** 类别模型 */
@property (nonatomic, strong) CLRecommendCategory *category;
@end
