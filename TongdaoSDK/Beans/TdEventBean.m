
//
//  TdEventBean.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TdEventBean.h"
#import "SingleForMerge.h"

@implementation TdEventBean
-(id)initWithaction:(ACTION_TYPE)action event:(NSString*)event andProperties:(NSDictionary*)properties{
    self = [super init];
    if (self) {
        self.action = action;
        self.userId = [[TdDataTool sharedTdDataTool] getUUID];
        self.event = event;
        self.properties = properties;
        self.timestamp = [[TdDataTool sharedTdDataTool] getTimeStamp];
    }
    return self;
}
-(NSMutableDictionary*)getJsonObject{
    NSMutableDictionary* objDict = [[NSMutableDictionary alloc]init];
    if (self.action == merge) {
    [objDict setValue:@"merge"forKey:@"action"];
    }else{
    [objDict setValue:self.action==identify?@"identify":@"track" forKey:@"action"];
    }
    [objDict setValue:self.userId forKey:@"user_id"];
    
    
    if (![[TdDataTool sharedTdDataTool]getAnonymous]) {
        
        if ([SingleForMerge sharedSingleForMerge].isMerge) {
            NSString* uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
            [objDict setValue:uuid forKey:@"previous_id"];
            [SingleForMerge sharedSingleForMerge].isMerge = NO;
        }
    }
    if (self.event != nil) {
        [objDict setValue:self.event forKey:@"event"];
    }
    
    if (self.properties != nil) {
        [objDict setValue:self.properties forKey:@"properties"];
    }
    
    [objDict setValue:self.timestamp forKey:@"timestamp"];
    
    return objDict;
}

@end
