



//
//  CommonLabel.m
//  石头剪子布
//
//  Created by aaa on 16/1/18.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import "CommonLabel.h"

@implementation CommonLabel

-(id)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr textColor:(UIColor *)textColor textFont:(UIFont *)textFont
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.text = titleStr;
        self.font = textFont;
        self.textColor = textColor;
    }
    return self;
}


@end
