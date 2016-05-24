//
//  CLTopicCell.m
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 * 1. 根据模型类型(帖子类型)添加对应的内容到cell的中间 这里的代码设置隐藏 显示 是为了解决cell 重复显示
 *
 *
 *
 *
 */
#import "CLTopicCell.h"
#import "CLTopicModel.h"
#import <UIImageView+WebCache.h>
#import "NSDate+CLExtension.h"
#import "CLTopicPictureView.h"
#import "CLTopicVoiceView.h"
#import "CLTopicVideoView.h"
#import "CLComment.h"
#import "CLUser.h"
@interface CLTopicCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
/** 帖子的文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/** 图片帖子中间的内容 */
@property (nonatomic, weak) CLTopicPictureView *pictureView;
/** 声音帖子中间的内容 */
@property (nonatomic, weak) CLTopicVoiceView *voiceView;
/** 视频帖子中间的内容 */
@property (nonatomic, weak) CLTopicVideoView *videoView;

/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@end
@implementation CLTopicCell
// 把这个cell传给评论视图的headView
+(instancetype)cell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}
-(CLTopicPictureView *)pictureView{
    if (!_pictureView) {
        CLTopicPictureView *pictureView = [CLTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
-(CLTopicVoiceView *)voiceView{
    if (!_voiceView) {
        CLTopicVoiceView *voiceView = [CLTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
-(CLTopicVideoView *)videoView{
    if (!_videoView) {
        CLTopicVideoView *videoView = [CLTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
- (void)awakeFromNib {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 今年
    今天
        1分钟内
            刚刚
        1小时内
            xx分钟前
    其他
            xx小时前
    昨天
        昨天 18:56:34
    其他
        06-23 19:56:23
 
 非今年
 2014-05-08 18:45:30
 */

-(void)setTopic:(CLTopicModel *)topic{
    _topic = topic;
    // 设置其他控件
//    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.profileImageView.image = [image circleImage];
//    }];
    
    [self.profileImageView setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
//    设置帖子的创建时间  get方法放在模型
    self.createTimeLabel.text = topic.create_time;
    // 新浪加V
    self.sinaVView.hidden = !topic.isSina_v;
    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
//    [self testDate:topic.create_time];
    // 设置帖子的文字内容
    self.text_label.text = topic.text;
    
    // 根据模型类型(帖子类型)添加对应的内容到cell的中间
    if (topic.type == CLTopicTypePicture) {// 图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureF;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == CLTopicTypeVoice) { // 声音帖子
        self.voiceView.hidden = NO;
                self.voiceView.topic = topic;
                self.voiceView.frame = topic.voiceF;
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
    }else if (topic.type == CLTopicTypeVideo) { // 视频帖子
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }else { // 段子帖子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
  // 处理最热评论  
 
    if (self.topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", self.topic.top_cmt.user.username, self.topic.top_cmt.content];
    }else {
        self.topCmtView.hidden = YES;
    }


}
- (void)testDate:(NSString *)create_time
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // 当前时间
    NSDate *now = [NSDate date];
    // 发帖时间
    NSDate *create = [fmt dateFromString:create_time];
    
   CLLog(@"%@", [now deltaFrom:create]);
    
    // 日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // 比较时间
//       NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//       NSDateComponents *cmps = [calendar components:unit fromDate:create toDate:now options:0];
//        CLLog(@"%zd %zd %zd %zd %zd %zd", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    // 获得NSDate的每一个元素
//        NSInteger year = [calendar component:NSCalendarUnitYear fromDate:now];
//        NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:now];
//        NSInteger day = [calendar component:NSCalendarUnitDay fromDate:now];
//    获得多个元素
//        NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
//        CLLog(@"%zd %zd %zd", cmps.year, cmps.month, cmps.day);
}

/**  计算相差多少s
- (void)testDate:(NSString *)create_time{
    // 当前时间
        NSDate *now = [NSDate date];
    // 发帖时间
     NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
       fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    将字符串转成当前时间
    NSDate *create = [fmt dateFromString:create_time];
    NSTimeInterval delta = [now timeIntervalSinceDate:create];
    CLLog(@"delta=%f",delta);
}
*/
- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    //如果没有数字 显示中文
    [button setTitle:placeholder forState:UIControlStateNormal];
}
//让中间cell的内容自适应 设置左右 上下间距
-(void)setFrame:(CGRect)frame{
    frame.origin.x = CLTopicCellMargin;
    frame.size.width -= 2 * CLTopicCellMargin;
//    frame.size.height -= CLTopicCellMargin;
    frame.size.height = self.topic.cellHeight - CLTopicCellMargin;
    frame.origin.y += CLTopicCellMargin;
    [super setFrame:frame];
}
- (IBAction)more {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
    [sheet showInView:self.window];
}
@end








