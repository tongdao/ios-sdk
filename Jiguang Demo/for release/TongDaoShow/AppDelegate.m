//
//  AppDelegate.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "AppDelegate.h"
#import <TongDaoUILibrary>
#import <AdSupport/AdSupport.h>
//#import "APService.h"
#import "DemoTdDataTool.h"
//#import "UMessage.h"
#import "LogSingle.h"
#import "DemoPage1ViewController.h"
#import "DemoPage2ViewController.h"
#import "DemoPage3ViewController.h"
#import "DemoPage4ViewController.h"
#import "DemoPage5ViewController.h"
#import "JPUSHService.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIViewController *displayedViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"这是uuid %@",[UIDevice currentDevice].identifierForVendor.UUIDString);
    
    _displayedViewController = self.window.rootViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDisplayedViewControllerByNotification:) name:DISPLAYED_CONTROLLER object:nil];
    // For JPush
    //    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
    //                                                   UIUserNotificationTypeSound |
    //                                                   UIUserNotificationTypeAlert)
    //                                       categories:nil];
    //    [APService setupWithOption:launchOptions];
    //#ifdef __IPHONE_8_0 //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
    //    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    //        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //    }  else {
    //        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    //    }
    //#else
    //    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    //#endif
    //for umneg
    //    [UMessage startWithAppkey:@"566e3fe267e58e6de4001ccc" launchOptions:launchOptions];
    //*************************************
    //for log
    //    [UMessage setLogEnabled:YES];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"a9cbbc0ad1642ee46424ba28"
                          channel:@"app store"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    
    
    // Override point for customization after application launch.
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"DIDLOG"]) {
        
        NSNumber* DIDLOG = [NSNumber numberWithBool:YES];
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setValue:DIDLOG forKey:@"DIDLOG"];
        
        [[TongDaoUiCore sharedManager] initTDSdkWithTDAppKey:[[DemoTdDataTool sharedManager]getAppKey] andUserId:@"0"];
        
        [TongDao setUserId:nil];
        
    }else{
        
        [[TongDaoUiCore sharedManager] initTDSdkWithTDAppKey:[[DemoTdDataTool sharedManager]getAppKey] andUserId:@"JpushUser1"];
        
    }
    
    return YES;
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVEDATATOBACKGROUND" object:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSLog(@"applicationWillEnterForeground");
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];
    //    [UMessage registerDeviceToken:deviceToken];
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    [[TongDaoUiCore sharedManager] identifyPushToken:myToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"The DeviceToken 获取失败 %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    //    NSLog(@"收到通知－－%@",userInfo);
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知1-－%@",[userInfo description]);
    
    
    if (userInfo == nil) {
        return;
    }
    
    //注意如果你是通过同道的portal发送的推送的话  此处的userIfor中就会包含tongrd_mid，tongrd_cid，tongrd_type，tongrd_value这4个自动，所以你需要解析userifor直到获取到这4的字段的值
    //     NSNumber* tempmsgId = [userInfo valueForKey:@"tongrd_mid"];
    //     NSNumber* tempcliId = [userInfo valueForKey:@"tongrd_cid"];
    //     if (tempmsgId != nil && tempcliId != nil) {
    //         NSDictionary* openPushDic = [[NSDictionary alloc]init];
    //         [openPushDic setValue:tempmsgId forKey:@"tongrd_mid"];
    //         [openPushDic setValue:tempcliId forKey:@"tongrd_cid"];
    //         [[TongDaoUiCore sharedManager] trackOpenPushMessageForBaiduOrJPush:openPushDic];
    //     }
    //
    //    NSString * type=[userInfo valueForKey:(@"tongrd_type")];
    //    NSString * value=[userInfo valueForKey:(@"tongrd_value")];
    //    if (type != nil && value != nil) {
    //        NSDictionary* openPageDic = [[NSDictionary alloc]init];
    //        [openPageDic setValue:type forKey:@"tongrd_type"];
    //        [openPageDic setValue:value forKey:@"tongrd_value"];
    //        NSMutableDictionary*linkAndPageDic=[[TongDaoUiCore sharedManager] getDeeplinkDictionary];
    //        [[TongDaoUiCore sharedManager] openPageForBaiduOrJPush:self.window.rootViewController andUserInfo:openPageDic andDeeplinkAndControllerId:linkAndPageDic];
    //    }
    
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){
        
        NSLog(@"the userinfor %@",[userInfo description]);
        
        [[TongDaoUiCore sharedManager] trackOpenPushMessageForBaiduOrJPush:userInfo];
        
        NSMutableDictionary*linkAndPageDic=[[TongDaoUiCore sharedManager] getDeeplinkDictionary];
        
        [[TongDaoUiCore sharedManager] openPageForBaiduOrJPush:self.window.rootViewController andUserInfo:userInfo andDeeplinkAndControllerId:linkAndPageDic];
    }
    
    completionHandler(44);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

@end
