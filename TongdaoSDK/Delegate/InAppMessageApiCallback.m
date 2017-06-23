//
//  InAppMessageApiCallback.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/14.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "InAppMessageApiCallback.h"
#import "TdMessageBean.h"

@implementation InAppMessageApiCallback

-(id)initWithDownloadInAppMessageListener:(id<OnDownloadInAppMessageListener>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

-(void)onResult:(NSHTTPURLResponse *)httpRes data:(NSData*)data sendData:(id)sendData{
    if (httpRes == nil) {
        if (self.delegate != nil) {
            [self.delegate onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:errorNet1002 andErrorMessage:ErrorInfos[errorMessageNet]]];
        }else{
            NSLog(@"%@",ErrorInfos[errorMessageNet]);
        }
    }else{
        NSError* resError = nil;
        NSInteger resCode = httpRes.statusCode;
        if (resCode==200) {
            NSArray * jsonRes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&resError];
            if (resError==nil) {
                if (jsonRes==nil) {
                    if (self.delegate != nil) {
                        [self.delegate onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                    }else{
                        NSLog(@"%@",ErrorInfos[errorMessageJson]);
                    }
                }else{
                    if (self.delegate == nil) {
                        NSLog(@"%@",ErrorInfos[notRegisterDownloadListenner]);
                    }else{
                        NSMutableArray* inAppMessages = [[NSMutableArray alloc]init];
                        for ( id eachItem in jsonRes) {
                            NSDictionary* inAppMsgObj = (NSDictionary*)eachItem;
                            if (inAppMsgObj != nil) {
                                TdMessageBean* tempMessageBean = [[TdMessageBean alloc]init];
                                tempMessageBean.htmlTemplate = inAppMsgObj[@"template"];
                                tempMessageBean.style = inAppMsgObj[@"style"];
                                tempMessageBean.script = inAppMsgObj[@"script"];
                                tempMessageBean.mid = inAppMsgObj[@"mid"];
                                tempMessageBean.cid = inAppMsgObj[@"cid"];
                                tempMessageBean.layout = inAppMsgObj[@"layout"];
                                //add to In App Message list
                            
                                [inAppMessages addObject:tempMessageBean];
                            }
                        }
                        //add code
                        [self.delegate onInAppMessageSuccess:inAppMessages];
                    }
                }
            }else{
                if (self.delegate != nil) {
                    [self.delegate onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                }else{
                    NSLog(@"%@",ErrorInfos[errorMessageJson]);
                }
            }
        }else{
            NSMutableDictionary* jsonRes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&resError];
            if (resError==nil) {
                if (jsonRes==nil) {
                    if (self.delegate != nil) {
                        [self.delegate onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                    }else{
                        NSLog(@"%@",ErrorInfos[errorMessageJson]);
                    }
                }else{
                    if (self.delegate != nil) {
                        NSString* message = [jsonRes objectForKey:@"message"];
                        [self.delegate onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:message]];
                    }else{
                        NSLog(@"%@",ErrorInfos[errorMessageRegister]);
                    }
                }
            }else{
                if (self.delegate != nil) {
                    [self.delegate onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                }else{
                    NSLog(@"%@",ErrorInfos[errorMessageJson]);
                }
            }
        }
        
    }
}

@end
