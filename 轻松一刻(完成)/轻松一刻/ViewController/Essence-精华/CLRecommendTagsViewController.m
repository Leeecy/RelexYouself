//
//  CLRecommendTagsViewController.m
//  轻松一刻
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLRecommendTagsViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "CLRecommendTagCell.h"
#import "CLRecommendTag.h"
#import <MJExtension.h>
@interface CLRecommendTagsViewController ()
/** 标签数据 */
@property (nonatomic, strong) NSArray *tags;
@end
static NSString * const CLTagsId = @"tag";
@implementation CLRecommendTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadTags];

    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 初始化UI
- (void)loadTags{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    
    [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//     responseObject为一个数组
        NSLog(@"%@",responseObject);
//        将字典数组转为模型数组
        self.tags = [CLRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
//        NSLog(@"tagArr=%@",tagArr);
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败!"];
    }];
}
-(void)configUI{
    
}
- (void)setupTableView
{
    self.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:CLTagsId];
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = CLGlobalBg;
    
}

#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件

#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:CLTagsId];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁

@end
