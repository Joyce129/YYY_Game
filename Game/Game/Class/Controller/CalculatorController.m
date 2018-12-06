//
//  CalculatorController.m
//  石头剪子布
//
//  Created by aaa on 16/1/22.
//  Copyright © 2016年 北京筑梦空间网络科技有限公司. All rights reserved.
//

#import "CalculatorController.h"

#import "CommonLabel.h"
#import "CommonTextField.h"
#import "CommonButton.h"
#import "CommonImage.h"

@interface CalculatorController () <UITextFieldDelegate>
{
    NSMutableArray *operatorArray;
}
@end

@implementation CalculatorController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"💖 智能计算器 💖";
    CommonImage *bgImage = [[CommonImage alloc]initWithFrame:[UIScreen mainScreen].bounds imageStr:@"calculatorBG"];
    self.view = bgImage;
    
    operatorArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%c",'+'],[NSString stringWithFormat:@"%c",'-'],[NSString stringWithFormat:@"%c",'*'],[NSString stringWithFormat:@"%c",'/'],[NSString stringWithFormat:@"%c",'%'],nil];
    CGFloat textWidth = (kDeviceWidth-160)/2.0;
    for (int i=0; i<operatorArray.count; i++)
    {
        CommonTextField *leftTextField = [[CommonTextField alloc]initWithFrame:CGRectMake(20, 150+i*95, textWidth, 40)];
        leftTextField.delegate = self;
        leftTextField.tag = 1 + i;
        [self.view addSubview:leftTextField];
        
        CommonLabel *operatorLabel = [[CommonLabel alloc]initWithFrame:CGRectMake(leftTextField.right+10,leftTextField.top, 30, 30) titleStr:operatorArray[i] textColor:[UIColor brownColor] textFont:[UIFont boldSystemFontOfSize:40]];
        operatorLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:operatorLabel];

        CommonTextField *rightTextField = [[CommonTextField alloc]initWithFrame:CGRectMake(operatorLabel.right+10,leftTextField.top ,leftTextField.width,leftTextField.height)];
        rightTextField.tag = 10 + i;
        rightTextField.delegate = self;
        [self.view addSubview:rightTextField];
        
        CommonButton *resultBtn = [[CommonButton alloc]initWithFrame:CGRectMake(kDeviceWidth-70, operatorLabel.top+5, 60, 30) textFlag:YES];
        resultBtn.tag = 100 + i;
        [resultBtn setTitle:operatorLabel.text forState:UIControlStateDisabled];
        [resultBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:resultBtn];
        
        CommonLabel *operatorResult = [[CommonLabel alloc]initWithFrame:CGRectMake(0, resultBtn.bottom+10, kDeviceWidth-5, 30) titleStr:@"" textColor:[UIColor redColor] textFont:[UIFont boldSystemFontOfSize:20]];
        operatorResult.tag = 1000 + i;
        operatorResult.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:operatorResult];
    }
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.view.top = 0;
    [self.view endEditing:YES];
}

//操作结果
-(void)operationAction:(CommonButton *)operatorBtn
{
    if (self.view.top == -170)
    {
        self.view.top = 0;
    }

    NSString *disableString = [operatorBtn titleForState:UIControlStateDisabled];
    
    CommonTextField *leftTextField = (CommonTextField *)[self.view viewWithTag:1+operatorBtn.tag-100];
    CommonTextField *rightTextField = (CommonTextField *)[self.view viewWithTag:10+operatorBtn.tag-100];
    CommonLabel *operatorResult = (CommonLabel *)[self.view viewWithTag:1000+operatorBtn.tag-100];

    if ([leftTextField.text containsString:@"."])
    {
        //小数
        CGFloat leftInteger = [leftTextField.text doubleValue];
        CGFloat rightInteger = [rightTextField.text doubleValue];
        CGFloat resultFloat;
        if ([disableString isEqualToString:@"+"])
        {
            resultFloat = leftInteger + rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.2f ",resultFloat];
        }
        else if ([disableString isEqualToString:@"-"])
        {
            resultFloat = leftInteger - rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.2f ",resultFloat];
        }
        else if ([disableString isEqualToString:@"*"])
        {
            resultFloat = leftInteger * rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.2f ",resultFloat];
        }
        else if ([disableString isEqualToString:@"/"])
        {
            resultFloat = (leftInteger*0.1) / (rightInteger*0.1);
            operatorResult.text = [NSString stringWithFormat:@"%.2f ",resultFloat];
        }
        else
        {
            resultFloat = (NSInteger)leftInteger % (NSInteger)rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.0f ",resultFloat];
        }
    }
    else
    {
        //整数
        NSInteger leftInteger = [leftTextField.text integerValue];
        NSInteger rightInteger = [rightTextField.text integerValue];
        CGFloat resultFloat;
        if ([disableString isEqualToString:@"+"])
        {
            resultFloat = leftInteger + rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.0f",resultFloat];
        }
        else if ([disableString isEqualToString:@"-"])
        {
            resultFloat = leftInteger - rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.0f",resultFloat];
        }
        else if ([disableString isEqualToString:@"*"])
        {
            resultFloat = leftInteger * rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.0f ",resultFloat];
        }
        else if ([disableString isEqualToString:@"/"])
        {
            resultFloat = (leftInteger*0.1) / (rightInteger*0.1);
            operatorResult.text = [NSString stringWithFormat:@"%.2f ",resultFloat];
        }
        else
        {
            resultFloat = leftInteger % rightInteger;
            operatorResult.text = [NSString stringWithFormat:@"%.0f ",resultFloat];
        }
    }
    [self.view endEditing:YES];
}


#pragma mark UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.view.top = 0;
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5 || textField.tag == 12 || textField.tag == 13 || textField.tag == 14)
        {
            self.view.top = -170;
        }
    }];
    return YES;
}

@end
