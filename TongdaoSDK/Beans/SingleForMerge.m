//
//  SingleForMerge.m
//  TongDaoSDK
//
//  Created by bin jin on 15/9/11.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "SingleForMerge.h"

@implementation SingleForMerge
static SingleForMerge *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(SingleForMerge *)sharedSingleForMerge
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.isMerge = NO;
    });
    return _instance;
}
@end
