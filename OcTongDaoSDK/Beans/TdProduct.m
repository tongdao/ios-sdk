//
//  TdProduct.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdProduct.h"

@implementation TdProduct

-(id)initWithProductId:(NSString *)productId sku:(NSString *)sku name:(NSString *)name price:(float)price currency:(NSString *)currency category:(NSString *)category{
    self = [super init];
    if (self) {
        self.productId = productId;
        self.sku = sku;
        self.name = name;
        self.price = price;
        self.currency = currency;
        self.category = category;
    }
    return self;
}

@end
