//
//  TdService.h
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/16.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "TdLocationCallback.h"
#import "TdStartLocation.h"
#import "TdAppInfoTool.h"
#import "ApiCallBack.h"
#import "ApiCallBackForOpenMessage.h"
#import "TdErrorTool.h"
#import "TdDataTool.h"
#import "TdApiTool.h"

@interface TdService : NSObject<TdLocationCallback,ApiCallBack,ApiCallBackForOpenMessage>
singleton_interface(TdService)

typedef NS_ENUM(NSUInteger, TongDaoinitData) {
    TDLocationIfor,
    TDDeviceInfor,
    TDNetworkInfo,
    TDApplicationInfor,
    TDFingerPrintInfor,
    TDNone
};

@property(atomic)NSArray* failTrackList;
@property(atomic,assign)BOOL isFailed;
@property(atomic,assign)TongDaoinitData ignoreInfor;

-(void)sendInitialData;

-(void)sendInitialDataAndIgnore:(TongDaoinitData)ingnoreInfor;

-(void)sendTrackEvent:(TdEventBean*)tdEventBean;

-(void)sendOpenMessageTrackEvent:(TdEventBean*)tdEventBean;
@end
