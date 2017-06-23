//
//  TongDao.m
//  TestLayout
//
//  Created by bin jin on 11/12/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TongDao.h"
#import "TdInAppMessageWebView.h"

@interface TongDao ()<OnDownloadInAppMessageListener>{
    UIViewController* _displayedViewController;
    
}

-(void) createContainerWithPageId:(int)pageId andContainerView:(UIView*)containerView andShowType:(enum TdShowTypes)showTypes;

@property (nonatomic) UIView *containerView;
@property (nonatomic, strong) NSArray *inAppMsg;
@property (nonatomic,strong) UITapGestureRecognizer* recognizer;
@property (nonatomic,strong)TdInAppMessageWebView *tempInAppMsgView;
@end

@implementation TongDao

@synthesize registerOnRewardBeanUnlocked;

static TongDao* sharedManager = nil;

+(TongDao*)sharedManager {
    static TongDao* instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[TongDao alloc] init];
    });
    
    return instance;
}

-(BOOL) initializeWithAppKey:(NSString*) appKey userId:(NSString*)userId andDebugMode:(BOOL) debugMode{
    if ([appKey isEqualToString:@""] || appKey == nil) {
        return NO;
    }
    if (userId == nil) {
        [[TdDataTool sharedTdDataTool] saveAnonymous:YES];
        userId  = [self generateUserId];
    }else{
        [[TdDataTool sharedTdDataTool] saveAnonymous:NO];
    }
    if ([userId isEqualToString:@""]) {
        return NO;
    }
    
    [[TdDataTool sharedTdDataTool]saveUuidAndKey:appKey userID:userId];
    return [[TdBridge sharedTdBridge] initSdk:appKey andIgnoreParam:TDNone andDebugMode:debugMode];
}

-(BOOL) initializeWithAppKey:(NSString*) appKey userId:(NSString*)userId andIgnore:(TongDaoinitData)ignoreType andDebugMode:(BOOL) debugMode{
    if ([appKey isEqualToString:@""] || appKey == nil) {
        return NO;
    }
    if (userId == nil) {
        [[TdDataTool sharedTdDataTool] saveAnonymous:YES];
        userId  = [self generateUserId];
    }else{
        [[TdDataTool sharedTdDataTool] saveAnonymous:NO];
    }
    if ([userId isEqualToString:@""]) {
        return NO;
    }
    
    [[TdDataTool sharedTdDataTool]saveUuidAndKey:appKey userID:userId];
    return [[TdBridge sharedTdBridge] initSdk:appKey andIgnoreParam:TDNone andDebugMode:debugMode];
}

-(void)loginWithUserId:(NSString*)userId{
    [[TdBridge sharedTdBridge] mergeUserId:userId];
}

-(void)logout{
//    [[TdBridge sharedTdBridge]]
}

-(NSString*)generateUserId
{
    return [[TdDataTool sharedTdDataTool] generateUserId];
}

-(void)registerErrorListener:(id<OnErrorListener>)onErrorListener
{
    [[TdBridge sharedTdBridge] registerErrorListener:onErrorListener];
}

-(void)trackWithEventName:(NSString *)eventName
{
    [[TdBridge sharedTdBridge]track:eventName];
}

-(void)trackWithEventName:(NSString *)eventName andValues:(NSDictionary *)values
{
    [[TdBridge sharedTdBridge]track:eventName values:(NSMutableDictionary *)values];
}

-(void)onSessionStart:(UIViewController*)viewController
{
    [[TdBridge sharedTdBridge] onSessionStart:viewController];
}

-(void)onSessionStartWithPageName:(NSString *)pageName
{
    [[TdBridge sharedTdBridge] onSessionStartWithPageName:pageName];
}

-(void)onSessionEnd:(UIViewController*)viewController
{
    [[TdBridge sharedTdBridge]onSessionEnd:viewController];
}

-(void)onSessionEndWithPageName:(NSString *)pageName
{
    [[TdBridge sharedTdBridge]onSessionEndWithPageName:pageName];
}

-(void) identify:(NSDictionary *)values
{
    [[TdBridge sharedTdBridge] identify:(NSMutableDictionary *)values];
}


-(void) identifyWithKey:(NSString *)key andValue:(id)value
{
    [[TdBridge sharedTdBridge]identifyWithName:key andValue:value];
}

-(void) identifyFullName:(NSString *)fullName
{
    [[TdBridge sharedTdBridge]identifyFullName:fullName];
}

-(void) identifyPushToken:(id)push_token
{
    [[TdBridge sharedTdBridge]identifyPushToken:push_token];
}

-(void) identifyFullNameWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName
{
    [[TdBridge sharedTdBridge]identifyFullNameWithFirstName:firstName andLastName:lastName];
}

-(void) identifyUserName:(NSString *)userName
{
    [[TdBridge sharedTdBridge]identifyUserName:userName];
}

-(void) identifyEmail:(NSString *)email
{
    [[TdBridge sharedTdBridge] identifyEmail:email];
}

-(void) identifyPhone:(NSString *)phoneNumber
{
    [[TdBridge sharedTdBridge] identifyPhone:phoneNumber];
}

-(void) identifyGender:(NSString *)gender
{
    if ([[gender lowercaseString] isEqualToString:@"male"] || [[gender lowercaseString] isEqualToString:@"female"]) {
        [[TdBridge sharedTdBridge]identifyGender:gender.lowercaseString];
    }
}

-(void) identifyAge:(int)age
{
    [[TdBridge sharedTdBridge]identifyAge:age];
}

-(void) identifyAvatar:(NSString *)url
{
    [[TdBridge sharedTdBridge]identifyAvatarWithUrl:url];
}

-(void) identifyAddress:(NSString *)address
{
    [[TdBridge sharedTdBridge]identifyAddress:address];
}

-(void) identifyBirthday:(NSDate *)date
{
    [[TdBridge sharedTdBridge]identifyBirthday:date];
}

-(void) identifySource:(TdSource *)tdSource
{
    [[TdBridge sharedTdBridge]identifySource:tdSource];
}

-(void) trackRegistration
{
    [[TdBridge sharedTdBridge]trackRegistration];
}

-(void) trackRegistrationWithDate:(NSDate *)date
{
    [[TdBridge sharedTdBridge]trackRegistration:date];
}

-(void) identifyRating:(int)rating
{
    [[TdBridge sharedTdBridge] identifyRating:rating];
}

-(void) trackPlaceOrder:(TdOrder *)order
{
    [[TdBridge sharedTdBridge]trackPlaceOrder:order];
}

-(void) trackPlaceOrder:(NSString *)name andPrice:(double)price andCurrency:(NSString *)currency andQuantity:(int)quantity
{
    if ([name isEqualToString:@""] || price <= 0 || quantity <= 0) {
        return;
    }
    
    TdProduct* tempProduct = [[TdProduct alloc]initWithProductId:nil sku:nil name:name price:price currency:currency category:nil];
    TdOrderLine* tempOrderLine = [[TdOrderLine alloc]initWithProduct:tempProduct andQuantity:quantity];
    NSMutableArray* orderLines = [[NSMutableArray alloc]init];
    [orderLines addObject:tempOrderLine];
    
    TdOrder* order = [[TdOrder alloc]init];
    order.total = price*quantity;
    order.currency = currency;
    order.orderList = orderLines;
    
    [[TdBridge sharedTdBridge]trackPlaceOrder:order];
}

-(void) trackPlaceOrder:(NSString *)name andPrice:(double)price andCurrency:(NSString *)currency
{
    [self trackPlaceOrder:name andPrice:price andCurrency:currency andQuantity:1];
}

-(void)downloadInAppMessage
{
//    NSLog(@"在uilab中准备下载");
    [[TdBridge sharedTdBridge]downloadInAppMessage:self];
}

-(void)onInAppMessageSuccess:(NSArray * __nonnull)tdMessageBeanList
{
//    NSLog(@"这是冲API 那来的同道message%@",tdMessageBeanList);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.inAppMsg = tdMessageBeanList;
        [self refreshInAppMessageView];
    });
}

/**
 This function is in charge of showing the in-app message
 It creates the TdInAppMessageView, sets the background color, size, initializes and shows it
 **/
-(void)refreshInAppMessageView
{
    if (self.inAppMsg != nil && self.inAppMsg.count > 0) {
        
        TdMessageBean *bean = (TdMessageBean*)self.inAppMsg.firstObject;
        if ([bean.layout isEqualToString:@"bottom"]) {
            self.tempInAppMsgView= [[TdInAppMessageWebView alloc] init];
            [self.tempInAppMsgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
            self.tempInAppMsgView.frame = CGRectMake(0, self.containerView.frame.size.height - 100, self.containerView.frame.size.width, 100);
            [self.tempInAppMsgView initComponent:bean andParentOfVc:self];
            [self.containerView addSubview:self.tempInAppMsgView];
//            [self addTapClose];
            
        } else if ([bean.layout isEqualToString:@"top"]) {
            self.tempInAppMsgView= [[TdInAppMessageWebView alloc] init];
            [self.tempInAppMsgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
            self.tempInAppMsgView.frame = CGRectMake(0, 20, self.containerView.frame.size.width, 100);
            [self.tempInAppMsgView initComponent:bean andParentOfVc:self];
            [self.containerView addSubview:self.tempInAppMsgView];
//            [self addTapClose];
            
        }else if ([bean.layout isEqualToString:@"full"]){
            self.tempInAppMsgView = [[TdInAppMessageWebView alloc]init];
            [self.tempInAppMsgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
            self.tempInAppMsgView.frame = CGRectMake(0, 0, self.containerView.frame.size.width,self.containerView.frame.size.height);
            [self.tempInAppMsgView initComponent:bean andParentOfVc:self];
            [self.containerView addSubview:self.tempInAppMsgView];
//            [self addTapClose];
        }
        
        
        //        [self addTapClose];
        
        
        
        [self trackReceivedInAppMessage:bean];
    }
}
-(void)addTapClose
{
    self.recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandler:)];
    [self.containerView addGestureRecognizer:self.recognizer];
}
-(void)tapGestureHandler:(UITapGestureRecognizer*) tapGes
{
    [self reset];
}
-(void)reset
{
    
    if(self.tempInAppMsgView != nil){
        self.tempInAppMsgView.isClosed=true;
        [self.tempInAppMsgView removeFromSuperview];
        self.tempInAppMsgView=nil;
    }
    
    if(self.recognizer != nil && self.containerView != nil){
        [self.containerView removeGestureRecognizer:self.recognizer];
        self.recognizer=nil;
    }
}

-(void)onError:(TdErrorBean *)errorBean
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.inAppMsg = nil;
    });
}

-(NSString*)getPageIdWithUrl:(NSURL*)url{
    if (url != nil) {
        return [self getDataWithUrl:url andDataUrl:@"0Qpage="];
    }
    return nil;
}

#pragma mark 未完成的方法
-(NSString*)getDataWithUrl:(NSURL*)url andDataUrl:(NSString*)dataUrl{
    NSString* path  = [url absoluteString];
    if (path) {
        NSRange range = [path rangeOfString:dataUrl];
        if (range.length>0) {
            //            NSInteger intindex = range.length;
            NSUInteger StartLocation = range.location + range.length;
            NSString* PAGEID = [path substringFromIndex:StartLocation];
            return PAGEID;
        }
        
    }
    return nil;
}

-(void) displayInAppMessage:(UIView *)view
{
    [self createContainerWithPageId:-999 andContainerView:view andShowType:INAPPMESSAGE];
}


-(void)createContainerWithPageId:(int)pageId andContainerView:(UIView *)containerView andShowType:(enum TdShowTypes)showTypes
{
    self.containerView = containerView;
    if (showTypes == INAPPMESSAGE) {
        [self downloadInAppMessage];
    }
}




-(void)trackOpenPushMessage:(NSDictionary*)userInfo{
    if (userInfo == nil) {
        return;
    }
    
    NSNumber* tempmsgId = [userInfo valueForKey:@"tongrd_mid"];
    NSNumber* tempcliId = [userInfo valueForKey:@"tongrd_cid"];
    
    if (tempmsgId == nil || tempcliId == nil) {
        return;
    }
    
    NSInteger msgId = [tempmsgId integerValue];
    NSInteger cliId = [tempcliId integerValue];
    
    if (msgId != 0 && cliId != 0) {
        [self sendOpenMessageWithEventName:@"!open_message" andMid:msgId andCid:cliId];
    }
}

-(void)sendOpenMessageWithEventName:(NSString*)eventName andMid:(NSInteger)mid andCid:(NSInteger)cid{
    [[TdBridge sharedTdBridge] sendOpenMessageWithEventName:eventName andMid:mid andCid:cid];
}


-(void)openPage:(UIViewController*)rootViewController andUserInfo:(NSDictionary*)userInfo andDeeplinkAndControllerId:(NSMutableDictionary*)deeplinkAndControllerId
{
    
    if (rootViewController==nil || userInfo==nil) {
        return;
    }
    
    NSString * type=[userInfo valueForKey:(@"tongrd_type")];
    NSString * value=[userInfo valueForKey:(@"tongrd_value")];
    if (type == nil || value == nil) {
        return;
    }
    
//    NSLog(@"%@",value);
    
    //关闭之前打开的ViewController
    if (_displayedViewController != nil) {
        [_displayedViewController dismissViewControllerAnimated:NO completion:nil];
        _displayedViewController = nil;
    }
    
    if ([type isEqualToString:(@"url")]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"%@",@"coming page");
            NSURL *url=[NSURL URLWithString:value];
            if(url != nil){
                [[UIApplication sharedApplication] openURL:url];
            }
        });
    }else if([type isEqualToString:(@"deeplink")]){
//        NSLog(@"%@",@"coming deeplink");
        
        if(deeplinkAndControllerId != nil && [deeplinkAndControllerId count]>0){
            for (NSString *key in deeplinkAndControllerId) {
                if (key!=nil && deeplinkAndControllerId[key]!=nil) {
                    if([value isEqualToString:(key)]){
                        NSString* storyboardId=deeplinkAndControllerId[key];
                        _displayedViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];
                        
                        if (_displayedViewController != nil) {
                            [rootViewController presentViewController:_displayedViewController animated:YES completion:nil];
                            break;
                        }
                    }
                }
            }
        }
    }
}

-(void)trackOpenInAppMessage:(TdMessageBean *)tdMessageBean{
    if (tdMessageBean == nil) {
        return;
    }
    
    NSNumber* messageId = tdMessageBean.mid;
    NSNumber* clientId = tdMessageBean.cid;
    
    if (messageId != nil && clientId != nil) {
        NSInteger mid = [messageId integerValue];
        NSInteger cid = [clientId integerValue];
        if (mid == 0 || cid == 0) {
            return;
        }else{
            [self sendOpenMessageWithEventName:@"!open_message" andMid:mid andCid:cid];
        }
    }
}

-(void)trackReceivedInAppMessage:(TdMessageBean *)tdMessageBean{
    if (tdMessageBean == nil) {
        return;
    }
    
    NSNumber* messageId = tdMessageBean.mid;
    NSNumber* clientId = tdMessageBean.cid;
    
    if (messageId != nil && clientId != nil) {
        NSInteger mid = [messageId integerValue];
        NSInteger cid = [clientId integerValue];
        
        if (mid == 0 || cid == 0) {
            return;
        }else{
            [self sendOpenMessageWithEventName:@"!receive_message" andMid:mid andCid:cid];
        }
    }
}

-(void)setDeeplinkDictionary:(NSMutableDictionary*)dictionary{
    [[TdBridge sharedTdBridge]setDeeplinkDictionary:dictionary];
}

-(NSMutableDictionary*)getDeeplinkDictionary{
    return [[TdBridge sharedTdBridge]getDeeplinkDictionary];
    return nil;
}

-(NSString*)getAppKey
{
    return [[TdDataTool sharedTdDataTool] getAppKey];
}

-(NSString*)getUserId{
    return [[TdDataTool sharedTdDataTool] getUUID];
}
@end
