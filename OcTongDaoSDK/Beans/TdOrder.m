//
//  TdOrder.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdOrder.h"

@implementation TdOrder

-(id)initWithOrderId:(NSString *)orderId total:(float)total revenue:(float)revenu shipping:(float)shipping tax:(float)tax discount:(float)discount couponId:(NSString *)couponId currency:(NSString *)currency orderList:(NSArray *)orderList{
    self = [super init];
    if (self) {
        self.orderId = orderId;
        self.total = total;
        self.revenue = revenu;
        self.shipping = shipping;
        self.tax = tax;
        self.discount = discount;
        self.couponId = couponId;
        self.currency = currency;
        self.orderList = orderList;
    }
    return self;
}
@end
