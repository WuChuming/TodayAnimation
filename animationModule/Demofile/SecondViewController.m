//
//  SecondViewController.m
//  animationModule
//
//  Created by WuChuMing on 2018/11/21.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import "SecondViewController.h"
#import "UIViewController+TodayAnimation.h"
#import "DemoTableViewCell.h"
#import "NormalViewCell.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *TdataArr;

@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.myTableView.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setHidden:YES];
//    [self.navigationController.navigationBar setTranslucent:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame  = CGRectMake(0, 0, 100, [UINavigationBar appearance].frame.size.height);
    button.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.TdataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    if (!cell) {
        cell = [[NormalViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normal"];
        
    }
//    cell.imageView.image = [UIImage imageNamed:@"test"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = self.TdataArr[indexPath.row];
    return cell;
}
#pragma mark ------TableView----
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.rowHeight = 120;
        _myTableView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.edgesForExtendedLayout = UIRectEdgeAll;
        _myTableView.frame = CGRectMake(0, self.view.frame.origin.y, _myTableView.frame.size.width, _myTableView.frame.size.height);
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (NSMutableArray *)TdataArr{
    if (!_TdataArr) {
        _TdataArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",nil];
    }
    return _TdataArr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self DD_popViewController];
}

@end
