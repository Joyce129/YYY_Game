//
//  RootViewController.m
//  Game
//
//  Created by YYY on 2017/12/16.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "ExpressionController.h"

#import "CommonImage.h"
#import "CommonLabel.h"

#import "CommonButton.h"

#import <AVFoundation/AVFoundation.h>

#define kPlayTop (self.bottomView.height-80)/2.0

@interface RootViewController ()
{
}

@property(nonatomic,strong)AVAudioPlayer *backgroundPlayer;

@property(nonatomic,strong)AVAudioPlayer *resultPlayer;

//出拳结果
@property(nonatomic,strong)CommonLabel *matchResult;

@property(nonatomic,strong)CommonLabel *computerScore;
@property(nonatomic,strong)CommonLabel *playerScore;

@property(nonatomic,assign)NSInteger computerGrade;
@property(nonatomic,assign)NSInteger playerGrade;

//动画图片
@property(nonatomic,strong)UIImageView *gifImageLeft;
@property(nonatomic,strong)UIImageView *gifImageRight;
@property(nonatomic,copy)NSString *gifPath;

@property(nonatomic,strong)NSMutableArray *figurePath;

@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSTimer *clockTimer;
@property(nonatomic,strong)CommonLabel *timerLabel;

//动画图片
@property(nonatomic,strong)NSArray *imagesArray1;
@property(nonatomic,strong)NSArray *imagesArray2;

//播放
@property(nonatomic,strong)UIButton *playBtn;

//底部视图
@property(nonatomic,strong)UIView *bottomView;

@end

@implementation RootViewController

//下一步
-(void)nextAction
{
    ExpressionController *express = [[ExpressionController alloc]init];
    UINavigationController *navExpresss = [[UINavigationController alloc]initWithRootViewController:express];
    navExpresss.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navExpresss animated:YES completion:^{
        
    }];
}

//定时器
-(void)clockAction:(NSTimer *)timer
{
    NSInteger internal = [timer.fireDate timeIntervalSinceDate:self.startDate];
    NSString *text = [NSString stringWithFormat:@"%02ld ：%02ld",internal/60,internal%60];
    [self.timerLabel setText:text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.computerGrade = 0;
    self.playerGrade = 0;
    
    CommonImage *bgImage = [[CommonImage alloc]initWithFrame:[UIScreen mainScreen].bounds imageStr:@"bgImage"];
    self.view = bgImage;
    
    CommonButton *nextBtn = [[CommonButton alloc]initWithFrame:CGRectMake(kDeviceWidth-50, 44, 65*0.65, 63*0.65) imageStr:@"next"];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    //定时器
    self.timerLabel = [[CommonLabel alloc]initWithFrame:CGRectMake(10, 44, 100, 30) titleStr:@"00 ：00" textColor:[UIColor redColor] textFont:[UIFont boldSystemFontOfSize:14]];
    [self.view addSubview:self.timerLabel];
    
    self.startDate = [NSDate date];
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(clockAction:) userInfo:nil repeats:YES];
    
    //出拳结果
    self.matchResult = [[CommonLabel alloc]initWithFrame:CGRectMake(0,85, kDeviceWidth, 25) titleStr:@"🏮 比赛即将开始 🏮" textColor:[UIColor redColor] textFont:[UIFont boldSystemFontOfSize:25]];
    self.matchResult.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.matchResult];
    
    //动画人物图片
    NSString *boyPath = [[NSBundle mainBundle] pathForResource:@"boy@2x" ofType:@"gif"];
    NSString *girlPath = [[NSBundle mainBundle] pathForResource:@"girl@2x" ofType:@"gif"];
    self.figurePath = [NSMutableArray arrayWithObjects:boyPath,girlPath, nil];
    
    _backgroundPlayer = [self loadBackgroundMusic:@"一生有你"];
    //设置无限循环
    [_backgroundPlayer setNumberOfLoops:-1];
    //开始播放
    [_backgroundPlayer play];
    
    
    self.imagesArray1 = @[[UIImage imageNamed:@"石头"],[UIImage imageNamed:@"剪子"],[UIImage imageNamed:@"布"]];
    self.imagesArray2 = @[[UIImage imageNamed:@"剪子"],[UIImage imageNamed:@"布"],[UIImage imageNamed:@"石头"]];
    
    
    for (int i=0; i<2; i++)
    {
        UIImageView *playName = [UIImageView imageViewWithGifFile:self.figurePath[i] frame:CGRectMake(15, 210+i*150, 60, 60)];
        playName.layer.masksToBounds = YES;
        playName.layer.cornerRadius = playName.width/2.0;
        [self.view addSubview:playName];
        
        UIImageView *playImage = [[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-80)/2.0, 200+i*150, 80, 80)];
        playImage.tag = i + 10;
        [self.view addSubview:playImage];
        
        CommonLabel *scoreLabel = [[CommonLabel alloc]initWithFrame:CGRectMake(kDeviceWidth-30, 230+i*150, 30, 20) titleStr:@"0" textColor:[UIColor redColor] textFont:[UIFont boldSystemFontOfSize:15]];
        if (i==0)
        {
            self.computerScore = scoreLabel;
        }
        else
        {
            self.playerScore = scoreLabel;
        }
        [self.view addSubview:scoreLabel];
        
        CommonImage *redflower = [[CommonImage alloc]initWithFrame:CGRectMake(kDeviceWidth-80, 220+i*150, 40, 40) imageStr:@"redFlower"];
        [self.view addSubview:redflower];
    }
    UIImageView *animateImage1 = (UIImageView *)[self.view viewWithTag:10];
    UIImageView *animateImage2 = (UIImageView *)[self.view viewWithTag:11];
    
    [UIView animateWithDuration:1.5f animations:^{
        [animateImage1 setAnimationDuration:1.0f];
        [animateImage1 setAnimationImages:self.imagesArray1];
        
        [animateImage2 setAnimationDuration:1.0f];
        [animateImage2 setAnimationImages:self.imagesArray2];
        
        [animateImage1 startAnimating];
        [animateImage2 startAnimating];
    }];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-130, kDeviceWidth, 100)];
    [self.view addSubview:self.bottomView];
    
    float edge = (kDeviceWidth-240)/4.0;
    NSArray *tempArray = @[@"石头",@"剪子",@"布"];
    for (int i=0; i<3; i++)
    {
        CommonImage *gesture = [[CommonImage alloc]initWithFrame:CGRectMake(edge+i*(edge+80), 0, 80, 80) imageStr:tempArray[i]];
        gesture.layer.masksToBounds = YES;
        gesture.tag = 100+i;
        gesture.layer.cornerRadius = 8;
        gesture.layer.borderColor = [UIColor lightGrayColor].CGColor;
        gesture.layer.borderWidth = 1.0;
        [self.bottomView addSubview:gesture];
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
        [gesture addGestureRecognizer:tapImage];
    }
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake((kDeviceWidth-80)/2.0, kDeviceHeight, 80, 80);
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateHighlighted];
    [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.playBtn];
}

//出拳
-(void)imageAction:(UITapGestureRecognizer *)tapGesture
{
    if (_resultPlayer.play)
    {
        [_resultPlayer stop];
    }
    [UIView animateWithDuration:0.7 animations:^{
        self.playBtn.top = kPlayTop;
        for (int i=0; i<3; i++)
        {
            CommonImage *gestureImage = (CommonImage *)[self.bottomView viewWithTag:100+i];
            gestureImage.top = kDeviceHeight;
        }
        UIImageView *animateImage1 = (UIImageView *)[self.view viewWithTag:10];
        [animateImage1 stopAnimating];
        
        UIImageView *animateImage2 = (UIImageView *)[self.view viewWithTag:11];
        [animateImage2 stopAnimating];
        
        //电脑随机出拳
        NSInteger computerResult = arc4random()%3;
        CommonImage *currentImage = (CommonImage *)tapGesture.view;
        NSInteger playerResult = currentImage.tag - 100;
        NSInteger endMathResutl = computerResult - playerResult;
        
        [animateImage1 setImage:self.imagesArray1[computerResult]];
        [animateImage2 setImage:self.imagesArray1[playerResult]];
        
        if (endMathResutl == 0)
        {
            self.resultPlayer = [self loadBackgroundMusic:@"和局"];
            self.matchResult.text = [NSString stringWithFormat:@"👏，比赛和局--- %ld : %ld",self.computerGrade,self.playerGrade];
            
            //动画图片
            self.gifPath = [[NSBundle mainBundle] pathForResource:@"image3@2x" ofType:@"gif"];
        }
        else if (endMathResutl == -1 || endMathResutl == 2)
        {
            //电脑赢
            self.resultPlayer = [self loadBackgroundMusic:@"伤感"];
            self.computerGrade++;
            self.computerScore.text = [NSString stringWithFormat:@"%ld",self.computerGrade];
            self.matchResult.text = [NSString stringWithFormat:@"遗憾💔，你输了--- %ld : %ld",self.computerGrade,self.playerGrade];
            
            //动画图片
            self.gifPath = [[NSBundle mainBundle] pathForResource:@"image2@2x" ofType:@"gif"];
        }
        else
        {
            //玩家赢
            self.resultPlayer = [self loadBackgroundMusic:@"恭喜"];
            self.playerGrade++;
            self.playerScore.text = [NSString stringWithFormat:@"%ld",self.playerGrade];
            self.matchResult.text = [NSString stringWithFormat:@"恭喜💕，你赢了--- %ld : %ld",self.computerGrade,self.playerGrade];
            
            //动画图片
            self.gifPath = [[NSBundle mainBundle] pathForResource:@"image1@2x" ofType:@"gif"];
        }
        
        for (int i=0; i<2; i++)
        {
            UIImageView *tempGiftImage = [UIImageView imageViewWithGifFile:self.gifPath frame:CGRectMake(10+i*(kDeviceWidth-100), self.playBtn.top, 80, 80)];
            
            if (i==0)
            {
                self.gifImageLeft = tempGiftImage;
            }
            else
            {
                self.gifImageRight = tempGiftImage;
            }
            [self.bottomView addSubview:tempGiftImage];
        }
        
        [self.resultPlayer setNumberOfLoops:1];
        [self.resultPlayer play];
    }];
}

//播放
-(void)playAction:(UIButton *)playButton
{
    if(_resultPlayer.play)
    {
        [_resultPlayer stop];
    }
    
    [UIView animateWithDuration:0.7 animations:^{
        self.matchResult.text = [NSString stringWithFormat:@"🌹 双方比值：%ld : %ld 🌹",self.computerGrade,self.playerGrade];
        self.playBtn.top = kDeviceHeight;
        self.gifImageLeft.top = self.playBtn.top;
        self.gifImageRight.top = self.playBtn.top;
        
        for (int i=0; i<3; i++)
        {
            CommonImage *gestureImage = (CommonImage *)[self.bottomView viewWithTag:100+i];
            gestureImage.top = 0;
        }
    }];
    
    UIImageView *animateImage1 = (UIImageView *)[self.view viewWithTag:10];
    UIImageView *animateImage2 = (UIImageView *)[self.view viewWithTag:11];
    [animateImage1 startAnimating];
    [animateImage2 startAnimating];
}

#pragma mark 加载背景音乐
-(AVAudioPlayer *)loadBackgroundMusic:(NSString *)fileName
{
    NSURL *url = [[NSBundle mainBundle]URLForResource:fileName withExtension:@"mp3"];
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    player.volume = 1.0;
    if (player)
    {
        [player prepareToPlay];
    }
    return player;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_backgroundPlayer stop];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_backgroundPlayer play];
}

@end
