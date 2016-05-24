//
//  CLCommentViewController.m
//  轻松一刻
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1.底部的工具栏不滚动 设置单独view
 *  2.最上面的视图定义为HeaderView  然后把 之前的cell丢给headView
 *  3. viewForHeader 也可以循环利用 
 4.清空评论列表上面View的top_cmt的显示的一条热门评论，清空之后高度会改变
 创建头部清空一次 仅仅是清空头部那个内容评论
 5.iOS8 自动适配cell 仅仅当cell的内容固定时才可以 如果cell的内容为图片 视频 等动态 采用模型设置
 6. cancel 上啦的时候取消下啦 等
 7.点击cell的时候加入评论 回复 顶 按钮
 */
#import "CLCommentViewController.h"
#import "CLTopicCell.h"
#import "CLTopicModel.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import "CLComment.h"
#import <MJExtension.h>
#import "CLCommentHeaderView.h"
#import "CLCommentCell.h"
static NSString * const CLCommentId = @"comment";
@interface CLCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 工具条底部间距   监听键盘弹出来改变底部工具栏线条的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
/** 保存帖子的top_cmt */
@property (nonatomic, strong) CLComment *saved_top_cmt;

/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;

/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation CLCommentViewController
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
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)keyboardWillChangeFrame:(NSNotification*)note{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束  屏幕高度－键盘的y值 ＝ 工具栏
    self.bottomSapce.constant = SCREEN_HEIGHT - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画 及时刷新
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];

}


#pragma mark -
#pragma mark 初始化UI
-(void)configUI{
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
//    加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}
- (void)setupBasic
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    // cell的高度设置
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 背景色
    self.tableView.backgroundColor = CLGlobalBg;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLCommentCell class]) bundle:nil] forCellReuseIdentifier:CLCommentId];
    
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CLTopicCellMargin, 0);

}
- (void)setupHeader{
    // 创建header
    UIView *header = [[UIView alloc] init];
     // 清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
//        清空高度
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    // 添加cell  把上个界面的cell 放到头视图 需要到自定义cell里面定义
    CLTopicCell *cell = [CLTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(SCREEN_WIDTH, self.topic.cellHeight);
    [header addSubview:cell];
    
    // header的高度
    header.height = self.topic.cellHeight + CLTopicCellMargin;
    
    // 设置header
    self.tableView.tableHeaderView = header;
}
#pragma mark -
#pragma mark 加载数据
- (void)loadNewComments{
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        } // 说明没有评论数据
        

        // 最热评论
        self.hotComments = [CLComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        self.latestComments = [CLComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 页码  下拉刷新成功回到第一页
        self.page = 1;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];

}
-(void)loadMoreComments{
    CLLogFunc;
     // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 页码
    NSInteger page = self.page + 1;
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    CLComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php"  parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        

        // 最新评论
        NSArray *newComments = [CLComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 页码  请求成功之后刷新页码
        self.page = page;
        
        // 刷新数据
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];

}
#pragma mark -
#pragma mark 事件

#pragma mark -
#pragma mark 数据请求


/**
 * 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section{
    if (section == 0) {//有两种可能
//        如果是热门评论有值就返回热门评论组 否则返回最新评论组
        return self.hotComments.count? self.hotComments : self.latestComments;
    }
//    返回最新评论
    return self.latestComments;
}
- (CLComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}
#pragma mark -
#pragma mark 代理
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 先从缓存池中找header
    CLCommentHeaderView *header = [CLCommentHeaderView headerViewWithTableView:tableView];
    
    // 设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    // 隐藏或显示底部 尾部控件
    tableView.mj_footer.hidden = (latestCount == 0);

    if (section == 0) { //组可能显示最热评论和最新评论
        return hotCount ? hotCount :latestCount;
    }
     // 非第0组
    return latestCount;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {// 0组可能显示最热评论和最新评论
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];

//    内容根据第几组判断
    cell.comment = [self commentInIndexPath:indexPath];
    return cell;

}
//用户开始拖动 scroll view 的时候被调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
// 创建菜单不显示
    [[UIMenuController sharedMenuController]setMenuVisible:NO animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {// 如果显示
        [menu setMenuVisible:NO animated:YES];
        
    }else{
        // 被点击的cell
       CLCommentCell *cell = (CLCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        // 出现一个第一响应者
        [cell becomeFirstResponder];
        // 显示MenuController
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
//        指向中间文字
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    
    }
}

#pragma mark -
#pragma mark 业务逻辑
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}
#pragma mark -
#pragma mark 通知注册和销毁
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 恢复帖子的top_cmt  退出视图的时候重新恢复高度
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
     // 取消所有任务
    [self.manager invalidateSessionCancelingTasks:YES];
}

@end
