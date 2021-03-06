//
//  UIImageView+GifAnimation.h
//  Game
//
//  Created by Jean on 2018/12/6.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (GifAnimation)

+ (UIImageView *)imageViewWithGifFile:(NSString *)file frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
