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

//#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define kPlayTop (bottomView.height-96)/2.0

@interface RootViewController ()
{
    //底部视图
    UIView *bottomView;
    //播放
    UIButton *playBtn;
    //出拳结果
    CommonLabel *matchResult;
    
    //动画图片
    NSArray *imagesArray1;
    NSArray *imagesArray2;
    
    CommonLabel *computerScore;
    CommonLabel *playerScore;
    
    NSInteger computerGrade;
    NSInteger playerGrade;
    
    //动画图片
    UIImageView *gifImageLeft;
    UIImageView *gifImageRight;
    NSString *gifPath;
    
    NSMutableArray *figurePath;
    
    NSDate *startDate;
    NSTimer *clockTimer;
    CommonLabel *timerLabel;
}

@property(nonatomic,strong)AVAudioPlayer *backgroundPlayer;

@property(nonatomic,strong)AVAudioPlayer *resultPlayer;

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
    NSInteger internal = [timer.fireDate timeIntervalSinceDate:startDate];
    NSString *text = [NSString stringWithFormat:@"%02ld ：%02ld",internal/60,internal%60];
    [timerLabel setText:text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CommonImage *bgImage = [[CommonImage alloc]initWithFrame:[UIScreen mainScreen].bounds imageStr:@"bgImage"];
    self.view = bgImage;
    
    CommonButton *nextBtn = [[CommonButton alloc]initWithFrame:CGRectMake(kDeviceWidth-50, 20, 65*0.65, 63*0.65) imageStr:@"next"];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    //定时器
    timerLabel = [[CommonLabel alloc]initWithFrame:CGRectMake(5, 20, 100, 30) titleStr:@"00 ：00" textColor:[UIColor redColor] textFont:[UIFont boldSystemFontOfSize:14]];
    [self.view addSubview:timerLabel];
    
    startDate = [NSDate date];
    clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(clockAction:) userInfo:nil repeats:YES];
    
    //出拳结果
    matchResult = [[CommonLabel alloc]initWithFrame:CGRectMake(0,60, kDeviceWidth, 25) titleStr:@"🏮 比赛即将开始 🏮" textColor:[UIColor redColor] textFont:[UIFont boldSystemFontOfSize:25]];
    
    if (kDeviceHeight > 568)
    {
        matchResult.top = 90;
    }
    matchResult.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:matchResult];
    
    //动画人物图片
    NSString *boyPath = [[NSBundle mainBundle] pathForResource:@"boy@2x" ofType:@"gif"];
    NSString *girlPath = [[NSBundle mainBundle] pathForResource:@"girl@2x" ofType:@"gif"];
    figurePath = [NSMutableArray arrayWithObjects:boyPath,girlPath, nil];
    
    _backgroundPlayer = [self loadBackgroundMusic:@"一生有你"];
    //设置无限循环
    [_backgroundPlayer setNumberOfLoops:-1];
    //开始播放
    [_backgroundPlayer play];
    computerGrade = 0;
    playerGrade = 0;
    
    imagesArray1 = @[[UIImage imageNamed:@"石头"],[UIImage imageNamed:@"剪子"],[UIImage imageNamed:@"布"]];
    imagesArray2 = @[[UIImage imageNamed:@"剪子"],[UIImage imageNamed:@"布"],[UIImage imageNamed:@"石头"]];
    
    
    for (int i=0; i<2; i++)
    {
        UIImageView *playName = [UIImageView imageViewWithGIFFile:figurePath[i] frame:CGRectMake(10, 180+i*150, 60, 60)];
        playName.layer.masksToBounds = YES;
        playName.layer.cornerRadius = playName.width/2.0;
        [self.view addSubview:playName];
        
        UIImageView *playImage = [[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-80)/2.0, playName.top, 80, 80)];
        playImage.tag = i + 10;
        [self.view addSubview:playImage];
        
        CommonLabel *scoreLabel = [[CommonLabel alloc]initWithFrame:CGRectMake(kDeviceWidth-30, playName.top+25, 30, 20) titleStr:@"0" textColor:[UIColor redColor] textFont:[UIFont boldSystemFontOfSize:15]];
        if (i==0)
        {
            computerScore = scoreLabel;
        }
        else
        {
            playerScore = scoreLabel;
        }
        [self.view addSubview:scoreLabel];
        
        CommonImage *redflower = [[CommonImage alloc]initWithFrame:CGRectMake(kDeviceWidth-80, playName.top+15, 40, 40) imageStr:@"redFlower"];
        [self.view addSubview:redflower];
    }
    UIImageView *animateImage1 = (UIImageView *)[self.view viewWithTag:10];
    UIImageView *animateImage2 = (UIImageView *)[self.view viewWithTag:11];
    
    [UIView animateWithDuration:1.5f animations:^{
        [animateImage1 setAnimationDuration:1.0f];
        [animateImage1 setAnimationImages:imagesArray1];
        
        [animateImage2 setAnimationDuration:1.0f];
        [animateImage2 setAnimationImages:imagesArray2];
        
        [animateImage1 startAnimating];
        [animateImage2 startAnimating];
    }];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-100, kDeviceWidth, 100)];
    [self.view addSubview:bottomView];
    
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
        [bottomView addSubview:gesture];
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
        [gesture addGestureRecognizer:tapImage];
    }
    
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake((kDeviceWidth-96)/2.0, kDeviceHeight, 80, 80);
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateHighlighted];
    [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:playBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

//出拳
-(void)imageAction:(UITapGestureRecognizer *)tapGesture
{
    if (_resultPlayer.play)
    {
        [_resultPlayer stop];
    }
    [UIView animateWithDuration:0.7 animations:^{
        playBtn.top = kPlayTop;
        for (int i=0; i<3; i++)
        {
            CommonImage *gestureImage = (CommonImage *)[bottomView viewWithTag:100+i];
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
        
        [animateImage1 setImage:imagesArray1[computerResult]];
        [animateImage2 setImage:imagesArray1[playerResult]];
        
        if (endMathResutl == 0)
        {
            _resultPlayer = [self loadBackgroundMusic:@"和局"];
            matchResult.text = [NSString stringWithFormat:@"👏，比赛和局--- %ld : %ld",computerGrade,playerGrade];
            
            //动画图片
            gifPath = [[NSBundle mainBundle] pathForResource:@"image3@2x" ofType:@"gif"];
        }
        else if (endMathResutl == -1 || endMathResutl == 2)
        {
            //电脑赢
            _resultPlayer = [self loadBackgroundMusic:@"伤感"];
            computerGrade++;
            computerScore.text = [NSString stringWithFormat:@"%ld",computerGrade];
            matchResult.text = [NSString stringWithFormat:@"遗憾💔，你输了--- %ld : %ld",computerGrade,playerGrade];
            
            //动画图片
            gifPath = [[NSBundle mainBundle] pathForResource:@"image2@2x" ofType:@"gif"];
        }
        else
        {
            //玩家赢
            _resultPlayer = [self loadBackgroundMusic:@"恭喜"];
            playerGrade++;
            playerScore.text = [NSString stringWithFormat:@"%ld",playerGrade];
            matchResult.text = [NSString stringWithFormat:@"恭喜💕，你赢了--- %ld : %ld",computerGrade,playerGrade];
            
            //动画图片
            gifPath = [[NSBundle mainBundle] pathForResource:@"image1@2x" ofType:@"gif"];
        }
        
        for (int i=0; i<2; i++)
        {
            UIImageView *tempGiftImage = [UIImageView imageViewWithGIFFile:gifPath frame:CGRectMake(10+i*(kDeviceWidth-100), playBtn.top, 80, 80)];
            
            if (i==0)
            {
                gifImageLeft = tempGiftImage;
            }
            else
            {
                tempGiftImage.left = kDeviceWidth-90;
                gifImageRight = tempGiftImage;
            }
            [bottomView addSubview:tempGiftImage];
        }
        
        
        [_resultPlayer setNumberOfLoops:1];
        [_resultPlayer play];
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
        matchResult.text = [NSString stringWithFormat:@"🌹 双方比值：%ld : %ld 🌹",computerGrade,playerGrade];
        playBtn.top = kDeviceHeight;
        gifImageLeft.top = playBtn.top;
        gifImageRight.top = playBtn.top;
        
        for (int i=0; i<3; i++)
        {
            CommonImage *gestureImage = (CommonImage *)[bottomView viewWithTag:100+i];
            gestureImage.top = 0;
        }
    }];
    
    UIImageView *animateImage1 = (UIImageView *)[self.view viewWithTag:10];
    UIImageView *animateImage2 = (UIImageView *)[self.view viewWithTag:11];
    [animateImage1 startAnimating];
    [animateImage2 startAnimating];
}

//加载背景音乐
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
