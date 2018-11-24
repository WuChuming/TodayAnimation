//
//  AppDelegate.m
//  animationModule
//
//  Created by WuChuMing on 2018/11/21.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "WodeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[FirstViewController alloc] init]];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[WodeViewController alloc] init]];
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = @[nav,nav2];
    [self setTabbarItemsWith:tabbar];
    self.window.rootViewController = tabbar;
    return YES;
}

- (void)setTabbarItemsWith:(UITabBarController *)tabVC{
    UITabBar *tabbar = tabVC.tabBar;
    /** 配置tabbar的items */
    [tabbar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *imageName = @"";
        NSString *selectedImageName = @"";
        NSString *title = @"";
        if (idx == 0) {
            /** 消息 */
            imageName = @"HomeTabBar-home-n";
            selectedImageName = @"HomeTabBar-home-y";
            title = @"主页";
        }else if (idx == 1) {
            /** 我的 */
            imageName = @"HomeTabBar-mine-n";
            selectedImageName = @"HomeTabBar-mine-y";
            title = @"我的";
        }
        /** icon */
        obj.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        /** 标题 */
        obj.title = title;
        obj.tag = idx;
        /** 字体属性(设置字体的时候要选择支持中文的字体，不然的话修改字号是无效的) */
        [obj setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName: [UIFont systemFontOfSize:11.f]} forState:UIControlStateNormal];
        [obj setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor], NSFontAttributeName: [UIFont systemFontOfSize:11.f]} forState:UIControlStateSelected];
        /** 字体偏移 */
        obj.titlePositionAdjustment = UIOffsetMake(0.f, 0.f);
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
