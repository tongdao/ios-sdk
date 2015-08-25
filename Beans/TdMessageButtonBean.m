//
//  TdMessageButtonBean.m
//  TongDaoSDK
//
//  Created by bin jin on 15/8/11.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdMessageButtonBean.h"

@implementation TdMessageButtonBean
-(instancetype)initWithX:(double)rateX Y:(double)rateY W:(double)rateW H:(double)rateH actionType:(NSString*)actionType actionValue:(NSString*)actionValue{
    self = [super init];
    if (self) {
        self.rateH = rateH;
        self.rateW = rateW;
        self.rateX = rateX;
        self.rateY = rateY;
        self.actionType = actionType;
        self.actionValue = actionValue;
    }
    return self;
}
-(double)getRateX{
    return self.rateX;
}
-(double)getRateY{
    return self.rateY;
}
-(double)getRateW{
    return self.rateW;
}
-(double)getRateH{
    return self.rateH;
}
-(NSString*)getActionType{
    return self.actionType;
}
-(NSString*)getActionValue{
    return self.actionValue;
}
@end
