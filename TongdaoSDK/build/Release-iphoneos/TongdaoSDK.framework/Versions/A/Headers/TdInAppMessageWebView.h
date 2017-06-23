//
//  TdInAppMessageWebView.h
//  TongdaoSDK
//
//  Created by Alex on 23/02/2017.
//  Copyright © 2017 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TongDaoUiCore.h"
#import "TongDao.h"
#import "WebViewJavascriptBridge.h"

@interface TdInAppMessageWebView : UIView
@property (nonatomic,assign) BOOL isClosed;
@property WebViewJavascriptBridge* bridge;

-(void)initComponent:(TdMessageBean*)bean andParentOfVc:(TongDaoUiCore*)tdUicore;
-(void)goLinkWithType:(NSString *)type andValue:(NSString *)value;
@end
