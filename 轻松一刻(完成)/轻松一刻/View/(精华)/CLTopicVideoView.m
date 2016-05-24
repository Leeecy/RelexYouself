//
//  CLTopicVideoView.m
//  轻松一刻
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLTopicVideoView.h"
#import "CLTopicModel.h"
#import <UIImageView+WebCache.h>
#import "CLShowPictureViewController.h"
@interface CLTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@end
@implementation CLTopicVideoView
+ (instancetype)videoView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
     self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTopic:(CLTopicModel *)topic
{
    _topic = topic;
    
    // 图片
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
