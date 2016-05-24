//
//  CLTopicPictureView.m
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1 .imageView 的左边和右边会超出 在xib中给添加 clipsubviews
 *
 *  2. 显示图片 第二种方法     绘制图形上下文
 *  @param nonatomic <#nonatomic description#>
 *
 *  @return <#return value description#>
 */
#import "CLTopicPictureView.h"
#import "CLTopicModel.h"
#import <UIImageView+WebCache.h>
#import "CLProgress.h"
#import "CLShowPictureViewController.h"
@interface CLTopicPictureView()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (weak, nonatomic) IBOutlet CLProgress *progressView;
@end

@implementation CLTopicPictureView

+ (instancetype)pictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
//清空自动布局属性
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture
{
    CLShowPictureViewController *showPicture = [[CLShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}
// xib中设置imageView属性为clipSubviews
- (void)setTopic:(CLTopicModel *)topic
{
    _topic = topic;
    /**
     在不知道图片扩展名的情况下, 如何知道图片的真实类型?
     * 取出图片数据的第一个字节, 就可以判断出图片的真实类型
     */
    
     // 立马显示最新的进度值(防止因为网速慢, 导致显示的是其他图片的下载进度)
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    // 设置图片
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
        // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        // 计算进度值
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        // 显示进度值
        [self.progressView setProgress:topic.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        // 如果是大图片, 才需要进行绘图处理
        if (topic.isBigPicture == NO) return;
        // 开启图形上下文 创建一个和imageView 大小的图文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
         // 将下载完的image对象绘制到图形上下文 drawInRect指定矩形框进行绘制
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        // 获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束图形上下文
        UIGraphicsEndImageContext();
        
    }];
//    判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    // 判断是否显示"点击查看全图"
    if (topic.isBigPicture) {//大图
        self.seeBigButton.hidden = NO;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }else { // 非大图
        self.seeBigButton.hidden = YES;
//        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
}
@end













