//
//  PageApiCallback.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/14.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "PageApiCallback.h"
#import "TdErrorTool.h"
#import "TongDaoApi.h"
@implementation PageApiCallback

-(id)initWithDownloadPageListener:(id<OnDownloadPageListener>)delegate{
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
            NSMutableDictionary* jsonRes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&resError];
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
                        PageBean* pageBean = [[PageBean alloc]init];
                        [pageBean setImage:[jsonRes objectForKey:@"image"]];
                        NSArray* rewardArrayObj = [jsonRes objectForKey:@"rewards"];
                        if (rewardArrayObj != nil && [rewardArrayObj count]>0) {
                            NSMutableArray* tempRewardBeanList = [[NSMutableArray alloc]init];
                            for (NSMutableDictionary* rewardObj in rewardArrayObj) {
                                if (rewardObj != nil) {
                                    RewardBean* tempRewardBean = [[RewardBean alloc]init];
                                    [tempRewardBean setRid:(NSInteger)[rewardObj objectForKey:@"id"]];
                                    [tempRewardBean setName:[rewardObj objectForKey:@"name"]];
                                    [tempRewardBean setSku:[rewardObj objectForKey:@"sku"]];
                                    [tempRewardBean setQuantity:(NSInteger)[rewardObj objectForKey:@"quantity"]];
                                    [tempRewardBeanList addObject:tempRewardBean];
                                }
                            }
                            [pageBean setRewards:tempRewardBeanList];
                        }
                        [self.delegate onPageSuccess:pageBean];
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
