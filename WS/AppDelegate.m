//
//  AppDelegate.m
//  WS
//
//  Created by gwzd on 14-4-1.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDBClass.h"
#import "UserInfo.h"



@interface AppDelegate()<LoginViewControllerDelegate>

@end

@implementation AppDelegate

- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSLog(@"Language Code is %@", [currentLocale objectForKey:NSLocaleLanguageCode]);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.backgroundColor = [UIColor whiteColor];
    //适配6 7
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];
//    self.window.clipsToBounds = YES;
//    if ( [[UIDevice currentDevice].systemVersion floatValue]>= 7.0) {
//        self.window.frame =  CGRectMake(0,20,_window.frame.size.width,_window.frame.size.height - 20);//空出20px，将状态栏给单独显示出来
//    }

//    [[FMDBClass shareInstance]init];
    
   
    NSString *useridstr = [[NSUserDefaults standardUserDefaults]objectForKey:PROID];
    if (useridstr.length != 0) {
        [UserInfo shareInstance].userId = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
        [UserInfo shareInstance].userName = [[NSUserDefaults standardUserDefaults]objectForKey:USERNAME];
        [UserInfo shareInstance].passWord = [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
        [UserInfo shareInstance].companyName = [[NSUserDefaults standardUserDefaults]objectForKey:COMPANYNAME];
        [UserInfo shareInstance].emailStr = [[NSUserDefaults standardUserDefaults]objectForKey:EMAILSTR];
        [UserInfo shareInstance].phoneStr = [[NSUserDefaults standardUserDefaults]objectForKey:PHONESTR];
        [UserInfo shareInstance].project_current_Id = [[NSUserDefaults standardUserDefaults]objectForKey:PROID];
        [UserInfo shareInstance].project_current_name = [[NSUserDefaults standardUserDefaults]objectForKey:PRONAME];
        [self initTabBarViewController];
        
    }else{
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝第一次登录＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝");
        
        NSString *lauStr = [self getPreferredLanguage];
        if ([lauStr isEqualToString:@"en"]) {
            
        }
        
         LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:[lauStr isEqualToString:@"en"] ?@"LoginViewController_en": @"LoginViewController" bundle:nil];
        loginVC.delegate = self;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = nc;
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initTabBarViewController{
    
//    self.rootTabBarViewController = [[UITabBarController alloc] init];
//    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
//    ReseachEvaluationViewController *resEvaVC = [[ReseachEvaluationViewController alloc]initWithNibName:@"ReseachEvaluationViewController" bundle:nil];
//    OnlineServiceViewController *onlineSerVC = [[OnlineServiceViewController alloc]initWithNibName:@"OnlineServiceViewController" bundle:nil];
//    FeedbackProViewController *feedProVC = [[FeedbackProViewController alloc]initWithNibName:@"FeedbackProViewController" bundle:nil];
//    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
//    NSArray *vcArr = @[feedbackVC,resEvaVC,onlineSerVC,feedProVC,searchVC];
//    NSArray *titleArr = @[@"反馈信息",@"调研评价",@"在线客服",@"反馈问题",@"搜索"];
//    NSMutableArray *ncArr = [[NSMutableArray alloc]init];
//    for (int i = 0; i < vcArr.count; i++) {
//        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:[vcArr objectAtIndex:i]];
//        nc.tabBarItem.title = [titleArr objectAtIndex:i];
//        UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"home_tab_icon_%d",i+1]];
//        UIImage *seleImage = [UIImage imageNamed:[NSString stringWithFormat:@"home_tab_icon_%d",i+1]];
//        [nc.tabBarItem setFinishedSelectedImage:normalImage withFinishedUnselectedImage:seleImage];
//        [ncArr addObject:nc];
//    }
//    self.rootTabBarViewController.viewControllers = ncArr;
//    self.window.rootViewController = self.rootTabBarViewController;
    
   
    NSString *xibName;
    if (IPHONE5) {
        if ([[self getPreferredLanguage] isEqualToString:@"en"]) {
            xibName = @"SeleViewController_en";
        }else{
            xibName = @"SeleViewController";
        }
    }else{
        if ([[self getPreferredLanguage] isEqualToString:@"en"]) {
            xibName = @"SeleViewController_3.5"; ////
        }else{
            xibName = @"SeleViewController_3.5";
        }
    }
    
    SeleViewController *seleVC = [[SeleViewController alloc]initWithNibName:xibName bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:seleVC];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];

   
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -- WXLoginViewControllerDelegate
- (void)loginSuccessViewController:(LoginViewController *)loginViewController withResponse:(id)response
{
    [self initTabBarViewController];
}
- (void)loginFailViewController:(LoginViewController *)loginViewController withError:(NSError *)error;
{
    
}
@end
