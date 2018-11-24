//
//  UIViewController+TodayAnimation.h
//  animationModule
//
//  Created by WuChuMing on 2018/11/21.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TodayAnimation)<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate>

/**
 自定义的动画过渡push（仿APPStore效果）

 @param VC push的VC
 @param fromV 点击的View
 @param toV 下一个VC的view，最好是Tableview(tableView必须使用懒加载，而且加载的时候就被add到VC的view上)
 */
- (void)DD_pushToViewController:(UIViewController *)VC fromView:(UIView *)fromV toView:(UITableView *)toV;

/**
 自定义动画过渡Pop
 */
- (void)DD_popViewController;

@end

NS_ASSUME_NONNULL_END
