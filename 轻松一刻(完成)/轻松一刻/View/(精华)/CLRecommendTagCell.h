//
//  CLRecommendTagCell.h
//  轻松一刻
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
//模型数据
@class CLRecommendTag;
@interface CLRecommendTagCell : UITableViewCell
/** 模型数据 */
@property (nonatomic, strong) CLRecommendTag *recommendTag;
@end
