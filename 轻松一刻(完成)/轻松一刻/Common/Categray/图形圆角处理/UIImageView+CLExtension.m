//
//  UIImageView+CLExtension.m
//  轻松一刻
//
//  Created by mac on 16/5/21.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "UIImageView+CLExtension.h"
#import <UIImageView+WebCache.h>
@implementation UIImageView (CLExtension)
-(void)setHeader:(NSString *)url{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];

}
@end
