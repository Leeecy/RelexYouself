//
//  CLEssenceViewController.m
//  轻松一刻
//
//  Created by chenl on 16/3/18.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1.利用子控制器创建标题
 *
 *  @param nonatomic <#nonatomic description#>
 *  @param weak      <#weak description#>
 *
 *  @return <#return value description#>
 */
#import "CLEssenceViewController.h"
#import "CLRecommendTagsViewController.h"
#import "CLTopicViewController.h"
@interface CLEssenceViewController ()<UIScrollViewDelegate>
/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation CLEssenceViewController

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
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
     // 设置导航栏左边的按钮 (封装为分类)
//    UIButton *tagButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [tagButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:(UIControlStateNormal)];
//    [tagButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:(UIControlStateHighlighted)];
//    tagButton.size = tagButton.currentBackgroundImage.size;
//    [tagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick:)];
    // 初始化子控制器
    [self setupChildVces];
    // 设置顶部的标签栏
    [self setupTitlesView];
    // 底部的scrollView
    [self setupContentView];
    self.view.backgroundColor = CLGlobalBg;
}
- (void)setupTitlesView{
    UIView *titlesView = [[UIView alloc]init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = CLTitilesViewH;
    titlesView.y = CLTitilesViewY;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
//    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    CGFloat width = titlesView.width / self.childViewControllers.count;
    CGFloat height = titlesView.height;
    
    
    for (NSInteger i = 0; i< self.childViewControllers.count ;i++) {
        UIButton *button = [[UIButton alloc]init];
        button.width = width;
        button.height = height;
        button.x = i * width;
//        利用tag计算滚动的offset
        button.tag = i;
         UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        
         // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
//    解决titleLabel崩溃问题
        [titlesView addSubview:indicatorView];
}
/**
 * 底部的scrollView
 */
- (void)setupContentView{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
//    contentView尺寸等于屏幕尺寸
    contentView.frame = self.view.bounds;
//    // 设置内边距  bottom为底部高度 底部 顶部分别减去对应的高度 但还是在视图view里 具有穿透效果
//    CGFloat bottom = self.tabBarController.tabBar.height;
////    最大y值
//    CGFloat top = CGRectGetMaxY(self.titlesView.frame);
//    contentView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //    让内容显示出来
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    
      self.contentView = contentView;
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
  
}
/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    CLTopicViewController *all = [[CLTopicViewController alloc] init];
     all.title = @"全部";
    all.type = CLTopicTypeAll;
    [self addChildViewController:all];
    
    CLTopicViewController *video = [[CLTopicViewController alloc] init];
    video.title = @"视频";
    video.type = CLTopicTypeVideo;
    [self addChildViewController:video];
    
    CLTopicViewController *voice = [[CLTopicViewController alloc] init];
    voice.title = @"声音";
    voice.type = CLTopicTypeVoice;
    [self addChildViewController:voice];
    
    CLTopicViewController *picture = [[CLTopicViewController alloc] init];
    picture.title = @"图片";
    picture.type = CLTopicTypePicture;
    [self addChildViewController:picture];
    
    CLTopicViewController *word = [[CLTopicViewController alloc] init];
    word.title = @"段子";
    word.type = CLTopicTypeWord;
    [self addChildViewController:word];
}

#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
-(IBAction)titleClick:(UIButton*)button{
    CLLogFunc;
//     // 修改按钮状态
//    self.selectedButton.enabled = YES;
//    button.enabled = NO;
//    self.selectedButton = button;
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
//    动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
//    滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag *self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

-(IBAction)tagClick:(id)sender{
    CLLogFunc;
    CLRecommendTagsViewController * tagVC = [[CLRecommendTagsViewController alloc]init];
    [self.navigationController pushViewController:tagVC animated:YES];
}


#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
   // 取出子控制器 (不写tableView是为了通用性)
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x ;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
  
    [scrollView addSubview:vc.view];
}
//停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁

@end
