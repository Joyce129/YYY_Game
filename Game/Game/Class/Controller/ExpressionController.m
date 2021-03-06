

//
//  ExpressionController.m
//  石头剪子布
//
//  Created by aaa on 16/1/21.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import "ExpressionController.h"
#import "CalculatorController.h"

#import "CommonImage.h"
#import "CommonButton.h"
#import "CommonLabel.h"
#import "YYYFlashView.h"

@interface ExpressionController ()
{
    NSMutableArray *imagesArray;
    NSMutableArray *faceGifArray;
    YYYFlashView *flashView;
}
@end

@implementation ExpressionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    CommonImage *bgImage = [[CommonImage alloc]initWithFrame:[UIScreen mainScreen].bounds imageStr:@"faceBg"];
    self.view = bgImage;
    
    CommonButton *backBtn = [[CommonButton alloc]initWithFrame:CGRectMake(5, 64, 65*0.65, 63*0.65) imageStr:@"back"];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    imagesArray = [NSMutableArray arrayWithObjects:@"00@2x",@"11@2x",@"22@2x",@"33@2x",@"44@2x",@"55@2x",@"66@2x",@"77@2x",@"88@2x",@"99@2x", nil];
    faceGifArray = [NSMutableArray array];
    
    //初始化子视图
    [self initSubViews];
    
    //动态文字
    [self dynamicExpression];
    // Do any additional setup after loading the view.
}

//返回
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//初始化子视图
-(void)initSubViews
{
    CGFloat width = kDeviceWidth/2.0;
    
    for (NSInteger i=0; i<imagesArray.count; i++)
    {
        NSInteger row = i/2;
        NSInteger col = i%2;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imagesArray[i] ofType:@"gif"];
        
        UIImageView *faceImage = [UIImageView imageViewWithGifFile:path frame:CGRectMake(0,0, 60, 60)];
        [faceImage setCenter:CGPointMake((col*width)+width/2.0, 170+row*90)];
        faceImage.userInteractionEnabled = YES;
        faceImage.backgroundColor = [UIColor clearColor];
        [faceGifArray addObject:faceImage];
        [self.view addSubview:faceImage];
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction)];
        [faceImage addGestureRecognizer:tapImage];
    }
    
    NSArray *array = @[@"二列",@"三列",@"四列",@"五列"];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.layer.masksToBounds = YES;
    segment.layer.borderColor = [UIColor yellowColor].CGColor;
    segment.layer.cornerRadius = 15;
    segment.layer.borderWidth = 1;
    
    [segment setBackgroundImage:[UIImage imageNamed:@"segmentBg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segment setBackgroundImage:[UIImage imageNamed:@"bgImage"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [segment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Verdana-BoldItalic" size:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [segment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor brownColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-BoldOblique" size:15],NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    segment.frame = CGRectMake((kDeviceWidth-200)/2.0, 64, 200, 40);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
}

//UISegmentedControl
-(void)segmentAction:(UISegmentedControl *)segmentControl
{
    NSInteger index = segmentControl.selectedSegmentIndex + 2;
    CGFloat width = kDeviceWidth/index;
    
    for (NSInteger i=0; i<imagesArray.count; i++)
    {
        NSInteger row = i/index;
        NSInteger col = i%index;
        
        UIImageView *tempFaceImage = faceGifArray[i];
        CGPoint center = CGPointMake((col*width)+width/2.0, 200+row*90);
        [tempFaceImage setCenter:center];
    }
}

//点击表情
-(void)imageAction
{
    CalculatorController *calculator = [[CalculatorController alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:calculator animated:YES];
}
//动态文本
-(void)dynamicExpression
{
    CGRect rect = CGRectMake(0,kDeviceHeight-80, self.view.frame.size.width, 50);
    flashView = [[YYYFlashView alloc] initWithFrame:rect];
    flashView.innerEdgeGap = 10.f;
    flashView.repeatCount = 0;
    flashView.speed = YYYFlashSpeedFast;
    NSString *str = @"💖  2018动画表情大赛  💖";
    flashView.text = str;
    flashView.font = [UIFont systemFontOfSize:22];
    flashView.textColor = [UIColor purpleColor];
    [flashView reloadView];
    [self.view addSubview:flashView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
