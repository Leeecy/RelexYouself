//
//  CLRecommendViewController.m
//  轻松一刻
//
//  Created by chenl on 16/3/21.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLRecommendViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <JSONModel.h>
#import "CLRecommendCategory.h"
#import <MJExtension.h>
#import "CLRecommendCategoryTableViewCell.h"
#import "CLRecommendUserCell.h"
#import "CLRecommendUser.h"
#import "MJRefresh.h"
//左边表格选中那一行的模型
#define  CLSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]
@interface CLRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 左边的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
/** 右边的类别数据 */
@property (nonatomic, strong) NSArray *users;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation CLRecommendViewController
static NSString * const CLCategoryId = @"category";
static NSString * const CLUserId = @"user";
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // 添加刷新控件
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 初始化UI
-(void)configUI{
    self.title = @"推荐关注";
    self.view.backgroundColor = CLGlobalBg;
    // 设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
//    注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLRecommendCategoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:CLCategoryId];
    
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:CLUserId];
//    显示指示器
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeBlack)];
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    [[AFHTTPSessionManager  manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 服务器返回的JSON数据
        self.categories = [CLRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        NSLog(@"%@",responseObject[@"list"]);
        //刷新表格
        [self.categoryTableView reloadData];
        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionTop)];
        // 隐藏指示器
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"加载推荐信息失败!"];
    }];
}
/**
 * 添加刷新控件
 */
-(void)setupRefresh{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.userTableView.mj_footer.hidden = YES;
    
}
#pragma mark -
#pragma mark 加载数据
- (void)loadNewUsers{
    CLRecommendCategory *rc = CLSelectedCategory;
    // 发送请求给服务器, 加载右侧的数据
    rc.currentPage = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.id);
    params[@"page"] = @(rc.currentPage);
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CLLog(@"%@",responseObject);
        // 字典数组 -> 模型数组
        NSArray *users = [CLRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        // 刷新右边的表格
        [self.userTableView reloadData];
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];
    
        [self.userTableView.mj_header endRefreshing];
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];


}

-(void)loadMoreUsers{
    CLLogFunc;
    // 发送请求给服务器, 加载右侧的数据
    CLRecommendCategory *categroy = CLSelectedCategory;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(categroy.id);
    params[@"page"] = @(++categroy.currentPage);
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [CLRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 添加到当前类别对应的用户数组中
        [categroy.users addObjectsFromArray:users];
        // 刷新右边的表格
        [self.userTableView reloadData];
        // 让底部控件结束刷新
        if (categroy.users.count == categroy.total) { // 全部数据已经加载完毕
            [self.userTableView.mj_footer endRefreshingWithNoMoreData];
        } else { // 还没有加载完毕
            [self.userTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 让底部控件结束刷新
        [self.userTableView.mj_footer endRefreshing];
        // 让底部控件结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }];

}
#pragma mark -
#pragma mark 事件

#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) {//左边的类别表格
        return self.categories.count;
    }else {// 左边被选中的类别模型
         CLRecommendCategory *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        // 每次刷新右边数据时, 都控制footer显示或者隐藏
        self.userTableView.mj_footer.hidden = (c.users.count == 0);
        return c.users.count;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        CLRecommendCategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CLCategoryId];
        cell.category = self.categories[indexPath.row];
        return cell;
    }else{
        CLRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CLUserId];
        CLRecommendCategory *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.user = c.users[indexPath.row];
        return cell;
    
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CLRecommendCategory *c = self.categories[indexPath.row];
    if (c.users.count) {
        // 显示曾经的数据
        [self.userTableView reloadData];
    }else{
        // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
        [self.userTableView reloadData];
//        进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
        
    }
  }
#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁


@end
