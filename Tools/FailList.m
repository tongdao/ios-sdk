//
//  FailList.m
//  TongDaoSDK
//
//  Created by bin jin on 15/8/24.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "FailList.h"

@implementation FailList
//singleton_implementation(FailList)
static FailList *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(FailList *)sharedFailList
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.failList = [[NSMutableArray alloc]init];
//        _instance.sendList = [[NSMutableArray alloc]init];
    });
    return _instance;
}
@end
