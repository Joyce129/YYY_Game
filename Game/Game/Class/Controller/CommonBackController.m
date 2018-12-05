

//
//  CommonBackController.m
//  石头剪子布
//
//  Created by aaa on 16/1/22.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import "CommonBackController.h"
#import "CommonButton.h"

@interface CommonBackController ()

@end

@implementation CommonBackController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CommonButton *backBtn = [[CommonButton alloc]initWithFrame:CGRectMake(0, 30, 65*0.65, 62*0.65) imageStr:@"back"];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    // Do any additional setup after loading the view.
}

//返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
