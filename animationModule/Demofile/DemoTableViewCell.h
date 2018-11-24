//
//  DemoTableViewCell.h
//  animationModule
//
//  Created by WuChuMing on 2018/11/21.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *TdataArr;

@property (nonatomic, strong) UIView *bgView;
@end

NS_ASSUME_NONNULL_END
