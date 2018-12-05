//
//  CommonButton.h
//  石头剪子布
//
//  Created by aaa on 16/1/21.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonButton : UIButton

//图片按钮
-(id)initWithFrame:(CGRect)frame imageStr:(NSString *)imageStr;

//文字按钮
-(id)initWithFrame:(CGRect)frame textFlag:(BOOL)textFlag;

@end
