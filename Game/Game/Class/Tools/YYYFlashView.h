//
//  YYYFlashView.h
//  Game
//
//  Created by Jean on 2018/12/6.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YYYFlashSpeed)
{
    YYYFlashSpeedSlow = -1,
    YYYFlashSpeedMild,
    YYYFlashSpeedFast
};

@interface YYYFlashView : UIView

@property(nonatomic,copy)NSString *text;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIColor *textColor;

@property(nonatomic,strong)NSAttributedString *attributedText;

@property(nonatomic,assign)YYYFlashSpeed speed;

// 循环滚动次数(为0时无限滚动)
@property(nonatomic,assign)NSUInteger repeatCount;

@property(nonatomic,assign)CGFloat innerEdgeGap;

- (void)reloadView;

@end
