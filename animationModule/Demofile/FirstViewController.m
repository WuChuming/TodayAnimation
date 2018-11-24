//
//  FirstViewController.m
//  animationModule
//
//  Created by WuChuMing on 2018/11/21.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "UIViewController+TodayAnimation.h"
#import "DemoTableViewCell.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *TdataArr;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    普通的按键方式
//   _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 500)];
//    _bgView.backgroundColor = [UIColor grayColor];
//
//
//    _imgV = [[UIImageView alloc] init];
//    _imgV.frame = CGRectMake(0, 0, 750/4, 810/4);
//    _imgV.image = [UIImage imageNamed:@"test"];
//    _imgV.center = CGPointMake(_bgView.frame.size.width/2, _bgView.frame.size.height/2);
//    [_bgView addSubview:_imgV];
//
//    [self.view addSubview:_bgView];
//    //[imgV setAnimation];
//
//    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(CGRectGetMinX(_imgV.frame), CGRectGetMaxY(_imgV.frame)+ 10, CGRectGetWidth(_imgV.frame), 50);
//    button.backgroundColor = [UIColor grayColor];
//    [button setTitle:@"push动画" forState:0];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    [_bgView addSubview:button];
    // Do any additional setup after loading the view.
    
//    TableView的Cell方式
    [self.view addSubview:self.myTableView];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[DemoTableViewCell class] forCellReuseIdentifier:@"DemoTableViewCell"];
    
    
}

//- (void) buttonClick:(UIButton *)sender{
//
//    SecondViewController *VC2 = [[SecondViewController alloc] init];
//    [self setTodayPushAnimationWithFromImgView:_imgV toImgView:VC2.headerImageView];
//    [UIView animateWithDuration:0.2 animations:^{
//         self.bgView.transform = CGAffineTransformMakeScale(0.9, 0.9);
//    } completion:^(BOOL finished) {
//       [self.navigationController pushViewController:VC2 animated:YES];
//    }];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.TdataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"DemoTableViewCell"];
    if (!cell) {
        cell = [[DemoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DemoTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.TdataArr[indexPath.section];
    return cell;
}

#pragma mark ------TableView----
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.rowHeight = 500;
    }
    return _myTableView;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (NSMutableArray *)TdataArr{
    if (!_TdataArr) {
        _TdataArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    }
    return _TdataArr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    SecondViewController *VC2 = [[SecondViewController alloc] init];
    
//    自定义的push
    [self DD_pushToViewController:VC2 fromView:cell toView:VC2.myTableView];
    
//    正常的push
//    [self.navigationController pushViewController:VC2 animated:YES];
    
}

@end
