//
//  AppDelegate.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "AppDelegate.h"
#import <TongDaoUILibrary/TongDaoUiCore.h>
//#import "APService.h"
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
    
    _displayedViewController = self.window.rootViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDisplayedViewControllerByNotification:) name:DISPLAYED_CONTROLLER object:nil];
    
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // 注册APNS
    [self registerUserNotification];
    
    // 处理远程通知启动APP
    //    [self receiveNotificationByLaunchingOptions:launchOptions];
    //    [[TongDaoUiCore sharedManager] initSdkWithAppKey:[[DemoTdDataTool sharedManager] getAppKey]];
    [[TongDaoUiCore sharedManager]initTDSdkWithTDAppKey:[[DemoTdDataTool sharedManager] getAppKey] andUserId:[[TongDaoUiCore sharedManager]generateUserId]];
    
    return YES;
}
/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
        return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
    }
}

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
            
            if (matchedIndex == 1 && _displayedViewController != nil) {
                [rc presentViewController:_displayedViewController animated:YES completion:^{
                    [[TongDaoUiCore sharedManager] displayAdvertisementWithUrl:url andContainerView:_displayedViewController.view];
                }];
            } else if (matchedIndex == 2) {
                [[TongDaoUiCore sharedManager] displayAdvertisementWithUrl:url andContainerView:rc.view];
            }
            
            return YES;
        }else {
            return NO;
        }
    }
    
    return NO;
}

//-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    /// Background Fetch 恢复SDK 运行
//    [GeTuiSdk resume];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

//- (void)applicationWillResignActive:(UIApplication *)application {
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // 结束同道服务
    //    [[TongDaoUiCore sharedManager] onSessionEnd:_displayedViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVEDATATOBACKGROUND" object:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 结束同道Session
    //    [[TongDaoUiCore sharedManager] onSessionEnd:_displayedViewController];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSLog(@"applicationWillEnterForeground");
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //    [APService registerDeviceToken:deviceToken];
    //    NSString *registrationId = [APService registrationID];
    //    [[TongDaoUiCore sharedManager] identifyPushToken:registrationId];
    
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [GeTuiSdk registerDeviceToken:myToken];    /// 向个推服务器注册deviceToken
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n",myToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [GeTuiSdk registerDeviceToken:@""];     /// 如果APNS注册失败，通知个推服务器
    NSLog(@"The DeviceToken 获取失败 %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知－－%@",userInfo);
    [[TongDaoUiCore sharedManager] trackOpenMessageForGeTui:userInfo];
    
    NSMutableDictionary*linkAndPageDic=[[TongDaoUiCore sharedManager] getDeeplinkDictionary];
    
    [[TongDaoUiCore sharedManager] openPageForGeTui:self.window.rootViewController andUserInfo:userInfo andDeeplinkAndControllerId:linkAndPageDic];
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"收到通知1-－%@",[userInfo description]);
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){
        
        NSLog(@"the userinfor %@",[userInfo description]);
        
        [[TongDaoUiCore sharedManager] trackOpenMessageForGeTui:userInfo];
        
        NSMutableDictionary*linkAndPageDic=[[TongDaoUiCore sharedManager] getDeeplinkDictionary];
        
        [[TongDaoUiCore sharedManager] openPageForGeTui:self.window.rootViewController andUserInfo:userInfo andDeeplinkAndControllerId:linkAndPageDic];
    }
    
    completionHandler(44);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    NSMutableDictionary* linkAndPageDic=[[NSMutableDictionary alloc] init];
    
    [linkAndPageDic setValue:@"DemoPage1Storyboard" forKey:@"demojpush://page1"];
    [linkAndPageDic setValue:@"DemoPage2Storyboard" forKey:@"demojpush://page2"];
    [linkAndPageDic setValue:@"DemoPage3Storyboard" forKey:@"demojpush://page3"];
    [linkAndPageDic setValue:@"DemoPage4Storyboard" forKey:@"demojpush://page4"];
    [linkAndPageDic setValue:@"DemoPage5Storyboard" forKey:@"demojpush://page5"];
    [[TongDaoUiCore sharedManager] setDeeplinkDictionary:linkAndPageDic];
    
    
    
    NSLog(@"applicationDidBecomeActive");
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//个推回调

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [[TongDaoUiCore sharedManager] identifyPushToken:clientId];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}
@end
