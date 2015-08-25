//
//  InAppMessageApiCallback.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/14.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "InAppMessageApiCallback.h"
#import "TdErrorTool.h"
#import "TongDaoApi.h"
#import "TdMessageButtonBean.h"
@implementation InAppMessageApiCallback

-(id)initWithDownloadInAppMessageListener:(id<OnDownloadInAppMessageListener>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

-(void)onResult:(NSHTTPURLResponse *)httpRes data:(id)data sendData:(id)sendData{
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
                                tempMessageBean.imageUrl = inAppMsgObj[@"image_url"];
                                tempMessageBean.message = inAppMsgObj[@"message"];
                                tempMessageBean.closeBtn = inAppMsgObj[@"close_btn"];
                                tempMessageBean.displayTime = inAppMsgObj[@"display_time"];
                                tempMessageBean.mid = inAppMsgObj[@"mid"];
                                tempMessageBean.cid = inAppMsgObj[@"cid"];
                                
                                //for portrait or landscape
                                tempMessageBean.isPortrait = [inAppMsgObj[@"is_portrait"] boolValue];
                                
                                tempMessageBean.layout = inAppMsgObj[@"layout"];
                                NSDictionary* actionDic = inAppMsgObj[@"action"];
                                if (actionDic != nil) {
                                    tempMessageBean.actionType = actionDic[@"type"];
                                    tempMessageBean.actionValue = actionDic[@"value"];
                                }
                                //for buttons
                                
                                NSArray* buttonsJsonArray = inAppMsgObj[@"buttons"];
                                if (buttonsJsonArray && buttonsJsonArray.count>0) {
                                    NSMutableArray* inAppMessageButtons = [[NSMutableArray alloc]init];
                                    for (id item in buttonsJsonArray) {
                                        NSDictionary* inAppBtnObj = item;
                                        if (inAppBtnObj) {
                                            NSNumber *xNum = inAppBtnObj[@"x"];
                                            NSNumber *yNum = inAppBtnObj[@"y"];
                                            NSNumber *wNum = inAppBtnObj[@"w"];
                                            NSNumber *hNum = inAppBtnObj[@"h"];
                                            
                                            double x =[xNum doubleValue];
                                            double y =[yNum doubleValue];
                                            double w =[wNum doubleValue];
                                            double h =[hNum doubleValue];
                                            
                                            
                                            NSString *btnActionType = nil;
                                            NSString *btnActionValue = nil;
                                            
                                            NSDictionary* inAppBtnActionObj = inAppBtnObj[@"action"];
                                            if (inAppBtnActionObj) {
                                                btnActionType = inAppBtnActionObj[@"type"];
                                                btnActionValue = inAppBtnActionObj[@"value"];
                                            }
                                            TdMessageButtonBean* inAppButton = [[TdMessageButtonBean alloc]initWithX:x Y:y W:w H:h actionType:btnActionType actionValue:btnActionValue];
                                            [inAppMessageButtons addObject:inAppButton];
                                        }
                                    }
                                    
                                    tempMessageBean.buttons = inAppMessageButtons;
                                }
                                
                                
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
