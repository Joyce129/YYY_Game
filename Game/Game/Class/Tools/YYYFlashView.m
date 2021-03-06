//
//  YYYFlashView.m
//  Game
//
//  Created by Jean on 2018/12/6.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import "YYYFlashView.h"

@interface YYYFlashView()
{
    BOOL moveNeed;
    
    CGFloat rate;
}

@property (nonatomic, strong) UIView *innerContainer;

@end

@implementation YYYFlashView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupViews];
    }
    return self;
}

- (void)setSpeed:(YYYFlashSpeed)speed
{
    _speed = speed;
    switch (_speed)
    {
        case YYYFlashSpeedFast:
            rate = 90.;
            break;
        case YYYFlashSpeedMild:
            rate = 75;
            break;
        case YYYFlashSpeedSlow:
            rate = 40.;
            break;
        default:
            break;
    }
}

//初始化子视图
- (void)setupViews
{
    self.innerContainer = [[UIView alloc] initWithFrame:self.bounds];
    self.innerContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:self.innerContainer];
}

- (void)reloadView
{
    [self.innerContainer.layer removeAnimationForKey:@"move"];
    for (UIView *sub in self.innerContainer.subviews)
    {
        if ([sub isKindOfClass:[UILabel class]])
        {
            [sub removeFromSuperview];
        }
    }
    CGFloat width = self.frame.size.width;
    CGRect frame1 = CGRectMake(0, 0, width, self.bounds.size.height);
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:frame1];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    if (self.text)
    {
        firstLabel.text = self.text;
        firstLabel.textColor = self.textColor;
        firstLabel.font = self.font;
    }
    [self.innerContainer addSubview:firstLabel];
    
    CGRect frame2 = CGRectMake(width + self.innerEdgeGap, 0, width, frame1.size.height);
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:frame2];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    if (self.text)
    {
        secondLabel.text = self.text;
        secondLabel.textColor = self.textColor;
        secondLabel.font = self.font;
    }
    [self.innerContainer addSubview:secondLabel];
    
    //序列帧动画
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    moveAnimation.removedOnCompletion = false;
    moveAnimation.keyTimes = @[@0., @0.191, @0.868, @1.0];
    moveAnimation.values = @[@0, @0., @(- width - self.innerEdgeGap)];
    moveAnimation.duration = width / rate;
    moveAnimation.repeatCount = self.repeatCount == 0 ? INT16_MAX : self.repeatCount;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    [self.innerContainer.layer addAnimation:moveAnimation forKey:@"move"];
}

@end
