//
//  AppDelegate.h
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"

/// 个推开发者网站中申请App时注册的AppId、AppKey、AppSecret
#define kGtAppId           @"jaT5V5Bxtv7fixtut6EN9"
#define kGtAppKey          @"pP2Zum8dBb6bYRIhMBUvs1"
#define kGtAppSecret       @"pIiXWcVq8o9kRS7712spl4"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

