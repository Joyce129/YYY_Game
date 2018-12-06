//
//  UIImageView+GifAnimation.m
//  Game
//
//  Created by Jean on 2018/12/6.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import "UIImageView+GifAnimation.h"

@implementation UIImageView (GifAnimation)

+ (UIImageView *)imageViewWithGifFile:(NSString *)file frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    //加载gif文件数据
    NSData *gifData = [NSData dataWithContentsOfFile:file];
    
    //GIF动画图片数组
    NSMutableArray *imagesArray = nil;
    //动画时长
    CGFloat animationTime = 0.f;
    
    //图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src)
    {
        //获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        //实例化图片数组
        imagesArray = [NSMutableArray arrayWithCapacity:count];
        
        for (size_t i = 0; i < count; i++ )
        {
            //获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);
           
            //获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];

            animationTime += [delayTime floatValue];
            if (image)
            {
                [imagesArray addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }
        CFRelease(src);
    }
    
    [imageView setImage:[imagesArray objectAtIndex:0]];
    [imageView setAnimationImages:imagesArray];
    [imageView setAnimationDuration:animationTime];
    [imageView startAnimating];
    
    return imageView;
}

@end
