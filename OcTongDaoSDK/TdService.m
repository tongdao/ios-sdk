//
//  TdService.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/16.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdService.h"
#import "TdStartLocation.h"
#import "InfoDataTool.h"
#import "TdEventBean.h"
#import "TongDaoApi.h"
#import "TongDaoBridge.h"
#import "TdErrorTool.h"
#import "FailList.h"
#import "SingleForAnonymous.h"
#import "TdDataTool.h"
@implementation TdService
//singleton_implementation(TdService)
static TdService *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(TdService *)sharedTdService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.failTrackList = [[NSMutableArray alloc]init];
//        _instance.sendList = [[NSMutableArray alloc]init];
        _instance.isFailed = NO;
    });
    return _instance;
}


-(void)addTrackEvent:(NSMutableDictionary*)trackData{
    NSMutableArray* failArr = [trackData objectForKey:@"events"];
   id currentObjc = [failArr lastObject];
    NSMutableArray*a = [[NSMutableArray alloc]init];
    [a addObject:currentObjc];
    if (self.failTrackList) {
        if (self.failTrackList.count>0) {
            for (id objc in self.failTrackList) {
               [a addObject:objc];
            }
        }
        self.failTrackList = a;
    }else{
        self.failTrackList = [[NSArray alloc]init];
        self.failTrackList = a;
    }
}
-(void)clearFailTrackList{
    self.failTrackList = nil;
}

-(void)sendInitialData{
    [[TdStartLocation sharedTdStartLocation] start:self];
}

-(void)sendTrackEvent:(TdEventBean*)tdEventBean{
        NSMutableArray* arr = [NSMutableArray arrayWithObject:[tdEventBean getJsonObject]];
        [self postEventData:arr];
}

-(void)sendOpenMessageTrackEvent:(TdEventBean*)tdEventBean{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [arr addObject:[tdEventBean getJsonObject]];
        [self postOpenMessageEventData:arr];
//    });

}

-(void)postOpenMessageEventData:(NSMutableArray*)arr{
    if (self.failTrackList != nil&&self.failTrackList.count>0&&self.isFailed == YES) {
        self.isFailed = NO;
        NSMutableArray* failArr = [[NSMutableArray alloc]init];
        for (id objc in self.failTrackList) {
            [failArr addObject:objc];
        }
        for (id obj in arr) {
            [failArr addObject:obj];
        }
        arr = failArr;
    }
    NSMutableDictionary* data=[self makeEventsJsonDec:arr];

    if (data != nil) {
//        NSLog(@"open message%@",data);
        [TongDaoApi postEvents:data callBackForOpenMessage:self];
    }
}


-(void)postEventData:(NSMutableArray*)arr{
    if (self.failTrackList != nil&&self.failTrackList.count>0&&self.isFailed == YES) {
                self.isFailed = NO;
        NSMutableArray* failArr = [[NSMutableArray alloc]init];
        for (id objc in self.failTrackList) {
            [failArr addObject:objc];
        }
        for (id obj in arr) {
            [failArr addObject:obj];
        }
        arr = failArr;
    }
        NSMutableDictionary* data=[self makeEventsJsonDec:arr];
        if (data != nil) {
//            NSLog(@"%@",data);
            [TongDaoApi postEvents:data callBack:self];
        }

}
-(NSMutableDictionary*)makeEventsJsonDec:(NSMutableArray*)transEvents{
    if (transEvents.count == 0) {
        return nil;
    }
    NSMutableDictionary* eventsObj = [[NSMutableDictionary alloc]init];
    [eventsObj setValue:transEvents forKey:@"events"];
    return eventsObj;
}
#pragma mark ApiCallback
-(void)onResult:(NSHTTPURLResponse *)httpRes data:(NSData*)data sendData:(id)sendData{
    
//    NSLog(@"apiCallback回调");
    
    if (httpRes == nil) {
        NSLog(@"httpRes is nil");
        [self addTrackEvent:sendData];
        self.isFailed = YES;
    }else{
        NSError* resErr =nil;
        NSInteger resCode = httpRes.statusCode;
        if (resCode==200||resCode==204) {
            NSLog(@"resCode is %ld",(long)resCode);
            [self clearFailTrackList];
        }else{
             NSMutableDictionary* jsonRes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&resErr];
            if (resErr==nil) {
                if (jsonRes==nil) {
                    if ([TongDaoBridge sharedTongDaoBridge].onErrorListener != nil) {
                        [[TongDaoBridge sharedTongDaoBridge].onErrorListener onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                    }else{
                        NSLog(@"resCode is %ld",(long)resCode);
                        [self addTrackEvent:sendData];
                                self.isFailed = YES;
                    }
                }else{
                    NSString* message = [jsonRes objectForKey:@"message"];
                    if ([TongDaoBridge sharedTongDaoBridge].onErrorListener != nil) {
                        [[TongDaoBridge sharedTongDaoBridge].onErrorListener onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:message]];
                    }else{
                        NSLog(@"resCode is %ld",(long)resCode);
                        [self addTrackEvent:sendData];
                                self.isFailed = YES;
                    }
                }
            }else{
                if ([TongDaoBridge sharedTongDaoBridge].onErrorListener != nil) {
                    [[TongDaoBridge sharedTongDaoBridge].onErrorListener onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                }else{
                    NSLog(@"resCode is %ld",(long)resCode);
                   [self addTrackEvent:sendData];
                            self.isFailed = YES;
                }
            }
        }
    }
}
-(void)onResult:(NSHTTPURLResponse *)httpRes dataForOpenMessage:(NSData *)data sendData:(id)sendData{
    
//    NSLog(@"apiCallback回调");
    
    if (httpRes == nil) {
        NSLog(@"dataForOpenMessage httpRes is nil");
        [self addTrackEvent:sendData];
        self.isFailed = YES;
    }else{
        NSError* resErr =nil;
        NSInteger resCode = httpRes.statusCode;
        if (resCode==200||resCode==204||resCode==502||resCode==504) {
            NSLog(@"dataForOpenMessage resCode is %ld",(long)resCode);
            [self clearFailTrackList];
        }else{
            NSMutableDictionary* jsonRes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&resErr];
            if (resErr==nil) {
                if (jsonRes==nil) {
                    if ([TongDaoBridge sharedTongDaoBridge].onErrorListener != nil) {
                        [[TongDaoBridge sharedTongDaoBridge].onErrorListener onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                    }else{
                        NSLog(@"resCode is %ld",(long)resCode);
                        [self addTrackEvent:sendData];
                        self.isFailed = YES;
                    }
                }else{
                    NSString* message = [jsonRes objectForKey:@"message"];
                    if ([TongDaoBridge sharedTongDaoBridge].onErrorListener != nil) {
                        [[TongDaoBridge sharedTongDaoBridge].onErrorListener onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:message]];
                    }else{
                        NSLog(@"resCode is %ld",(long)resCode);
                        [self addTrackEvent:sendData];
                        self.isFailed = YES;
                    }
                }
            }else{
                if ([TongDaoBridge sharedTongDaoBridge].onErrorListener != nil) {
                    [[TongDaoBridge sharedTongDaoBridge].onErrorListener onError:[[TdErrorTool sharedTdErrorTool] makeErrorBeanWithErrorCode:resCode andErrorMessage:ErrorInfos[errorMessageJson]]];
                }else{
                    NSLog(@"resCode is %ld",(long)resCode);
                    [self addTrackEvent:sendData];
                    self.isFailed = YES;
                }
            }
        }
    }
}
#pragma mark TdLocationCallback
-(void)onSuccess:(NSMutableDictionary *)locDic{
    NSMutableDictionary* initDic = [[NSMutableDictionary alloc]init];
    [initDic setValue:locDic forKey:@"!location"];
    InfoDataTool *infoTool = [[InfoDataTool alloc]init];
    [initDic setValue:[infoTool getDeviceDict] forKey:@"!device"];
    [initDic setValue:[infoTool getAppDic] forKey:@"!application"];
    [initDic setValue:[infoTool getCarrierDic] forKey:@"!connection"];
    [initDic setValue:[infoTool getFingerprintDict] forKey:@"!fingerprint"];
    NSNumber *isAnonymous = [NSNumber numberWithBool:[[TdDataTool sharedTdDataTool] getAnonymous]];
    [initDic setValue:isAnonymous forKey:@"!anonymous"];
    TdEventBean* tdEventBean = [[TdEventBean alloc]initWithaction:identify event:nil andProperties:initDic];
    [self sendTrackEvent:tdEventBean];
}


@end
