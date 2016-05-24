//
//  CLRecommendCategoryTableViewCell.m
//  轻松一刻
//
//  Created by chenl on 16/3/21.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLRecommendCategoryTableViewCell.h"
#import "CLRecommendCategory.h"
@interface CLRecommendCategoryTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end
@implementation CLRecommendCategoryTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = CLRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = CLRGBColor(219, 21, 26);
    // 当cell的selection为None时, cell被选中时, 内部的子控件就不会进入高亮状态
//    self.textLabel.textColor = CLRGBColor(78, 78, 78);
//    self.textLabel.highlightedTextColor = CLRGBColor(219, 21, 26);
//    UIView *bg = [[UIView alloc] init];
//    bg.backgroundColor = [UIColor clearColor];
//    self.selectedBackgroundView = bg;
}
/**
 * 可以在这个方法中监听cell的选中和取消选中
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : CLRGBColor(78, 78, 78);
    // Configure the view for the selected state
}
-(void)setCategory:(CLRecommendCategory *)category{
    _category = category;
    self.textLabel.text = category.name;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    // 重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}
@end
