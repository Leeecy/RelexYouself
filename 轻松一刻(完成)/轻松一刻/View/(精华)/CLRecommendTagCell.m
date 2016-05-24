//
//  CLRecommendTagCell.m
//  轻松一刻
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLRecommendTagCell.h"
#import "CLRecommendTag.h"
#import <UIImageView+WebCache.h>
@interface CLRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation CLRecommendTagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRecommendTag:(CLRecommendTag *)recommendTag{
    _recommendTag = recommendTag;
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.themeNameLabel.text = recommendTag.theme_name;
    NSString *subNumber = nil;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%ld",(long)recommendTag.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅", recommendTag.sub_number / 10000.0];
        
    }
    self.subNumberLabel.text = subNumber;
    
}
//修改cell的frame 
-(void)setFrame:(CGRect)frame{
//    CLLog(@"setFrame ---%@",NSStringFromCGRect(frame))
    ;
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
//    y值不变的情况下高度－1
    frame.size.height -= 1;
    
    [super setFrame:frame];

}
@end
