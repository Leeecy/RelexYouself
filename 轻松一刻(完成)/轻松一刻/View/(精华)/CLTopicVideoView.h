//
//  CLTopicVideoView.h
//  轻松一刻
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLTopicModel;
@interface CLTopicVideoView : UITableViewCell
+(instancetype)videoView;

/** 帖子数据 */
@property (nonatomic, strong) CLTopicModel *topic;

@end
