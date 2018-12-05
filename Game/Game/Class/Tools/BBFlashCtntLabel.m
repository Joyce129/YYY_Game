//
//  BBFlashCtntLabel.m
//  DebugTest
//
//  Created by iXcoder on 15/3/2.
//  Copyright (c) 2015年 iXcoder. All rights reserved.
//

#import "BBFlashCtntLabel.h"

@interface BBFlashCtntLabel()
{
    BOOL seted;
    
    BOOL moveNeed;
    
    CGFloat rate;
}

@property (nonatomic, strong) UIView *innerContainer;

@end

@implementation BBFlashCtntLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
        NSLog(@"11111");
    }
    return self;
}

- (void)setSpeed:(BBFlashCtntSpeed)speed
{
    _speed = speed;
    switch (_speed)
    {
        case BBFlashCtntSpeedFast:
            rate = 90.;
            break;
        case BBFlashCtntSpeedMild:
            rate = 75;
            break;
        case BBFlashCtntSpeedSlow:
            rate = 40.;
            break;
        default:
            break;
    }
}

- (void)setup
{
    if (seted)
    {
        return ;
    }
    self.innerContainer = [[UIView alloc] initWithFrame:self.bounds];
    self.innerContainer.backgroundColor = [UIColor clearColor];
    self.innerContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.innerContainer];
    seted = YES;
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
    CGRect f = CGRectMake(0, 0, width, self.bounds.size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:f];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    if (self.text)
    {
        label.text = self.text;
        label.textColor = self.textColor;
        label.font = self.font;
    }
    [self.innerContainer addSubview:label];
    
    CGRect f1 = CGRectMake(width + self.leastInnerGap, 0, width, f.size.height);
    UILabel *next = [[UILabel alloc] initWithFrame:f1];
    next.backgroundColor = [UIColor clearColor];
    next.textAlignment = NSTextAlignmentCenter;
    if (self.text)
    {
        next.text = self.text;
        next.textColor = self.textColor;
        next.font = self.font;
    }
    [self.innerContainer addSubview:next];
    
    //序列帧动画
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    moveAnimation.keyTimes = @[@0., @0.191, @0.868, @1.0];
    moveAnimation.values = @[@0, @0., @(- width - self.leastInnerGap)];
    moveAnimation.duration = width / rate;
    moveAnimation.repeatCount = self.repeatCount == 0 ? INT16_MAX : self.repeatCount;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    [self.innerContainer.layer addAnimation:moveAnimation forKey:@"move"];
}

@end
