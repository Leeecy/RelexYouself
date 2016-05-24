//
//  CLCommentCell.m
//  轻松一刻
//
//  Created by mac on 16/5/21.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1.xib中音频的高度为22 所以设置内容的高度 >=22 不然 当音频显示 文字消失的时候
 *内容不会自适应  设置label的属性 高度
 *  @param weak
 *  @param nonatomic
 *
 *  @return
 */
#import "CLCommentCell.h"
#import "CLComment.h"
#import <UIImageView+WebCache.h>
#import "CLUser.h"
@interface CLCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@end
@implementation CLCommentCell

- (void)awakeFromNib
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setComment:(CLComment *)comment{
    _comment = comment;
//    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
//    self.sexView.image = [comment.user.sex isEqualToString:CLUserSexMale]? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    [self.profileImageView setHeader:comment.user.profile_image];
    self.contentLabel.text = comment.content;
    
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    if (comment.voiceuri.length) {//因为url有可能是@“” 所以用长度判断
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    }else {
        self.voiceButton.hidden = YES;
    }
}
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = CLTopicCellMargin;
    frame.size.width -= 2 * CLTopicCellMargin;
    
    [super setFrame:frame];
}

@end















