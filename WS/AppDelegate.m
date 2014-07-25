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



@interface AppDelegate()


@end

@implementation AppDelegate

- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
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
        
    }
    NSString *xibName;
    if (IPHONE5) {
        if ([[self getPreferredLanguage] isEqualToString:@"en"]) {
            xibName = @"LoginViewController_en";
        }else{
            xibName = @"LoginViewController";
        }
    }else{
        if ([[self getPreferredLanguage] isEqualToString:@"en"]) {
            xibName = @"LoginViewController_3.5en";
        }else{
            xibName = @"LoginViewController_3.5";
        }
    }
    
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName: xibName bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = nc;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}




@end
