//
//  TdAppInfoTool.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdAppInfoTool.h"


@implementation TdAppInfoTool


-(ScreenSize)getWidthAndHeight{
    NSInteger width = 0;
    NSInteger height = 0;
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]){
        
        width = [UIScreen mainScreen].currentMode.size.width;
        height = [UIScreen mainScreen].currentMode.size.height;
    }
    ScreenSize size = {width,height};
    
    return size;
}

-(NSDictionary*)getDeviceDict{
    NSMutableDictionary *trackBeanDict = [[NSMutableDictionary alloc]init];
    NSArray *deviceInfoDatas = [[TdDataTool sharedTdDataTool] getDeviceInfo];
    trackBeanDict[MODEL] = deviceInfoDatas[0];
    trackBeanDict[BRAND] = deviceInfoDatas[1];
    trackBeanDict[DEVICE_NAME] = deviceInfoDatas[2];
    trackBeanDict[OS_NAME]=deviceInfoDatas[3];
    trackBeanDict[OS_VERSION]=deviceInfoDatas[4];
    trackBeanDict[LANGUAGE]=deviceInfoDatas[7];
    //add width and height
    ScreenSize wAndH=[self getWidthAndHeight];
    trackBeanDict[WIDTH]=[NSNumber numberWithInteger:wAndH.width];
    trackBeanDict[HEIGHT]=[NSNumber numberWithInteger:wAndH.height];
    
    return trackBeanDict;
}

-(NSDictionary*)getAppDic{
    NSMutableDictionary* trackBeanDict = [[NSMutableDictionary alloc]init];
    NSMutableArray* appInfoDatas = [[TdDataTool sharedTdDataTool] getAppInfor];
    trackBeanDict[APP_VERSION_CODE]=appInfoDatas[0];
    trackBeanDict[APP_VERSION_NAME]=appInfoDatas[1];
    return  trackBeanDict;
}

-(NSDictionary*)getCarrierDic{
    NSMutableDictionary* trackBeanDict = [[NSMutableDictionary alloc]init];
    NSMutableArray* connectDatas = [[TdDataTool sharedTdDataTool] getConnectInfo];
    trackBeanDict[CONNECTION_TYPE]=connectDatas[0];
    trackBeanDict[CONNECTION_QUALITY]=connectDatas[1];
    trackBeanDict[CARRIER]=connectDatas[2];
    trackBeanDict[CARRIER_CODE]=connectDatas[3];
    return trackBeanDict;
    
}

@end
