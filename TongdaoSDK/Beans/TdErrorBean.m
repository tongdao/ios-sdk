//
//  TdErrorBean.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdErrorBean.h"
@implementation TdErrorBean

-(NSInteger)getTdErrorCode{
    return self.errorCode;
}

-(NSString*)getTdErrorMsg{
    return self.errorMsg;
}

-(void)setTdErrorCode:(NSInteger)errorCode{
    self.errorCode = errorCode;
}

-(void)setTdErrorMsg:(NSString*)errorMsg{
    self.errorMsg = errorMsg;
}


@end
