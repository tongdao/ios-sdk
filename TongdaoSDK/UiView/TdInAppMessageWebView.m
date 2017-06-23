//
//  TdInAppMessageWebView.m
//  TongdaoSDK
//
//  Created by Alex on 23/02/2017.
//  Copyright © 2017 Tongdao. All rights reserved.
//

#import "TdInAppMessageWebView.h"


@interface TdInAppMessageWebView ()
@property (nonatomic, strong) TdMessageBean *messageBean;
@property (nonatomic,strong)TongDao *tdUicore;
@end

@implementation TdInAppMessageWebView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)initComponent:(TdMessageBean *)bean andParentOfVc:(TongDao *)tdUicore
{
    self.isClosed = NO;
    self.messageBean = bean;
    self.tdUicore = tdUicore;
    if (self.messageBean != nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [webView setOpaque:false];
        [webView setBackgroundColor:[UIColor clearColor]];
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.bounces = NO;
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
        [self.bridge registerHandler:@"trackOpen" handler:^(id data, WVJBResponseCallback responseCallback) {
            //should be {href:href, type:type}
            NSString *type = [data objectForKey:@"type"];
            NSString *value = [data objectForKey:@"href"];
            [self goLinkWithType:type andValue:value];
            responseCallback(data);
        }];
        [self.bridge registerHandler:@"closeMessage" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"closeMessage called with: %@", data);
            [webView removeFromSuperview];
            [[TongDao sharedManager] reset];
        }];
        [self.bridge registerHandler:@"trackReceive" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"trackReceive called with: %@", data);
            [tdUicore trackReceivedInAppMessage:self.messageBean];
            responseCallback(data);
        }];
        [self.bridge registerHandler:@"getWindowSettings" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"getWindowSettings called with: %@", data);
            NSMutableDictionary *size = [[NSMutableDictionary alloc]init];
            [size setValue:[NSNumber numberWithInt:self.frame.size.width] forKey:@"width"];
            [size setValue:[NSNumber numberWithInt:self.frame.size.height] forKey:@"height"];
            NSLog(@"%@",size);
            responseCallback(size);
        }];
        NSString* html = [bean getHtml];
        [webView loadHTMLString:html baseURL:nil];
        [self addSubview:webView];
    }
}

-(void)goLinkWithType:(NSString *)type andValue:(NSString *)value {
    [self.tdUicore trackOpenInAppMessage:self.messageBean];
    if([type isEqualToString:@"deeplink"]){
        NSMutableString* storyboardId= nil;
        NSMutableDictionary* dict=[self.tdUicore getDeeplinkDictionary];
        
        if (dict != nil && [dict count]>0) {
            storyboardId=[dict valueForKey:value];
            if (storyboardId!=nil&&![storyboardId isEqualToString:@""] ) {
                UIViewController* displayedViewController=[[[[UIApplication sharedApplication].delegate window].rootViewController storyboard] instantiateViewControllerWithIdentifier:storyboardId];
                
                if (displayedViewController!=nil) {
                    if ([self viewController] != nil) {
                        [[self viewController] presentViewController:displayedViewController animated:YES completion:nil];
                    }
                }
            }
            
        }
    }else if([type isEqualToString:@"url"]){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:value]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:value]];
        }
    }
    
    [self.tdUicore reset];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
