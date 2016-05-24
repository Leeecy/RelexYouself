//
//  CLCommentHeaderView.h
//  轻松一刻
//
//  Created by chenl on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCommentHeaderView : UITableViewHeaderFooterView
/** 文字数据  传给控制器显示的标题*/
@property (nonatomic, copy) NSString *title;
//控制器传一个view过来
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
