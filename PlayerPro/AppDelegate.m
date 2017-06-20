//
//  AppDelegate.m
//  PlayerPro
//
//  Created by 安风 on 2017/6/20.
//  Copyright © 2017年 安风. All rights reserved.
//

#import "AppDelegate.h"
#import "YYModel.h"
#import "AppModel.h"
#import "SearchViewController.h"
#import "MineViewController.h"
#import "WifiViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    UMConfigInstance.appKey = @"591d390d65b6d63c4c002623";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSError *error = nil;
    
    NSString *ss = [NSString stringWithFormat:@"http://opmams01o.bkt.clouddn.com/videoPlayer.json?v=%@",currentDateString];
    NSURL *xcfURL = [NSURL URLWithString:ss];
    NSString *htmlString = [NSString stringWithContentsOfURL:xcfURL encoding:NSUTF8StringEncoding error:&error];
    AppModel *model;
    if (htmlString == nil) {
        model =[[AppModel alloc]init];
        model.wetchat.isShow= NO;
    }else{
        model = [AppModel yy_modelWithJSON:htmlString];
    }
    
    
    AppUnitl.sharedManager.model = model;
    AppUnitl.sharedManager.isDownLoad = YES;
    //    AppUnitl.sharedManager.model.wetchat.isAlertShow = YES;
    //    AppUnitl.sharedManager.model.wetchat.isShow= YES;
    if (AppUnitl.sharedManager.model.wetchat.isShow) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"pinglun"]) {
            AppUnitl.sharedManager.model.wetchat.isShow = NO;
        }
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"mycollection"];
    
    if (data == nil) {
        NSMutableArray *array = [NSMutableArray array];
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:@"mycollection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    NSString *jifen = [[NSUserDefaults standardUserDefaults] objectForKey:@"myintegral"];
    
    if (jifen == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"myintegral"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    SearchViewController *firstViewController = [[SearchViewController alloc] init];
    firstViewController.hidesBottomBarWhenPushed = NO;
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:firstViewController];
    
    WifiViewController *secondViewController =  [[WifiViewController alloc]init];
    secondViewController.hidesBottomBarWhenPushed = NO;
    UINavigationController *secondNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:secondViewController];
    
    MineViewController *thirdViewController =  [[MineViewController alloc] init];
    thirdViewController.hidesBottomBarWhenPushed = NO;
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:thirdViewController];
    
    
    UIColor *unSelectedTabBarTitleTextColor = [UIColor colorWithRed:114.0/255.0 green:115.0/255.0 blue:116.0/255.0 alpha:1.0f];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:unSelectedTabBarTitleTextColor
                                                       ,NSForegroundColorAttributeName ,[UIFont systemFontOfSize:26], NSFontAttributeName, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor]
                                                       ,NSForegroundColorAttributeName,[UIFont systemFontOfSize:26], NSFontAttributeName, nil]
                                             forState:UIControlStateSelected];
    NSArray *titles = @[@"主页", @"搜索", @"更多"];
    NSArray *images = @[@"souye", @"shousuo", @"wod"];
    
    self.mainVC = [[UITabBarController alloc] init];
    
    self.mainVC.viewControllers = @[secondNavigationController, firstNavigationController , thirdNavigationController];
    
    [self.mainVC.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [images objectAtIndex:idx]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_unselected",
                                                        [images objectAtIndex:idx]]];
        [item setTitle:titles[idx]];
        [item setImage:[unselectedimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[selectedimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:10]}   forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    UITabBar *tabBar = self.mainVC.tabBar;
    //修改字体颜色
    tabBar.tintColor = [UIColor redColor];
    
    self.mainVC.tabBar.translucent = NO;
    
    
    
    self.window.rootViewController = self.mainVC;
    
    [self.window makeKeyAndVisible];
    return YES;
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
