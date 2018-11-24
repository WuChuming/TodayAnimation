//
//  UIViewController+TodayAnimation.m
//  animationModule
//
//  Created by WuChuMing on 2018/11/21.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import "UIViewController+TodayAnimation.h"
#import <objc/runtime.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
/** StatusBar 高度 */
#define dd_kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
/**NavigationBar的高度*/
#define dd_kNavigationBarHeight ([UINavigationBar appearance].frame.size.height==0?44:[UINavigationBar appearance].frame.size.height)
/**导航的高度（包含上面20高度）*/
#define dd_kNavigationHeight (dd_kStatusBarHeight + dd_kNavigationBarHeight)

#define K_Scale 0.8
#define shrinkRate 0.9

@interface UIViewController()

@property (copy, nonatomic) NSString *A_isPushAnimation;

@property (strong, nonatomic) UIView *A_fromImgV;

@property (strong, nonatomic) NSNumber *A_previous_navH;

@property (nonatomic, strong) UIView *A_toImgV;

@property (nonatomic, strong) UITableView *A_tableView;
//手势参数
@property (nonatomic, strong) NSNumber *A_startPointY;
@property (nonatomic, strong) NSNumber *A_startPointX;
@end

@implementation UIViewController (TodayAnimation)

static BOOL isHorizontal = NO;
static CGFloat startPointY = 0;
static CGFloat startPointX = 0;
static CGFloat scale = 0;
static CGFloat v_width = 0;
static CGFloat v_height = 0;


- (void)DD_pushToViewController:(UIViewController *)VC fromView:(UIView *)fromV toView:(UITableView *)toV{
    [self setTodayPushAnimationWithFromView:fromV toView:toV];
    [UIView animateWithDuration:.3f delay:0 usingSpringWithDamping:5.f initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
    fromV.transform = CGAffineTransformMakeScale(shrinkRate,shrinkRate);
    } completion:^(BOOL finished) {
     fromV.transform = CGAffineTransformIdentity;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}

- (void)DD_popViewController{
    [self setTodayPopAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTodayPushAnimationWithFromView:(UIView *)fromV toView:(UITableView *)toV{
    self.navigationController.delegate = self;
    self.A_fromImgV = fromV;
    self.A_toImgV = toV;
    self.A_isPushAnimation = @"1";
}

- (void)setTodayPopAnimation{
    self.navigationController.delegate = self;
    self.A_isPushAnimation = @"0";
}
#pragma mark - UIViewControllerAnimatedTransitioning
// MARK: 设置代理
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self;
}

// MARK: 设置动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([self.A_isPushAnimation isEqualToString:@"1"]) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = self.A_toImgV;
        UIView *fromView = self.A_fromImgV;
        UIView *containerView = [transitionContext containerView];
        UIImageView *snapShotView = [[UIImageView alloc]initWithImage:[self screenShotView:self.A_toImgV]];
//       开始的Frame
        CGRect originFrame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    
        snapShotView.frame = originFrame;
        snapShotView.contentMode = UIViewContentModeScaleToFill;
        snapShotView.clipsToBounds = YES;
        fromView.hidden = YES;
        
        CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = toFrame;
        //给push的视图添加磨砂玻璃效果
        // 背景毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//      添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        toVC.view.userInteractionEnabled = YES;
        [toView addGestureRecognizer:pan];
        v_width = toVC.view.frame.size.width;
        v_height = toVC.view.frame.size.height;
        pan.delegate = self;
         NSLog(@"----to------>%@--->%@",[self findSuperViewController:toView],toVC);
        toView.hidden = YES;
        toVC.view.alpha = 0.f;
        [containerView addSubview:toVC.view];
        [containerView  addSubview:effectView];
        [containerView addSubview:snapShotView];
        [containerView layoutIfNeeded];
//    导航栏
        UINavigationBar *nav_bar = self.navigationController.navigationBar;
        self.A_previous_navH = @(nav_bar.frame.origin.y);
        NSLog(@"---height-->%f",nav_bar.frame.origin.y);
        
        CGFloat origin_height = originFrame.size.height;
        CGFloat center_y = originFrame.origin.y + origin_height/2;
        CGFloat curentPosition = center_y - toFrame.size.height/2;
        CGFloat m_curentPosition = curentPosition>0?curentPosition:-curentPosition;
        CGFloat animationrate = m_curentPosition*0.25/toFrame.size.height;
        NSLog(@"--pushRate-->%f-->%f",toFrame.size.height,animationrate);
//        动画开始
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.5+animationrate initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [containerView layoutIfNeeded];
                toVC.view.alpha = 1.0f;
                UITabBar*tabBar = self.tabBarController.tabBar;
                if (IPHONE_X) {
                    tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 83);
                } else {
                    tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49);
                }
                nav_bar.frame = CGRectMake(0, -dd_kNavigationHeight, SCREEN_WIDTH, dd_kNavigationHeight);
                [self setNeedsStatusBarAppearanceUpdate];
                snapShotView.frame = CGRectMake(toView.frame.origin.x, toView.frame.origin.y, toFrame.size.width, toFrame.size.height);
                [containerView convertRect:toView.frame fromView:toView.superview];
                [toVC.view sendSubviewToBack:effectView];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f animations:^{
                } completion:^(BOOL finished) {
                    toView.hidden = NO;
                    fromView.hidden = NO;
                    snapShotView.alpha = 0;
                    effectView.alpha = 0;
                    [effectView removeFromSuperview];
                    [snapShotView removeFromSuperview];
//                   设置模板
              UIImageView *tsnapShotView = [[UIImageView alloc]initWithImage:[self screenShotView:[self findSuperViewController:self.A_fromImgV].view]];
                    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                    tsnapShotView.frame = toVC.view.bounds;
                    [toVC.view addSubview:tsnapShotView];
                    // 背景毛玻璃
                    UIBlurEffect *effect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                    UIVisualEffectView *effectView2 = [[UIVisualEffectView alloc] initWithEffect:effect2];
                    effectView2.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
                    [toVC.view insertSubview:effectView2 atIndex:0];
                    [toVC.view insertSubview:tsnapShotView atIndex:0];
                }];
            }];
    } else {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        UIView *fromView = toVC.A_toImgV;
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        UIView *originView = toVC.A_fromImgV;
        UIView *snapShotView = [[UIImageView alloc]initWithImage:[self screenShotView:originView]];
        snapShotView.layer.masksToBounds = YES;
        snapShotView.layer.cornerRadius = 15;
        snapShotView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
        fromView.hidden = YES;
        originView.hidden = YES;
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
        [containerView addSubview:snapShotView];
       __block UINavigationBar *nav_bar = self.navigationController.navigationBar;
        nav_bar.frame = CGRectMake(0, -dd_kNavigationHeight, SCREEN_WIDTH, dd_kNavigationHeight);
        
        //       开始的Frame
        CGRect originFrame = [containerView convertRect: toVC.A_fromImgV.frame fromView:toVC.A_fromImgV.superview];
//        CGRect toFrame = [containerView convertRect: toVC.A_toImgV.frame fromView:toVC.view];
        
        CGFloat origin_height = originFrame.size.height;
        CGFloat center_y = originFrame.origin.y + origin_height/2;
        CGFloat curentPosition = center_y - SCREEN_HEIGHT/2;
        CGFloat m_curentPosition = curentPosition>0?curentPosition:-curentPosition;
        CGFloat animationrate = m_curentPosition*0.25/SCREEN_HEIGHT;
        NSLog(@"--popRate-->%f",animationrate);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.72f+animationrate initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [containerView layoutIfNeeded];
            fromVC.view.alpha = 0.0f;
            snapShotView.layer.cornerRadius = 15;
           [self setNeedsStatusBarAppearanceUpdate];
            snapShotView.frame = [containerView convertRect:originView.frame fromView:originView.superview];

            CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
            CGFloat status_y = statusFrame.origin.y;
            NSLog(@"---status_y---->%f",status_y);
            
            UITabBar *tabBar = (UITabBar *)self.tabBarController.tabBar;
            if (IPHONE_X) {
                tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-83, SCREEN_WIDTH, 83);
            } else {
                tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
            }
            nav_bar.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH, 44);
            NSLog(@"----height--->%f", nav_bar.frame.origin.y);
        } completion:^(BOOL finished) {
            fromView.hidden = YES;
            [snapShotView removeFromSuperview];
            originView.hidden = NO;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}


#pragma mark - 下拉缩小，跳转

- (void)pan:(UIPanGestureRecognizer *)pan {
    if ([pan.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll_view = (UIScrollView *)pan.view;
        if (scroll_view.contentOffset.y == 0) {
        switch (pan.state) {
            case UIGestureRecognizerStateBegan: {   // 手势开始
                CGPoint currentPoint =[pan locationInView:pan.view];
                startPointY = currentPoint.y;
                startPointX = currentPoint.x;
                // 确定是否可以横划，判断起始点位置
                if (startPointX>30) {
                    isHorizontal = NO;
                } else {
                    isHorizontal = YES;
                }
            } break;
            case UIGestureRecognizerStateChanged: { // 手势状态改变
                CGPoint currentPoint =[pan locationInView:pan.view];
                // 如果可以横划，判断是横划还是竖划
                if (isHorizontal) {
                    if ((currentPoint.x-startPointX)>(currentPoint.y-startPointY)) {
                        scale = (v_width-(currentPoint.x-startPointX))/v_width;
                    } else {
                        scale = (v_height-(currentPoint.y-startPointY))/v_height;
                    }
                } else {
                    scale = (v_height-(currentPoint.y-startPointY))/v_height;
                }
                NSLog(@"----scale----->%f",scale);
                UIViewController *cVC = [self findSuperViewController:pan.view];
                if (scale > 1.0f) {
                    scale = 1.0f;
                } else if (scale <=K_Scale) {
                    scale = K_Scale; dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [cVC setTodayPopAnimation];
                        [cVC.navigationController popViewControllerAnimated:YES];
                    });
                }
                if (self.A_toImgV) {
                    NSLog(@"-------toV-->%@",self.A_toImgV);
                    self.A_toImgV.layer.cornerRadius = 50 - (25*scale);
                    self.A_toImgV.layer.masksToBounds = YES;
                    self.A_toImgV.transform = CGAffineTransformMakeScale(scale, scale);
                }
            } break;
            case UIGestureRecognizerStateEnded:  { // 手势结束
                NSLog(@"手势结束");
                scale = 1;
                if (scale>K_Scale) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.A_toImgV.transform = CGAffineTransformIdentity;
                    }];
                }
                
            }  break;
            default:
                break;
        }
        }
    }
}

//截图
-(UIImage *)screenShotView:(UIView *)view{
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark 获得当前view的控制器
- (UIViewController *)findSuperViewController:(UIView *)view
{
    UIResponder *responder = view;
    // 循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

// TODO: 即将进入高亮状态
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
            cell.transform = CGAffineTransformMakeScale(shrinkRate, shrinkRate);
    }];
    return YES;
}

// TODO: 结束高亮状态
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark ----添加属性------
//跟类别添加属性
//定义常量 必须是C语言字符串
static char *isPushAnimation_key = "isPushAnimation_key";
static char *fromImgV_key = "fromImgV_key";
static char *A_toImgV_key = "A_toImgV_key";
static char *previous_navH_key = "previous_navH_key";
static char *A_tableView_key = "A_tableView_key";

//手势的参数
static char *A_startPointY_key = "A_startPointY_key";
static char *A_startPointX_key = "A_startPointX_key";

- (void)setA_tableView:(UITableView *)A_tableView{
    objc_setAssociatedObject(self, A_tableView_key, A_tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UITableView *)A_tableView{
     return objc_getAssociatedObject(self, A_tableView_key);
}

- (void)setA_toImgV:(UIView *)A_toImgV{
   objc_setAssociatedObject(self, A_toImgV_key, A_toImgV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)A_toImgV{
    return objc_getAssociatedObject(self, A_toImgV_key);
}
- (void)setA_fromImgV:(UIView *)A_fromImgV{
     objc_setAssociatedObject(self, fromImgV_key, A_fromImgV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)A_fromImgV{
    return objc_getAssociatedObject(self, fromImgV_key);
}

- (void)setA_isPushAnimation:(NSString *)A_isPushAnimation{
    objc_setAssociatedObject(self, isPushAnimation_key, A_isPushAnimation,OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)A_isPushAnimation{
     return objc_getAssociatedObject(self, isPushAnimation_key);
}

- (void)setA_previous_navH:(NSNumber *)A_previous_navH{
    objc_setAssociatedObject(self, previous_navH_key, A_previous_navH, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)A_previous_navH{
  return objc_getAssociatedObject(self, previous_navH_key);
}

// 手势参数
- (void)setA_startPointX:(NSNumber *)A_startPointX{
     objc_setAssociatedObject(self, A_startPointX_key, A_startPointX, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)A_startPointX{
    return objc_getAssociatedObject(self, A_startPointX_key);
}

- (void)setA_startPointY:(NSNumber *)A_startPointY{
    objc_setAssociatedObject(self, A_startPointY_key, A_startPointY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)A_startPointY{
    return objc_getAssociatedObject(self, A_startPointY_key);
}

@end
