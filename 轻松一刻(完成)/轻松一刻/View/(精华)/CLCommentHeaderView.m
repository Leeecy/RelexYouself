//
//  CLCommentHeaderView.m
//  轻松一刻
//
//  Created by chenl on 16/5/20.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLCommentHeaderView.h"
@interface CLCommentHeaderView()
/** 文字标签 */
@property (nonatomic, weak) UILabel *label;
@end
@implementation CLCommentHeaderView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    CLCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) { // 缓存池中没有, 自己创建
        header = [[CLCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = CLGlobalBg;
        
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = CLRGBColor(67, 67, 67);
        label.width = 200;
        label.x = CLTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.label.text = title;
}

@end
