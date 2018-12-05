

//
//  CommonImage.m
//  石头剪子布
//
//  Created by aaa on 16/1/18.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import "CommonImage.h"

@implementation CommonImage

-(id)initWithFrame:(CGRect)frame imageStr:(NSString *)imageStr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:imageStr];
    }
    return self;
}


@end
