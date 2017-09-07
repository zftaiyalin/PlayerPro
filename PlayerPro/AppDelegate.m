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
    
    
    UMConfigInstance.appKey = @"594a798f1061d2671d000ae4";/*打乱代码结构*/
    UMConfigInstance.channelId = @"App Store";/*打乱代码结构*/
    [MobClick startWithConfigure:UMConfigInstance];/*打乱代码结构*//*打乱代码结构*///配置以上参数后调用此方法初始化SDK！
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];/*打乱代码结构*//*打乱代码结构*/
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];/*打乱代码结构*//*打乱代码结构*/
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];/*打乱代码结构*//*打乱代码结构*/
    NSError *error = nil;/*打乱代码结构*/
    
    NSString *ss = [NSString stringWithFormat:@"http://opmams01o.bkt.clouddn.com/playerPro.json?v=%@",currentDateString];/*打乱代码结构*//*打乱代码结构*/
    NSURL *xcfURL = [NSURL URLWithString:ss];/*打乱代码结构*//*打乱代码结构*/
    NSString *htmlString = [NSString stringWithContentsOfURL:xcfURL encoding:NSUTF8StringEncoding error:&error];/*打乱代码结构*//*打乱代码结构*/
    AppModel *model;/*打乱代码结构*/
    if (htmlString == nil) {
        model =[[AppModel alloc]init];/*打乱代码结构*//*打乱代码结构*/
        model.wetchat.isShow= NO;/*打乱代码结构*/
    }else{
        model = [AppModel yy_modelWithJSON:htmlString];/*打乱代码结构*//*打乱代码结构*/
    }
    
    
    AppUnitl.sharedManager.model = model;/*打乱代码结构*/
    AppUnitl.sharedManager.isDownLoad = YES;/*打乱代码结构*/
   
//    AppUnitl.sharedManager.model.wetchat.isShow= NO;/*打乱代码结构*/
 
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"mycollection"];/*打乱代码结构*//*打乱代码结构*/
    
    if (data == nil) {
        NSMutableArray *array = [NSMutableArray array];/*打乱代码结构*//*打乱代码结构*/
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:array];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:@"mycollection"];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/
    }
    
    
    
    NSString *jifen = [[NSUserDefaults standardUserDefaults] objectForKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
    
    if (jifen == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"myintegral"];/*打乱代码结构*//*打乱代码结构*/
        [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*//*打乱代码结构*/
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];/*打乱代码结构*//*打乱代码结构*/
    
    
    SearchViewController *firstViewController = [[SearchViewController alloc] init];/*打乱代码结构*//*打乱代码结构*/
    firstViewController.hidesBottomBarWhenPushed = NO;/*打乱代码结构*/
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:firstViewController];/*打乱代码结构*//*打乱代码结构*/
    
    WifiViewController *secondViewController =  [[WifiViewController alloc]init];/*打乱代码结构*//*打乱代码结构*/
    secondViewController.hidesBottomBarWhenPushed = NO;/*打乱代码结构*/
    UINavigationController *secondNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:secondViewController];/*打乱代码结构*//*打乱代码结构*/
    
    MineViewController *thirdViewController =  [[MineViewController alloc] init];/*打乱代码结构*//*打乱代码结构*/
    thirdViewController.hidesBottomBarWhenPushed = NO;/*打乱代码结构*/
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:thirdViewController];/*打乱代码结构*//*打乱代码结构*/
    
    
    UIColor *unSelectedTabBarTitleTextColor = [UIColor colorWithRed:114.0/255.0 green:115.0/255.0 blue:116.0/255.0 alpha:1.0f];/*打乱代码结构*//*打乱代码结构*/
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:unSelectedTabBarTitleTextColor
                                                       ,NSForegroundColorAttributeName ,[UIFont systemFontOfSize:26], NSFontAttributeName, nil]
                                             forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor]
                                                       ,NSForegroundColorAttributeName,[UIFont systemFontOfSize:26], NSFontAttributeName, nil]
                                             forState:UIControlStateSelected];/*打乱代码结构*//*打乱代码结构*/
    NSArray *titles = @[@"主页", @"搜索", @"更多"];/*打乱代码结构*//*打乱代码结构*/
    NSArray *images = @[@"souye", @"shousuo", @"wod"];/*打乱代码结构*//*打乱代码结构*/
    
    self.mainVC = [[UITabBarController alloc] init];/*打乱代码结构*//*打乱代码结构*/
    
    self.mainVC.viewControllers = @[secondNavigationController, firstNavigationController , thirdNavigationController];/*打乱代码结构*//*打乱代码结构*/
    
    [self.mainVC.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [images objectAtIndex:idx]]];/*打乱代码结构*//*打乱代码结构*/
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_unselected",
                                                        [images objectAtIndex:idx]]];/*打乱代码结构*//*打乱代码结构*/
        [item setTitle:titles[idx]];/*打乱代码结构*//*打乱代码结构*/
        [item setImage:[unselectedimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];/*打乱代码结构*//*打乱代码结构*/
        [item setSelectedImage:[selectedimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];/*打乱代码结构*//*打乱代码结构*/
        
    }];/*打乱代码结构*//*打乱代码结构*/
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:10]}   forState:UIControlStateNormal];/*打乱代码结构*//*打乱代码结构*/
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];/*打乱代码结构*//*打乱代码结构*/
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];/*打乱代码结构*//*打乱代码结构*/
    UITabBar *tabBar = self.mainVC.tabBar;/*打乱代码结构*/
    //修改字体颜色
    tabBar.tintColor = [UIColor redColor];/*打乱代码结构*//*打乱代码结构*/
    
    self.mainVC.tabBar.translucent = NO;/*打乱代码结构*/
    
    
    
    self.window.rootViewController = self.mainVC;/*打乱代码结构*/
    
    [self.window makeKeyAndVisible];/*打乱代码结构*//*打乱代码结构*/
    return YES;/*打乱代码结构*/
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
    // Called as part of the transition from the background to the active state;/*打乱代码结构*/ here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
