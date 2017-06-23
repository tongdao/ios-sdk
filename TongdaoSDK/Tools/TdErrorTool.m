//
//  TdErrorTool.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/14.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdErrorTool.h"

@implementation TdErrorTool
singleton_implementation(TdErrorTool)
-(TdErrorBean*)makeErrorBeanWithErrorCode:(NSInteger)errorCode andErrorMessage:(NSString*)errorMessage{
    TdErrorBean* error = [[TdErrorBean alloc]init];
    [error setTdErrorCode:errorCode];
    [error setTdErrorMsg:errorMessage];
    return error;
}

@end
