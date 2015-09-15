//
//  SingleForAnonymous.m
//  TongDaoSDK
//
//  Created by bin jin on 15/9/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "SingleForAnonymous.h"

@implementation SingleForAnonymous
//singleton_implementation(SingleForAnonymous)
static SingleForAnonymous *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(SingleForAnonymous *)sharedSingleForAnonymous
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.isAnonymous = YES;
    });
    return _instance;
}
@end
