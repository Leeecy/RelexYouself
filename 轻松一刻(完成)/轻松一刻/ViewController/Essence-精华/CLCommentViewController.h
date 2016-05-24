//
//  CLCommentViewController.h
//  轻松一刻
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLTopicModel;
@interface CLCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) CLTopicModel *topic;
@end
