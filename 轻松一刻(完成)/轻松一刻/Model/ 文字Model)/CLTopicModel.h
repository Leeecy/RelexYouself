//
//  CLTopicModel.h
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLComment;
@interface CLTopicModel : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;

/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 小图片的URL */
@property (nonatomic, copy) NSString *small_image;
/** 中图片的URL */
@property (nonatomic, copy) NSString *middle_image;
/** 大图片的URL */
@property (nonatomic, copy) NSString *large_image;
/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 播放次数 */
@property (nonatomic, assign) NSInteger playcount;

//** 帖子的类型  根据type 判断顶部的滑动
@property (nonatomic, assign) CLTopicType type;

/** 是否为新浪加V用户 */
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;

/** 最热评论(期望这个数组中存放的是CLComment模型) 因为显示的最热评论只有一条数据 只需要拿出一条数据就可以*/
@property (nonatomic, strong) CLComment *top_cmt;
/** qzone_uid */
//@property (nonatomic, copy) NSString *qzone_uid;
/****** 额外的辅助属性 ******/

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** 图片控件的frame */
@property (nonatomic, assign, readonly) CGRect pictureF;
/** 图片是否太大 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
/** 图片的下载进度 */
@property (nonatomic, assign) CGFloat pictureProgress;

/** 声音控件的frame */
@property (nonatomic, assign, readonly) CGRect voiceF;
/** 视频控件的frame */
@property (nonatomic, assign, readonly) CGRect videoF;
@end
