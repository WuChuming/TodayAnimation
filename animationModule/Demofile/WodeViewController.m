//
//  WodeViewController.m
//  animationModule
//
//  Created by WuChuMing on 2018/11/23.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import "WodeViewController.h"

@interface WodeViewController ()

@end

@implementation WodeViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
}



@end
