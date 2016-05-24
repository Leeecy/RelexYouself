//
//  CLCommentCell.h
//  轻松一刻
//
//  Created by mac on 16/5/21.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLComment;
@interface CLCommentCell : UITableViewCell
/** 评论 */
@property (nonatomic, strong) CLComment *comment;
@end
