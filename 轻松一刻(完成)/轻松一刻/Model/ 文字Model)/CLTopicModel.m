//
//  CLTopicModel.m
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1.用户评论
 2 Model里面计算属性之后 cell直接可以拿去用
 3.将cell的高度计算好之后直接丢给控制器使用
 */
#import "CLTopicModel.h"
#import <MJExtension.h>
#import "CLComment.h"
#import "CLUser.h"
@implementation CLTopicModel
//解决readonly报错  自定义成员变量
{
    CGFloat _cellHeight;
}
//@"top_cmt":@"top_cmt[0]" 修改映射关系 
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt":@"top_cmt[0]"
             //取出数组里面字典下面的属性
             // @"qzone_uid" : @"top_cmt[0].user.qzone_uid"

             };
}
// 告诉服务器返回的事CLComment模型 
+ (NSDictionary *)objectClassInArray{
    //    return @{@"top_cmt" : [CLComment class]};
    return @{@"top_cmt" : @"CLComment"};
}
- (NSString *)create_time
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}
//动态计算cell的高度
- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 4 * CLTopicCellMargin, MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell的高度
        // 文字部分的高度  头固定  CLTopicCellTextY 顶部文字的距离
        _cellHeight = CLTopicCellTextY + textH + CLTopicCellMargin;
        // 根据段子的类型来计算cell的高度  根据type 来判断
        if (self.type== CLTopicTypePicture) {//只处理图片
            // 图片显示出来的宽度 ＝ 文字的宽度
            CGFloat pictureW = maxSize.width;
            // 显示显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            if (pictureH >= CLTopicCellPictureMaxH) {
                // 图片高度过长
                pictureH = CLTopicCellPictureBreakH;
                self.bigPicture = YES; // 大图
            }
            
            // 计算图片控件的frame
            CGFloat pictureX = CLTopicCellMargin;
//        CLTopicCellMargin  文字底部与图片的距离
            CGFloat pictureY = CLTopicCellTextY + textH +CLTopicCellMargin;
             _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
             _cellHeight += pictureH +CLTopicCellMargin;
        }else if (self.type == CLTopicTypeVoice) { // 声音帖子
            CGFloat voiceX = CLTopicCellMargin;
//            
            CGFloat voiceY = CLTopicCellTextY + textH + CLTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight += voiceH + CLTopicCellMargin;
        }else if (self.type == CLTopicTypeVideo) { // 视频帖子
            CGFloat videoX = CLTopicCellMargin;
            CGFloat videoY = CLTopicCellTextY + textH + CLTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + CLTopicCellMargin;
        }
        // 如果有最热评论 systemFontOfSize:13 这个高度要设置为和xib一样大小
//        CLComment *cmt = [self.top_cmt firstObject];
        if (self.top_cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
          _cellHeight += CLTopicCellTopCmtTitleH + contentH + CLTopicCellMargin;
        }
        
        // 底部工具条的高度
        _cellHeight += CLTopicCellBottomBarH + CLTopicCellMargin;
    }
    return _cellHeight;
}

@end
