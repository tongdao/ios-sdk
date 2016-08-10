//
//  TongDaoApi.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/14.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TongDaoApi.h"
#import "TdDataTool.h"
#import "TdUrlTool.h"
#import "PageApiCallback.h"
#import "InAppMessageApiCallback.h"
#import "TdService.h"
#import "FailList.h"
static NSString *const X_APP_KEY = @"X-APP-KEY";
static NSString *const X_SDK_VERSION = @"X-SDK-VERSION";
static NSString *const X_DEVICE_KEY = @"X-DEVICE-KEY";

static NSString *const CONTENT_TYPE_NAME = @"Content-Type";
static NSString *const CONTENT_TYPE_VALUE = @"application/json";

static NSString *const ACCEPT_NAME = @"Accept";
static NSString *const ACCEPT_VALUE=@"application/json";

static NSString *const sdkVersion=@"30207";

static NSString *const X_AUTO_CLAIM=@"X-AUTO-CLAIM";
static NSString *const AUTO_CLAIM_FLAG=@"1";
static NSString *const X_LOCAL_TIME=@"X-LOCAL-TIME";
@implementation TongDaoApi

+(void)downloadPage:(NSInteger)pageId downloadListener:(id<OnDownloadPageListener>)downloadListener{
    NSString* appKey = [[TdDataTool sharedTdDataTool] getAppKey];
    NSString* userId = [[TdDataTool sharedTdDataTool] getUUID];
    if (appKey != nil && userId != nil) {
        NSString* url = [TdUrlTool getPageUrl:pageId userId:userId];
        [self apiCallWithAppKey:appKey method:API_METHOD[GET] isPageCall:YES url:url data:nil callBack:[[PageApiCallback alloc]initWithDownloadPageListener:downloadListener]];
    }
}

+(void)downloadInAppMessage:(id<OnDownloadInAppMessageListener>)inAppMessageListener{
    NSString* appKey = [[TdDataTool sharedTdDataTool] getAppKey];
    NSString* userId = [[TdDataTool sharedTdDataTool] getUUID];
    if (appKey != nil && userId != nil) {
        NSString* url = [TdUrlTool getInAppMessageUrl:userId];
        [self apiCallWithAppKey:appKey method:API_METHOD[GET] isPageCall:NO url:url data:nil callBack:[[InAppMessageApiCallback alloc]initWithDownloadInAppMessageListener:inAppMessageListener]];
    }
}

+(void)postEvents:(id)data callBack:(id<ApiCallBack>)callBack{
    NSString* appKey = [[TdDataTool sharedTdDataTool] getAppKey];
    NSString* userId = [[TdDataTool sharedTdDataTool] getUUID];
    if (appKey != nil && userId != nil) {
        NSString* url = [TdUrlTool getEventsUrl];
        [self apiCallWithAppKey:appKey method:API_METHOD[POST] isPageCall:NO url:url data:data callBack:callBack];
    }
}

+(void)postEvents:(id)data callBackForOpenMessage:(id<ApiCallBackForOpenMessage>)callBack{
    NSString* appKey = [[TdDataTool sharedTdDataTool] getAppKey];
    NSString* userId = [[TdDataTool sharedTdDataTool] getUUID];
    if (appKey != nil && userId != nil) {
        NSString* url = [TdUrlTool getEventsUrl];
        [self apiCallWithAppKey:appKey method:API_METHOD[POST] isPageCall:NO url:url data:data callBackForOpenMessage:callBack];
    }
}

+(NSMutableURLRequest*)addHeadData:(NSMutableURLRequest*)request method:(NSString*)method isPageCall:(BOOL)isPageCall appKey:(NSString*)appKey{
    if ([method isEqualToString:API_METHOD[POST]]) {
        [request addValue:CONTENT_TYPE_VALUE forHTTPHeaderField:CONTENT_TYPE_NAME];
    }
    if (isPageCall) {
        [request addValue:AUTO_CLAIM_FLAG forHTTPHeaderField:X_AUTO_CLAIM];
    }
    [request addValue:ACCEPT_VALUE forHTTPHeaderField:ACCEPT_NAME];
    [request addValue:appKey forHTTPHeaderField:X_APP_KEY];
    [request addValue:sdkVersion forHTTPHeaderField:X_SDK_VERSION];
    [request addValue:[[TdDataTool sharedTdDataTool] getUUID] forHTTPHeaderField:X_DEVICE_KEY];
    [request addValue:[[TdDataTool sharedTdDataTool] getTimeStamp] forHTTPHeaderField:X_LOCAL_TIME];
    return request;
}

+(void)apiCallWithAppKey:(NSString*)appKey method:(NSString*)method isPageCall:(BOOL)isPageCall url:(NSString*)url data:(id)data callBack:(id<ApiCallBack>)callBack{
   
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];

    request.HTTPMethod = method;
    request =[self addHeadData:request method:method isPageCall:isPageCall appKey:appKey];
    
    NSError* err = nil;
    if (data != nil && [method isEqualToString:API_METHOD[POST]]) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&err];
    }
    
    // Here set flag to 1 requestInProgress = true
    // if requestInProgress == false {
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *connectionError) {
        
        if (connectionError) {
            NSLog(@"Httperror:%@ %ld", connectionError.localizedDescription,(long)connectionError.code);
            [callBack onResult:nil data:responseData sendData:data];
        }else{
            NSHTTPURLResponse* httpRes = (NSHTTPURLResponse*)response;
            //requestInProgress = false;
//            NSLog(@"请求的API的实际链接 %@",request.URL);
            [callBack onResult:httpRes data:responseData sendData:data];
        }
    }];

}

+(void)apiCallWithAppKey:(NSString*)appKey method:(NSString*)method isPageCall:(BOOL)isPageCall url:(NSString*)url data:(id)data callBackForOpenMessage:(id<ApiCallBackForOpenMessage>)callBack{
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    
    request.HTTPMethod = method;
    request =[self addHeadData:request method:method isPageCall:isPageCall appKey:appKey];
    
    NSError* err = nil;
    if (data != nil && [method isEqualToString:API_METHOD[POST]]) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&err];
    }
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *connectionError) {
        
        if (connectionError) {
            NSLog(@"Httperror:%@ %ld", connectionError.localizedDescription,(long)connectionError.code);
//            [[TdService sharedTdService].failTrackList addObject:data];
            [callBack onResult:nil dataForOpenMessage:responseData sendData:data];
        }else{
            NSHTTPURLResponse* httpRes = (NSHTTPURLResponse*)response;
            [callBack onResult:httpRes dataForOpenMessage:responseData sendData:data];
        }
    }];
}

@end
