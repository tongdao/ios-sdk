//
//  AppDelegate.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "AppDelegate.h"
#import <TongdaoSDK/TongdaoSDK.h>
#import "DemoTdDataTool.h"
#import "LogSingle.h"
#import "DemoPage1ViewController.h"
#import "DemoPage2ViewController.h"
#import "DemoPage3ViewController.h"
#import "DemoPage4ViewController.h"
#import "DemoPage5ViewController.h"

@interface AppDelegate () <JPUSHRegisterDelegate>

@property (nonatomic, strong) UIViewController *displayedViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _displayedViewController = self.window.rootViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDisplayedViewControllerByNotification:) name:DISPLAYED_CONTROLLER object:nil];
    // For JPush
//    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                   UIUserNotificationTypeSound |
//                                                   UIUserNotificationTypeAlert)
//                                       categories:nil];
//    [APService setupWithOption:launchOptions];
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"a9cbbc0ad1642ee46424ba28"
                          channel:@"umeng"
                 apsForProduction:false
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[TongDao sharedManager] identifyPushToken:registrationID];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    

    
    _displayedViewController = self.window.rootViewController;

    return YES;
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
    [[TongDao sharedManager] onSessionEnd:_displayedViewController];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSLog(@"applicationWillEnterForeground");
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
 
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device token: %@", deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [[TongDao sharedManager] trackOpenPushMessage:userInfo];
    
    NSMutableDictionary*linkAndPageDic=[[TongDao sharedManager] getDeeplinkDictionary];
    
    [[TongDao sharedManager] openPage:self.window.rootViewController andUserInfo:userInfo andDeeplinkAndControllerId:linkAndPageDic];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
   
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知－－%@",userInfo);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知1-－%@",[userInfo description]);
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){

        NSLog(@"the userinfor %@",[userInfo description]);
        
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if ([LogSingle sharedManager].isLogin) {
    [[TongDao sharedManager] initializeWithAppKey:[[DemoTdDataTool sharedManager] getAppKey] userId:nil andDebugMode:true];
//    }else{
//        [[TongDao sharedManager]initSdkWithAppKey:[[DemoTdDataTool sharedManager] getAppKey]];
//    }
   
//        NSString *registrationId = [APService registrationID];
    NSMutableDictionary* linkAndPageDic=[[NSMutableDictionary alloc] init];
    
    [linkAndPageDic setValue:@"DemoPage1Storyboard" forKey:@"demojpush://page1"];
    [linkAndPageDic setValue:@"DemoPage2Storyboard" forKey:@"demojpush://page2"];
    [linkAndPageDic setValue:@"DemoPage3Storyboard" forKey:@"demojpush://page3"];
    [linkAndPageDic setValue:@"DemoPage4Storyboard" forKey:@"demojpush://page4"];
    [linkAndPageDic setValue:@"DemoPage5Storyboard" forKey:@"demojpush://page5"];
    
    [[TongDao sharedManager] setDeeplinkDictionary:linkAndPageDic];
//    [[TongDao sharedManager] onSessionStart:_displayedViewController];
    NSLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
