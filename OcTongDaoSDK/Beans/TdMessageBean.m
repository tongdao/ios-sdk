//
//  TdMessageBean.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdMessageBean.h"

@implementation TdMessageBean

-(id)initWithImageUrl:(NSString *)imageUrl message:(NSString *)message displayTime:(NSNumber*)displayTime layout:(NSString *)layout actionType:(NSString *)actionType actionValue:(NSString *)actionValue mid:(NSNumber*)mid cid:(NSNumber*)cid{
    self = [super init];
    if (self) {
        self.imageUrl = imageUrl;
        self.message = message;
        self.displayTime = displayTime;
        self.layout = layout;
        self.actionType = actionType;
        self.actionValue = actionValue;
        self.mid = mid;
        self.cid = cid;
    }
    return self;
}

@end
