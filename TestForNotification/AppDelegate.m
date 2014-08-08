//
//  AppDelegate.m
//  TestForNotification
//
//  Created by dshy1234 on 14-8-6.
//  Copyright (c) 2014年 redcdn. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  // Required
  [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)];
  // Required
  [APService setupWithOption:launchOptions];
  
  
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  
  [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
  [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
  [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
  [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
  [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
  
  NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (dictionary != nil)
  {
    NSString *title = [dictionary valueForKey:@"title"];
    NSString *content = [dictionary valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"收到电话" message:[NSString stringWithFormat:@"收到电话\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content] delegate:nil cancelButtonTitle:@"接听" otherButtonTitles:@"拒绝", nil];
    [alertView show];
  }

  
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  // Required
  [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  
  // Required
  [APService handleRemoteNotification:userInfo];
  
  
  
  
  NSString *title = [userInfo valueForKey:@"title"];
  NSString *content = [userInfo valueForKey:@"content"];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
  UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"收到电话" message:[NSString stringWithFormat:@"收到电话\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content] delegate:nil cancelButtonTitle:@"接听" otherButtonTitles:@"拒绝", nil];
  [alertView show];
  
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  
  // IOS 7 Support Required
  [APService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
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

#pragma mark -

- (void)networkDidSetup:(NSNotification *)notification {
  NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
  NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
  NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
  NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
   
  NSDictionary * userInfo = [notification userInfo];
  NSString *title = [userInfo valueForKey:@"title"];
  NSString *content = [userInfo valueForKey:@"content"];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
  UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"收到电话" message:[NSString stringWithFormat:@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
  [alertView show];
}


@end
