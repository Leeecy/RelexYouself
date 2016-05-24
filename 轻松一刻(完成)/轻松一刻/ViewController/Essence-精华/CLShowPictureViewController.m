//
//  CLShowPictureViewController.m
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLShowPictureViewController.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "CLTopicModel.h"
#import "CLProgress.h"
@interface CLShowPictureViewController ()
@property (weak, nonatomic) IBOutlet CLProgress *progressView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation CLShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 初始化UI
-(void)configUI{
    // 添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    // 图片尺寸
    CGFloat pictureW = SCREEN_WIDTH;
    CGFloat pictureH = SCREEN_WIDTH * self.topic.height/self.topic.width;
    if (pictureH > SCREEN_HEIGHT) {// 图片显示高度超过一个屏幕, 需要滚动查看
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
//        图片滚动范围
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else {
        imageView.size = CGSizeMake(pictureW, pictureH);
//        图片不超过高度时 居中显示
        imageView.centerY = SCREEN_HEIGHT * 0.5;
    }
     // 马上显示当前图片的下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];
    // 下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//         receivedSize 收到的大小  expectedSize 期望的大小
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        加载完成显示
        self.progressView.hidden = YES;
    }];

}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save {
    if (self.imageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片并没下载完毕!"];
        return;
    }
    
    // 将图片写入相册  保存成功调用方法 @selector(image:didFinishSavingWithError:contextInfo:)必须传一个方法
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
}
#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理

#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁

@end
