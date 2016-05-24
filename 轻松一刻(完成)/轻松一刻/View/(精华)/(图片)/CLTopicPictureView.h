//
//  CLTopicPictureView.h
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//
//  图片帖子中间的内容
#import <UIKit/UIKit.h>
@class CLTopicModel;
@interface CLTopicPictureView : UIView
+ (instancetype)pictureView;
/** 帖子数据 */
@property (nonatomic, strong) CLTopicModel *topic;
@end
