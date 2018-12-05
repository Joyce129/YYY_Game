

//
//  CommonTextField.m
//  石头剪子布
//
//  Created by aaa on 16/1/22.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import "CommonTextField.h"

@implementation CommonTextField

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:239/255.0 green:249/255.0 blue:154/255.0 alpha:1];
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.keyboardAppearance = UIKeyboardAppearanceLight;
        self.keyboardType = UIKeyboardTypeDecimalPad;
        self.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.clearButtonMode = UITextFieldViewModeNever;
        self.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

@end
