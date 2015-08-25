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
-(ErrorBean*)makeErrorBeanWithErrorCode:(NSInteger)errorCode andErrorMessage:(NSString*)errorMessage{
    ErrorBean* error = [[ErrorBean alloc]init];
    [error setTdErrorCode:errorCode];
    [error setTdErrorMsg:errorMessage];
    return error;
}

@end
