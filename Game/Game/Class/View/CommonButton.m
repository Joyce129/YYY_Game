



//
//  CommonButton.m
//  石头剪子布
//
//  Created by aaa on 16/1/21.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import "CommonButton.h"

@implementation CommonButton

//图片按钮
-(id)initWithFrame:(CGRect)frame imageStr:(NSString *)imageStr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
    return self;
}

//文字按钮
-(id)initWithFrame:(CGRect)frame textFlag:(BOOL)textFlag
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (textFlag)
        {
            [self setTitle:@"计算" forState:UIControlStateNormal];
            self.titleLabel.font = [UIFont systemFontOfSize:13];
            self.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.layer.borderWidth = 0.2;
            self.layer.cornerRadius = 6;
            self.backgroundColor = [UIColor colorWithRed:137/255.0 green:213/255.0 blue:241/255.0 alpha:1];
        }
    }
    return self;
}

@end
