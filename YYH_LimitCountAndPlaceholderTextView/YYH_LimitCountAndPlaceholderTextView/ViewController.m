//
//  ViewController.m
//  YYH_LimitCountAndPlaceholderTextView
//
//  Created by 杨昱航 on 2017/6/13.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = CGRectMake(5, 230, [UIScreen mainScreen].bounds.size.width-10, 80);
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    textView.layer.borderWidth = 1;
    textView.font = [UIFont systemFontOfSize:14];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.YYH_placeHolder = @"向厂家反馈同业相关活动、产品信息、用于市场分析。";
    textView.YYH_limitCount=30;
    textView.YYH_placeHolderColor = [UIColor redColor];
    [self.view addSubview:textView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
