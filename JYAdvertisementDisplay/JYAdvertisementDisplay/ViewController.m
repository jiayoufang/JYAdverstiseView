//
//  ViewController.m
//  JYAdvertisementDisplay
//
//  Created by fangjiayou on 15/7/30.
//  Copyright (c) 2015年 方. All rights reserved.
//

#import "ViewController.h"
#import "JYAdvertiseView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JYAdvertiseView *advertiseView = [[JYAdvertiseView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 150)];
    advertiseView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:advertiseView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
