//
//  CLMeViewCell.m
//  轻松一刻
//
//  Created by chenl on 16/5/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLMeViewCell.h"

@implementation CLMeViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//Cell的初始化方法，可以设置一个风格和标识符
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}
//1、init初始化不会触发layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
//    此处因为第二行没有设置图片 所以直接返回 不然 距离会变化
    if (self.imageView.image == nil) return;
    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.height * 0.5;
//    文字的x值等于图片的x ＋ 10
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame)+ CLTopicCellMargin;
}
// 这个方法也可以强行改变cell 的y值  不推荐 一般设置tableView的内边距改变
//- (void)setFrame:(CGRect)frame
//{
////    XMGLog(@"%@", NSStringFromCGRect(frame));
//    frame.origin.y -= (35 - XMGTopicCellMargin);
//    [super setFrame:frame];
//}
@end
