//
//  CLTopicViewController.h
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTopicViewController : UITableViewController
/** 帖子类型(交给子类去实现) */

@property (nonatomic, assign) CLTopicType type;
@end
