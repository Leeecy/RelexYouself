//
//  CLTopicViewController.m
//  轻松一刻
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1.点击cell跳转到下一个界面  CLCommentViewController.h
 *  2. 设置下面tabbar 点击第二次加载刷新 发送通知到CLTabBar的四个button处理
 3.判断是否是新帖界面
 *
 */
#import "CLTopicViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "MJRefresh.h"
#import "CLTopicModel.h"
#import "CLTopicCell.h"
#import "CLCommentViewController.h"
#import "CLNewViewController.h"
@interface CLTopicViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@end
static NSString * const CLTopicCellId = @"topic";
@implementation CLTopicViewController

- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化表格
    [self setupTableView];
    // 添加刷新控件
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 初始化UI
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}
-(void)setupTableView{
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = CLTitilesViewY + CLTitilesViewH;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    // 注册
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLTopicCell class]) bundle:nil] forCellReuseIdentifier:CLTopicCellId];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLTopicCell" bundle:nil] forCellReuseIdentifier:CLTopicCellId];
    // 监听tabbar点击的通知
    [CLNoteCenter addObserver:self selector:@selector(tabBarSelect) name:CLTabBarDidSelectNotification object:nil];
}
-(void)tabBarSelect{
    // 如果是连续选中2次, 直接刷新
//    self.view.isShowingOnKeyWindow 当前视图显示
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex// && self.tabBarController.selectedViewController == self.navigationController
        && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;

}
#pragma mark - a参数
// a 为判断精华和新帖的参数
- (NSString *)a
{
    //parentViewController 取得当前控制器的父容器 前提是建立父子关系是通过self addChildViewController
    return [self.parentViewController isKindOfClass:[CLNewViewController class]] ? @"newlist" : @"list";
    CLLog(@"%@",self.parentViewController);
}
#pragma mark -
#pragma mark 加载数据
/**
 * 加载新的帖子数据
 */
- (void)loadNewTopics{
    // 结束上啦  如果 要执行下拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    NSLog(@"1111==%@",params[@"a"]),
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    // 发送请求
    [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.params != params) return;
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典 -> 模型
        self.topics = [CLTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //        页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
}
// 先下拉刷新, 再上拉刷新第5页数据

// 下拉刷新成功回来: 只有一页数据, page == 0
// 上啦刷新成功回来: 最前面那页 + 第5页数据

/**
 * 加载更多的帖子数据
 */
- (void)loadMoreTopics{
    // 结束下拉  需要上啦刷新的时候
    [self.tableView.mj_header endRefreshing];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
//    @将整形变为对象类型
    params[@"type"] = @(self.type);
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];

        // 字典 -> 模型
        NSArray *newTopics = [CLTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //        将之前的数组放到最后面
        [self.topics addObjectsFromArray:newTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
         // 设置页码
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        [self.tableView.mj_footer endRefreshing];
        //        // 恢复页码
        //        self.page--;
    }];
    
}
#pragma mark -
#pragma mark 事件

#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CLTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLCommentViewController *commentVc = [[CLCommentViewController alloc] init];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CLTopicModel *topic = self.topics[indexPath.row];


    // 返回这个模型对应的cell高度
    return topic.cellHeight;
}
#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁


@end
