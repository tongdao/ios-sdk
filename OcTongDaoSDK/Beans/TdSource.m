//
//  TdSource.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdSource.h"

@implementation TdSource

-(id)initWithAdvertisementId:(NSString*)advertisementId advertisementGroupId:(NSString*)advertisementGroupId campaignId:(NSString*)campaignId sourceId:(NSString*)sourceId{
    self = [super init];
    if (self) {
        self.advertisementId = advertisementId;
        self.advertisementGroupId = advertisementGroupId;
        self.campaignId = campaignId;
        self.sourceId = sourceId;
    }
    return self;
}

@end
