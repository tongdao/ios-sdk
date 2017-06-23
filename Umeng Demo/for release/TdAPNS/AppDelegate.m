//
//  AppDelegate.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "AppDelegate.h"
#import <TongdaoSDK/TongdaoSDK.h>
//#import "APService.h"
#import "UMessage.h"
#import "DemoTdDataTool.h"
#import "LogSingle.h"
#import "DemoPage1ViewController.h"
#import "DemoPage2ViewController.h"
#import "DemoPage3ViewController.h"
#import "DemoPage4ViewController.h"
#import "DemoPage5ViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIViewController *displayedViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[TongDao sharedManager] initSdkWithAppKey:[[DemoTdDataTool sharedManager] getAppKey]];
    _displayedViewController = self.window.rootViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDisplayedViewControllerByNotification:) name:DISPLAYED_CONTROLLER object:nil];
//     [self registerRemoteNotification];
//     [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    
#ifdef __IPHONE_8_0 //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    //for umneg
    [UMessage startWithAppkey:@"58bfc415f43e4826f3000c43" launchOptions:launchOptions];
    //*************************************
    //for log
    [UMessage setLogEnabled:YES];
    
    [[TongDao sharedManager] initializeWithAppKey:[[DemoTdDataTool sharedManager] getAppKey] userId:nil andDebugMode:true];
    



    return YES;
}
- (void)registerRemoteNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self displayAdvertisementByDeeplink:url];
}

-(void)setDisplayedViewControllerByNotification:(NSNotification*)notification
{
    id obj = [notification object];
    
    if ([obj isKindOfClass:[UIViewController class]]) {
        if (_displayedViewController != nil) {
            [_displayedViewController dismissViewControllerAnimated:NO completion:nil];
            _displayedViewController = nil;
        }
        _displayedViewController = (UIViewController*)obj;
    }
}

-(BOOL)displayAdvertisementByDeeplink:(NSURL*)url
{
    NSString *host = url.host;
    if (host != nil) {
        
        UIViewController *rc = self.window.rootViewController;
        if (rc != nil) {
            
            if (_displayedViewController != nil) {
                [_displayedViewController dismissViewControllerAnimated:NO completion:nil];
                _displayedViewController = nil;
            }
            
            // 解析deeplink的host,根据host来跳转到相关的view controller. eg: taobao://Add_Cart?
            int matchedIndex = 0;
            if ([host isEqualToString:@"page1"]) {
                _displayedViewController = [rc.storyboard instantiateViewControllerWithIdentifier:@"DemoPage1Storyboard"];
                matchedIndex = 1;
            } else if ([host isEqualToString:@"page2"]) {
                _displayedViewController = [rc.storyboard instantiateViewControllerWithIdentifier:@"DemoPage2Storyboard"];
                matchedIndex = 1;
            } else if ([host isEqualToString:@"page3"]) {
                _displayedViewController = [rc.storyboard instantiateViewControllerWithIdentifier:@"DemoPage3Storyboard"];
                matchedIndex = 1;
            } else if ([host isEqualToString:@"page4"]) {
                _displayedViewController = [rc.storyboard instantiateViewControllerWithIdentifier:@"DemoPage4Storyboard"];
                matchedIndex = 1;
            } else if ([host isEqualToString:@"page5"]) {
                _displayedViewController = [rc.storyboard instantiateViewControllerWithIdentifier:@"DemoPage5Storyboard"];
                matchedIndex = 1;
            } else if ([host isEqualToString:@"home"]) {
                matchedIndex = 2;
            } else {
                matchedIndex = 0;
            }
            
//            if (matchedIndex == 1 && _displayedViewController != nil) {
//                [rc presentViewController:_displayedViewController animated:YES completion:^{
//                    [[TongDao sharedManager] displayAdvertisementWithUrl:url andContainerView:_displayedViewController.view];
//                }];
//            } else if (matchedIndex == 2) {
//                [[TongDao sharedManager] displayAdvertisementWithUrl:url andContainerView:rc.view];
//            }
            
            return YES;
        }else {
            return NO;
        }
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // 结束同道服务
//    [[TongDao sharedManager] onSessionEnd:_displayedViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVEDATATOBACKGROUND" object:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 结束同道Session
//    [[TongDao sharedManager] onSessionEnd:_displayedViewController];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSLog(@"applicationWillEnterForeground");
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
 
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [UMessage registerDeviceToken:deviceToken];
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[TongDao sharedManager] identifyPushToken:myToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"The DeviceToken 获取失败 %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
   
//    [APService handleRemoteNotification:userInfo];
     [UMessage didReceiveRemoteNotification:userInfo];
    NSLog(@"收到通知－－%@",userInfo);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知1-－%@",[userInfo description]);
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){

        NSLog(@"the userinfor %@",[userInfo description]);
        
        [[TongDao sharedManager] trackOpenPushMessage:userInfo];
                
        NSMutableDictionary*linkAndPageDic=[[TongDao sharedManager] getDeeplinkDictionary];
        
        [[TongDao sharedManager] openPage:self.window.rootViewController andUserInfo:userInfo andDeeplinkAndControllerId:linkAndPageDic];
    }
    
    completionHandler(44);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if ([LogSingle sharedManager].isLogin) {
//    }else{
//        [[TongDao sharedManager]initSdkWithAppKey:[[DemoTdDataTool sharedManager] getAppKey]];
//    }
    NSMutableDictionary* linkAndPageDic=[[NSMutableDictionary alloc] init];
    
    [linkAndPageDic setValue:@"DemoPage1Storyboard" forKey:@"demoumeng://page1"];
    [linkAndPageDic setValue:@"DemoPage2Storyboard" forKey:@"demoumeng://page2"];
    [linkAndPageDic setValue:@"DemoPage3Storyboard" forKey:@"demoumeng://page3"];
    [linkAndPageDic setValue:@"DemoPage4Storyboard" forKey:@"demoumeng://page4"];
    [linkAndPageDic setValue:@"DemoPage5Storyboard" forKey:@"demoumeng://page5"];
    
    [[TongDao sharedManager] setDeeplinkDictionary:linkAndPageDic];
    NSLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
